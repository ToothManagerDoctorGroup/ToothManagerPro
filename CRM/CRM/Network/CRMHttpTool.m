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
        if (failure) {
            failure(error);
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
        if (failure) {
            failure(error);
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
        if (failure) {
            failure(error);
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
        if (failure) {
            failure(error);
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

@end
