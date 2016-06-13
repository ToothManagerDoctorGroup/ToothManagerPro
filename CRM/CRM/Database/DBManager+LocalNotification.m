//
//  DBManager+LocalNotification.m
//  CRM
//
//  Created by TimTiger on 14-8-30.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "DBManager+LocalNotification.h"
#import "NSDate+Conversion.h"
#import "NSString+Conversion.h"

@implementation DBManager (LocalNotification)

- (BOOL)insertLocalNotification:(LocalNotification *)notification {
    //测试可以
    if (notification == nil) {
        return NO;
    }
    
    __block BOOL ret = NO;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\"",LocalNotificationTableName,notification.ckeyid];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            ret = YES;
        }
        [set close];
    }];
    if (ret == YES) {
        ret = [self updateLocalNotificaiton:notification];
        return ret;
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        /*
         @property (nonatomic,copy) NSString *title;  //提醒标题
         @property (nonatomic,copy) NSString *content; //提醒内容
         @property (nonatomic,copy) NSDate *fireDate;
         @property (nonatomic) NSInteger repeatType;  //提醒方式，【每天，每周，每年 ...
         @property (nonatomic) NSInteger level;       //提醒优先级
         @property (nonatomic) NSString  *patientid;
         @property (nonatomic) NSString  *caseid;
         @property (nonatomic) NSString  *ckeid;
         @property (nonatomic) BOOL selected;
         @property (nonatomic,copy) NSString *creation_date;
         @property (nonatomic,copy) NSString *sync_time;
         @property (nonatomic,copy) NSString *update_date;
         */
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        
        /*@"\"KeyId\" integer primary key autoincrement ,\n\t \"patient_id\" integer,\n\t \"case_id\" integer ,\n\t \"repeat_type\" integer ,\n\t \"firedate\" text,\n\t \"title\" text,\n\t \"content\" text,\n\t \"level\" integer, \"create_date\" text, \"update_date\" text"*/
        [columeArray addObject:@"ckeyid"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"patient_id"]; //姓名
        [columeArray addObject:@"reserve_type"]; //等级
        [columeArray addObject:@"reserve_time"];
        [columeArray addObject:@"reserve_content"];
        [columeArray addObject:@"medical_place"];
        [columeArray addObject:@"medical_chair"];
        [columeArray addObject:@"creation_date"]; //创建时间
        [columeArray addObject:@"update_date"];
        [columeArray addObject:@"sync_time"];
        [columeArray addObject:@"doctor_id"];
        
        [columeArray addObject:@"tooth_position"];
        [columeArray addObject:@"clinic_reserve_id"];
        [columeArray addObject:@"duration"];
        [columeArray addObject:@"therapy_doctor_id"];
        [columeArray addObject:@"therapy_doctor_name"];
        [columeArray addObject:@"reserve_status"];
        [columeArray addObject:@"case_id"];
        
        [valueArray addObject:notification.ckeyid];
        [valueArray addObject:notification.user_id];
        [valueArray addObject:notification.patient_id];
        [valueArray addObject:notification.reserve_type];
        [valueArray addObject:notification.reserve_time];
        [valueArray addObject:notification.reserve_content];
        [valueArray addObject:notification.medical_place];
        [valueArray addObject:notification.medical_chair];
        
        [valueArray addObject:[NSString currentDateString]];
        
        if (notification.update_date == nil || [notification.update_date isEmpty]) {
            [valueArray addObject:notification.update_date];
        }else{
            [valueArray addObject:[NSString currentDateString]];
        }
        if (notification.sync_time == nil) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:notification.sync_time];
        }
        [valueArray addObject:notification.doctor_id];
        
        [valueArray addObject:notification.tooth_position];
        [valueArray addObject:notification.clinic_reserve_id];
        [valueArray addObject:notification.duration];
        [valueArray addObject:notification.therapy_doctor_id];
        [valueArray addObject:notification.therapy_doctor_name];
        if ([NSString isEmptyString:notification.reserve_status]) {
            [valueArray addObject:@"0"];
        }else{
            [valueArray addObject:notification.reserve_status];
        }
        if (notification.case_id == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:notification.case_id];
        }
        
        
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        
        // 3. 写入数据库 
        NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@)", LocalNotificationTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
        
    }];
    return ret;
}

- (NSArray *)localNotificationListFormDB {
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    NSString * sqlString = [NSString stringWithFormat:@"select * from %@ where user_id = \"%@\" and creation_date > datetime('%@') and reserve_status=\"%@\"",LocalNotificationTableName,[AccountManager currentUserid],[NSString defaultDateString],@"0"];
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlString];
        while (result && [result next]) {
            LocalNotification *notification = [LocalNotification notificaitonWithResult:result];
            [resultArray addObject:notification];
        }
        [result close];
    }];
    return resultArray;
}

- (BOOL)updateLocalNotificaiton:(LocalNotification *)notification {
    //测试可以
    if (notification == nil || [NSString isEmptyString:notification.ckeyid]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"patient_id"]; //姓名
        [columeArray addObject:@"reserve_type"];
        [columeArray addObject:@"reserve_time"];
        [columeArray addObject:@"reserve_content"];
        [columeArray addObject:@"medical_place"];
        [columeArray addObject:@"medical_chair"];
        [columeArray addObject:@"sync_time"];
        [columeArray addObject:@"creation_date"];
        [columeArray addObject:@"update_date"];
        [columeArray addObject:@"doctor_id"];
        [columeArray addObject:@"user_id"];
        
        [columeArray addObject:@"tooth_position"];
        [columeArray addObject:@"clinic_reserve_id"];
        [columeArray addObject:@"duration"];
        [columeArray addObject:@"therapy_doctor_id"];
        [columeArray addObject:@"therapy_doctor_name"];
        [columeArray addObject:@"reserve_status"];
        [columeArray addObject:@"case_id"];
        
        [valueArray addObject:notification.patient_id];
        [valueArray addObject:notification.reserve_type];
        [valueArray addObject:notification.reserve_time];
        [valueArray addObject:notification.reserve_content];
        [valueArray addObject:notification.medical_place];
        [valueArray addObject:notification.medical_chair];
        //[valueArray addObject:notification.creation_date];
        if ([NSString isEmptyString:notification.sync_time]) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:notification.sync_time];
        }
        if ([NSString isEmptyString:notification.creation_date]) {
            [valueArray addObject:[NSString currentDateString]];
        } else {
            [valueArray addObject:notification.creation_date];
        }
        if ([NSString isEmptyString:notification.update_date]) {
            [valueArray addObject:[NSString currentDateString]];
        } else {
            [valueArray addObject:notification.update_date];
        }
        [valueArray addObject:notification.doctor_id];
        [valueArray addObject:notification.user_id];
        
        [valueArray addObject:notification.tooth_position];
        [valueArray addObject:notification.clinic_reserve_id];
        [valueArray addObject:notification.duration];
        [valueArray addObject:notification.therapy_doctor_id];
        [valueArray addObject:notification.therapy_doctor_name];
        if ([NSString isEmptyString:notification.reserve_status]) {
            [valueArray addObject:@"0"];
        }else{
            [valueArray addObject:notification.reserve_status];
        }
        if (notification.case_id == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:notification.case_id];
        }
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where ckeyid = \"%@\"", LocalNotificationTableName, [columeArray componentsJoinedByString:@"=?,"],notification.ckeyid];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
        
    }];
    return ret;
}


     
     
- (BOOL)deleteLocalNotification:(LocalNotification *)notification {
    if (notification == nil) {
        return NO;
    }
    
    notification.creation_date = [NSString defaultDateString];
    return [self updateLocalNotificaiton:notification];
    
//    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where ckeyid = \"%@\"",LocalNotificationTableName,notification.ckeyid];
//    __block BOOL ret = NO;
//    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
//        ret = [db executeUpdate:sqlStr];
//    }];
//    return ret;
}
     
- (BOOL)deleteLocalNotification_Sync:(LocalNotification *)notification {
    if (notification == nil) {
        return NO;
    }
         
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where ckeyid = \"%@\"",LocalNotificationTableName,notification.ckeyid];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
     }];
    return ret;
}

- (BOOL)deleteLocalNotificationWithPatientId_sync:(NSString *)patientId{
    if ([NSString isEmptyString:patientId]) {
        return NO;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where patient_id = \"%@\" and doctor_id = '%@'",LocalNotificationTableName,patientId,[AccountManager currentUserid]];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    return ret;
}

- (LocalNotification *)getLocalNotificationWithCkeyId:(NSString *)ckeyId{
    if ([NSString isEmptyString:ckeyId]) {
        return nil;
    }
    
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\"",LocalNotificationTableName,ckeyId];
    __block LocalNotification *localNoti = nil;
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlStr];
        if (result && [result next]) {
            localNoti = [LocalNotification notificaitonWithResult:result];
        }
        [result close];
    }];
    return localNoti;
}

- (NSArray *)localNotificationListByPatientId:(NSString *)patientId{
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    NSString * sqlString = [NSString stringWithFormat:@"select * from %@ where user_id = \"%@\" and patient_id = \"%@\"  and creation_date > datetime('%@') and reserve_status=\"%@\"",LocalNotificationTableName,[AccountManager currentUserid],patientId,[NSString defaultDateString],@"0"];
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlString];
        while (result && [result next]) {
            LocalNotification *notification = [LocalNotification notificaitonWithResult:result];
            [resultArray addObject:notification];
        }
        [result close];
    }];
    return resultArray;
}

- (NSArray *)localNotificationListWithStartDate:(NSString *)startDate endDate:(NSString *)endDate{
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    NSString * sqlString = [NSString stringWithFormat:@"select * from %@ where user_id = \"%@\" and creation_date > datetime('%@') and reserve_time >= datetime('%@') and reserve_time <= datetime('%@') and reserve_status=\"%@\"",LocalNotificationTableName,[AccountManager currentUserid],[NSString defaultDateString],startDate,endDate,@"0"];
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlString];
        while (result && [result next]) {
            LocalNotification *notification = [LocalNotification notificaitonWithResult:result];
            [resultArray addObject:notification];
        }
        [result close];
    }];
    return resultArray;
}

@end
