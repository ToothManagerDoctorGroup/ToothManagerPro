//
//  CRMUserDefalut.m
//  CRM
//
//  Created by TimTiger on 9/6/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "CRMUserDefalut.h"
#import "NSString+Conversion.h"

@implementation CRMUserDefalut

/**
 *  获取退出应用前使用者ID
 *
 *  @return 用户id
 */
+ (NSString *)latestUserId {
    NSString *userid = [CRMUserDefalut objectForKey:LatestUserID];
    if ([userid isEmpty]) {
        return nil;
    } else {
        return userid;
    }
}
/**
 *  获取当前登录用户的签约状态
 *
 *  @return 用户签约状态
 */
+ (NSString *)isSign{
    NSString *key = [NSString stringWithFormat:@"%@isSign",[self latestUserId]];
    NSString *signState = [CRMUserDefalut objectForKey:key];
    if ([signState isEmpty]) {
        return nil;
    }else{
        return signState;
    }
}

+ (void)setIsSign:(NSString *)isSign{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%@isSign",[self latestUserId]];
    [userdefaults setObject:isSign forKey:key];
    [userdefaults synchronize];
}

/**
 *  设置最后使用者id
 *
 *  @param userid[in] 用户id
 */
+ (void)setLatestUserId:(NSString *)userid {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:userid forKey:LatestUserID];
    [userdefaults synchronize];
}

+ (void)setObject:(id)object forKey:(NSString *)akey {
     NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:object forKey:akey];
    [userdefaults synchronize];
}

+ (id)objectForKey:(NSString *)akey {
     NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:akey];
}

@end
