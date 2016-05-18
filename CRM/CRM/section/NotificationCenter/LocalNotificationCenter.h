//
//  LocalNotificationCenter.h
//  CRM
//
//  Created by TimTiger on 14-8-26.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonMacro.h"
#import "DBTableMode.h"

@class FMResultSet;
@interface LocalNotification : DBTableMode

@property (nonatomic,copy) NSString *reserve_time;
@property (nonatomic,copy) NSString *reserve_content;  //提醒内容
@property (nonatomic, copy) NSString *reserve_type;
@property (nonatomic,copy) NSString *medical_place;   //就诊地点
@property (nonatomic,copy) NSString *medical_chair;   //椅位
@property (nonatomic, copy) NSString *patient_id;
@property (nonatomic,copy) NSString *creation_date;
@property (nonatomic,copy) NSString *sync_time;
@property (nonatomic,copy) NSString *update_date;
@property (nonatomic) BOOL selected;   //同步的时候此字段没有用处

@property (nonatomic, copy)NSString *tooth_position;
@property (nonatomic, copy)NSString *clinic_reserve_id;
@property (nonatomic, copy)NSString *duration;//时长
@property (nonatomic, copy)NSString *reserve_status;//预约状态：0已预约 1已改约

@property (nonatomic, copy)NSString *therapy_doctor_id;//修复医生的id
@property (nonatomic, copy)NSString *therapy_doctor_name;//修复医生的姓名

@property (nonatomic, copy)NSString *case_id;//病历id(预留字段，新功能使用)

/**
 *  本地使用
 */
@property (nonatomic, copy)NSString *reserve_time_end;//预约结束时间

+ (LocalNotification *)notificationWithNoti:(LocalNotification *)localNoti;
+ (LocalNotification *)notificaitonWithResult:(FMResultSet *)result;
+ (LocalNotification *)LNFromLNFResult:(NSDictionary *)lnRe;

@end

@interface LocalNotificationCenter : NSObject

@property (nonatomic,retain) Patient *selectPatient;
@property (nonatomic) Patient *yuyuePatient;
Declare_ShareInstance(LocalNotificationCenter);

- (BOOL)addLocalNotification:(LocalNotification *)notificaiton;
- (BOOL)removeLocalNotification:(LocalNotification *)notificaiton;
- (BOOL)updateLocalNotification:(LocalNotification *)notification;
- (NSArray *)localNotificationListWithString:(NSString *)string;
- (NSArray *)localNotificationListWithString:(NSString *)string array:(NSArray *)array;
- (NSArray *)localNotificationListWithString1:(NSString *)string;

//取消通知
- (void)cancelNotification:(LocalNotification *)notification;

@end
