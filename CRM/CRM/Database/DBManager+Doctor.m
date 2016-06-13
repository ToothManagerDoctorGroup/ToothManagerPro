//
//  DBManager+Doctor.m
//  CRM
//
//  Created by TimTiger on 5/20/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "DBManager+Doctor.h"
#import "NSString+Conversion.h"

@implementation DBManager (Doctor)
//doctor 表是以userid为key，而不是ckyid

/**
 *  插入一条医生信息
 *
 *  @param userobj 医生信息 
 *
 *  @return 是否成功
 */
-(BOOL)insertDoctorWithDoctor:(Doctor *)doctorobj {
    if (doctorobj == nil || [doctorobj.user_id isEmpty]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\" and user_id = \"%@\"",DoctorTableName,doctorobj.ckeyid,[AccountManager currentUserid]];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            ret = YES;
        }
        [set close];
    }];
    if (ret == YES) {
        ret = [self updateDoctorWithDoctor:doctorobj];
        return ret;
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"ckeyid"];
        [columeArray addObject:@"doctor_name"];
        [columeArray addObject:@"doctor_dept"];
        [columeArray addObject:@"doctor_phone"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"doctor_email"];
        [columeArray addObject:@"doctor_hospital"];
        [columeArray addObject:@"doctor_position"];
        [columeArray addObject:@"doctor_degree"];
        [columeArray addObject:@"doctor_image"];
        [columeArray addObject:@"auth_status"];
        [columeArray addObject:@"auth_text"];
        [columeArray addObject:@"auth_pic"];
        [columeArray addObject:@"creation_date"]; //创建时间
        [columeArray addObject:@"update_date"]; //跟新时间
        [columeArray addObject:@"doctor_id"];
        
        [columeArray addObject:@"doctor_birthday"];
        [columeArray addObject:@"doctor_gender"];
        [columeArray addObject:@"doctor_cv"];
        [columeArray addObject:@"doctor_skill"];

        
        [valueArray addObject:doctorobj.ckeyid];
        [valueArray addObject:doctorobj.doctor_name];
        [valueArray addObject:doctorobj.doctor_dept];
        [valueArray addObject:doctorobj.doctor_phone];
        [valueArray addObject:doctorobj.user_id];
        [valueArray addObject:doctorobj.doctor_email];
        [valueArray addObject:doctorobj.doctor_hospital];
        [valueArray addObject:doctorobj.doctor_position];
        [valueArray addObject:doctorobj.doctor_degree];
        [valueArray addObject:doctorobj.doctor_image];
        [valueArray addObject:[NSNumber numberWithInteger:doctorobj.auth_status]];
        [valueArray addObject:doctorobj.auth_text];
        [valueArray addObject:doctorobj.auth_pic];
        [valueArray addObject:[NSString currentDateString]];
        [valueArray addObject:[NSString defaultDateString]];
        [valueArray addObject:doctorobj.doctor_id];
        
        [valueArray addObject:doctorobj.doctor_birthday];
        [valueArray addObject:doctorobj.doctor_gender];
        [valueArray addObject:doctorobj.doctor_cv];
        [valueArray addObject:doctorobj.doctor_skill];
        

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
        [titleArray addObject:@"?"];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@)", DoctorTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
        NSLog(@"insertPatientString:%@",sqlQuery);
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
    }];
    return ret;
}

/**
 *  更新一条医生信息
 *
 *  @param userobj 医生信息
 *
 *  @return 是否成功
 */
- (BOOL)updateDoctorWithDoctor:(Doctor *)doctorobj {
    if (doctorobj == nil || [doctorobj.ckeyid isEmpty]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        NSDate* currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* strCurrentDate = [dateFormatter stringFromDate:currentDate];
        
        [columeArray addObject:@"doctor_name"];
        [columeArray addObject:@"doctor_dept"];
        [columeArray addObject:@"doctor_phone"];
        [columeArray addObject:@"doctor_email"];
        [columeArray addObject:@"doctor_hospital"];
        [columeArray addObject:@"doctor_position"];
        [columeArray addObject:@"doctor_degree"];
        [columeArray addObject:@"doctor_image"];
        [columeArray addObject:@"auth_status"];
        [columeArray addObject:@"auth_text"];
        [columeArray addObject:@"auth_pic"];
        [columeArray addObject:@"update_date"]; //更新时间
        [columeArray addObject:@"doctor_id"];
        [columeArray addObject:@"doctor_birthday"];
        [columeArray addObject:@"doctor_gender"];
        [columeArray addObject:@"doctor_cv"];
        [columeArray addObject:@"doctor_skill"];
        
        [valueArray addObject:doctorobj.doctor_name];
        [valueArray addObject:doctorobj.doctor_dept];
        [valueArray addObject:doctorobj.doctor_phone];
        [valueArray addObject:doctorobj.doctor_email];
        [valueArray addObject:doctorobj.doctor_hospital];
        [valueArray addObject:doctorobj.doctor_position];
        [valueArray addObject:doctorobj.doctor_degree];
        [valueArray addObject:doctorobj.doctor_image];
        [valueArray addObject:[NSNumber numberWithInteger:doctorobj.auth_status]];
        [valueArray addObject:doctorobj.auth_text];
        [valueArray addObject:doctorobj.auth_pic];
        if ([NSString isEmptyString:doctorobj.update_date]) {
          [valueArray addObject:[NSString stringWithString:strCurrentDate]];
        } else {
          [valueArray addObject:doctorobj.update_date];
        }
        [valueArray addObject:doctorobj.doctor_id];
        [valueArray addObject:doctorobj.doctor_birthday];
        [valueArray addObject:doctorobj.doctor_gender];
        [valueArray addObject:doctorobj.doctor_cv];
        [valueArray addObject:doctorobj.doctor_skill];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where ckeyid = \"%@\" and user_id = \"%@\"", DoctorTableName, [columeArray componentsJoinedByString:@"=?,"],doctorobj.ckeyid,[AccountManager currentUserid]];
        NSLog(@"insertPatientString:%@",sqlQuery);
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
    }];
    return ret;
}
/**
 *  更新一条医生信息
 *
 *  @param doctorobj 医生对象
 *  @param db        db
 *
 *  @return 是否成功
 */
- (BOOL)updateDoctorUseTransactionWithDoctor:(Doctor *)doctorobj andDB:(FMDatabase *)db{
    
    NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
    
    NSDate* currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* strCurrentDate = [dateFormatter stringFromDate:currentDate];
    
    [columeArray addObject:@"doctor_name"];
    [columeArray addObject:@"doctor_dept"];
    [columeArray addObject:@"doctor_phone"];
    [columeArray addObject:@"doctor_email"];
    [columeArray addObject:@"doctor_hospital"];
    [columeArray addObject:@"doctor_position"];
    [columeArray addObject:@"doctor_degree"];
    [columeArray addObject:@"doctor_image"];
    [columeArray addObject:@"auth_status"];
    [columeArray addObject:@"auth_text"];
    [columeArray addObject:@"auth_pic"];
    [columeArray addObject:@"update_date"]; //更新时间
    [columeArray addObject:@"doctor_id"];
    [columeArray addObject:@"doctor_birthday"];
    [columeArray addObject:@"doctor_gender"];
    [columeArray addObject:@"doctor_cv"];
    [columeArray addObject:@"doctor_skill"];
    
    [valueArray addObject:doctorobj.doctor_name];
    [valueArray addObject:doctorobj.doctor_dept];
    [valueArray addObject:doctorobj.doctor_phone];
    [valueArray addObject:doctorobj.doctor_email];
    [valueArray addObject:doctorobj.doctor_hospital];
    [valueArray addObject:doctorobj.doctor_position];
    [valueArray addObject:doctorobj.doctor_degree];
    [valueArray addObject:doctorobj.doctor_image];
    [valueArray addObject:[NSNumber numberWithInteger:doctorobj.auth_status]];
    [valueArray addObject:doctorobj.auth_text];
    [valueArray addObject:doctorobj.auth_pic];
    if ([NSString isEmptyString:doctorobj.update_date]) {
        [valueArray addObject:[NSString stringWithString:strCurrentDate]];
    } else {
        [valueArray addObject:doctorobj.update_date];
    }
    [valueArray addObject:doctorobj.doctor_id];
    [valueArray addObject:doctorobj.doctor_birthday];
    [valueArray addObject:doctorobj.doctor_gender];
    [valueArray addObject:doctorobj.doctor_cv];
    [valueArray addObject:doctorobj.doctor_skill];
    
    // 3. 写入数据库
    NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where ckeyid = \"%@\" and user_id = \"%@\"", DoctorTableName, [columeArray componentsJoinedByString:@"=?,"],doctorobj.ckeyid,[AccountManager currentUserid]];
    NSLog(@"insertPatientString:%@",sqlQuery);
    BOOL ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
    return ret;
}

/**
 *  删除一条医生信息
 *
 *  @param userobj 医生信息
 *
 *  @return 是否成功
 */
- (BOOL)deleteDoctorWithUserObject:(Doctor *)doctorobj {
    if (doctorobj.user_id <= 0) {
        return NO;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where ckeyid = \"%@\"",DoctorTableName,doctorobj.ckeyid];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    return ret;
}

/**
 *  获取一条医生信息
 *
 *  @param ckeyid 医生ckeyid
 *
 *  @return 医生信息
 */
- (Doctor *)getDoctorWithCkeyId:(NSString *)user_id {
    if ([user_id isEmpty]) {
        return nil;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\"",DoctorTableName,user_id];
    __block Doctor *doctor = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            doctor = [Doctor doctorlWithResult:set];
        }
        [set close];
    }];
    return doctor;
}

/**
 *  获取一条医生信息
 *
 *  @param docname 医生姓名
 *
 *  @return 医生信息
 */
- (Doctor *)getDoctorWithName:(NSString *)docname {
    if ([docname isEmpty]) {
        return nil;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where doctor_name = \"%@\" and user_id = \"%@\"",DoctorTableName,docname,[AccountManager currentUserid]];
    __block Doctor *doctor = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            doctor = [Doctor doctorlWithResult:set];
        }
        [set close];
    }];
    return doctor;
}

/**
 *  获取医生列表
 *  @return 医生列表
 */
- (NSArray *)getAllDoctor {
  
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where user_id = \"%@\"",DoctorTableName,[AccountManager currentUserid]];

    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        while([set next]) {
            Doctor *doctor = [Doctor doctorlWithResult:set];
            [resultArray addObject:doctor];
        }
        [set close];
    }];
    return resultArray;
}



- (Doctor *)getDoctorNameByPatientIntroducerMapWithPatientId:(NSString *)patientId withIntrId:(NSString *)intrId{
    if ([patientId isEmpty]) {
        return nil;
    }
    
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ m,%@ d where m.doctor_id=d.doctor_id and m.patient_id=\"%@\" and m.intr_id=\"%@\" and d.user_id =\"%@\"",PatIntrMapTableName,DoctorTableName,patientId,intrId,intrId];
    __block Doctor *doctor = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            doctor = [Doctor doctorlWithResult:set];
        }
        [set close];
    }];
    return doctor;
}
@end
