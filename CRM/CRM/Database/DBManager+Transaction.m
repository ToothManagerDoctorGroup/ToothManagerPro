//
//  DBManager+Transaction.m
//  CRM
//
//  Created by Argo Zhang on 16/4/12.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "DBManager+Transaction.h"
#import "DBManager+Doctor.h"
#import "DBManager+Patients.h"
#import "DBManager+Introducer.h"
#import "MyDateTool.h"

@implementation DBManager (Transaction)

- (void)insertObjects:(NSArray *)resources useTransaction:(BOOL)useTransaction{
    if (!resources || resources.count == 0) return;
    
    if (useTransaction) {
        NSLog(@"事务插入前时间:%@ 数据量：%ld",[MyDateTool stringWithDateWithSec:[NSDate date]],resources.count);
        [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
            [db beginTransaction];
                for (int i = 0; i < resources.count; i++) {
                    FMResultSet *set = nil;
                    BOOL ret = NO;
                    id obj = resources[i];
                    
                    if ([obj isKindOfClass:[Doctor class]]) {
                        //医生
                        Doctor *doctor = (Doctor *)obj;
                        NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where doctor_name = \"%@\" and user_id = \"%@\"",DoctorTableName,doctor.doctor_name,[AccountManager currentUserid]];
                        set = [db executeQuery:sqlStr];
                        if (set && [set next]) {
                            ret = [self updateDoctor:doctor withDB:db];
                            if (!ret) {
                                NSLog(@"医生数据更新失败");
                            }
                        }else{
                            ret = [self insertDoctor:doctor withDB:db];
                            if (!ret) {
                                NSLog(@"医生数据插入失败");
                            }
                        }
                    }else if([obj isKindOfClass:[Patient class]]){
                        //患者
                        Patient *patient = (Patient *)obj;
                        NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\"",PatientTableName,patient.ckeyid];
                        set = [db executeQuery:sqlStr];
                        if (set && [set next]) {
                            //表明数据库有这条数据，执行更新操作
                            ret = [self updatePatient:patient withDB:db];
                            if (!ret) {
                                NSLog(@"患者信息更新失败");
                            }
                        }else{
                            //执行插入操作
                            ret = [self insertPatient:patient withDB:db];
                            if (!ret) {
                                NSLog(@"患者信息插入失败");
                            }
                        }
                    }else if ([obj isKindOfClass:[Introducer class]]){
                        //介绍人
                        Introducer *introducer = (Introducer *)obj;
                        NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where intr_name = \"%@\" and user_id = \"%@\"",IntroducerTableName,introducer.intr_name,[AccountManager currentUserid]];
                        set = [db executeQuery:sqlStr];
                        if (set && [set next]) {
                            //表明数据库有这条数据，执行更新操作
                            ret = [self updateIntroducer:introducer withDB:db];
                        }else{
                            //执行插入操作
                            ret = [self insertIntroducer:introducer withDB:db];
                            if(ret){
                                NSLog(@"数据插入成功");
                            }else{
                                NSLog(@"数据插入失败");
                            }
                        }
                    }
                    [set close];
                    
                    if (!ret) {
                        [db rollback];
                        return;
                    }
                }
            [db commit];
        }];
    }else{
        NSLog(@"非事务插入前时间:%@",[MyDateTool stringWithDateWithSec:[NSDate date]]);
        for (int i = 0; i < resources.count; i++) {
            id obj = resources[i];
            
            if ([obj isKindOfClass:[Doctor class]]) {
                //医生
                Doctor *doctor = (Doctor *)obj;
                [self insertDoctorWithDoctor:doctor];
            }else if([obj isKindOfClass:[Patient class]]){
                //患者
                Patient *patient = (Patient *)obj;
                [self insertPatientBySync:patient];
            }else if ([obj isKindOfClass:[Introducer class]]){
                //介绍人
                Introducer *introducer = (Introducer *)obj;
                [self insertIntroducer:introducer];
            }
        }
        
        NSLog(@"非事务插入后时间:%@",[MyDateTool stringWithDateWithSec:[NSDate date]]);
    }
}
/*
- (void)insertObjects:(NSArray *)resources useTransaction:(BOOL)useTransaction{
    if (!resources || resources.count == 0) return;
    
    if (useTransaction) {
        NSLog(@"事务插入前时间:%@ 数据量：%ld",[MyDateTool stringWithDateWithSec:[NSDate date]],resources.count);
        [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
            [db beginTransaction];
            BOOL isRollBack = NO;
            @try {
                for (int i = 0; i < resources.count; i++) {
                    FMResultSet *set = nil;
                    id obj = resources[i];
                    
                    if ([obj isKindOfClass:[Doctor class]]) {
                        //医生
                        Doctor *doctor = (Doctor *)obj;
                        NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where doctor_name = \"%@\" and user_id = \"%@\"",DoctorTableName,doctor.doctor_name,[AccountManager currentUserid]];
                        set = [db executeQuery:sqlStr];
                        if (set && [set next]) {
                            BOOL ret = [self updateDoctor:doctor withDB:db];
                            if (!ret) {
                                NSLog(@"医生数据更新失败");
                            }
                        }else{
                            BOOL ret = [self insertDoctor:doctor withDB:db];
                            if (!ret) {
                                NSLog(@"医生数据插入失败");
                            }
                        }
                    }else if([obj isKindOfClass:[Patient class]]){
                        //患者
                        Patient *patient = (Patient *)obj;
                        NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\"",PatientTableName,patient.ckeyid];
                        set = [db executeQuery:sqlStr];
                        if (set && [set next]) {
                            //表明数据库有这条数据，执行更新操作
                            BOOL ret = [self updatePatient:patient withDB:db];
                            if (!ret) {
                                NSLog(@"患者信息更新失败");
                            }
                        }else{
                            //执行插入操作
                            BOOL ret = [self insertPatient:patient withDB:db];
                            if (!ret) {
                                NSLog(@"患者信息插入失败");
                            }
                        }
                    }else if ([obj isKindOfClass:[Introducer class]]){
                        //介绍人
                        Introducer *introducer = (Introducer *)obj;
                        NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where intr_name = \"%@\" and user_id = \"%@\"",IntroducerTableName,introducer.intr_name,[AccountManager currentUserid]];
                        set = [db executeQuery:sqlStr];
                        if (set && [set next]) {
                            //表明数据库有这条数据，执行更新操作
                            [self updateIntroducer:introducer withDB:db];
                        }else{
                            //执行插入操作
                            if([self insertIntroducer:introducer withDB:db]){
                                NSLog(@"数据插入成功");
                            }else{
                                NSLog(@"数据插入失败");
                            }
                        }
                    }
                    [set close];
                }
            }
            @catch (NSException *exception) {
                isRollBack = YES;
                [db rollback];
            }
            @finally {
                if (!isRollBack) {
                    NSLog(@"事务插入后时间:%@",[MyDateTool stringWithDateWithSec:[NSDate date]]);
                    [db commit];
                }
            }
        }];
        
    }else{
        NSLog(@"非事务插入前时间:%@",[MyDateTool stringWithDateWithSec:[NSDate date]]);
        for (int i = 0; i < resources.count; i++) {
            id obj = resources[i];
            
            if ([obj isKindOfClass:[Doctor class]]) {
                //医生
                Doctor *doctor = (Doctor *)obj;
                [self insertDoctorWithDoctor:doctor];
            }else if([obj isKindOfClass:[Patient class]]){
                //患者
                Patient *patient = (Patient *)obj;
                [self insertPatientBySync:patient];
            }else if ([obj isKindOfClass:[Introducer class]]){
                //介绍人
                Introducer *introducer = (Introducer *)obj;
                [self insertIntroducer:introducer];
            }
        }
        
        NSLog(@"非事务插入后时间:%@",[MyDateTool stringWithDateWithSec:[NSDate date]]);
    }
}
*/
/**
 *  使用事务将医生数据插入数据库
 *
 *  @param doctors        医生数据
 *  @param useTransaction 是否使用事务
 */
- (void)insertDoctors:(NSArray *)doctors useTransaction:(BOOL)useTransaction
{
    if (!doctors || doctors.count == 0) return;
    if (useTransaction) {
        [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
            [db beginTransaction];
            BOOL isRollBack = NO;
            @try {
                for (int i = 0; i < doctors.count; i++) {
                    FMResultSet *set = nil;
                    Doctor *doctor = doctors[i];
                    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where doctor_name = \"%@\" and user_id = \"%@\"",DoctorTableName,doctor.doctor_name,[AccountManager currentUserid]];
                    set = [db executeQuery:sqlStr];
                    if (set && [set next]) {
                        BOOL ret = [self updateDoctor:doctor withDB:db];
                        if (!ret) {
                            NSLog(@"医生数据更新失败");
                        }
                    }else{
                        BOOL ret = [self insertDoctor:doctor withDB:db];
                        if (!ret) {
                            NSLog(@"医生数据插入失败");
                        }
                    }
                    [set close];
                }
            }
            @catch (NSException *exception) {
                isRollBack = YES;
                [db rollback];
            }
            @finally {
                if (!isRollBack) {
                    [db commit];
                }
            }
        }];
        
    }else{
        for (int i = 0; i < doctors.count; i++) {
            Doctor *doctor = doctors[i];
            [self insertDoctorWithDoctor:doctor];
        }
    }
}


/**
 *  使用事务将患者数据插入数据库
 *
 *  @param doctors        患者数据
 *  @param useTransaction 是否使用事务
 */
- (void)insertPatients:(NSArray *)patients useTransaction:(BOOL)useTransaction
{
    if (!patients || patients.count == 0) return;
    if (useTransaction) {
        [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
            [db beginTransaction];
            BOOL isRollBack = NO;
            @try {
                for (int i = 0; i < patients.count; i++) {
                    FMResultSet *set = nil;
                    Patient *patient = patients[i];
                    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\"",PatientTableName,patient.ckeyid];
                    set = [db executeQuery:sqlStr];
                    if (set && [set next]) {
                        //表明数据库有这条数据，执行更新操作
                        BOOL ret = [self updatePatient:patient withDB:db];
                        if (!ret) {
                            NSLog(@"患者信息更新失败");
                        }
                    }else{
                        //执行插入操作
                        BOOL ret = [self insertPatient:patient withDB:db];
                        if (!ret) {
                            NSLog(@"患者信息插入失败");
                        }
                    }
                    [set close];
                }
            }
            @catch (NSException *exception) {
                isRollBack = YES;
                [db rollback];
            }
            @finally {
                if (!isRollBack) {
                    [db commit];
                }
            }
        }];
        
    }else{
        for (int i = 0; i < patients.count; i++) {
            Patient *patient = patients[i];
            [self insertPatientBySync:patient];
        }
    }
}

/**
 *  使用事务将介绍人数据插入数据库
 *
 *  @param introducers        介绍人数据
 *  @param useTransaction     是否使用事务
 */
- (void)insertIntroducers:(NSArray *)introducers useTransaction:(BOOL)useTransaction
{
    if (!introducers || introducers.count == 0) return;
    if (useTransaction) {
        [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
            [db beginTransaction];
            BOOL isRollBack = NO;
            @try {
                for (int i = 0; i < introducers.count; i++) {
                    FMResultSet *set = nil;
                    Introducer *introducer = introducers[i];
                    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where intr_name = \"%@\" and user_id = \"%@\"",IntroducerTableName,introducer.intr_name,[AccountManager currentUserid]];
                    set = [db executeQuery:sqlStr];
                    if (set && [set next]) {
                        //表明数据库有这条数据，执行更新操作
                        
                    }else{
                        //执行插入操作
                        
                    }
                    [set close];
                }
            }
            @catch (NSException *exception) {
                isRollBack = YES;
                [db rollback];
            }
            @finally {
                if (!isRollBack) {
                    [db commit];
                }
            }
        }];
        
    }else{
        for (int i = 0; i < introducers.count; i++) {
            Introducer *introducer = introducers[i];
            [self insertIntroducer:introducer];
        }
    }
}


#pragma mark - ******************* Insert / Update Method *********************
#pragma mark Doctor
- (BOOL)updateDoctor:(Doctor *)doctor withDB:(FMDatabase *)db{
    //表明数据库有这条数据，执行更新操作
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
    
    [valueArray addObject:doctor.doctor_name];
    [valueArray addObject:doctor.doctor_dept];
    [valueArray addObject:doctor.doctor_phone];
    [valueArray addObject:doctor.doctor_email];
    [valueArray addObject:doctor.doctor_hospital];
    [valueArray addObject:doctor.doctor_position];
    [valueArray addObject:doctor.doctor_degree];
    [valueArray addObject:doctor.doctor_image];
    [valueArray addObject:[NSNumber numberWithInteger:doctor.auth_status]];
    [valueArray addObject:doctor.auth_text];
    [valueArray addObject:doctor.auth_pic];
    if (nil == doctor.update_date) {
        [valueArray addObject:[NSString stringWithString:strCurrentDate]];
    } else {
        [valueArray addObject:doctor.update_date];
    }
    [valueArray addObject:doctor.doctor_id];
    [valueArray addObject:doctor.doctor_birthday];
    [valueArray addObject:doctor.doctor_gender];
    [valueArray addObject:doctor.doctor_cv];
    [valueArray addObject:doctor.doctor_skill];
    
    // 3. 写入数据库
    NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where ckeyid = \"%@\" and user_id = \"%@\"", DoctorTableName, [columeArray componentsJoinedByString:@"=?,"],doctor.ckeyid,[AccountManager currentUserid]];
    BOOL ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
    return ret;
}

- (BOOL)insertDoctor:(Doctor *)doctor withDB:(FMDatabase *)db{
    //执行插入操作
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
    
    
    [valueArray addObject:doctor.ckeyid];
    [valueArray addObject:doctor.doctor_name];
    [valueArray addObject:doctor.doctor_dept];
    [valueArray addObject:doctor.doctor_phone];
    [valueArray addObject:doctor.user_id];
    [valueArray addObject:doctor.doctor_email];
    [valueArray addObject:doctor.doctor_hospital];
    [valueArray addObject:doctor.doctor_position];
    [valueArray addObject:doctor.doctor_degree];
    [valueArray addObject:doctor.doctor_image];
    [valueArray addObject:[NSNumber numberWithInteger:doctor.auth_status]];
    [valueArray addObject:doctor.auth_text];
    [valueArray addObject:doctor.auth_pic];
    [valueArray addObject:[NSString currentDateString]];
    [valueArray addObject:[NSString defaultDateString]];
    [valueArray addObject:doctor.doctor_id];
    
    [valueArray addObject:doctor.doctor_birthday];
    [valueArray addObject:doctor.doctor_gender];
    [valueArray addObject:doctor.doctor_cv];
    [valueArray addObject:doctor.doctor_skill];
    
    for (int i = 0; i < 20; i++) {
        [titleArray addObject:@"?"];
    }
    
    // 3. 写入数据库
    NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@)", DoctorTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
    BOOL ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
    return ret;
}
#pragma mark Patient
- (BOOL)updatePatient:(Patient *)patient withDB:(FMDatabase *)db{
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
    [columeArray addObject:@"creation_date"];
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
    
    if (patient.sync_time == nil) {
        [valueArray addObject:[NSString defaultDateString]];
    } else {
        [valueArray addObject:patient.sync_time];
    }
    [valueArray addObject:patient.doctor_id];
    [valueArray addObject:patient.creation_date];
    
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
    BOOL ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
    return ret;
}

- (BOOL)insertPatient:(Patient *)patient withDB:(FMDatabase *)db{
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
    if (patient.sync_time == nil) {
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
    
    for (int i = 0; i < 20; i++) {
        [titleArray addObject:@"?"];
    }
    
    // 3. 写入数据库
    NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@)", PatientTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
    BOOL ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
    return ret;
}

#pragma mark Introducer
- (BOOL)updateIntroducer:(Introducer *)introducer withDB:(FMDatabase *)db{
    NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
    
    [columeArray addObject:@"intr_name"]; //姓名
    [columeArray addObject:@"intr_phone"]; //电话
    [columeArray addObject:@"intr_level"]; //等级
    [columeArray addObject:@"user_id"];
    [columeArray addObject:@"update_date"];
    [columeArray addObject:@"sync_time"];
    [columeArray addObject:@"doctor_id"];
    [columeArray addObject:@"intr_id"];
    
    [valueArray addObject:introducer.intr_name];
    [valueArray addObject:introducer.intr_phone];
    [valueArray addObject:[NSNumber numberWithInteger:introducer.intr_level]];
    [valueArray addObject:introducer.user_id];
    if (nil == introducer.update_date) {
        [valueArray addObject:[NSString currentDateString]];
    } else {
        [valueArray addObject:introducer.update_date];
    }
    if (nil == introducer.sync_time) {
        [valueArray addObject:[NSString defaultDateString]];
    } else {
        [valueArray addObject:introducer.sync_time];
    }
    [valueArray addObject:introducer.doctor_id];
    [valueArray addObject:introducer.intr_id];
    
    // 3. 写入数据库
    NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=?  where ckeyid = \"%@\"", IntroducerTableName, [columeArray componentsJoinedByString:@"=?,"],introducer.ckeyid];
    BOOL ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
    return ret;
}

- (BOOL)insertIntroducer:(Introducer *)introducer withDB:(FMDatabase *)db{
    NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
    
    [columeArray addObject:@"ckeyid"];
    [columeArray addObject:@"intr_name"]; //姓名
    [columeArray addObject:@"intr_phone"]; //电话
    [columeArray addObject:@"intr_level"]; //等级
    [columeArray addObject:@"user_id"];
    [columeArray addObject:@"creation_date"]; //创建时间
    [columeArray addObject:@"update_date"];
    [columeArray addObject:@"sync_time"];
    [columeArray addObject:@"doctor_id"];
    [columeArray addObject:@"intr_id"];
    
    [valueArray addObject:introducer.ckeyid];
    [valueArray addObject:introducer.intr_name];
    [valueArray addObject:introducer.intr_phone];
    [valueArray addObject:[NSNumber numberWithInteger:introducer.intr_level]];
    [valueArray addObject:introducer.user_id];
    [valueArray addObject:[NSString currentDateString]];
    [valueArray addObject:[NSString defaultDateString]];
    if (introducer.sync_time == nil) {
        [valueArray addObject:[NSString defaultDateString]];
    } else {
        [valueArray addObject:introducer.sync_time];
    }
    [valueArray addObject:introducer.doctor_id];
    [valueArray addObject:introducer.intr_id];
    
    for (int i = 0; i < 10; i++) {
        [titleArray addObject:@"?"];
    }
    
    // 3. 写入数据库
    NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@)", IntroducerTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
    BOOL ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
    return ret;
}
@end
