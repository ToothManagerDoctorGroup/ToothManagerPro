//
//  CRMUnEncryptedHttpTool.m
//  CRM
//
//  Created by Argo Zhang on 16/4/5.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "CRMUnEncryptedHttpTool.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"
#import "NSString+TTMAddtion.h"
#import "AFHTTPSessionManager.h"
#import "JSONKit.h"
#import "CRMHttpTool.h"

@interface CRMUnEncryptedHttpTool ()

@property (nonatomic, strong)AFHTTPRequestOperationManager *manager;

@end

@implementation CRMUnEncryptedHttpTool
Realize_ShareInstance(CRMUnEncryptedHttpTool);

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.requestSerializer.timeoutInterval = 40.f; //设置请求超时时间
    }
    return self;
}

- (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    [self.manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"初始化数据:%@---%@",operation.responseString,operation.request.URL);
        if (success) {
            success(responseObject);
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
        if (success) {
            success(responseObject);
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
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorStr = error.code == 500 ? CRMHttpToolServerError : CRMHttpToolWlanError;
        NSError *cusError = [NSError errorWithDomain:@"网络异常" code:error.code userInfo:@{@"NSLocalizedDescription" : errorStr}];
        if (failure) {
            failure(cusError);
        }
    }];
}


- (void)Upload:(NSString *)URLString parameters:(id)parameters uploadParam:(MyUploadParam *)uploadParam success:(void (^)())success failure:(void (^)(NSError *))failure{
    
    [self.manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.fileName mimeType:uploadParam.mimeType];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success();
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

- (void)Upload:(NSString *)URLString
    parameters:(id)parameters
   uploadParam:(MyUploadParam *)uploadParam
       success:(void (^)())success{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
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


@end
