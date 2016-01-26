//
//  XLLoginTool.m
//  CRM
//
//  Created by Argo Zhang on 16/1/25.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLLoginTool.h"
#import "AFHTTPRequestOperationManager.h"
#import "CRMHttpRespondModel.h"
#import "NSString+TTMAddtion.h"
#import "AccountManager.h"
#import "CRMUserDefalut.h"
#import "NSString+TTMAddtion.h"

@implementation XLLoginTool

+ (void)loginWithNickName:(NSString *)nickName password:(NSString *)password success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure{
    
    ValidationResult ret = ValidationResultValid; //[nickname isValidWithFormat:@"^[\u4e00-\u9fa5]{3,15}$"];
    if (ret == ValidationResultInValid)
    {
        [SVProgressHUD showImage:nil status:@"昵称格式错误"];
        return;
    }
    if (ret == ValidationResultValidateStringIsEmpty)
    {
        [SVProgressHUD showImage:nil status:@"昵称不能为空"];
        return;
    }
    ret = [password isValidWithFormat:@"^[a-zA-Z0-9]{6,16}$"];
    if (ret == ValidationResultInValid)
    {
        [SVProgressHUD showImage:nil status:@"密码格式错误"];
        return;
    }
    if (ret == ValidationResultValidateStringIsEmpty)
    {
        [SVProgressHUD showImage:nil status:@"密码不能为空"];
        return;
    }
    
    NSString *urlStr =  [NSString stringWithFormat:@"%@ashxzj/loginhandler.ashx",DomainName];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = [NSString TripleDES:nickName encryptOrDecrypt:kCCEncrypt encryptOrDecryptKey:NULL];
    params[@"password"] = [NSString TripleDES:password encryptOrDecrypt:kCCEncrypt encryptOrDecryptKey:NULL];
    params[@"devicetype"] = [NSString TripleDES:@"ios" encryptOrDecrypt:kCCEncrypt encryptOrDecryptKey:NULL];
    if ([CRMUserDefalut objectForKey:DeviceToken]) {
        params[@"devicetoken"] = [NSString TripleDES:[CRMUserDefalut objectForKey:DeviceToken] encryptOrDecrypt:kCCEncrypt encryptOrDecryptKey:NULL];
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 40.f; //设置请求超时时间
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];//请求
    
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *dataStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //解密数据
        NSString *sourceStr = [NSString TripleDES:dataStr encryptOrDecrypt:kCCDecrypt encryptOrDecryptKey:NULL];
        //将json转化成字典
        NSDictionary *dic = [NSString dicFromJsonStr:sourceStr];
        //字典转模型
        CRMHttpRespondModel *model = [CRMHttpRespondModel objectWithKeyValues:dic];
        if (success) {
            success(model);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
