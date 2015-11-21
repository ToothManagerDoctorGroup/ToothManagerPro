//
//  LocalNotificationCenter.m
//  CRM
//
//  Created by TimTiger on 14-8-26.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "LocalNotificationCenter.h"
#import "CRMMacro.h"
#import "NSDate+Conversion.h"
#import "FMResultSet.h"
#import "NSString+Conversion.h"
#import "DBManager+LocalNotification.h"
#import "CRMUserDefalut.h"
#import "NSDictionary+Extension.h"
#import "DBTableMode.h"
#import "DBManager+Patients.h"

NSString * const RepeatIntervalDay = @"每天";
NSString * const RepeatIntervalWeek = @"每周";
NSString * const RepeatIntervalMonth = @"每月";
NSString * const RepeatIntervalNone = @"不重复";

@implementation LocalNotification

+ (LocalNotification *)notificaitonWithResult:(FMResultSet *)result {
    LocalNotification *notification = [[LocalNotification alloc]init];
    notification.patient_id = [result stringForColumn:@"patient_id"];
    notification.reserve_content = [result stringForColumn:@"reserve_content"];
    notification.medical_place = [result stringForColumn:@"medical_place"];
    notification.medical_chair = [result stringForColumn:@"medical_chair"];
    notification.reserve_time = [[result stringForColumn:@"reserve_time"] substringToIndex:16];
    notification.reserve_type = [result stringForColumn:@"reserve_type"];
    notification.creation_date = [result stringForColumn:@"creation_date"];
    notification.update_date = [result stringForColumn:@"update_date"];
    notification.sync_time = [result stringForColumn:@"sync_time"];
    notification.user_id = [result stringForColumn:@"user_id"];
    notification.ckeyid = [result stringForColumn:@"ckeyid"];
    notification.doctor_id = [result stringForColumn:@"doctor_id"];
    return notification;
}

+ (LocalNotification *)LNFromLNFResult:(NSDictionary *)lnRe{
    LocalNotification *tempLN = [[LocalNotification alloc]init];
    
    tempLN.ckeyid = [lnRe stringForKey:@"ckeyid"];
    tempLN.user_id = [AccountManager currentUserid];
    tempLN.patient_id = [lnRe stringForKey:@"patient_id"];
    tempLN.reserve_content = [lnRe stringForKey:@"reserve_content"];
    tempLN.medical_place = [lnRe stringForKey:@"medical_place"];
    tempLN.medical_chair = [lnRe stringForKey:@"medical_chair"];
    tempLN.reserve_time = [lnRe stringForKey:@"reserve_time"];
    tempLN.reserve_type = [lnRe stringForKey:@"reserve_type"];
    tempLN.update_date = [NSString defaultDateString];
    tempLN.sync_time = [lnRe stringForKey:@"sync_time"];
    tempLN.doctor_id = [lnRe stringForKey:@"doctor_id"];

    return tempLN;
}


- (id)init {
    self = [super init];
    if (self){
        _reserve_content = @"";
        _selected = NO;
    }
    return self;
}

@end

@interface LocalNotificationCenter ()

@end

@implementation LocalNotificationCenter
Realize_ShareInstance(LocalNotificationCenter);

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)addLocalNotification:(LocalNotification *)notificaiton {
//    [self addNotification:notificaiton];
    BOOL ret = [[DBManager shareInstance] insertLocalNotification:notificaiton];
    if (ret) {
        [self scheduleNotification:notificaiton];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCreated object:nil];
    }
    return ret;
}

- (BOOL)removeLocalNotification:(LocalNotification *)notificaiton {
   BOOL ret = [[DBManager shareInstance] deleteLocalNotification:notificaiton];
    if (ret) {
         [self cancelNotification:notificaiton];
    }
    return ret;
}

- (BOOL)updateLocalNotification:(LocalNotification *)notification {
    BOOL ret = [[DBManager shareInstance] updateLocalNotificaiton:notification];
    if (ret) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOtificationUpdated object:nil];
    }
    return ret;
}

- (NSArray *)localNotificationListWithString:(NSString *)string {
    NSArray *array = [[DBManager shareInstance] localNotificationListFormDB];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    for (LocalNotification *local in array) {
        if ([local.reserve_time hasPrefix:string]) {
            [resultArray addObject:local];
        }
    }
    return resultArray;
}
- (NSArray *)localNotificationListWithString1:(NSString *)string {
    /*
    NSArray *array = [[DBManager shareInstance] localNotificationListFormDB];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *lastArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *array1 = [string componentsSeparatedByString:@"|"];
    for(NSInteger i = 0;i<array1.count;i++){
        for (LocalNotification *local in array) {
            if ([local.reserve_time hasPrefix:array1[i]]) {
                [resultArray addObject:local];
            }
        }
        [lastArray addObject:resultArray];
    }
    return lastArray;*/
    NSArray *array = [[DBManager shareInstance] localNotificationListFormDB];
    NSArray *array1 = [string componentsSeparatedByString:@"|"];
    
    NSMutableArray *lastArray = [NSMutableArray arrayWithCapacity:array1.count];
    for(NSInteger i = 0;i<array1.count;i++){
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
        for (LocalNotification *local in array) {
            if ([local.reserve_time hasPrefix:array1[i]]) {
                [resultArray addObject:local];
            }
        }
        [lastArray addObject:resultArray];
    }
    return lastArray;
}

- (void)scheduleNotification:(LocalNotification *)notification {
    
    [self cancelNotification:notification];
    
    UILocalNotification *localNoti = [[UILocalNotification alloc]init];
    localNoti.timeZone = [NSTimeZone systemTimeZone];
    localNoti.fireDate = [notification.reserve_time stringToNSDate];
    /*
    if ([notification.reserve_type isEqualToString:RepeatIntervalDay]) {
        localNoti.repeatInterval = NSCalendarUnitDay;
    } else  if ([notification.reserve_type isEqualToString:RepeatIntervalWeek]) {
        localNoti.repeatInterval = NSCalendarUnitWeekday;
    } else  if ([notification.reserve_type isEqualToString:RepeatIntervalMonth]) {
        localNoti.repeatInterval = NSCalendarUnitMonth;
    } else   {
        localNoti.repeatInterval = NSCalendarUnitEra;
    }*/
    
    Patient *tpatient = [[DBManager shareInstance] getPatientWithPatientCkeyid:notification.patient_id];
    localNoti.alertBody = [NSString stringWithFormat:@"患者 %@ %@",tpatient.patient_name,notification.reserve_type];
    localNoti.alertAction = notification.reserve_type;
    localNoti.applicationIconBadgeNumber += 1;
    localNoti.soundName = UILocalNotificationDefaultSoundName;
    localNoti.userInfo = [NSDictionary dictionaryWithObject:notification.ckeyid forKey:@"ckeyid"];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
}

- (void)cancelNotification:(LocalNotification *)notification {
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *localNotifi in notifications) {
        NSString *notificationckeyid = [localNotifi.userInfo stringForKey:@"ckeyid"];
        if (![NSString isEmptyString:notificationckeyid] && [notification.ckeyid isEqualToString:notificationckeyid]) {
            [[UIApplication sharedApplication] cancelLocalNotification:localNotifi];
        }
    }
}

@end
