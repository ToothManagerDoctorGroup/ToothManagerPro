//
//  CRMUnEncryptedHttpTool.h
//  CRM
//
//  Created by Argo Zhang on 16/4/5.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyUploadParam.h"
#import "CommonMacro.h"
/**
 *  不带加密的网络接口
 */
@interface CRMUnEncryptedHttpTool : NSObject
Declare_ShareInstance(CRMUnEncryptedHttpTool);

/**
 *  GET请求
 *
 *  @param URLString  基础url
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;
/**
 *  POST请求
 *
 *  @param URLString  基础的url
 *  @param parameters 请求的参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
- (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;
/**
 *  POST请求带有附加信息：图片，语音或者zip
 *
 *  @param URLString  基础的url
 *  @param parameters 请求的参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
- (void)POST:(NSString *)URLString
  parameters:(id)parameters
 uploadParam:(MyUploadParam *)uploadParam
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

/**
 *  上传图片
 *
 *  @param URLString   url
 *  @param parameters  请求参数
 *  @param uploadParam 上传图片附带参数
 *  @param success     成功回调
 *  @param failure     失败回调
 */
- (void)Upload:(NSString *)URLString
    parameters:(id)parameters
   uploadParam:(MyUploadParam *)uploadParam
       success:(void (^)())success
       failure:(void (^)(NSError *error))failure;


- (void)Upload:(NSString *)URLString
    parameters:(id)parameters
   uploadParam:(MyUploadParam *)uploadParam
       success:(void (^)())success;

/**
 *  同步POST请求
 *
 *  @param URLString  URL
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
- (id)SyncPOST:(NSString *)URLString
    parameters:(id)parameters
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure;

/**
 *  同步GET请求
 *
 *  @param URLString  URL
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
- (id)SyncGET:(NSString *)URLString
   parameters:(id)parameters
      success:(void (^)(id responseObject))success
      failure:(void (^)(NSError *error))failure;
/**
 *  移除所有的未发送的网络请求
 */
- (void)cancelAllOperation;

@end
