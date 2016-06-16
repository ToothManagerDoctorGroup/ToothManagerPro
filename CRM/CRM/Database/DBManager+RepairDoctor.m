//
//  DBManager+RepairDoctor.m
//  CRM
//
//  Created by doctor on 15/4/24.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "DBManager+RepairDoctor.h"

@implementation DBManager (RepairDoctor)

/*
 *@brief 插入一条修复医生数据 到修复医生表中
 *@param material 数据
 */
- (BOOL)insertRepairDoctor:(RepairDoctor *)doctorobj
{
    if (doctorobj == nil || [doctorobj.user_id isEmpty]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where doctor_name = \"%@\" and ckeyid = \"%@\"",RepairDocTableName,doctorobj.doctor_name,doctorobj.ckeyid];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            ret = YES;
        }
        [set close];
    }];
    if (ret == YES) {
        ret = [self updateRepairDoctor:doctorobj];
        return ret;
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        
        /*
         doctor_id text, doctor_name text, doctor_dept text,doctor_phone text, user_id text, doctor_email text, doctor_hospital text, doctor_position text, doctor_degree text, auth_status integer, auth_text text, auth_pic text,creation_date text,
         */
        [columeArray addObject:@"ckeyid"];
        [columeArray addObject:@"doctor_name"];
        [columeArray addObject:@"doctor_phone"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"creation_time"]; //创建时间
        [columeArray addObject:@"creation_date"]; //创建时间,同步用
        [columeArray addObject:@"sync_time"]; //跟新时间
        [columeArray addObject:@"update_date"];
        [columeArray addObject:@"doctor_id"];
        
        
        [valueArray addObject:doctorobj.ckeyid];
        [valueArray addObject:doctorobj.doctor_name];
        [valueArray addObject:doctorobj.doctor_phone];
        [valueArray addObject:doctorobj.user_id];
        [valueArray addObject:[NSString currentDateString]];
        [valueArray addObject:[NSString currentDateString]];
        if (nil == doctorobj.sync_time) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:doctorobj.sync_time];
        }

        [valueArray addObject:[NSString defaultDateString]];
        [valueArray addObject:doctorobj.doctor_id];
        
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
        NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@)", RepairDocTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
        NSLog(@"insertPatientString:%@",sqlQuery);
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
    }];
    return ret;
}

/**
 *  更新一条修复医生信息
 *
 *  @param repairDoctor 修复医生信息
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)updateRepairDoctor:(RepairDoctor *)doctorobj {
    //测试可以
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
        [columeArray addObject:@"doctor_phone"];
        [columeArray addObject:@"update_date"];   //更新时间
        [columeArray addObject:@"creation_time"];
        [columeArray addObject:@"doctor_id"];
        
        [valueArray addObject:doctorobj.doctor_name];
        [valueArray addObject:doctorobj.doctor_phone];
        if (nil == doctorobj.update_date) {
            [valueArray addObject:[NSString stringWithString:strCurrentDate]];
        } else {
            [valueArray addObject:doctorobj.update_date];
        }
        [valueArray addObject:doctorobj.creation_time];
        [valueArray addObject:doctorobj.doctor_id];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where ckeyid = \"%@\" and user_id = \"%@\"", RepairDocTableName, [columeArray componentsJoinedByString:@"=?,"],doctorobj.ckeyid,[AccountManager currentUserid]];
        NSLog(@"insertPatientString:%@",sqlQuery);
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
    }];
    return ret;
}

/**
 *  删除一条修复医生信息
 *
 *  @param userobj 医生信息
 *
 *  @return 是否成功
 */
- (BOOL)deleteRepairDoctorWithCkeyId:(NSString *)ckeyid {
    //测试可以
    if (ckeyid == nil) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        
        [columeArray addObject:@"creation_date"];
    
        [valueArray addObject:[NSString defaultDateString]];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where ckeyid = \"%@\" and user_id = \"%@\"", RepairDocTableName, [columeArray componentsJoinedByString:@"=?,"],ckeyid,[AccountManager currentUserid]];
        NSLog(@"insertPatientString:%@",sqlQuery);
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
    }];
    return ret;

}

/**
 *  删除一条修复医生信息
 *
 *  @param userobj 医生信息
 *
 *  @return 是否成功
 */
- (BOOL)deleteRepairDoctorWithCkeyId_sync:(NSString *)ckeyid{
    if ([NSString isEmptyString:ckeyid]) {
        return NO;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where ckeyid = \"%@\"",RepairDocTableName,ckeyid];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    return ret;
}

/*
 *@brief 获取修复医生表中全部修复医生
 *@return NSArray 返回患者数组，没有则为nil
 */
- (NSArray *)getAllRepairDoctor
{
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where user_id = \"%@\" and creation_date > datetime(\"%@\")",RepairDocTableName,[AccountManager currentUserid],[NSString defaultDateString]];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        while([set next]) {
            RepairDoctor *doctor = [RepairDoctor repairDoctorlWithResult:set];
            [resultArray addObject:doctor];
        }
        [set close];
    }];
    return resultArray;

}

/**
 *  获取修复医生修复的病人个数
 *
 *  @param introducerId 介绍人id
 *
 *  @return 个数
 */
- (NSInteger)numberPatientsWithRepairDoctorId:(NSString *)repairDoctorId
{
    if ([NSString isEmptyString:repairDoctorId]) {
        return 0;
    }
    
    NSString *sqlStr = [NSString stringWithFormat:@"select count(ckeyid) from %@ where repair_doctor = '%@' and creation_date_sync > datetime('%@')",MedicalCaseTableName,repairDoctorId,[NSString defaultDateString]];
    __block FMResultSet *result = nil;
    __block NSInteger count = 0;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlStr];
        if (result && [result next]) {
            count = [result intForColumnIndex:0];
        }
        [result close];
    }];
    
    return count;
}

/**
 *  @brief 根据修复医生id 查询患者表
 *  @param patientId 患者id
 *  @return 患者数组
 */
- (NSArray *)getPatientByRepairDoctorId:(NSString *)repairDoctorId {
//    select * from patient where ckeyid in(
//                                          select distinct patient_id from medical_case where repair_doctor='156_20141204083956')
    __block FMResultSet* result = nil;
    
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString * sqlString = nil;
         sqlString = [NSString stringWithFormat:@"select * from '%@'  where ckeyid in ( select distinct patient_id from '%@' where repair_doctor= '%@') and user_id = '%@' and creation_date > datetime('%@')",PatientTableName,MedicalCaseTableName,repairDoctorId,[AccountManager currentUserid],[NSString defaultDateString]];
        result = [db executeQuery:sqlString];
         while ([result next])
         {
             Patient * patient = [Patient patientlWithResult:result];
             [resultArray addObject:patient];
         }
         [result close];
     }];
    
    return resultArray;
}

- (BOOL)isInRepairDoctorTable:(NSString *)phone {
    if (phone == nil) {
        return YES;
    }
    __block BOOL ret = NO;
    
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where doctor_phone = '%@' and user_id = '%@' and creation_date > datetime('%@')",RepairDocTableName,phone,[AccountManager currentUserid], [NSString defaultDateString]];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            ret = YES;
        }
        [set close];
    }];
    return ret;
}


/**
 *  获取一条医生信息
 *
 *  @param userobj 医生id
 *
 *  @return 医生信息
 */
- (RepairDoctor *)getRepairDoctorWithCkeyId:(NSString *)user_id {
    if ([user_id isEmpty]) {
        return nil;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\"",RepairDocTableName,user_id];
    __block RepairDoctor *doctor = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            doctor = [RepairDoctor repairDoctorlWithResult:set];
        }
        [set close];
    }];
    return doctor;
}

@end
