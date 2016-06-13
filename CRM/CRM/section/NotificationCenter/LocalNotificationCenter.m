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
#import "MyDateTool.h"
#import <EventKit/EventKit.h>
#import "MyDateTool.h"
#import "XLEventStoreManager.h"
#import "NSString+TTMAddtion.h"

NSString * const RepeatIntervalDay = @"每天";
NSString * const RepeatIntervalWeek = @"每周";
NSString * const RepeatIntervalMonth = @"每月";
NSString * const RepeatIntervalNone = @"不重复";

@implementation LocalNotification

+ (LocalNotification *)notificationWithNoti:(LocalNotification *)localNoti{
    LocalNotification *notification = [[LocalNotification alloc]init];
    notification.patient_id = localNoti.patient_id;
    notification.reserve_content = localNoti.reserve_content;
    notification.medical_place = localNoti.medical_place;
    notification.medical_chair = localNoti.medical_chair;
    notification.reserve_time = localNoti.reserve_time;
    notification.reserve_type = localNoti.reserve_type;
    notification.creation_date = localNoti.creation_date;
    notification.update_date = localNoti.update_date;
    notification.sync_time = localNoti.sync_time;
    
    notification.tooth_position = localNoti.tooth_position;
    notification.clinic_reserve_id = localNoti.clinic_reserve_id;
    notification.duration = localNoti.duration;
    notification.reserve_status = localNoti.reserve_status;
    
    notification.therapy_doctor_id = localNoti.therapy_doctor_id;
    notification.therapy_doctor_name = localNoti.therapy_doctor_name;
    
    notification.case_id = localNoti.case_id;
    
    return notification;

}

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
    notification.reserve_status = [result stringForColumn:@"reserve_status"];
    
    notification.tooth_position = [result stringForColumn:@"tooth_position"];
    notification.clinic_reserve_id = [result stringForColumn:@"clinic_reserve_id"];
    notification.duration = [result stringForColumn:@"duration"];
    
    notification.therapy_doctor_id = [result stringForColumn:@"therapy_doctor_id"];
    notification.therapy_doctor_name = [result stringForColumn:@"therapy_doctor_name"];
    
    notification.case_id = [result stringForColumn:@"case_id"];
    
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
    tempLN.reserve_status = [lnRe stringForKey:@"reserve_status"];
    
    tempLN.tooth_position = [[lnRe stringForKey:@"tooth_position"] convertIfNill];
    tempLN.clinic_reserve_id = [lnRe stringForKey:@"clinic_reserve_id"];
    tempLN.duration = [lnRe stringForKey:@"duration"];
    
    tempLN.therapy_doctor_id = [lnRe stringForKey:@"therapy_doctor_id"];
    tempLN.therapy_doctor_name = [lnRe stringForKey:@"therapy_doctor_name"];
    tempLN.case_id = [lnRe stringForKey:@"case_id"];

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

- (NSString *)reserve_time_end{
    //获取开始时间
    NSDate *startTime = [MyDateTool dateWithStringNoSec:self.reserve_time];
    NSDate *endTime = [startTime dateByAddingTimeInterval:(int)60 * 60 * [self.duration floatValue]];
    
    return [MyDateTool stringWithDateNoSec:endTime];
}

@end

@interface LocalNotificationCenter ()

@property (nonatomic, strong)EKEventStore *eventStore;

@end

@implementation LocalNotificationCenter
Realize_ShareInstance(LocalNotificationCenter);

- (EKEventStore *)eventStore{
    if (!_eventStore) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return _eventStore;
}

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
        //添加预约信息到系统日历
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

- (NSArray *)localNotificationListWithString:(NSString *)string array:(NSArray *)array{
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
    
    /*
    [self cancelNotification:notification];
    
    UILocalNotification *localNoti = [[UILocalNotification alloc]init];
    localNoti.timeZone = [NSTimeZone systemTimeZone];
    localNoti.fireDate = [notification.reserve_time stringToNSDate];
    
    Patient *tpatient = [[DBManager shareInstance] getPatientWithPatientCkeyid:notification.patient_id];
    localNoti.alertBody = [NSString stringWithFormat:@"患者 %@ %@",tpatient.patient_name,notification.reserve_type];
    localNoti.alertAction = notification.reserve_type;
    localNoti.applicationIconBadgeNumber += 1;
    localNoti.soundName = UILocalNotificationDefaultSoundName;
    localNoti.userInfo = [NSDictionary dictionaryWithObject:notification.ckeyid forKey:@"ckeyid"];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
    */
    
    Patient *tpatient = [[DBManager shareInstance] getPatientWithPatientCkeyid:notification.patient_id];
    //获取系统设置
    NSString *autoReserve = [CRMUserDefalut objectForKey:AutoReserveRecordKey];
    if (autoReserve == nil) {
        autoReserve = Auto_Action_Close;
        [CRMUserDefalut setObject:autoReserve forKey:AutoReserveRecordKey];
    }
    if ([autoReserve isEqualToString:Auto_Action_Open]) {
        //将提醒事件添加到系统日历中
        [[XLEventStoreManager shareInstance] addEventToSystemCalendarWithLocalNotification:notification patient:tpatient];
    }
}

- (void)cancelNotification:(LocalNotification *)notification {
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *localNotifi in notifications) {
        NSString *notificationckeyid = [localNotifi.userInfo stringForKey:@"ckeyid"];
        if (![NSString isEmptyString:notificationckeyid] && [notification.ckeyid isEqualToString:notificationckeyid]) {
            [[UIApplication sharedApplication] cancelLocalNotification:localNotifi];
//            //删除当前日历的同时，删除系统日历事件
//            NSString *autoReserve = [CRMUserDefalut objectForKey:AutoReserveRecordKey];
//            if (autoReserve == nil) {
//                autoReserve = Auto_Action_Close;
//                [CRMUserDefalut setObject:autoReserve forKey:AutoReserveRecordKey];
//            }
//            if ([autoReserve isEqualToString:Auto_Action_Open]) {
//                //删除日历事件
//                [[XLEventStoreManager shareInstance] removeEventToSystemCalendarWithLocalNotification:notification];
//                
//            }
        }
    }
}

@end
