//
//  CRMHttpTool.m
//  CRM
//
//  Created by Argo Zhang on 15/11/11.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "CRMHttpTool.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"
#import "NSString+TTMAddtion.h"
#import "JSONKit.h"

NSString *const CRMHttpToolWlanError = @"网络异常";
NSString *const CRMHttpToolServerError = @"服务器正在维护，请稍后再试";

@interface CRMHttpTool ()

@property (nonatomic, strong)AFHTTPRequestOperationManager *manager;

@end
@implementation CRMHttpTool
Realize_ShareInstance(CRMHttpTool);
- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [AFHTTPRequestOperationManager manager];
//        _manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
        if ([EncryptionOpen isEqualToString:Auto_Action_Open]) {
            _manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
        }
        _manager.requestSerializer.timeoutInterval = 40.f; //设置请求超时时间
    }
    return self;
}

- (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    
    [self.manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"初始化数据:%@---%@",operation.responseString,operation.request.URL);
        
        if ([EncryptionOpen isEqualToString:Auto_Action_Open]) {
            NSString *dataStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            //解密数据
            NSString *sourceStr = [[dataStr TripleDESIsEncrypt:NO] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if (success) {
                success([sourceStr objectFromJSONString]);
            }
        }else{
            if (success) {
                success(responseObject);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"初始化数据:%@---%@",operation.responseString,operation.request.URL);
        NSString *errorStr = error.code == 500 ? CRMHttpToolServerError : CRMHttpToolWlanError;
        NSError *cusError = [NSError errorWithDomain:@"网络异常" code:error.code userInfo:@{@"NSLocalizedDescription" : errorStr}];
        if (failure) {
            failure(cusError);
        }
    }];
}

- (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    [self.manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
         NSLog(@"初始化数据:%@---%@",operation.responseString,operation.request.URL);
        
        if ([EncryptionOpen isEqualToString:Auto_Action_Open]) {
            NSString *dataStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            //解密数据
            NSString *sourceStr = [[dataStr TripleDESIsEncrypt:NO] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if (success) {
                success([sourceStr objectFromJSONString]);
            }
        }else{
            if (success) {
                success(responseObject);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"初始化数据:%@---%@",operation.responseString,operation.request.URL);
        NSString *errorStr = error.code == 500 ? CRMHttpToolServerError : CRMHttpToolWlanError;
        NSError *cusError = [NSError errorWithDomain:@"网络异常" code:error.code userInfo:@{@"NSLocalizedDescription" : errorStr}];
        if (failure) {
            failure(cusError);
        }
    }];
}

- (void)POST:(NSString *)URLString
  parameters:(id)parameters
 uploadParam:(MyUploadParam *)uploadParam
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure{
    [self.manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.fileName mimeType:uploadParam.mimeType];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([EncryptionOpen isEqualToString:Auto_Action_Open]) {
            NSString *dataStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            //解密数据
            NSString *sourceStr = [[dataStr TripleDESIsEncrypt:NO] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if (success) {
                success([sourceStr objectFromJSONString]);
            }
        }else{
            if (success) {
                success(responseObject);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorStr = error.code == 500 ? CRMHttpToolServerError : CRMHttpToolWlanError;
        NSError *cusError = [NSError errorWithDomain:@"网络异常" code:error.code userInfo:@{@"NSLocalizedDescription" : errorStr}];
        if (failure) {
            failure(cusError);
        }
    }];
}


- (void)Upload:(NSString *)URLString parameters:(id)parameters uploadParam:(MyUploadParam *)uploadParam success:(void (^)(id responseObject))success failure:(void (^)(NSError *))failure{
    
    [self.manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.fileName mimeType:uploadParam.mimeType];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog ( @"operation: %@", operation.responseString );
        NSString *errorStr = error.code == 500 ? CRMHttpToolServerError : CRMHttpToolWlanError;
        NSError *cusError = [NSError errorWithDomain:@"网络异常" code:error.code userInfo:@{@"NSLocalizedDescription" : errorStr}];
        if (failure) {
            failure(cusError);
        }
    }];
}

- (id)SyncPOST:(NSString *)URLString
      parameters:(id)parameters
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure{
    NSError *error = nil;
    return [self.manager syncPOST:URLString parameters:parameters operation:NULL error:&error];
}

- (id)SyncGET:(NSString *)URLString
   parameters:(id)parameters
      success:(void (^)(id responseObject))success
      failure:(void (^)(NSError *error))failure{
    NSError *error = nil;
    return [self.manager syncGET:URLString parameters:parameters operation:NULL error:&error];
}

- (void)cancelAllOperation{
    [self.manager.operationQueue cancelAllOperations];
}



- (void)logWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params{
    NSMutableString *mStr = [NSMutableString string];
    [mStr appendFormat:@"%@?",urlStr];
    for (NSString *key in params.allKeys) {
        [mStr appendFormat:@"%@=%@&",key,params[key]];
    }
    NSLog(@"requestUrl:%@",[mStr substringToIndex:mStr.length - 1]);
}

@end
