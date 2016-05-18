//
//  XLLoginTool.h
//  CRM
//
//  Created by Argo Zhang on 16/1/25.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  登录网络请求工具类（加密）
 */
@class CRMHttpRespondModel;
@interface XLLoginTool : NSObject
/**
 *  登录接口
 *
 *  @param nickName 用户名
 *  @param password 密码
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)loginWithNickName:(NSString *)nickName password:(NSString *)password success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;
/**
 *  更新用户推送所需registerId
 *
 *  @param userId     用户id
 *  @param registerId 注册id
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)updateUserRegisterIdWithUserId:(NSString *)userId registerId:(NSString *)registerId success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

@end
