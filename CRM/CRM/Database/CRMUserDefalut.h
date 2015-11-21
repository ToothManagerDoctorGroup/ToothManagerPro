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
#define DeviceToken  (@"DeviceToken")

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

+ (void)setObject:(id)object forKey:(NSString *)akey;

+ (id)objectForKey:(NSString *)akey;

@end
