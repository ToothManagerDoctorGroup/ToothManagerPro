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
 *  设置最后使用者id
 *
 *  @param userid[in] 用户id
 */
+ (void)setLatestUserId:(NSString *)userid {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:userid forKey:LatestUserID];
    [userdefaults synchronize];
}


/**
 *  设置最后使用者的密码（环信用到）
 *
 *  @param password 用户密码
 */
+ (void)setLatestUserPassword:(NSString *)password{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:password forKey:LatestUserPassword];
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

+ (NSString *)getAppVersion{
     NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
     return [userdefaults objectForKey:KVersion];
}

+ (void)obtainAppVersion{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"] forKey:KVersion];
    [userdefaults synchronize];
}


+ (void)isShowedForKey:(NSString *)key showedBlock:(void (^)())showedBlock noShowBlock:(void (^)())noShowBlock{
    //获取配置项
    NSString *isShowed = [CRMUserDefalut objectForKey:key];
    if (isShowed == nil) {
        isShowed = Auto_Action_Open;
        [CRMUserDefalut setObject:isShowed forKey:key];
    }
    if ([isShowed isEqualToString:Auto_Action_Open]) {
        [CRMUserDefalut setObject:Auto_Action_Close forKey:key];
        if (showedBlock) {
            showedBlock();
        }
    }else{
        if (noShowBlock) {
            noShowBlock();
        }
    }
}



@end
