//
//  DBManager+Patients.m
//  CRM
//
//  Created by TimTiger on 5/14/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "DBManager+Patients.h"
#import "TimFramework.h"
#import "DBManager+Materials.h"
#import "DBManager+Introducer.h"
#import "LocalNotificationCenter.h"
#import "CRMUserDefalut.h"
#import "MJExtension.h"
#import "JSONKit.h"
#import "DBManager+AutoSync.h"
#import "XLPatientTotalInfoModel.h"
#import "SDWebImageManager.h"
#import "PatientManager.h"
#import "NSString+TTMAddtion.h"
#import "XLTransferRecordModel.h"

#define ImageDown [NSString stringWithFormat:@"%@%@/UploadFiles/",DomainName,Method_His_Crm]
@implementation DBManager (Patients)

/*
 *@brief 插入一条患者数据 到患者表中
 *@param patient 数据
 */
- (BOOL)insertPatient:(Patient *)patient
{
    if (patient == nil) {
        return NO;
    }
    
    __block BOOL ret = NO;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\"",PatientTableName,patient.ckeyid];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            ret = YES;
        }
        [set close];
    }];
    if (ret == YES) {
        ret = [self updatePatient:patient];
        return ret;
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"ckeyid"];
        [columeArray addObject:@"patient_name"]; //姓名
        [columeArray addObject:@"patient_phone"]; //电话
        [columeArray addObject:@"patient_avatar"];
        [columeArray addObject:@"patient_gender"];
        [columeArray addObject:@"patient_age"];
        [columeArray addObject:@"patient_status"];
        [columeArray addObject:@"ori_user_id"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"introducer_id"]; //介绍人编号
        [columeArray addObject:@"creation_date"]; //创建时间
        [columeArray addObject:@"update_date"]; //创建时间
        [columeArray addObject:@"sync_time"];
        [columeArray addObject:@"doctor_id"];
        
        [columeArray addObject:@"patient_allergy"];
        [columeArray addObject:@"patient_remark"];
        [columeArray addObject:@"idCardNum"];
        [columeArray addObject:@"patient_address"];
        [columeArray addObject:@"anamnesis"];
        [columeArray addObject:@"nickName"];
        
        [valueArray addObject:patient.ckeyid];
        [valueArray addObject:patient.patient_name];
        [valueArray addObject:patient.patient_phone];
        [valueArray addObject:patient.patient_avatar];
        [valueArray addObject:patient.patient_gender];
        [valueArray addObject:patient.patient_age];
        [valueArray addObject:[NSNumber numberWithInteger:patient.patient_status]];
        [valueArray addObject:patient.ori_user_id];
        [valueArray addObject:patient.user_id];
        [valueArray addObject:patient.introducer_id];
        if ([NSString isEmptyString:patient.creation_date]) {
            [valueArray addObject:[NSString currentDateString]];
        }else{
            [valueArray addObject:patient.creation_date];
        }
        [valueArray addObject:[NSString currentDateString]];
        if ([NSString isEmptyString:patient.sync_time]) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:patient.sync_time];
        }
        [valueArray addObject:patient.doctor_id];
        
        [valueArray addObject:patient.patient_allergy];
        [valueArray addObject:patient.patient_remark];
        [valueArray addObject:patient.idCardNum];
        [valueArray addObject:patient.patient_address];
        [valueArray addObject:patient.anamnesis];
        [valueArray addObject:patient.nickName];
        

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
        NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@)", PatientTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
        NSLog(@"insertPatientString:%@",sqlQuery);
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
    }];
    return ret;
}


- (BOOL)insertPatientBySync:(Patient *)patient{
    if (patient == nil) {
        return NO;
    }
    
    __block BOOL ret = NO;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\"",PatientTableName,patient.ckeyid];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            ret = YES;
        }
        [set close];
    }];
    if (ret == YES) {
        ret = [self updatePatientBySync:patient];
        return ret;
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"ckeyid"];
        [columeArray addObject:@"patient_name"]; //姓名
        [columeArray addObject:@"patient_phone"]; //电话
        [columeArray addObject:@"patient_avatar"];
        [columeArray addObject:@"patient_gender"];
        [columeArray addObject:@"patient_age"];
        [columeArray addObject:@"patient_status"];
        [columeArray addObject:@"ori_user_id"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"introducer_id"]; //介绍人编号
        [columeArray addObject:@"creation_date"]; //创建时间
        [columeArray addObject:@"update_date"]; //创建时间
        [columeArray addObject:@"sync_time"];
        [columeArray addObject:@"doctor_id"];
        
        [columeArray addObject:@"patient_allergy"];
        [columeArray addObject:@"patient_remark"];
        [columeArray addObject:@"idCardNum"];
        [columeArray addObject:@"patient_address"];
        [columeArray addObject:@"anamnesis"];
        [columeArray addObject:@"nickName"];
        
        [valueArray addObject:patient.ckeyid];
        [valueArray addObject:patient.patient_name];
        [valueArray addObject:patient.patient_phone];
        if ([NSString isEmptyString:patient.patient_avatar]) {
            [valueArray addObject:@"bb.jpg"];
        }else{
            [valueArray addObject:patient.patient_avatar];
        }
        if ([NSString isEmptyString:patient.patient_gender]) {
            [valueArray addObject:@"2"];
        }else{
            [valueArray addObject:patient.patient_gender];
        }
        if ([NSString isEmptyString:patient.patient_age]) {
            [valueArray addObject:@"0"];
        }else{
            [valueArray addObject:patient.patient_age];
        }
        [valueArray addObject:[NSNumber numberWithInteger:patient.patient_status]];
        if ([NSString isEmptyString:patient.ori_user_id]) {
            [valueArray addObject:@"0"];
        }else{
            [valueArray addObject:patient.ori_user_id];
        }
        [valueArray addObject:patient.user_id];
        [valueArray addObject:patient.introducer_id];
        if ([NSString isEmptyString:patient.creation_date]) {
            [valueArray addObject:[NSString currentDateString]];
        }else{
            [valueArray addObject:patient.creation_date];
        }
        [valueArray addObject:patient.update_date];
        if ([NSString isEmptyString:patient.sync_time]) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:patient.sync_time];
        }
        [valueArray addObject:patient.doctor_id];
        if (patient.patient_allergy == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:patient.patient_allergy];
        }
        if (patient.patient_remark == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:patient.patient_remark];
        }
        if (patient.idCardNum == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:patient.idCardNum];
        }
        if (patient.patient_address == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:patient.patient_address];
        }
        if (patient.anamnesis == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:patient.anamnesis];
        }
        if (patient.nickName == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:patient.nickName];
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
        [titleArray addObject:@"?"];

        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@)", PatientTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
        NSLog(@"insertPatientString:%@",sqlQuery);
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
    }];
    return ret;
}

/**
 *  判断一个通讯录用户是否已经导入成了患者
 *
 *  @param phone 号码
 *
 *  @return YES, NO
 */
- (BOOL)isInPatientsTable:(NSString*)phone {
    
    if (phone == nil) {
        return YES;
    }
    __block int count = 0;
    __block FMResultSet *set = nil;
    NSString *sqlStr = [NSString stringWithFormat:@"select count(*) as 'count' from (select patient_phone from %@ where creation_date > datetime('%@')  and doctor_id=\"%@\" union select patient_phone from %@ where creation_date > datetime('%@')  and ckeyid in (select patient_id from %@ where doctor_id=\"%@\")) p where p.patient_phone = \"%@\"",PatientTableName,[NSString defaultDateString],[AccountManager currentUserid],PatientTableName,[NSString defaultDateString],PatIntrMapTableName,[AccountManager currentUserid],phone];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            count = [set intForColumn:@"count"];
        }
        [set close];
    }];
    return count == 0 ? NO : YES;
}

- (BOOL)insertPatientsWithArray:(NSArray *)array {
    if (array.count == 0) {
        return NO;
    }
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (Patient *patient in array) {
            ret = [self insertPatient:patient withDB:db];
        }
    }];
    return ret;
}

- (BOOL)insertPatient:(Patient *)patient withDB:(FMDatabase *)db {
    if (patient == nil) {
        return NO;
    }
    
    __block BOOL ret = NO;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = '%@' and patient_phone = '%@' and user_id = '%@'",PatientTableName,patient.ckeyid,patient.patient_phone,[AccountManager currentUserid]];
    
    FMResultSet *set = nil;
    set = [db executeQuery:sqlStr];
    if (set && [set next]) {
        ret = YES;
    }
    [set close];
    
    if (ret == YES) {
        ret = [self updatePatient:patient];
        return ret;
    }
    
    NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
    
    [columeArray addObject:@"ckeyid"];
    [columeArray addObject:@"patient_name"]; //姓名
    [columeArray addObject:@"patient_phone"]; //电话
    [columeArray addObject:@"patient_avatar"];
    [columeArray addObject:@"patient_gender"];
    [columeArray addObject:@"patient_age"];
    [columeArray addObject:@"patient_status"];
    [columeArray addObject:@"ori_user_id"];
    [columeArray addObject:@"user_id"];
    [columeArray addObject:@"introducer_id"]; //介绍人编号
    [columeArray addObject:@"creation_date"]; //创建时间
    [columeArray addObject:@"update_date"];
    [columeArray addObject:@"sync_time"];
    [columeArray addObject:@"doctor_id"];
    
    [columeArray addObject:@"patient_allergy"];
    [columeArray addObject:@"patient_remark"];
    [columeArray addObject:@"idCardNum"];
    [columeArray addObject:@"patient_address"];
    [columeArray addObject:@"anamnesis"];
    [columeArray addObject:@"nickName"];
    
    [valueArray addObject:patient.ckeyid];
    [valueArray addObject:patient.patient_name];
    [valueArray addObject:patient.patient_phone];
    [valueArray addObject:patient.patient_avatar];
    [valueArray addObject:patient.patient_gender];
    [valueArray addObject:patient.patient_age];
    [valueArray addObject:[NSNumber numberWithInteger:patient.patient_status]];
    [valueArray addObject:patient.ori_user_id];
    [valueArray addObject:patient.user_id];
    [valueArray addObject:patient.introducer_id];
    [valueArray addObject:[NSString currentDateString]];
    [valueArray addObject:[NSString defaultDateString]];
    if ([NSString isEmptyString:patient.sync_time]) {
        [valueArray addObject:[NSString defaultDateString]];
    } else {
        [valueArray addObject:patient.sync_time];
    }
    [valueArray addObject:patient.doctor_id];
    
    [valueArray addObject:patient.patient_allergy];
    if (patient.patient_remark == nil) {
        [valueArray addObject:@""];
    }else{
        [valueArray addObject:patient.patient_remark];
    }
    [valueArray addObject:patient.idCardNum];
    [valueArray addObject:patient.patient_address];
    [valueArray addObject:patient.anamnesis];
    [valueArray addObject:patient.nickName];
    
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
    NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@)", PatientTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
    NSLog(@"insertPatientString:%@",sqlQuery);
    ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
    
    if (ret == NO) {
        
    }
    
    return ret;
}

/**
 *  更新患者信息
 *
 *  @param patient 患者信息
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)updatePatient:(Patient *)patient {
    if (patient == nil || patient.ckeyid <= 0) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"patient_name"]; //姓名
        [columeArray addObject:@"patient_phone"]; //电话
        [columeArray addObject:@"patient_avatar"];
        [columeArray addObject:@"patient_gender"];
        [columeArray addObject:@"patient_age"];
        [columeArray addObject:@"patient_status"];
        [columeArray addObject:@"ori_user_id"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"introducer_id"]; //介绍人编号
        [columeArray addObject:@"update_date"];
        [columeArray addObject:@"creation_date"];
        [columeArray addObject:@"sync_time"];
        [columeArray addObject:@"doctor_id"];
        
        [columeArray addObject:@"patient_allergy"];
        [columeArray addObject:@"patient_remark"];
        [columeArray addObject:@"idCardNum"];
        [columeArray addObject:@"patient_address"];
        [columeArray addObject:@"anamnesis"];
        [columeArray addObject:@"nickName"];
        
        
        [valueArray addObject:patient.patient_name];
        [valueArray addObject:patient.patient_phone];
        [valueArray addObject:patient.patient_avatar];
        [valueArray addObject:patient.patient_gender];
        [valueArray addObject:patient.patient_age];
        [valueArray addObject:[NSNumber numberWithInteger:patient.patient_status]];
        [valueArray addObject:patient.ori_user_id];
        [valueArray addObject:patient.user_id];
        [valueArray addObject:patient.introducer_id];
        //用update_date来区分是真的update还是从服务器同步后的update
        //如果是从服务器同步后update的，update_date会设置为1970年的默认时间
        if ([NSString isEmptyString:patient.update_date]) {
            [valueArray addObject:[NSString currentDateString]];
        }else {
            [valueArray addObject:patient.update_date];
        }
        if ([NSString isEmptyString:patient.creation_date]) {
            [valueArray addObject:[NSString currentDateString]];
        }else{
            [valueArray addObject:patient.creation_date];
        }
        
        if ([NSString isEmptyString:patient.sync_time]) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:patient.sync_time];
        }
        [valueArray addObject:patient.doctor_id];
        
        [valueArray addObject:patient.patient_allergy];
        if (patient.patient_remark == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:patient.patient_remark];
        }
        
        [valueArray addObject:patient.idCardNum];
        [valueArray addObject:patient.patient_address];
        [valueArray addObject:patient.anamnesis];
        [valueArray addObject:patient.nickName];
        
        
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where ckeyid = '%@'", PatientTableName, [columeArray componentsJoinedByString:@"=?,"], patient.ckeyid];
        NSLog(@"insertPatientString:%@",sqlQuery);
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
        
        }
    }];
    return ret;
}


- (BOOL)updatePatientBySync:(Patient *)patient{
    if (patient == nil || patient.ckeyid <= 0) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"patient_name"]; //姓名
        [columeArray addObject:@"patient_phone"]; //电话
        [columeArray addObject:@"patient_avatar"];
        [columeArray addObject:@"patient_gender"];
        [columeArray addObject:@"patient_age"];
        [columeArray addObject:@"patient_status"];
        [columeArray addObject:@"ori_user_id"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"introducer_id"]; //介绍人编号
        [columeArray addObject:@"sync_time"];
        [columeArray addObject:@"doctor_id"];
        [columeArray addObject:@"update_date"];
        [columeArray addObject:@"creation_date"];
        [columeArray addObject:@"patient_allergy"];
        [columeArray addObject:@"patient_remark"];
        [columeArray addObject:@"idCardNum"];
        [columeArray addObject:@"patient_address"];
        [columeArray addObject:@"anamnesis"];
        [columeArray addObject:@"nickName"];
        
        [valueArray addObject:patient.patient_name];
        [valueArray addObject:patient.patient_phone];
        if ([NSString isEmptyString:patient.patient_avatar]) {
            [valueArray addObject:@"bb.jpg"];
        }else{
            [valueArray addObject:patient.patient_avatar];
        }
        if ([NSString isEmptyString:patient.patient_gender]) {
            [valueArray addObject:@"2"];
        }else{
            [valueArray addObject:patient.patient_gender];
        }
        if ([NSString isEmptyString:patient.patient_age]) {
            [valueArray addObject:@"0"];
        }else{
            [valueArray addObject:patient.patient_age];
        }
        [valueArray addObject:[NSNumber numberWithInteger:patient.patient_status]];
        if ([NSString isEmptyString:patient.ori_user_id]) {
            [valueArray addObject:@"0"];
        }else{
            [valueArray addObject:patient.ori_user_id];
        }
        [valueArray addObject:patient.user_id];
        [valueArray addObject:patient.introducer_id];
        //用update_date来区分是真的update还是从服务器同步后的update
        //如果是从服务器同步后update的，update_date会设置为1970年的默认时间
        
        if ([NSString isEmptyString:patient.sync_time]) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:patient.sync_time];
        }
        [valueArray addObject:patient.doctor_id];
        [valueArray addObject:patient.update_date];
        if ([NSString isEmptyString:patient.creation_date]) {
            [valueArray addObject:[NSString currentDateString]];
        }else{
            [valueArray addObject:patient.creation_date];
        }
        
        [valueArray addObject:patient.patient_allergy];
        if (patient.patient_remark == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:patient.patient_remark];
        }
        if (patient.idCardNum == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:patient.idCardNum];
        }
        if (patient.patient_address == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:patient.patient_address];
        }
        if (patient.anamnesis == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:patient.anamnesis];
        }
        if (patient.nickName == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:patient.nickName];
        }
        
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where ckeyid = '%@'", PatientTableName, [columeArray componentsJoinedByString:@"=?,"], patient.ckeyid];
        NSLog(@"insertPatientString:%@",sqlQuery);
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
    }];
    return ret;
}

/*
 *@brief 删除一条患者的数据
 *@param patient_id 患者KeyID
 */
- (BOOL)deletePatientByPatientID:(NSString *)patient_id {
    
    if ([NSString isEmptyString:patient_id]) {
        return NO;
    }

    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"creation_date"];
        
        [valueArray addObject:[NSString defaultDateString]];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where ckeyid = \"%@\" and user_id = \"%@\"", PatientTableName, [columeArray componentsJoinedByString:@"=?,"],patient_id,[AccountManager currentUserid]];
        NSLog(@"insertPatientString:%@",sqlQuery);
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
    }];

    
    if (ret) {
        //删除病例
        ret = [self deleteMedicalCaseWithPatientId:patient_id];
        if (ret == NO) {
            return NO;
        }
        
        //删除预约记录
        ret = [self deleteMedicalReservesWithPatientId:patient_id];
        if (ret == NO) {
            return NO;
        }
        
        //删除耗材记录
        ret = [self deleteMedicalExpenseWithPatientId:patient_id];
        if (ret == NO) {
            return NO;
        }
        
        //删除病例记录
        ret = [self deleteMedicalRecordsWithPatientId:patient_id];
        if (ret == NO) {
            return NO;
        }
        
        //删除CTlib
        ret = [self deleteCTlibWithPatientId:patient_id];
        if (ret == NO) {
            return NO;
        }
    }
    return ret;
}

- (BOOL)deletePatientByPatientID_sync:(NSString *)patient_id {
    
    
    if ([NSString isEmptyString:patient_id]) {
        return NO;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where ckeyid = \"%@\" and user_id = \"%@\"",PatientTableName,patient_id,[AccountManager currentUserid]];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    
    return ret;
}


#if 0
/*
 *@brief 获取患者表中全部患者
 *@return NSArray 返回患者数组，没有则为nil
 */
- (NSArray *)getAllPatient
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString * sqlString = [NSString stringWithFormat:@"select * from %@ ORDER BY update_date DESC",PatientTableName];
         result = [db executeQuery:sqlString];
//         NSLog(@"sqlString:%@",sqlString);
         while ([result next])
         {
             Patient * patient = [Patient patientlWithResult:result];
             [resultArray addObject:patient];
         }
         [result close];
     }];
    
    return resultArray;
}
#endif


- (NSArray *)getAllPatientWithPage:(int)page{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sqlString = [NSString stringWithFormat:@"select a.doctor_id, a.ckeyid,a.[patient_name],a.[patient_phone],a.[patient_status],a.[update_date],a.[nickName],b.intr_name,sum(ifnull(expense_num,0)) as expense_num from (select * from patient_version2 where creation_date > datetime('%@')  and doctor_id=\"%@\" union select * from patient_version2 where creation_date > datetime('%@') and ckeyid in (select patient_id from patient_introducer_map_version2 where doctor_id=\"%@\" or intr_id=\"%@\")) a left join (select m.*,i.intr_name as intr_name from introducer_version2 i,patient_introducer_map_version2 m where m.[intr_id]=i.[ckeyid] and m.intr_source like '%%B' and m.doctor_id=\"%@\" union select m.*,i.doctor_name as intr_name from doctor_version2 i,patient_introducer_map_version2 m where m.[intr_id]=i.[doctor_id] and m.intr_source like '%%I' and m.doctor_id=\"%@\") b on a.ckeyid=b.patient_id left join (select * from %@ ee join %@ m on ee.mat_id=m.ckeyid and m.mat_type=2) e on a.[ckeyid]=e.patient_id group by a.ckeyid,a.patient_name,a.patient_status,b.intr_name order by a.update_date desc limit %i,%i",[NSString defaultDateString],[AccountManager shareInstance].currentUser.userid,[NSString defaultDateString],[AccountManager shareInstance].currentUser.userid,[AccountManager shareInstance].currentUser.userid,[AccountManager shareInstance].currentUser.userid,[AccountManager shareInstance].currentUser.userid,MedicalExpenseTableName,MaterialTableName,page * CommonPageSize,CommonPageSize];
      //join %@ m on m.ckeyid=e.[mat_id] and m.mat_type = 1
         result = [db executeQuery:sqlString];
         while ([result next])
         {
//             Patient * patient = [Patient patientlWithResult:result];
             Patient * patient = [Patient patientWithMixResult:result];
             [resultArray addObject:patient];
         }
         [result close];
     }];

    return resultArray;
}

- (NSArray *)getAllPatientWithID:(NSString *)userid {
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sqlString = [NSString stringWithFormat:@"select * from %@ where creation_date > datetime('%@')  and doctor_id=\"%@\" union select * from %@ where creation_date > datetime('%@')  and ckeyid in (select patient_id from %@ where doctor_id=\"%@\" or intr_id=\"%@\")",PatientTableName,[NSString defaultDateString],userid,PatientTableName,[NSString defaultDateString],PatIntrMapTableName,userid,userid];
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

- (NSArray *)getAllPatientWIthID:(NSString *)userid type:(NSString *)type{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *doctor_id = nil;
         NSString *intr_id = nil;
         NSString *sqlString,*sqlExtension;
         if ([type isEqualToString:@"from"]) {
             //我转给别人的
             doctor_id = userid;
             intr_id = [AccountManager currentUserid];
             sqlExtension = [NSString stringWithFormat:@"(select * from patient_version2 where creation_date > datetime('%@') and ckeyid in (select patient_id from patient_introducer_map_version2 where doctor_id=\"%@\" and intr_id=\"%@\"))",[NSString defaultDateString],doctor_id,intr_id];
//             sqlString = [NSString stringWithFormat:@"select * from %@ where ckeyid in(select patient_id from %@ where doctor_id=\"%@\" and intr_id=\"%@\")",PatientTableName,PatIntrMapTableName,userid,[AccountManager currentUserid]];
         }else if([type isEqualToString:@"to"]){
             doctor_id = [AccountManager currentUserid];
             intr_id = userid;
             sqlExtension = [NSString stringWithFormat:@"(select * from patient_version2 where creation_date > datetime('%@') and ckeyid in (select patient_id from patient_introducer_map_version2 where doctor_id=\"%@\" and intr_id=\"%@\"))",[NSString defaultDateString],doctor_id,intr_id];
             //别人转给我的
//             sqlString = [NSString stringWithFormat:@"select * from %@ where ckeyid in(select patient_id from %@ where doctor_id=\"%@\" and intr_id=\"%@\")",PatientTableName,PatIntrMapTableName,[AccountManager currentUserid],userid];
         }else{
             doctor_id = [AccountManager currentUserid];
             intr_id = userid;

             sqlExtension = [NSString stringWithFormat:@"(select * from patient_version2 where creation_date > datetime('%@') and ckeyid in (select distinct patient_id from %@ where repair_doctor = \"%@\" and user_id = '%@'))",[NSString defaultDateString],MedicalCaseTableName,userid,doctor_id];
             //我修复的
//             sqlString = [NSString stringWithFormat:@"select * from '%@'  where ckeyid in ( select distinct patient_id from '%@' where repair_doctor= '%@') and user_id = '%@' and creation_date > datetime('%@')",PatientTableName,MedicalCaseTableName,userid,[AccountManager currentUserid],[NSString defaultDateString]];
         }
         
        sqlString = [NSString stringWithFormat:@"select * from (select a.doctor_id, a.ckeyid,a.[patient_name],a.[patient_phone],a.[patient_status],a.[update_date],a.[nickName],b.intr_name,sum(ifnull(expense_num,0)) as expense_num from %@ a left join (select m.*,i.intr_name as intr_name from introducer_version2 i,patient_introducer_map_version2 m where m.[intr_id]=i.[ckeyid] and m.intr_source like '%%B' and m.doctor_id=\"%@\" union select m.*,i.doctor_name as intr_name from doctor_version2 i,patient_introducer_map_version2 m where m.[intr_id]=i.[doctor_id] and m.intr_source like '%%I' and m.doctor_id=\"%@\") b on a.ckeyid=b.patient_id left join (select * from %@ ee join %@ m on ee.mat_id=m.ckeyid and m.mat_type=2) e on a.[ckeyid]=e.patient_id group by a.ckeyid,a.patient_name,a.patient_status,b.intr_name order by a.update_date desc)",sqlExtension,[AccountManager shareInstance].currentUser.userid,[AccountManager shareInstance].currentUser.userid,MedicalExpenseTableName,MaterialTableName];
         
         result = [db executeQuery:sqlString];
         while ([result next])
         {
//             Patient *patient = [Patient patientlWithResult:result];
             Patient * patient = [Patient patientWithMixResult:result];
             [resultArray addObject:patient];
         }
         [result close];
     }];
    
    return resultArray;
}

- (NSInteger)getPatientCountWithID:(NSString *)userid type:(NSString *)type{
    __block FMResultSet* result = nil;
    __block NSInteger count = 0;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         
         NSString *sqlString;
         if ([type isEqualToString:@"from"]) {
             //我转给别人的
             sqlString = [NSString stringWithFormat:@"select count(*) as 'count' from %@ where ckeyid in(select patient_id from %@ where doctor_id=\"%@\" and intr_id=\"%@\")",PatientTableName,PatIntrMapTableName,userid,[AccountManager currentUserid]];
         }else if([type isEqualToString:@"to"]){
             //别人转给我的
             sqlString = [NSString stringWithFormat:@"select count(*) as 'count' from %@ where ckeyid in(select patient_id from %@ where doctor_id=\"%@\" and intr_id=\"%@\")",PatientTableName,PatIntrMapTableName,[AccountManager currentUserid],userid];
         }else{
             //我修复的
             sqlString = [NSString stringWithFormat:@"select count(*) as 'count' from '%@'  where ckeyid in ( select distinct patient_id from '%@' where repair_doctor= '%@') and user_id = '%@' and creation_date > datetime('%@')",PatientTableName,MedicalCaseTableName,userid,[AccountManager currentUserid],[NSString defaultDateString]];
         }
         result = [db executeQuery:sqlString];
         while (result.next) {
             count = [result intForColumn:@"count"];
         }
         [result close];
     }];
    
    return count;
}

- (NSArray *)getPatientWithKeyWords:(NSString *)keyWord{
    __block FMResultSet* result = nil;
    
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];

    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sqlString = [NSString stringWithFormat:@"select a.doctor_id, a.ckeyid,a.[patient_name],a.[patient_phone],a.[patient_status],a.[update_date],a.[nickName],b.intr_name,sum(ifnull(expense_num,0)) as expense_num from (select * from patient_version2 where creation_date > datetime('%@') and doctor_id=\"%@\" union select * from patient_version2 where creation_date > datetime('%@') and ckeyid in (select patient_id from patient_introducer_map_version2 where doctor_id=\"%@\" or intr_id=\"%@\")) a left join (select m.*,i.intr_name as intr_name from introducer_version2 i,patient_introducer_map_version2 m where m.[intr_id]=i.[ckeyid] and m.intr_source like '%%B' and m.doctor_id=\"%@\" union select m.*,i.doctor_name as intr_name from doctor_version2 i,patient_introducer_map_version2 m where m.[intr_id]=i.[doctor_id] and m.intr_source like '%%I' and m.doctor_id=\"%@\") b on a.ckeyid=b.patient_id left join (select * from %@ ee join %@ m on ee.mat_id=m.ckeyid and m.mat_type=2) e on a.[ckeyid]=e.patient_id where a.[patient_name] like '%%%@%%' or a.[nickname] like '%%%@%%' or patient_phone like '%%%@%%' group by a.ckeyid,a.patient_name,a.patient_status,b.intr_name order by a.update_date desc",[NSString defaultDateString],[AccountManager shareInstance].currentUser.userid,[NSString defaultDateString],[AccountManager shareInstance].currentUser.userid,[AccountManager shareInstance].currentUser.userid,[AccountManager shareInstance].currentUser.userid,[AccountManager shareInstance].currentUser.userid,MedicalExpenseTableName,MaterialTableName,keyWord,keyWord,keyWord];
        
         result = [db executeQuery:sqlString];

         while ([result next])
         {
             Patient * patient = [Patient patientWithMixResult:result];
             [resultArray addObject:patient];
         }
         [result close];
     }];
    
    return resultArray;
}

/**
 *  根据类型获取患者
 *
 *  @param type 患者类型
 *
 *  @return 患者数组
 */
- (NSArray *)getPatientsWithStatus:(PatientStatus )status page:(int)page{
    __block FMResultSet* result = nil;
    
    NSString *sqlExtension;
    if (status == PatientStatuspeAll) {
        sqlExtension = @"";
    }else if (status == PatientStatusUntreatUnPlanted){
        sqlExtension = [NSString stringWithFormat:@" and patient_status <= %ld and patient_status >= %ld ",(long)PatientStatusUnplanted,(long)PatientStatusUntreatment];
    }else {
        sqlExtension = [NSString stringWithFormat:@" and patient_status = %ld",(long)status];
    }
    
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sqlString = [NSString stringWithFormat:@"select a.doctor_id, a.ckeyid,a.[patient_name],a.[patient_phone],a.[patient_status],a.[update_date],a.[nickName],b.intr_name,sum(ifnull(expense_num,0)) as expense_num from (select * from patient_version2 where creation_date > datetime('%@') %@ and doctor_id=\"%@\" union select * from patient_version2 where creation_date > datetime('%@') %@ and ckeyid in (select patient_id from patient_introducer_map_version2 where doctor_id=\"%@\" or intr_id=\"%@\")) a left join (select m.*,i.intr_name as intr_name from introducer_version2 i,patient_introducer_map_version2 m where m.[intr_id]=i.[ckeyid] and m.intr_source like '%%B' and m.doctor_id=\"%@\" union select m.*,i.doctor_name as intr_name from doctor_version2 i,patient_introducer_map_version2 m where m.[intr_id]=i.[doctor_id] and m.intr_source like '%%I' and m.doctor_id=\"%@\") b on a.ckeyid=b.patient_id left join (select * from %@ ee join %@ m on ee.mat_id=m.ckeyid and m.mat_type=2) e on a.[ckeyid]=e.patient_id group by a.ckeyid,a.patient_name,a.patient_status,b.intr_name order by a.update_date desc limit %i,%i",[NSString defaultDateString],sqlExtension,[AccountManager shareInstance].currentUser.userid,[NSString defaultDateString],sqlExtension,[AccountManager shareInstance].currentUser.userid,[AccountManager shareInstance].currentUser.userid,[AccountManager shareInstance].currentUser.userid,[AccountManager shareInstance].currentUser.userid,MedicalExpenseTableName,MaterialTableName,page * CommonPageSize,CommonPageSize];
         
         result = [db executeQuery:sqlString];
         while ([result next])
         {
             Patient * patient = [Patient patientWithMixResult:result];
             [resultArray addObject:patient];
         }
         [result close];
         
     }];
    
    return resultArray;
}

/**
 *  根据类型和时间查询患者
 *
 *  @param status    患者状态 （已种植和已修复）
 *  @param startTime 开始时间 （种植时间或修复时间）
 *  @param endTime   结束时间 （种植时间或修复时间）
 *  @param page      分页
 *
 *  @return 患者数
 */
- (NSArray *)getPatientsWithStatus:(PatientStatus)status startTime:(NSString *)startTime endTime:(NSString *)endTime page:(int)page{
    
    __block FMResultSet* result = nil;

    if (status == PatientStatusUnrepaired) {
        //已种未修
        
    }else if (status == PatientStatusRepaired){
        //已修复
        
    }
    NSString *sqlExtension = [NSString stringWithFormat:@" and patient_status = %ld",(long)status];
    
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sqlString = [NSString stringWithFormat:@"select a.doctor_id, a.ckeyid,a.[patient_name],a.[patient_phone],a.[patient_status],a.[update_date],a.[nickName],b.intr_name,sum(ifnull(expense_num,0)) as expense_num from (select * from patient_version2 where creation_date > datetime('%@') %@ and doctor_id=\"%@\" union select * from patient_version2 where creation_date > datetime('%@') %@ and ckeyid in (select patient_id from patient_introducer_map_version2 where doctor_id=\"%@\" or intr_id=\"%@\")) a left join (select m.*,i.intr_name as intr_name from introducer_version2 i,patient_introducer_map_version2 m where m.[intr_id]=i.[ckeyid] and m.intr_source like '%%B' and m.doctor_id=\"%@\" union select m.*,i.doctor_name as intr_name from doctor_version2 i,patient_introducer_map_version2 m where m.[intr_id]=i.[doctor_id] and m.intr_source like '%%I' and m.doctor_id=\"%@\") b on a.ckeyid=b.patient_id left join (select * from %@ ee join %@ m on ee.mat_id=m.ckeyid and m.mat_type=2) e on a.[ckeyid]=e.patient_id group by a.ckeyid,a.patient_name,a.patient_status,b.intr_name order by a.update_date desc limit %i,%i",[NSString defaultDateString],sqlExtension,[AccountManager shareInstance].currentUser.userid,[NSString defaultDateString],sqlExtension,[AccountManager shareInstance].currentUser.userid,[AccountManager shareInstance].currentUser.userid,[AccountManager shareInstance].currentUser.userid,[AccountManager shareInstance].currentUser.userid,MedicalExpenseTableName,MaterialTableName,page * CommonPageSize,CommonPageSize];
         
         result = [db executeQuery:sqlString];
         while ([result next])
         {
             Patient * patient = [Patient patientWithMixResult:result];
             [resultArray addObject:patient];
         }
         [result close];
         
     }];
    
    return resultArray;
}

/**
 *  根据类型和时间查询患者
 *
 *  @param status    患者状态 （已种植和已修复）
 *  @param startTime 开始时间 （种植时间或修复时间）
 *  @param endTime   结束时间 （种植时间或修复时间）
 *  @param cureDoctors 治疗医生
 *  @param page      分页
 *
 *  @return 患者数
 */
- (NSArray *)getPatientsWithStatus:(PatientStatus)status startTime:(NSString *)startTime endTime:(NSString *)endTime cureDoctors:(NSArray *)cureDoctors page:(int)page{
    __block FMResultSet* result = nil;
    NSString *sqlExtension;
    NSString *keyExtension;
    NSString *keyParam;
    //有修复医生
    NSString *repairDoctorId = nil;
    if (cureDoctors && cureDoctors.count > 0) {
        if (cureDoctors.count == 1) {
            Doctor *doc = cureDoctors[0];
            repairDoctorId = doc.ckeyid;
        }else{
            NSMutableString *mString = [NSMutableString string];
            for (Doctor *doc in cureDoctors) {
                [mString appendFormat:@"%@,",doc.ckeyid];
            }
            repairDoctorId = [mString substringToIndex:mString.length - 1];
        }
    }
    switch (status) {
        case PatientStatuspeAll:
            //所有患者
            keyParam = @"creation_date";
            if (repairDoctorId == nil) {
                //判断是否选择了时间
                if ([startTime isNotEmpty] && [endTime isNotEmpty]) {
                    //选择了时间
                    keyExtension = [NSString stringWithFormat:@"select p.* from %@ p where p.creation_date >= datetime('%@') and p.creation_date <= datetime('%@') and p.patient_status >= %ld",PatientTableName,startTime,endTime,(long)PatientStatusUntreatment];
                }else{
                    //未选择时间
                    keyExtension = [NSString stringWithFormat:@"select p.* from %@ p where p.creation_date > datetime('%@') and p.patient_status >= %ld",PatientTableName,[NSString defaultDateString],(long)PatientStatusUntreatment];
                }
            }else{
                //判断是否选择了时间
                if ([startTime isNotEmpty] && [endTime isNotEmpty]) {
                    keyExtension = [NSString stringWithFormat:@"select p.* from %@ p,%@ mc where p.ckeyid=mc.patient_id and p.creation_date >= datetime('%@') and p.creation_date <= datetime('%@') and mc.repair_doctor in (%@) and p.patient_status >= %ld",PatientTableName,MedicalCaseTableName,startTime,endTime,repairDoctorId,(long)PatientStatusUntreatment];
                }else{
                    keyExtension = [NSString stringWithFormat:@"select p.* from %@ p,%@ mc where p.ckeyid=mc.patient_id and p.creation_date > datetime('%@') and mc.repair_doctor in (%@) and p.patient_status >= %ld",PatientTableName,MedicalCaseTableName,[NSString defaultDateString],repairDoctorId,(long)PatientStatusUntreatment];
                }
            }
            sqlExtension = [NSString stringWithFormat:@"(%@ and p.doctor_id='%@' union %@ and p.ckeyid in (select patient_id from %@ where doctor_id='%@' or intr_id='%@'))",keyExtension,[AccountManager currentUserid],keyExtension,PatIntrMapTableName,[AccountManager currentUserid],[AccountManager currentUserid]];
            
            break;
        case PatientStatusUntreatment:
            //未就诊
            keyParam = @"creation_date";
            sqlExtension = [self getKeySqlExtensionWithStatus:status keyParam:keyParam startTime:startTime endTime:endTime repairDoctorId:repairDoctorId];
            break;
        case PatientStatusUnplanted:
            //未种植
            keyParam = @"creation_date";
            sqlExtension = [self getKeySqlExtensionWithStatus:status keyParam:keyParam startTime:startTime endTime:endTime repairDoctorId:repairDoctorId];
            break;
        case PatientStatusUnrepaired:
            //已种未修
            keyParam = @"implant_time";
            sqlExtension = [self getKeySqlExtensionWithStatus:status keyParam:keyParam startTime:startTime endTime:endTime repairDoctorId:repairDoctorId];
            break;
        case PatientStatusRepaired:
            //已修复
            keyParam = @"repair_time";
            sqlExtension = [self getKeySqlExtensionWithStatus:status keyParam:keyParam startTime:startTime endTime:endTime repairDoctorId:repairDoctorId];
            break;
        case PatientStatusUntreatUnPlanted:
            //未就诊和未种植的
            break;
    }
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sqlString = [NSString stringWithFormat:@"select a.doctor_id, a.ckeyid,a.[patient_name],a.[patient_phone],a.[patient_status],a.[update_date],a.[nickName],b.intr_name,sum(ifnull(expense_num,0)) as expense_num from %@ a left join (select m.*,i.intr_name as intr_name from %@ i,%@ m where m.[intr_id]=i.[ckeyid] and m.intr_source like '%%B' and m.doctor_id='%@' union select m.*,i.doctor_name as intr_name from %@ i,%@ m where m.[intr_id]=i.[doctor_id] and m.intr_source like '%%I' and m.doctor_id='%@') b on a.ckeyid=b.patient_id left join (select * from %@ ee join %@ m on ee.mat_id=m.ckeyid and m.mat_type=2) e on a.[ckeyid]=e.patient_id group by a.ckeyid,a.patient_name,a.patient_status,b.intr_name order by a.update_date desc limit %i,%i",sqlExtension,IntroducerTableName,PatIntrMapTableName,[AccountManager currentUserid],DoctorTableName,PatIntrMapTableName,[AccountManager currentUserid],MedicalExpenseTableName,MaterialTableName,page * CommonPageSize,CommonPageSize];
         
         result = [db executeQuery:sqlString];
         while ([result next])
         {
             Patient * patient = [Patient patientWithMixResult:result];
             [resultArray addObject:patient];
         }
         [result close];
         
     }];
    
    return resultArray;
}

#pragma mark - 获取拼接的sql语句
- (NSString *)getKeySqlExtensionWithStatus:(PatientStatus)status keyParam:(NSString *)keyParam startTime:(NSString *)startTime endTime:(NSString *)endTime repairDoctorId:(NSString *)repairDoctorId{
    NSString *keyExtension = nil;
    NSString *sqlExtension = nil;
    //判断选择的状态
    if (status == PatientStatusUntreatment || status == PatientStatusUnplanted) {
        if (repairDoctorId == nil) {
            //判断是否选择了时间
            if ([startTime isNotEmpty] && [endTime isNotEmpty]) {
                //选择了时间
                keyExtension = [NSString stringWithFormat:@"select p.* from %@ p where p.%@ >= datetime('%@') and p.%@ <= datetime('%@') and p.patient_status = %ld",PatientTableName,keyParam,startTime,keyParam,endTime,(long)status];
            }else{
                //未选择时间
                keyExtension = [NSString stringWithFormat:@"select p.* from %@ p where p.%@ > datetime('%@') and p.patient_status = %ld",PatientTableName,keyParam,[NSString defaultDateString],(long)status];
            }
        }else{
            //判断是否选择了时间
            if ([startTime isNotEmpty] && [endTime isNotEmpty]) {
                keyExtension = [NSString stringWithFormat:@"select p.* from %@ p,%@ mc where p.ckeyid=mc.patient_id and mc.%@ >= datetime('%@') and mc.%@ <= datetime('%@') and mc.repair_doctor in (%@) and p.patient_status = %ld",PatientTableName,MedicalCaseTableName,keyParam,startTime,keyParam,endTime,repairDoctorId,(long)status];
            }else{
                keyExtension = [NSString stringWithFormat:@"select p.* from %@ p,%@ mc where p.ckeyid=mc.patient_id and mc.%@ > datetime('%@') and mc.repair_doctor in (%@) and p.patient_status = %ld",PatientTableName,MedicalCaseTableName,keyParam,[NSString defaultDateString],repairDoctorId,(long)status];
            }
        }
    }else{
        if (repairDoctorId == nil) {
            //判断是否选择了时间
            if ([startTime isNotEmpty] && [endTime isNotEmpty]) {
                keyExtension = [NSString stringWithFormat:@"select p.* from %@ p,%@ mc where p.ckeyid=mc.patient_id and mc.%@ >= datetime('%@') and mc.%@ <= datetime('%@') and p.patient_status >= %ld",PatientTableName,MedicalCaseTableName,keyParam,startTime,keyParam,endTime,(long)status];
            }else{
                keyExtension = [NSString stringWithFormat:@"select p.* from %@ p,%@ mc where p.ckeyid=mc.patient_id and mc.%@ > datetime('%@') and p.patient_status >= %ld",PatientTableName,MedicalCaseTableName,keyParam,[NSString defaultDateString],(long)status];
            }
        }else{
            //判断是否选择了时间
            if ([startTime isNotEmpty] && [endTime isNotEmpty]) {
                keyExtension = [NSString stringWithFormat:@"select p.* from %@ p,%@ mc where p.ckeyid=mc.patient_id and mc.%@ >= datetime('%@') and mc.%@ <= datetime('%@') and mc.repair_doctor in (%@) and p.patient_status >= %ld",PatientTableName,MedicalCaseTableName,keyParam,startTime,keyParam,endTime,repairDoctorId,(long)status];
            }else{
                keyExtension = [NSString stringWithFormat:@"select p.* from %@ p,%@ mc where p.ckeyid=mc.patient_id and mc.%@ > datetime('%@') and mc.repair_doctor in (%@) and p.patient_status >= %ld",PatientTableName,MedicalCaseTableName,keyParam,[NSString defaultDateString],repairDoctorId,(long)status];
            }
        }
    }
    sqlExtension = [NSString stringWithFormat:@"(%@ and p.doctor_id='%@' union %@ and p.ckeyid in (select patient_id from %@ where doctor_id='%@' or intr_id='%@'))",keyExtension,[AccountManager currentUserid],keyExtension,PatIntrMapTableName,[AccountManager currentUserid],[AccountManager currentUserid]];
    
    return sqlExtension;
}


/**
 *  根据创建时间查询患者
 *
 *  @param startTime 开始时间
 *  @param endTime   结束时间
 *  @param page      页数
 *
 *  @return 患者数
 */

- (int)getPatientsCountWithStatus:(PatientStatus )status{
    
    __block FMResultSet* result = nil;
    __block NSInteger count = 0;
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sqlString;
         if (status == PatientStatuspeAll) {
             sqlString = [NSString stringWithFormat:@"select count(*) as 'count' from %@ where user_id = \"%@\" and creation_date > datetime('%@')",PatientTableName,[AccountManager currentUserid],[NSString defaultDateString]];
         }else{
             sqlString = [NSString stringWithFormat:@"select count(*) as 'count' from %@ where patient_status = %d and user_id = \"%@\" and creation_date > datetime('%@')",PatientTableName,(int)status,[AccountManager currentUserid],[NSString defaultDateString]];
             
         }
         result = [db executeQuery:sqlString];
         
         while (result.next) {
             count = [result intForColumn:@"count"];
         }
         [result close];
     }];
    
    return (int)count;
}

- (BOOL)patientIsExist:(Patient *)patient{
    if (patient == nil) {
        return NO;
    }
    
    __block BOOL ret = NO;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where doctor_id = \"%@\" and patient_name='%@' and patient_phone = '%@'",PatientTableName,[AccountManager currentUserid],patient.patient_name,patient.patient_phone];
    
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

- (NSInteger)getAllPatientCount{
    __block FMResultSet* result = nil;
    __block NSInteger count = 0;
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sqlString = [NSString stringWithFormat:@"select count(*) as 'count' from (select * from %@ where creation_date > datetime('%@') and doctor_id=\"%@\" union select * from %@ where creation_date > datetime('%@')  and ckeyid in (select patient_id from %@ where doctor_id=\"%@\" or intr_id=\"%@\"))",PatientTableName,[NSString defaultDateString],[AccountManager currentUserid],PatientTableName,[NSString defaultDateString],PatIntrMapTableName,[AccountManager currentUserid],[AccountManager currentUserid]];
         result = [db executeQuery:sqlString];
         while (result.next) {
             count = [result intForColumn:@"count"];
         }
         [result close];
     }];
    
    return count;
}

/**
 *  获取患者信息
 *
 *  @param ckeyid 患者id
 *
 *  @return 患者信息
 */
- (Patient *)getPatientWithPatientCkeyid:(NSString *)ckeyid {
    if ([NSString isEmptyString:ckeyid]) {
        return nil;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = '%@' and creation_date > datetime('%@') and user_id = '%@'",PatientTableName,ckeyid, [NSString defaultDateString],[AccountManager currentUserid]];
    __block Patient *retPatient = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            retPatient = [Patient patientlWithResult:set];
        }
        [set close];
    }];
    return retPatient;
}

- (Patient *)getPatientCkeyid:(NSString *)ckeyid{
    if ([NSString isEmptyString:ckeyid]) {
        return nil;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = '%@' and user_id = '%@'",PatientTableName,ckeyid,[AccountManager currentUserid]];
    __block Patient *retPatient = nil;
    __block FMResultSet *set = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            retPatient = [Patient patientlWithResult:set];
        }
        [set close];
    }];
    return retPatient;
}

/*
 *@brief 通过患者表的introducer_id 获取介绍人表的信息
 *@return NSArray 返回患者数组，没有则为nil
 */
- (Introducer *)getIntroducerByIntroducerID:(NSString *)introducerId
{
    if (introducerId < 0) {
        return nil;
    }
    
    NSString * sqlString = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\" and creation_date > datetime('%@')",IntroducerTableName,introducerId,[NSString defaultDateString]];
    
//  NSLog(@"sqlString:%@",sqlString);
    __block Introducer *introducer = nil;
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlString];
        if (result && result.next) {
            introducer = [Introducer introducerlWithResult:result];
        }
        [result close];
    }];
    return introducer;
}

/**
 *  插入一条Patient Introducer Map
 *
 *  @param PatientIntroducerMap 患者介绍人对应表
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)insertPatientIntroducerMap:(PatientIntroducerMap *)PatIntro{
    if (PatIntro == nil) {
        return NO;
    }
    __block BOOL ret = NO;
    
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where patient_id = \"%@\" and doctor_id = \"%@\" and intr_source like '%%B'",PatIntrMapTableName,PatIntro.patient_id,PatIntro.doctor_id];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        __block FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            ret = YES;
        }
        [set close];
    }];
    if (ret == YES) {
        [SVProgressHUD dismiss];
        
//          [SVProgressHUD showImage:nil status:@"不能重复转诊"];
//        return YES;
        
       ret = [self updatePatientIntroducerMap:PatIntro];
       return ret;
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        /*
         @property (nonatomic,copy) NSString *patient_id;        //患者id
         @property (nonatomic,copy) NSString *introducer_id;     //介绍人id
         @property (nonatomic,copy) NSString *intr_time;         //介绍时间
         @property (nonatomic,copy) NSString *remark;            //备注
         @property (nonatomic,copy) NSString *creation_date; //创建时间
         @property (nonatomic,copy) NSString *update_date;
         @property (nonatomic,copy) NSString *sync_time;      //同步时间
         */
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"ckeyid"];
        [columeArray addObject:@"patient_id"];
        [columeArray addObject:@"intr_id"];
        [columeArray addObject:@"intr_time"];
        [columeArray addObject:@"intr_source"];
        [columeArray addObject:@"remark"];
        [columeArray addObject:@"creation_date"]; //创建时间
        [columeArray addObject:@"update_date"];
        [columeArray addObject:@"sync_time"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"doctor_id"];
        
        [valueArray addObject:PatIntro.ckeyid];
        [valueArray addObject:PatIntro.patient_id];
        [valueArray addObject:PatIntro.intr_id];
        [valueArray addObject:PatIntro.intr_time];
        [valueArray addObject:PatIntro.intr_source];
        [valueArray addObject:PatIntro.remark];
        [valueArray addObject:[NSString currentDateString]];
        [valueArray addObject:[NSString currentDateString]];
        if ([NSString isEmptyString:PatIntro.sync_time]) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:PatIntro.sync_time];
        }
        [valueArray addObject:PatIntro.user_id];
        [valueArray addObject:PatIntro.doctor_id];

        
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
        NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@) ", PatIntrMapTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
    }];
    return ret;
}

- (BOOL)insertPatientIntroducerMap_Sync:(PatientIntroducerMap *)PatIntro{
    if (PatIntro == nil) {
        return NO;
    }
    __block BOOL ret = NO;
    
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where patient_id = \"%@\" and doctor_id = \"%@\" and intr_source = '%@'",PatIntrMapTableName,PatIntro.patient_id,PatIntro.doctor_id,PatIntro.intr_source];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        __block FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            ret = YES;
        }
        [set close];
    }];
    if (ret == YES) {
        ret = [self updatePatientIntroducerMap:PatIntro];
        return ret;
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        /*
         @property (nonatomic,copy) NSString *patient_id;        //患者id
         @property (nonatomic,copy) NSString *introducer_id;     //介绍人id
         @property (nonatomic,copy) NSString *intr_time;         //介绍时间
         @property (nonatomic,copy) NSString *remark;            //备注
         @property (nonatomic,copy) NSString *creation_date; //创建时间
         @property (nonatomic,copy) NSString *update_date;
         @property (nonatomic,copy) NSString *sync_time;      //同步时间
         */
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"ckeyid"];
        [columeArray addObject:@"patient_id"];
        [columeArray addObject:@"intr_id"];
        [columeArray addObject:@"intr_time"];
        [columeArray addObject:@"intr_source"];
        [columeArray addObject:@"remark"];
        [columeArray addObject:@"creation_date"]; //创建时间
        [columeArray addObject:@"update_date"];
        [columeArray addObject:@"sync_time"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"doctor_id"];
        
        [valueArray addObject:PatIntro.ckeyid];
        [valueArray addObject:PatIntro.patient_id];
        [valueArray addObject:PatIntro.intr_id];
        [valueArray addObject:PatIntro.intr_time];
        [valueArray addObject:PatIntro.intr_source];
        [valueArray addObject:PatIntro.remark];
        [valueArray addObject:[NSString currentDateString]];
        [valueArray addObject:[NSString currentDateString]];
        if ([NSString isEmptyString:PatIntro.sync_time]) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:PatIntro.sync_time];
        }
        [valueArray addObject:PatIntro.user_id];
        [valueArray addObject:PatIntro.doctor_id];
        
        
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
        NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace  into %@ (%@) values (%@) ", PatIntrMapTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        if (ret) {
            NSLog(@"insertPtientIntrMapSuccessString:%@",sqlQuery);
        }
    }];
    return ret;
}


/**
 *  更新患者介绍人对应表
 *
 *  @param PatientIntroducerMap 患者介绍人对应表
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)updatePatientIntroducerMap:(PatientIntroducerMap *)PatIntro{
    if (PatIntro == nil || [NSString isEmptyString:PatIntro.patient_id]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"patient_id"];
        [columeArray addObject:@"intr_id"];
        [columeArray addObject:@"intr_time"];
        [columeArray addObject:@"intr_source"];
        [columeArray addObject:@"remark"];
        [columeArray addObject:@"update_date"];
        [columeArray addObject:@"sync_time"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"doctor_id"];

        [valueArray addObject:PatIntro.patient_id];
        [valueArray addObject:PatIntro.intr_id];
        [valueArray addObject:PatIntro.intr_time];
        [valueArray addObject:PatIntro.intr_source];
        [valueArray addObject:PatIntro.remark];
        //用update_date来区分是真的update还是从服务器同步后的update
        //如果是从服务器同步后update的，update_date会设置为1970年的默认时间
        if ([NSString isEmptyString:PatIntro.update_date]) {
            [valueArray addObject:[NSString currentDateString]];
        }
        else {
            [valueArray addObject:PatIntro.update_date];
        }
        if ([NSString isEmptyString:PatIntro.sync_time]) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:PatIntro.sync_time];
        }
        [valueArray addObject:PatIntro.user_id];
        [valueArray addObject:PatIntro.doctor_id];
        
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where patient_id = \"%@\" and doctor_id = \"%@\" and intr_source like '%%B'", PatIntrMapTableName, [columeArray componentsJoinedByString:@"=?,"],PatIntro.patient_id,PatIntro.doctor_id];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret) {
             NSLog(@"updatePtientIntrMapSuccessString:%@",sqlQuery);
        }
        
    }];
    return ret;

}

/**
 *  更新患者介绍人对应表,同步时使用
 *
 *  @param PatientIntroducerMap 患者介绍人对应表
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)updatePatientIntroducerMap_Sync:(PatientIntroducerMap *)PatIntro{
    if (PatIntro == nil || [NSString isEmptyString:PatIntro.patient_id]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"patient_id"];
        [columeArray addObject:@"intr_id"];
        [columeArray addObject:@"intr_time"];
        [columeArray addObject:@"intr_source"];
        [columeArray addObject:@"remark"];
        [columeArray addObject:@"update_date"];
        [columeArray addObject:@"sync_time"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"doctor_id"];
        
        
        [valueArray addObject:PatIntro.patient_id];
        [valueArray addObject:PatIntro.intr_id];
        [valueArray addObject:PatIntro.intr_time];
        [valueArray addObject:PatIntro.intr_source];
        [valueArray addObject:PatIntro.remark];
        //用update_date来区分是真的update还是从服务器同步后的update
        //如果是从服务器同步后update的，update_date会设置为1970年的默认时间
        if ([NSString isEmptyString:PatIntro.update_date]) {
            [valueArray addObject:[NSString currentDateString]];
        }
        else {
            [valueArray addObject:PatIntro.update_date];
        }
        if ([NSString isEmptyString:PatIntro.sync_time]) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:PatIntro.sync_time];
        }
        [valueArray addObject:PatIntro.user_id];
        [valueArray addObject:PatIntro.doctor_id];
        
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where patient_id = \"%@\" and doctor_id = \"%@\" and intr_source = '%@'", PatIntrMapTableName, [columeArray componentsJoinedByString:@"=?,"],PatIntro.patient_id,PatIntro.doctor_id,PatIntro.intr_source];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
        
    }];
    return ret;
}

- (BOOL)updateUpdateDate:(NSString *)patientId{

        __block BOOL ret = NO;
    
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        [columeArray addObject:@"update_date"];
        [valueArray addObject:[NSString currentDateString]];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set update_date = '%@' where ckeyid = '%@' ",PatientTableName,[NSString currentDateString],patientId];
        NSLog(@"insertPatientString:%@",sqlQuery);
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        if (ret == NO) {
            NSLog(@"存入失败");
        }
        if(ret == YES){
            NSLog(@"存入成功");
        }
    }];
    
    
    /*
    NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set update_date = '%@' where ckeyid = '%@' ",PatientTableName,[NSString currentDateString],patientId];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlQuery];
    }];
    return  ret;
    */
    return ret;
}




/**
 *  插入一条病例
 *
 *  @param medicalCase 病例信息
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)insertMedicalCase:(MedicalCase *)medicalCase {
    if (medicalCase == nil) {
        return NO;
    }
    
    __block BOOL ret = NO;

    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\"",MedicalCaseTableName,medicalCase.ckeyid];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        __block FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            ret = YES;
        }
        [set close];
    }];
    if (ret == YES) {
        ret = [self updateMedicalCase:medicalCase];
        return ret;
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"ckeyid"];
        [columeArray addObject:@"case_name"];
        [columeArray addObject:@"patient_id"];
        [columeArray addObject:@"implant_time"];
        [columeArray addObject:@"next_reserve_time"];
        [columeArray addObject:@"repair_time"];
        [columeArray addObject:@"repair_doctor"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"case_status"];
        [columeArray addObject:@"creation_date"]; //创建时间
        [columeArray addObject:@"update_date"];
        [columeArray addObject:@"sync_time"];
        [columeArray addObject:@"doctor_id"];
        [columeArray addObject:@"creation_date_sync"]; //创建时间用于，同步那边使用
        [columeArray addObject:@"repair_doctor_name"];
        [columeArray addObject:@"tooth_position"];
        [columeArray addObject:@"team_notice"];
        [columeArray addObject:@"hxGroupId"];
        
        [valueArray addObject:medicalCase.ckeyid];
        [valueArray addObject:medicalCase.case_name];
        [valueArray addObject:medicalCase.patient_id];
        [valueArray addObject:[self isDefaultDate:medicalCase.implant_time]];
        if (medicalCase.next_reserve_time == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:[self isDefaultDate:medicalCase.next_reserve_time]];
        }
        [valueArray addObject:[self isDefaultDate:medicalCase.repair_time]];
        [valueArray addObject:medicalCase.repair_doctor];
        [valueArray addObject:medicalCase.user_id];
        [valueArray addObject:[NSNumber numberWithInteger:medicalCase.case_status]];
        [valueArray addObject:medicalCase.creation_date];
        [valueArray addObject:[NSString defaultDateString]];
        if ([medicalCase.sync_time isEmpty] || medicalCase.sync_time == nil) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:medicalCase.sync_time];
        }
        [valueArray addObject:medicalCase.doctor_id];
        [valueArray addObject:[NSString currentDateString]];
        if (medicalCase.repair_doctor_name == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:medicalCase.repair_doctor_name];
        }
        if (medicalCase.tooth_position ==nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:medicalCase.tooth_position];
        }
        if (medicalCase.team_notice == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:medicalCase.team_notice];
        }
        if (medicalCase.hxGroupId == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:medicalCase.hxGroupId];
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

        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@) ", MedicalCaseTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
    }];
    return ret;
}

/**
 *  删除患者的关系数据
 *
 *  @param patientId 患者id
 *
 *  @return 成功YES 失败NO
 */
- (BOOL)deletePatientIntroducerMap:(NSString *)patientId{
    if ([NSString isEmptyString:patientId]) {
        return NO;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where patient_id = '%@' and doctor_id = '%@'",PatIntrMapTableName,patientId,[AccountManager currentUserid]];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    return ret;
}

/**
 *  删除指定的PatientIntroducerMap
 *
 *  @param patIntrMap PatientIntroducerMap
 *
 *  @return 是否删除成功
 */
- (BOOL)deletePatientIntroducerMapWithMap:(PatientIntroducerMap *)patIntrMap{
    
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where patient_id = \"%@\" and doctor_id = \"%@\" and intr_id = \"%@\"",PatIntrMapTableName,patIntrMap.patient_id,patIntrMap.doctor_id,patIntrMap.intr_id];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    return ret;
}

/**
 *  获取患者的转诊记录
 *
 *  @param patientId 患者id
 *
 *  @return 转诊记录数组
 */
- (NSArray *)getPatientTransferRecordWithPatientId:(NSString *)patientId{
    NSString *sqlStr = [NSString stringWithFormat:@"select distinct pm.doctor_id,pm.intr_time,d.doctor_name,d.doctor_image from %@ pm join %@ d on d.ckeyid=pm.doctor_id where pm.patient_id='%@' and pm.intr_source='I' and pm.user_id='%@' order by intr_time desc",PatIntrMapTableName,DoctorTableName,patientId,[AccountManager currentUserid]];
    __block FMResultSet *resultSet;
    __block NSMutableArray *resultArray = [NSMutableArray array];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        resultSet = [db executeQuery:sqlStr];
        int i = 1;
        while (resultSet.next) {
            XLTransferRecordModel *model = [XLTransferRecordModel transferRecordModelWithResultSet:resultSet];
            model.number = i;
            [resultArray addObject:model];
            i++;
        }
        [resultSet close];
    }];
    
    return resultArray;
}



#pragma mark - 判断时间是否是默认时间
- (NSString *)isDefaultDate:(NSString *)dateStr{
    if (dateStr == nil) {
        return @"";
    }
    NSString *dateTmp = [dateStr componentsSeparatedByString:@" "][0];
    if ([dateTmp isEqualToString:@"1900-01-01"]) {
        return @"";
    }else{
        return dateStr;
    }
}


/**
 *  更新病例
 *
 *  @param medicalCase 病例
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)updateMedicalCase:(MedicalCase *)medicalCase {
    if (medicalCase == nil || [NSString isEmptyString:medicalCase.ckeyid]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        // \"case_name\" text,\n\t \"creation_date\" text ,\n\t \"patient_id\" integer,\n\t \"case_status\" integer"];
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"case_name"];
        [columeArray addObject:@"patient_id"];
        [columeArray addObject:@"implant_time"];
        [columeArray addObject:@"next_reserve_time"];
        [columeArray addObject:@"repair_time"];
        [columeArray addObject:@"repair_doctor"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"case_status"];
        [columeArray addObject:@"update_date"];
        [columeArray addObject:@"sync_time"];
        [columeArray addObject:@"doctor_id"];
        [columeArray addObject:@"creation_date"];
        [columeArray addObject:@"repair_doctor_name"];
        [columeArray addObject:@"tooth_position"];
        [columeArray addObject:@"team_notice"];
        [columeArray addObject:@"hxGroupId"];
        
        [valueArray addObject:medicalCase.case_name];
        [valueArray addObject:medicalCase.patient_id];
        [valueArray addObject:[self isDefaultDate:medicalCase.implant_time]];
        [valueArray addObject:[self isDefaultDate:medicalCase.next_reserve_time]];
        [valueArray addObject:[self isDefaultDate:medicalCase.repair_time]];
        [valueArray addObject:medicalCase.repair_doctor];
        [valueArray addObject:medicalCase.user_id];
        [valueArray addObject:[NSNumber numberWithInteger:medicalCase.case_status]];
        //用update_date来区分是真的update还是从服务器同步后的update
        //如果是从服务器同步后update的，update_date会设置为1970年的默认时间
        if ([NSString isEmptyString:medicalCase.update_date]) {
            [valueArray addObject:[NSString currentDateString]];
        }
        else {
            [valueArray addObject:medicalCase.update_date];
        }
        if ([NSString isEmptyString:medicalCase.sync_time]) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:medicalCase.sync_time];
        }
        [valueArray addObject:medicalCase.doctor_id];
        [valueArray addObject:medicalCase.creation_date];
        if (medicalCase.repair_doctor_name == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:medicalCase.repair_doctor_name];
        }
        if (medicalCase.tooth_position == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:medicalCase.tooth_position];
        }
        if (medicalCase.team_notice == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:medicalCase.team_notice];
        }
        if (medicalCase.hxGroupId == nil) {
            [valueArray addObject:@""];
        }else{
            [valueArray addObject:medicalCase.hxGroupId];
        }

        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where ckeyid = \"%@\"", MedicalCaseTableName, [columeArray componentsJoinedByString:@"=?,"],medicalCase.ckeyid];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
        
    }];
    return ret;
}

/**
 *  根据病例id获取病例
 *
 *  @param caseid 病例id
 *
 *  @return 病例
 */
- (MedicalCase *)getMedicalCaseWithCaseId:(NSString *)caseid {
    if (caseid < 0) {
        return nil;
    }
    
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\" and creation_date_sync > datetime('%@')",MedicalCaseTableName,caseid,[NSString defaultDateString]];
    __block MedicalCase *medicalCase = nil;
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlStr];
        if (result && [result next]) {
            medicalCase = [MedicalCase medicalCaseWithResult:result];
        }
        [result close];
    }];
    return medicalCase;
}

- (BOOL)deleteMedicalCaseWithCaseId:(NSString *)caseid {
    if (caseid <= 0) {
        return NO;
    }
    
    //在删除的时候把create_date设为初始值，等同步成功后，由同步模块删除
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"creation_date_sync"]; //更新时间
        
        [valueArray addObject:[NSString defaultDateString]];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where ckeyid = \"%@\"", MedicalCaseTableName, [columeArray componentsJoinedByString:@"=?,"],caseid];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
    }];
    
    
    if (ret) {
        //删除预约记录
        [self deleteMedicalReserveWithCaseId:caseid];
        //删除耗材记录
        [self deleteMedicalExpenseWithCaseId:caseid];
        //删除病例记录
        [self deleteMedicalRecordWithCaseId:caseid];
        //删除CTlib
        [self deleteCTlibWithCaseId:caseid];
    }
    
    return ret;
}

- (BOOL)deleteMedicalExpenseWithCaseId_sync:(NSString *)caseid {
    if (caseid <= 0) {
        return NO;
    }
    
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where ckeyid = \"%@\"",MedicalCaseTableName,caseid];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    return ret;
}

- (BOOL)deleteMedicalCaseWithPatientId:(NSString *)patientId {
    if ([NSString isEmptyString:patientId]) {
        return NO;
    }
    
    //在删除的时候把create_date设为初始值，等同步成功后，由同步模块删除
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"creation_date_sync"]; //更新时间
        
        [valueArray addObject:[NSString defaultDateString]];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where patient_id = \"%@\" and user_id = \"%@\"", MedicalCaseTableName, [columeArray componentsJoinedByString:@"=?,"],patientId,[AccountManager currentUserid]];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
    }];
    return ret;

}

- (BOOL)deleteMedicalCaseWithPatientId_sync:(NSString *)patientId {
    if ([NSString isEmptyString:patientId]) {
        return NO;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where patient_id = '%@' and doctor_id = '%@'",MedicalCaseTableName,patientId,[AccountManager currentUserid]];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    return ret;
}

- (BOOL)deleteMedicalCaseWithCase_AutoSync:(MedicalCase *)mCase{
    if (![mCase.ckeyid isNotEmpty]) {
        return NO;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where ckeyid = \"%@\"",MedicalCaseTableName,mCase.ckeyid];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    
    return ret;
}

/**
 *  插入一条MedicalReserve
 */
- (BOOL)insertMedicalReserve:(MedicalReserve *)medicalReserve {
    
    if (medicalReserve == nil) {
        return NO;
    }
    
    __block BOOL ret = NO;
     NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = '%@'",MedicalReserveTableName,medicalReserve.ckeyid];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            ret = YES;
        }
        [set close];
    }];
    if (ret == YES) {
        ret = [self updateMedicalReserve:medicalReserve];
        return ret;
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        
        NSDate* currentDate = [NSDate date];
        
        [columeArray addObject:@"ckeyid"];
        [columeArray addObject:@"patient_id"];
        [columeArray addObject:@"case_id"];
        [columeArray addObject:@"reserve_time"];
        [columeArray addObject:@"actual_time"];
        [columeArray addObject:@"repair_time"];
        [columeArray addObject:@"creation_date_sync"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"update_date"];
        [columeArray addObject:@"doctor_id"];
        [columeArray addObject:@"creation_date"];
        
        
        [valueArray addObject:medicalReserve.ckeyid];
        [valueArray addObject:medicalReserve.patient_id];
        [valueArray addObject:medicalReserve.case_id];
        [valueArray addObject:medicalReserve.reserve_time];
        [valueArray addObject:medicalReserve.actual_time];
        [valueArray addObject:medicalReserve.repair_time];
        [valueArray addObject:[NSString stringWithString:[currentDate description]]];
        [valueArray addObject:medicalReserve.user_id];
        [valueArray addObject:[NSString defaultDateString]];
        [valueArray addObject:medicalReserve.doctor_id];
        [valueArray addObject:medicalReserve.creation_date];
        
        
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
        NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@) ", MedicalReserveTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        
    }];
    
//    if ([NSString isNotEmptyString:medicalReserve.reserve_time] && ![medicalReserve.reserve_time  isEqualToString:@"0"]) {
//        LocalNotification *notificaton = [[LocalNotification alloc]init];
//       // notificaton.reserve_content = @"种植";//[self getPatientWithPatientCkeyid:medicalReserve.patient_id].patient_name;
//        notificaton.reserve_time = medicalReserve.reserve_time;//[NSString stringWithFormat:@"预约 %@ 前来",medicalReserve.reserve_time];
//       // notificaton.reserve_type = RepeatIntervalNone;
//        
//        notificaton.reserve_content = RepeatIntervalNone;
//        notificaton.reserve_type = @"种植";
//        
//        notificaton.medical_place = [AccountManager shareInstance].currentUser.hospitalName;
//        notificaton.medical_chair = @"";
//        notificaton.patient_id = medicalReserve.patient_id;
//        notificaton.user_id = [AccountManager currentUserid];
//        [[LocalNotificationCenter shareInstance] addLocalNotification:notificaton];
//    }
    
    if (ret) {
        [self updatePatientStatusWithMedicalReserve:medicalReserve];
    }
    return ret;
}

/**
 *  更新一条MedicalReserve
 *
 *  @param medicalReserve 预约记录
 *
 *  @return 成功yes,失败NO
 */
- (BOOL)updateMedicalReserve:(MedicalReserve *)medicalReserve {
    if (medicalReserve == nil ||  [NSString isEmptyString:medicalReserve.ckeyid]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        // \"patient_id\" integer,\n\t \"case_id\" integer ,\n\t \"reserve_time\" text,\n\t \"actual_time\" text,\n\t \"repair_time\" text,\n\t \"creation_date\" text,\n\t"];
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"patient_id"];
        [columeArray addObject:@"case_id"];
        [columeArray addObject:@"reserve_time"];
        [columeArray addObject:@"actual_time"];
        [columeArray addObject:@"repair_time"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"update_date"];
        [columeArray addObject:@"doctor_id"];
        [columeArray addObject:@"creation_date"];
        
        [valueArray addObject:medicalReserve.patient_id];
        [valueArray addObject:medicalReserve.case_id];
        [valueArray addObject:medicalReserve.reserve_time];
        [valueArray addObject:medicalReserve.actual_time];
        [valueArray addObject:medicalReserve.repair_time];
        [valueArray addObject:medicalReserve.user_id];
        if ([NSString isEmptyString:medicalReserve.update_date]) {
           [valueArray addObject:[NSString currentDateString]];
        } else {
           [valueArray addObject:[NSString stringWithString:medicalReserve.update_date]];
        }
        [valueArray addObject:medicalReserve.doctor_id];
        [valueArray addObject:medicalReserve.creation_date];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@  set %@=? where ckeyid = '%@'", MedicalReserveTableName, [columeArray componentsJoinedByString:@"=?,"],medicalReserve.ckeyid];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
    }];
    
    //自动添加通知，暂时注释掉
    /*if ([medicalReserve.reserve_time isNotEmpty] && ![medicalReserve.reserve_time isEqualToString:@"0"]) {
        LocalNotification *notificaton = [[LocalNotification alloc]init];
       // notificaton.reserve_content = @"种植";
        //[self getPatientWithPatientCkeyid:medicalReserve.patient_id].patient_name;
        notificaton.reserve_time = medicalReserve.reserve_time;
        //[NSString stringWithFormat:@"预约 %@ 前来",medicalReserve.reserve_time];
      //  notificaton.reserve_type = RepeatIntervalNone;
        
        notificaton.reserve_content = RepeatIntervalNone;
        notificaton.reserve_type = @"种植";
        
        notificaton.medical_place = [AccountManager shareInstance].currentUser.hospitalName;
        notificaton.medical_chair = @"";
        
        notificaton.patient_id = medicalReserve.patient_id;
        notificaton.user_id = [AccountManager currentUserid];
        notificaton.doctor_id = [AccountManager currentUserid];
        [[LocalNotificationCenter shareInstance] addLocalNotification:notificaton];
    }*/
    
    if (ret) { //病例保存成功，更新患者状态
       [self updatePatientStatusWithMedicalReserve:medicalReserve];
    }
    
    return ret;
}

- (BOOL)updatePatientStatusWithMedicalReserve:(MedicalReserve *)medicalReserve {
    BOOL ret = NO;
    if (![medicalReserve hasActualDate]) {
        ret = [self updatePatientStatus:PatientStatusUnplanted withPatientId:medicalReserve.patient_id];
    } else if ([medicalReserve hasActualDate] && ![medicalReserve hasRepairDate]) {
        ret = [self updatePatientStatus:PatientStatusUnrepaired withPatientId:medicalReserve.patient_id];
    } else if ([medicalReserve hasRepairDate]) {
        ret = [self updatePatientStatus:PatientStatusRepaired withPatientId:medicalReserve.patient_id];
    }
    return ret;
}

- (BOOL)updatePatientStatus:(PatientStatus)status withPatientId:(NSString *)patientId {
    if (patientId <= 0) {
        return NO;
    }
    NSTimeInterval updateTime = [[NSDate date] timeIntervalSince1970];
    NSString *sqlStr = [NSString stringWithFormat:@"update %@ set patient_status = %d ,update_date = %lf ,update_date = \"%@\" where ckeyid = \"%@\"",PatientTableName,(int)status,updateTime,[NSString currentDateString],patientId];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    return  ret;
}

/**
 *  获取病例预约信息
 *
 *  @param caseid 病例id
 *
 *  @return 病例信息
 */
- (MedicalReserve *)getMedicalReserveWithCaseId:(NSString *)caseid {
    if ([NSString isEmptyString:caseid]) {
        return nil;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where case_id = \"%@\" and creation_date_sync > datetime('%@')",MedicalReserveTableName,caseid, [NSString defaultDateString]];
    __block FMResultSet *resultSet = nil;
    __block MedicalReserve *medicalReserve = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        resultSet = [db executeQuery:sqlStr];
        if (resultSet && [resultSet next]) {
            medicalReserve  = [MedicalReserve medicalReserveWithResult:resultSet];
        }
        [resultSet close];
    }];
    return medicalReserve;
}

- (BOOL)deleteMedicalReservesWithPatientId:(NSString *)patientId {
    if ([NSString isEmptyString:patientId]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        // \"patient_id\" integer,\n\t \"case_id\" integer ,\n\t \"reserve_time\" text,\n\t \"actual_time\" text,\n\t \"repair_time\" text,\n\t \"creation_date\" text,\n\t"];
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"creation_date_sync"];
        
        [valueArray addObject:[NSString defaultDateString]];
        
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@  set %@=? where patient_id = \"%@\" and user_id = \"%@\"", MedicalReserveTableName, [columeArray componentsJoinedByString:@"=?,"],patientId,[AccountManager currentUserid]];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
    }];
     
    return ret;
}



- (BOOL)deleteMedicalReserveWithCaseId:(NSString *)caseid {
    if (caseid <= 0) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        // \"patient_id\" integer,\n\t \"case_id\" integer ,\n\t \"reserve_time\" text,\n\t \"actual_time\" text,\n\t \"repair_time\" text,\n\t \"creation_date\" text,\n\t"];
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"creation_date_sync"];
        
        [valueArray addObject:[NSString defaultDateString]];
        
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@  set %@=? where case_id = \"%@\"", MedicalReserveTableName, [columeArray componentsJoinedByString:@"=?,"],caseid];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
    }];

    return ret;
}

- (BOOL)deleteMedicalReserveWithCaseId_sync:(NSString *)caseid {
    if (caseid <= 0) {
        return NO;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where case_id = %@",MedicalReserveTableName,caseid];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    return ret;
}

/**
 *  插入一条会诊信息
 *
 *  @param patientConsultation 会诊信息
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)insertPatientConsultation:(PatientConsultation *)patientConsultation{
    if (patientConsultation == nil) {
        return NO;
    }
    
    __block BOOL ret = NO;
    
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\"",PatientConsultationTableName,patientConsultation.ckeyid];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        __block FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            ret = YES;
        }
        [set close];
    }];
    if (ret == YES) {
        ret = [self updatePatientConsultation:patientConsultation];
        return ret;
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"ckeyid"];
        [columeArray addObject:@"patient_id"];
        [columeArray addObject:@"doctor_name"];
        [columeArray addObject:@"amr_file"];
        [columeArray addObject:@"amr_time"];
        [columeArray addObject:@"cons_type"];
        [columeArray addObject:@"cons_content"];
        [columeArray addObject:@"data_flag"];
        [columeArray addObject:@"creation_date"]; //创建时间
        [columeArray addObject:@"update_date"];
        [columeArray addObject:@"sync_time"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"doctor_id"];
        
        
        [valueArray addObject:patientConsultation.ckeyid];
        [valueArray addObject:patientConsultation.patient_id];
        [valueArray addObject:patientConsultation.doctor_name];
        [valueArray addObject:patientConsultation.amr_file];
        [valueArray addObject:patientConsultation.amr_time];
        [valueArray addObject:patientConsultation.cons_type];
        [valueArray addObject:patientConsultation.cons_content];
        [valueArray addObject:[NSString stringWithFormat:@"%ld",patientConsultation.data_flag]];
        
        
        [valueArray addObject:patientConsultation.creation_date];
        [valueArray addObject:[NSString defaultDateString]];
        if ([NSString isEmptyString:patientConsultation.sync_time]) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:patientConsultation.sync_time];
        }
        [valueArray addObject:patientConsultation.user_id];
        [valueArray addObject:patientConsultation.doctor_id];
        
        
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
        NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@) ", PatientConsultationTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
    }];
    return ret;
    
}

- (BOOL)updatePatientConsultation:(PatientConsultation *)patientConsultation{
    if (patientConsultation == nil || [NSString isEmptyString:patientConsultation.patient_id]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"patient_id"];
        [columeArray addObject:@"doctor_name"];
        [columeArray addObject:@"amr_file"];
        [columeArray addObject:@"amr_time"];
        [columeArray addObject:@"cons_type"];
        [columeArray addObject:@"cons_content"];
        [columeArray addObject:@"data_flag"];
        [columeArray addObject:@"creation_date"];
        
        [columeArray addObject:@"update_date"];
        [columeArray addObject:@"sync_time"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"doctor_id"];
        
        
        [valueArray addObject:patientConsultation.patient_id];
        [valueArray addObject:patientConsultation.doctor_name];
        [valueArray addObject:patientConsultation.amr_file];
        [valueArray addObject:patientConsultation.amr_time];
        [valueArray addObject:patientConsultation.cons_type];
        [valueArray addObject:patientConsultation.cons_content];
        [valueArray addObject:[NSString stringWithFormat:@"%ld",patientConsultation.data_flag]];
        [valueArray addObject:patientConsultation.creation_date];
        //用update_date来区分是真的update还是从服务器同步后的update
        //如果是从服务器同步后update的，update_date会设置为1970年的默认时间
        if ([NSString isEmptyString:patientConsultation.update_date]) {
            [valueArray addObject:[NSString currentDateString]];
        }else {
            [valueArray addObject:patientConsultation.update_date];
        }
        if ([NSString isEmptyString:patientConsultation.sync_time]) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:patientConsultation.sync_time];
        }
        [valueArray addObject:patientConsultation.user_id];
        [valueArray addObject:patientConsultation.doctor_id];
        
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where ckeyid = \"%@\"", PatientConsultationTableName, [columeArray componentsJoinedByString:@"=?,"],patientConsultation.ckeyid];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
        
    }];
    return ret;
}


- (NSArray *)getPatientConsultationWithPatientId:(NSString *)patientId{
    if ([NSString isEmptyString:patientId]) {
        return  nil;
    }
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where patient_id = \"%@\" and user_id =  \"%@\" and creation_date > datetime('%@')",PatientConsultationTableName,patientId,[AccountManager currentUserid], [NSString defaultDateString]];
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlStr];
        while (result && [result next]) {
            PatientConsultation *patientC = [PatientConsultation patientConsultationWithResult:result];
            [resultArray addObject:patientC];
        }
        [result close];
    }];
    return resultArray;
    
    
}

- (PatientConsultation *)getPatientConsultationWithCkeyId:(NSString *)ckeyid{
    if ([NSString isEmptyString:ckeyid]) {
        return nil;
    }
    
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\"",PatientConsultationTableName,ckeyid];
    __block PatientConsultation *patientC = nil;
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlStr];
        if (result && [result next]) {
            patientC = [PatientConsultation patientConsultationWithResult:result];
        }
        [result close];
    }];
    return patientC;
}

- (BOOL)deletePatientConsultationWithPatientId_sync:(NSString *)patientId {
    if ([NSString isEmptyString:patientId]) {
        return NO;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where patient_id = '%@' and doctor_id = '%@'",PatientConsultationTableName,patientId,[AccountManager currentUserid]];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    return ret;
}

- (BOOL)deletePatientConsultationWithCkeyId_sync:(NSString *)ckeyId{
    if ([NSString isEmptyString:ckeyId]) {
        return NO;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where ckeyid = '%@'",PatientConsultationTableName,ckeyId];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    return ret;
}


/**
 *  插入一条病例记录
 *
 *  @param medicalRecord 病例记录信息
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)insertMedicalRecord:(MedicalRecord *)medicalRecord {
    if (medicalRecord == nil) {
        return NO;
    }
    
    __block BOOL ret = NO;
     NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\"",MedicalRecordableName,medicalRecord.ckeyid];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            ret = YES;
        }
        [set close];
    }];
    if (ret == YES) {
        ret = [self updateMedicalRecord:medicalRecord];
        return ret;
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        // "patient_id\" integer,\n\t \"case_id\" integer ,\n\t \"record_content\" text,\n\t \"creation_date\" text"];
        /*
         @property (nonatomic,copy) NSString *patient_id;   //患者id
         @property (nonatomic,copy) NSString  *case_id;      //病例id
         @property (nonatomic,copy) NSString *record_content;           //就诊记录
         @property (nonatomic,copy) NSString* creationdate;   //创建时间
         @property (nonatomic,copy) NSString *user_id;    //医生id
         @property (nonatomic,copy) NSString *update_date;
         @property (nonatomic,copy) NSString *sync_time;      //同步时间
         */
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"ckeyid"];
        [columeArray addObject:@"patient_id"];
        [columeArray addObject:@"case_id"];
        [columeArray addObject:@"record_content"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"creation_date_sync"];
        [columeArray addObject:@"update_date"];
        [columeArray addObject:@"sync_time"];
        [columeArray addObject:@"doctor_id"];
        [columeArray addObject:@"creation_date"];
        
        [valueArray addObject:medicalRecord.ckeyid];
        [valueArray addObject:medicalRecord.patient_id];
        [valueArray addObject:medicalRecord.case_id];
        [valueArray addObject:medicalRecord.record_content];
        [valueArray addObject:medicalRecord.user_id];
        [valueArray addObject:[NSString currentDateString]];
        [valueArray addObject:[NSString defaultDateString]];
        if ([NSString isEmptyString:medicalRecord.sync_time]) {
          [valueArray addObject:[NSString defaultDateString]];
        } else {
          [valueArray addObject:medicalRecord.sync_time];
        }
        [valueArray addObject:medicalRecord.doctor_id];
        [valueArray addObject:medicalRecord.creation_date];
        
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
        NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@) ", MedicalRecordableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
    }];
    return ret;
}

/**
 *  更新一条病例记录
 *
 *  @param medicalRecord 病例记录信息
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)updateMedicalRecord:(MedicalRecord *)medicalRecord {
    if (medicalRecord == nil || [NSString isEmptyString:medicalRecord.ckeyid]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        // "patient_id\" integer,\n\t \"case_id\" integer ,\n\t \"record_content\" text,\n\t \"creation_date\" text"];
      
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        NSDate* currentDate = [NSDate date];
        [columeArray addObject:@"patient_id"];
        [columeArray addObject:@"case_id"];
        [columeArray addObject:@"record_content"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"update_date"];
        [columeArray addObject:@"sync_time"];
        [columeArray addObject:@"doctor_id"];
        [columeArray addObject:@"creation_date"];
        
        [valueArray addObject:medicalRecord.patient_id];
        [valueArray addObject:medicalRecord.case_id];
        [valueArray addObject:medicalRecord.record_content];
        [valueArray addObject:medicalRecord.user_id];
        [valueArray addObject:[NSString stringWithString:[currentDate description]]];
        if ([NSString isEmptyString:medicalRecord.sync_time]) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:medicalRecord.sync_time];
        }
        [valueArray addObject:medicalRecord.doctor_id];
        [valueArray addObject:medicalRecord.creation_date];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where ckeyid = \"%@\"", MedicalRecordableName, [columeArray componentsJoinedByString:@"=?,"],medicalRecord.ckeyid];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
    }];
    return ret;

}

/**
 *  删除一条病例记录
 *
 *  @param medicalRecordId 记录id
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)deleteMedicalRecordWithId:(NSString *)medicalRecordId {
    if (medicalRecordId <= 0) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        // "patient_id\" integer,\n\t \"case_id\" integer ,\n\t \"record_content\" text,\n\t \"creation_date\" text"];
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"creation_date_sync"];
        
        [valueArray addObject:[NSString defaultDateString]];

        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where ckeyid = \"%@\"", MedicalRecordableName, [columeArray componentsJoinedByString:@"=?,"],medicalRecordId];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
    }];

    return ret;
}

- (BOOL)deleteMedicalRecordWithId_Sync:(NSString *)medicalRecordId {
    if (medicalRecordId <= 0) {
        return NO;
    }
    
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where ckeyid = '%@'",MedicalRecordableName,medicalRecordId];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    return ret;
}


- (BOOL)deleteMedicalRecordsWithPatientId:(NSString *)patientId {
    if ([NSString isEmptyString:patientId]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        // "patient_id\" integer,\n\t \"case_id\" integer ,\n\t \"record_content\" text,\n\t \"creation_date\" text"];
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"creation_date_sync"];
        
        [valueArray addObject:[NSString defaultDateString]];
        
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where patient_id = \"%@\" and user_id = \"%@\"", MedicalRecordableName, [columeArray componentsJoinedByString:@"=?,"],patientId,[AccountManager currentUserid]];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
    }];

    return ret;
}

- (BOOL)deleteMedicalRecordWithCaseId:(NSString *)caseid {
    if (caseid <= 0) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        // "patient_id\" integer,\n\t \"case_id\" integer ,\n\t \"record_content\" text,\n\t \"creation_date\" text"];
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"creation_date_sync"];
        
        [valueArray addObject:[NSString defaultDateString]];
        
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where case_id = \"%@\"", MedicalRecordableName, [columeArray componentsJoinedByString:@"=?,"],caseid];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
    }];

    return ret;
}

- (BOOL)deleteMedicalRecordWithCaseId_sync:(NSString *)caseid{
    if (caseid <= 0) {
        return NO;
    }
    
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where case_id = '%@' and doctor_id = '%@'",MedicalRecordableName,caseid,[AccountManager currentUserid]];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    
    
    return ret;
}

/**
 *  @brief 根据病例id获取病例记录
 *
 *  @param caseid 病例id
 *
 *  @return 病例记录
 */
- (NSArray *)getMedicalRecordWithCaseId:(NSString *)caseid {
    
    if ([NSString isEmptyString:caseid]) {
        return nil;
    }
    
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where case_id = \"%@\" and creation_date_sync > datetime('%@')",MedicalRecordableName,caseid, [NSString defaultDateString]];
    __block NSMutableArray *resultRecordArray = [NSMutableArray arrayWithCapacity:0];
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlStr];
        while ([result next]) {
            MedicalRecord *resultRecord = [MedicalRecord medicalRecordWithResult:result];
            [resultRecordArray addObject:resultRecord];
        }
        [result close];
    }];
    return resultRecordArray;
}

- (MedicalRecord *)getMedicalRecordWithCkeyId:(NSString *)ckeyId{
    if ([NSString isEmptyString:ckeyId]) {
        return nil;
    }
    
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\"",MedicalRecordableName,ckeyId];
    __block MedicalRecord *medicalRecord = nil;
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlStr];
        if (result && [result next]) {
            medicalRecord = [MedicalRecord medicalRecordWithResult:result];
        }
        [result close];
    }];
    return medicalRecord;

}

/**
 *  插入一条CT记录
 *
 *  @param ctlib CT信息
 *
 *  @return 成功YES ,失败NO
 */
- (BOOL)insertCTLib:(CTLib *)ctlib {
//    \"patient_id\" integer,\n\t \"case_id\" integer ,\n\t \"ct_image\" text,\n\t \"ct_desc\" text,\n\t \"creation_date\" text"];
    if (ctlib == nil || ctlib.user_id == nil) {
        return NO;
    }
    
    __block BOOL ret = NO;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\"",CTLibTableName, ctlib.ckeyid];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            ret = YES;
        }
        [set close];
    }];
    if (ret) {
        ret = [self updateCTLib:ctlib];
        return ret;
    }

    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"ckeyid"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"patient_id"];
        [columeArray addObject:@"case_id"];
        [columeArray addObject:@"ct_image"];
        [columeArray addObject:@"ct_desc"];
        [columeArray addObject:@"creation_date_sync"];
        [columeArray addObject:@"update_date"]; //创建时间
        [columeArray addObject:@"sync_time"];
        [columeArray addObject:@"doctor_id"];
        [columeArray addObject:@"creation_date"];
        [columeArray addObject:@"is_main"];
        
        [valueArray addObject:ctlib.ckeyid];
        [valueArray addObject:ctlib.user_id];
        if (nil == ctlib.patient_id) {
            [valueArray addObject:@""];
        } else {
            [valueArray addObject:ctlib.patient_id];
        }
        
        [valueArray addObject:ctlib.case_id];
        [valueArray addObject:ctlib.ct_image];
        [valueArray addObject:ctlib.ct_desc];
        [valueArray addObject:[NSString currentDateString]];
        [valueArray addObject:[NSString defaultDateString]];
        if ([NSString isEmptyString:ctlib.sync_time]) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:ctlib.sync_time];
        }
        [valueArray addObject:ctlib.doctor_id];
        [valueArray addObject:ctlib.creation_date];
        if ([NSString isEmptyString:ctlib.is_main]) {
            [valueArray addObject:@"0"];
        }else{
            [valueArray addObject:ctlib.is_main];
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
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@)", CTLibTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
    }];
    return ret;
}

- (BOOL)updateCTLib:(CTLib *)ctlib {
    if (ctlib == nil || ctlib.user_id == nil) {
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
        
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"patient_id"];
        [columeArray addObject:@"case_id"];
        [columeArray addObject:@"ct_image"];
        [columeArray addObject:@"ct_desc"];
        [columeArray addObject:@"update_date"]; //创建时间
        [columeArray addObject:@"sync_time"];
        [columeArray addObject:@"doctor_id"];
        [columeArray addObject:@"creation_date"];
        [columeArray addObject:@"is_main"];
        
        [valueArray addObject:ctlib.user_id];
        if (nil == ctlib.patient_id) {
            [valueArray addObject:@""];
        } else {
            [valueArray addObject:ctlib.patient_id];
        }
        [valueArray addObject:ctlib.case_id];
        [valueArray addObject:ctlib.ct_image];
        [valueArray addObject:ctlib.ct_desc];
        if ([NSString isEmptyString:ctlib.update_date]) {
            [valueArray addObject:[NSString stringWithString:strCurrentDate]];
        } else {
            [valueArray addObject:ctlib.update_date];
        }
        if ([NSString isEmptyString:ctlib.sync_time]) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:ctlib.sync_time];
        }
        [valueArray addObject:ctlib.doctor_id];
        [valueArray addObject:ctlib.creation_date];
        if ([NSString isEmptyString:ctlib.is_main]) {
            [valueArray addObject:@"0"];
        }else{
            [valueArray addObject:ctlib.is_main];
        }
        
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where ckeyid = \"%@\"", CTLibTableName, [columeArray componentsJoinedByString:@"=?,"],ctlib.ckeyid];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
    }];
    return ret;

}

/**
 *  删除一条CTlib记录
 *
 *  @param libid ctLIb id
 *
 *  @return 成功yes ,失败NO
 */
- (BOOL)deleteCTlibWithLibId:(NSString *)libid {
    if ([NSString isEmptyString:libid]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"creation_date_sync"];
        
        [valueArray addObject:[NSString defaultDateString]];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where ckeyid = \"%@\"", CTLibTableName, [columeArray componentsJoinedByString:@"=?,"],libid];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
    }];
    return ret;
}

- (BOOL)deleteCTlibWithLibId_sync:(NSString *)libid {
    if ([NSString isEmptyString:libid]) {
        return NO;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where ckeyid = \"%@\" and doctor_id = '%@'",CTLibTableName,libid,[AccountManager currentUserid]];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    
    
    return ret;
}

- (BOOL)deleteCTlibWithCTLib_AutoSync:(CTLib *)ctLib{
    if ([NSString isEmptyString:ctLib.ckeyid]) {
        return NO;
    }
    
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where ckeyid = \"%@\"",CTLibTableName,ctLib.ckeyid];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    if (ret) {
        //添加一条自动同步信息
        InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_CtLib postType:Delete dataEntity:[ctLib.keyValues JSONString] syncStatus:@"0"];
        [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
    }
    return ret;
}

- (BOOL)deleteCTlibWithCaseId:(NSString *)caseId {
    if ([NSString isEmptyString:caseId]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"creation_date_sync"];
        
        [valueArray addObject:[NSString defaultDateString]];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where case_id = \"%@\"", CTLibTableName, [columeArray componentsJoinedByString:@"=?,"],caseId];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
    }];
    return ret;
}

- (BOOL)deleteCTlibWithPatientId:(NSString *)patientId {
    if ([NSString isEmptyString:patientId]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"creation_date_sync"];
        
        [valueArray addObject:[NSString defaultDateString]];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where patient_id = \"%@\" and user_id = \"%@\"", CTLibTableName, [columeArray componentsJoinedByString:@"=?,"],patientId,[AccountManager currentUserid]];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
    }];
    return ret;
}

- (CTLib *)getCTLibWithCKeyId:(NSString *)ckeyId{
    if ([NSString isEmptyString:ckeyId]) {
        return nil;
    }
    
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\"",CTLibTableName,ckeyId];
    __block CTLib *ctLib = nil;
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlStr];
        if (result && [result next]) {
            ctLib = [CTLib libWithResult:result];
        }
        [result close];
    }];
    return ctLib;
}

- (BOOL)setUpMainCT:(CTLib *)ctLib patientId:(NSString *)patientId{
    if (ctLib == nil) {
        return NO;
    }
    //获取当前病历下的主ct片
    NSArray *mainCts = [self getMainCTWithPatientId:patientId];
    if (mainCts.count > 0) {
        //将主照片的状态设置为0
        for (CTLib *ct in mainCts) {
            ct.is_main = @"0";
            if([self updateMainCTLib:ct]){
                //添加一条更新ct片的自动同步数据
                InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_CtLib postType:Update dataEntity:[ct.keyValues JSONString] syncStatus:@"0"];
                [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
            }
        }
    }
    //设置新的主照片
    BOOL ret = [self updateMainCTLib:ctLib];
    if (ret) {
        //添加一条更新ct片的自动同步数据
        InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_CtLib postType:Update dataEntity:[ctLib.keyValues JSONString] syncStatus:@"0"];
        [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
    }
    return ret;
}

//获取病历下的主ct
- (NSArray *)getMainCTWithPatientId:(NSString *)patient_id{
    if ([NSString isEmptyString:patient_id]) {
        return  nil;
    }
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ ct where ct.is_main = '1' and creation_date_sync > datetime('%@') and ct.doctor_id='%@' and ct.case_id in (select mc.ckeyid from %@ mc where mc.patient_id = '%@')",CTLibTableName,[NSString defaultDateString],[AccountManager currentUserid],MedicalCaseTableName,patient_id];
//    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where case_id = '%@' and user_id = '%@' and creation_date_sync > datetime('%@') and is_main = '1'",CTLibTableName,case_id,[AccountManager currentUserid],[NSString defaultDateString]];
    
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlStr];
        while (result && [result next]) {
            CTLib *ctlib = [CTLib libWithResult:result];
            [resultArray addObject:ctlib];
        }
        [result close];
        
    }];
    return resultArray;
}

- (BOOL)updateMainCTLib:(CTLib *)ctLib{
    __block BOOL result = NO;
    if (ctLib == nil) {
        return result;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"UPDATE %@ SET is_main = \"%@\" where ckeyid = \"%@\"",CTLibTableName,ctLib.is_main,ctLib.ckeyid];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sqlStr];
    }];
    return result;
}

/**
 *  获取CTLib中所有数据，也就是照片合集
 *
 *  @param medicalcaseid 病例id
 *
 *  @return CTLib 数组
 */
- (NSArray*)getCTLibArrayWithCaseId:(NSString *)medicalcaseid isAsc:(BOOL)asc{
    if ([NSString isEmptyString:medicalcaseid]) {
        return  nil;
    }
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];

    NSString *ascStr = asc ? @"asc" : @"desc";
    
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where case_id = \"%@\" and user_id = \"%@\" and creation_date_sync > datetime('%@') order by ckeyid %@",CTLibTableName,medicalcaseid,[AccountManager currentUserid],[NSString defaultDateString],ascStr];
    
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlStr];
        while (result && [result next]) {
            CTLib *ctlib = [CTLib libWithResult:result];
            [resultArray addObject:ctlib];
        }
        [result close];
        
    }];
    return resultArray;
}


/**
 *  获取CTLib 数据
 *
 *  @param PatientId 患者id
 *
 *  @return ctblib 数组
 */
- (NSArray *)getCTLibArrayWithPatientId:(NSString *)PatientId {
    if ([NSString isEmptyString:PatientId]) {
        return  nil;
    }
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ ct where ct.creation_date_sync > datetime('%@') and ct.doctor_id = '%@' and  ct.case_id in (select mc.ckeyid from %@ mc where mc.patient_id = '%@' and doctor_id = '%@')",CTLibTableName,[NSString defaultDateString],[AccountManager currentUserid],MedicalCaseTableName,PatientId,[AccountManager currentUserid]];
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlStr];
        while (result && [result next]) {
            CTLib *ctlib = [CTLib libWithResult:result];
            [resultArray addObject:ctlib];
        }
        [result close];
    }];
    return resultArray;
}

/**
 *  获取患者的病例
 *
 *  @param patientid 患者id
 *
 *  @return 病例数组
 */
- (NSArray *)getMedicalCaseArrayWithPatientId:(NSString *)patientid {
    if ([NSString isEmptyString:patientid]) {
        return  nil;
    }
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where patient_id = \"%@\" and creation_date_sync > datetime('%@') ORDER BY creation_date DESC",MedicalCaseTableName,patientid,[NSString defaultDateString]];
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlStr];
        while (result && [result next]) {
            MedicalCase *ctlib = [MedicalCase medicalCaseWithResult:result];
            [resultArray addObject:ctlib];
        }
        [result close];
    }];
    return resultArray;
}

/**
 *  获取患者的就诊记录
 *
 *  @param patientid 患者id
 *  @param caseid 病例号
 *  @return 病例数组
 */
- (NSArray *)getMedicalRecordByPatientId:(NSString *)patientid AndCaseId:(NSString *)caseid
{
    if ([NSString isEmptyString:patientid] || [NSString isEmptyString:caseid]) {
        return nil;
    }
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
   NSString * sqlString = [NSString stringWithFormat:@"select * from %@ where case_id = '%@' and patient_id = '%@' and creation_date_sync > datetime('%@')",MedicalRecordableName,caseid,patientid,[NSString defaultDateString]];
    NSLog(@"getMedicalRecord.sql:%@",sqlString);
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlString];
        while (result && [result next]) {
            MedicalRecord *medicalRecord = [MedicalRecord medicalRecordWithResult:result];
            [resultArray addObject:medicalRecord];
        }
        [result close];
    }];
    return resultArray;
}

- (BOOL)saveAllDownloadPatientInfoWithPatientModel:(XLPatientTotalInfoModel *)model{
    
    BOOL ret = NO;
    //保存患者消息
    Patient *patient = [Patient PatientFromPatientResult:model.baseInfo];
    //稍后条件判断是否成功的代码
    if([self insertPatientBySync:patient]){
        ret = YES;
    };
    
    //判断medicalCase数据是否存在
    if (ret) {
        if (model.medicalCase.count > 0) {
            //保存病历数据
            for (int i = 0; i < model.medicalCase.count; i++) {
                MedicalCase *medicalCase = [MedicalCase MedicalCaseFromPatientMedicalCase:model.medicalCase[i]];
                if([self insertMedicalCase:medicalCase]){
                    ret = YES;
                }else{
                    ret = NO;
                    break;
                }
            }
        }
    }
    if (ret) {
        //判断medicalCourse数据是否存在
        if (model.medicalCourse.count > 0) {
            for (int i = 0; i < model.medicalCourse.count; i++) {
                MedicalRecord *medicalrecord = [MedicalRecord MRFromMRResult:model.medicalCourse[i]];
                if([self insertMedicalRecord:medicalrecord]){
                    ret = YES;
                }else{
                    ret = NO;
                    break;
                }
            }
        }
    }
    
    if (ret) {
        //判断consultation数据是否存在
        if (model.consultation.count > 0) {
            for (int i = 0; i < model.consultation.count; i++) {
                PatientConsultation *patientC = [PatientConsultation PCFromPCResult:model.consultation[i]];
                if([self insertPatientConsultation:patientC]){
                    ret = YES;
                }else{
                    ret = NO;
                    break;
                }
            }
        }
    }
    
    if (ret) {
        //判断expense数据是否存在
        if (model.expense.count > 0) {
            for (int i = 0; i < model.expense.count; i++) {
                MedicalExpense *medicalexpense = [MedicalExpense MEFromMEResult:model.expense[i]];
                if([self insertMedicalExpenseWith:medicalexpense]){
                    ret = YES;
                }else{
                    ret = NO;
                    break;
                }
            }
        }
    }
    
    if (ret) {
        //判断introducerMap数据是否存在
        if (model.introducerMap.count > 0) {
            for (int i = 0; i < model.introducerMap.count; i++) {
                PatientIntroducerMap *map = [PatientIntroducerMap PIFromMIResult:model.introducerMap[i]];
                if ([self insertPatientIntroducerMap:map]) {
                    ret = YES;
                }else{
                    ret = NO;
                    break;
                }
            }
        }
    }
    
    NSMutableArray *ctImages = [NSMutableArray array];
    if (ret) {
        //判断CT数据是否存在
        if (model.cT.count > 0) {
            for (int i = 0; i < model.cT.count; i++) {
                CTLib *ctlib = [CTLib CTLibFromCTLibResult:model.cT[i]];
                if ([ctlib.ct_image isNotEmpty]) {
                    [ctImages addObject:ctlib];
                }
                
                if([self insertCTLib:ctlib]){
                    ret = YES;
                }else{
                    ret = NO;
                    break;
                }
            }
        }
    }
    
    if (ret) {
        if (ctImages.count > 0) {
            @autoreleasepool {
                for (int i = 0; i < ctImages.count; i++) {
                    CTLib *ct = ctImages[i];
                    NSString *urlImage = [NSString stringWithFormat:@"%@%@_%@", ImageDown, ct.ckeyid, ct.ct_image];
                    
                    UIImage *image = [self getImageFromURL:urlImage];
                    if (nil != image) {
                        //删除本地的缓存图片
                        if([PatientManager IsImageExisting:ct.ct_image]){
                            NSLog(@"本地图片被删除");
                            [[SDImageCache sharedImageCache] removeImageForKey:ct.ct_image];
                        }
                        //将图片保存到本地
                        [PatientManager pathImageSaveToDisk:[image fixOrientation] withKey:ct.ct_image];
                        NSLog(@"图片下载成功:%@",urlImage);
                    }
                }
            }
        }
    }
    
    return ret;
}

//获取图片
- (UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}


@end
