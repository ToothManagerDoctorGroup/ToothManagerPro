//
//  CRMUserDefalut.h
//  CRM
//
//  Created by TimTiger on 9/6/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LatestUserID (@"LatestUserID")
#define LatestUserName (@"LatestUserName")
#define LatestUserPassword (@"LatestUserPassword")
#define DeviceToken  (@"DeviceToken")
#define RegisterId (@"RegisterId")

#define KVersion (@"KVersion")

#define kUserIsSignKey(UserId) [NSString stringWithFormat:@"%@isSign",UserId]

@interface CRMUserDefalut : NSObject

/**
 *  获取退出应用前使用者ID
 *
 *  @return 用户id
 */
+ (NSString *)latestUserId;


/**
 *  设置最后使用者id
 *
 *  @param userid[in] 用户id
 */
+ (void)setLatestUserId:(NSString *)userid;
/**
 *  设置最后使用者的密码（环信用到）
 *
 *  @param password 用户密码
 */
+ (void)setLatestUserPassword:(NSString *)password;


+ (void)setObject:(id)object forKey:(NSString *)akey;

+ (id)objectForKey:(NSString *)akey;

/**
 *  获取当前的版本号
 *
 *  @return 版本号
 */
+ (NSString *)getAppVersion;
/**
 *  保存版本号
 *
 *  @param version 版本号
 */
+ (void)obtainAppVersion;

/**
 *  判断是否显示
 *
 *  @param key         key
 *  @param showedBlock 已显示的回调
 */
+ (void)isShowedForKey:(NSString *)key showedBlock:(void (^)())showedBlock noShowBlock:(void (^)())noShowBlock;

@end
