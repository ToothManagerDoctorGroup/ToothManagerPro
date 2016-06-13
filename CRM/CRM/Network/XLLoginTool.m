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
#import "JSONKit.h"
#import "CRMHttpTool.h"
#import "UIApplication+Version.h"
#import "NSString+TTMAddtion.h"
#import "CRMHttpTool.h"

@implementation XLLoginTool

+ (void)loginWithNickName:(NSString *)nickName password:(NSString *)password success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure{
    
    ValidationResult ret = ValidationResultValid;
    
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
    
    NSString *urlStr =  [NSString stringWithFormat:@"%@%@/loginhandler.ashx",DomainName,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = [NSString TripleDES:nickName encryptOrDecrypt:kCCEncrypt encryptOrDecryptKey:NULL];
    params[@"password"] = [NSString TripleDES:password encryptOrDecrypt:kCCEncrypt encryptOrDecryptKey:NULL];
    params[@"devicetype"] = [NSString TripleDES:@"ios" encryptOrDecrypt:kCCEncrypt encryptOrDecryptKey:NULL];
    if ([CRMUserDefalut objectForKey:RegisterId]) {
        params[@"devicetoken"] = [NSString TripleDES:[CRMUserDefalut objectForKey:RegisterId] encryptOrDecrypt:kCCEncrypt encryptOrDecryptKey:NULL];
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
        NSDictionary *dic = [sourceStr objectFromJSONString];
        //字典转模型
        CRMHttpRespondModel *model = [CRMHttpRespondModel objectWithKeyValues:dic];
        NSLog(@"data:%@,url:%@",sourceStr,operation.request.URL);
        
        if (success) {
            success(model);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


/**
 *  更新用户推送所需registerId
 *
 *  @param userId     用户id
 *  @param registerId 注册id
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)updateUserRegisterId:(NSString *)registerId success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/UpdateRegId.ashx",DomainName,Method_Ashx];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"device_token"] = [[CRMUserDefalut objectForKey:DeviceToken] TripleDESIsEncrypt:YES];
    param[@"regid"] = [registerId TripleDESIsEncrypt:YES];
    param[@"userid"] = [[AccountManager currentUserid] TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:param success:^(id responseObject) {
        
        CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        
        if (success) {
            success(respond);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
/**
 *  新的登录接口
 *
 *  @param nickName 用户名
 *  @param password 密码
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)newLoginWithNickName:(NSString *)nickName password:(NSString *)password success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure{
    ValidationResult ret = ValidationResultValid;
    
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
    
    NSString *urlStr =  [NSString stringWithFormat:@"%@%@/NewLoginHandler.ashx",DomainName,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = [nickName TripleDESIsEncrypt:YES];
    params[@"password"] = [password TripleDESIsEncrypt:YES];
    params[@"devicetype"] = [@"ios" TripleDESIsEncrypt:YES];
    if ([CRMUserDefalut objectForKey:DeviceToken]) {
        params[@"devicetoken"] = [[CRMUserDefalut objectForKey:DeviceToken] TripleDESIsEncrypt:YES];
    }
    if ([CRMUserDefalut objectForKey:RegisterId]) {
        params[@"reg_id"] = [[CRMUserDefalut objectForKey:RegisterId] TripleDESIsEncrypt:YES];
    }
    params[@"mobile_model"] = [[NSString deviceString] TripleDESIsEncrypt:YES];//手机型号
    params[@"sys_version"] = [[UIApplication systemVersion] TripleDESIsEncrypt:YES];//系统版本号
    params[@"app_version"] = [[UIApplication currentVersion] TripleDESIsEncrypt:YES];//app版本号
    
    [[CRMHttpTool shareInstance] logWithUrlStr:urlStr params:params];
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
        //字典转模型
        CRMHttpRespondModel *model = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


/**
 *  获取客户端的版本限制
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getVersionLimitSuccess:(void (^)(XLVersionLimitModel *limitM))success failure:(void (^)(NSError *error))failure{
    //his.crm\ashx\SysGlobalSettingHandler.ashx?action=getminversion
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/SysGlobalSettingHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = [@"getminversion" TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:param success:^(id responseObject) {
        XLVersionLimitModel *limitM = [[XLVersionLimitModel alloc] initWithDic:responseObject];
        if (success) {
            success(limitM);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end

@implementation XLVersionLimitModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.ios_min_version = dic[@"ios_min_version"];
        self.android_min_version = dic[@"android_min_version"];
        self.is_forcible_update = dic[@"is_forcible_update"];
    }
    return self;
}

@end
