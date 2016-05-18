//
//  TTMMyHttpTool.h
//  ToothManager
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 roger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTMUpLoadParam.h"

@interface TTMMyHttpTool : NSObject
/**
 *  GET请求
 *
 *  @param URLString  基础url
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)GET:(NSString *)URLString
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
+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

+ (void)Upload:(NSString *)URLString
    parameters:(id)parameters
   uploadParam:(TTMUpLoadParam *)uploadParam
       success:(void (^)())success
       failure:(void (^)(NSError *error))failure;
@end
