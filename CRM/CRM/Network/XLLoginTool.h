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
@class CRMHttpRespondModel,XLVersionLimitModel;
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
+ (void)updateUserRegisterId:(NSString *)registerId success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

/**
 *  新的登录接口
 *
 *  @param nickName 用户名
 *  @param password 密码
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)newLoginWithNickName:(NSString *)nickName password:(NSString *)password success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

/**
 *  获取客户端的版本限制
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getVersionLimitSuccess:(void (^)(XLVersionLimitModel *limitM))success failure:(void (^)(NSError *error))failure;

@end

@interface XLVersionLimitModel : NSObject

@property (nonatomic, copy)NSString *ios_min_version;//ios最小版本号
@property (nonatomic, copy)NSString *android_min_version;//安卓最小版本号
@property (nonatomic, copy)NSString *is_forcible_update;//是否强制更新

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
