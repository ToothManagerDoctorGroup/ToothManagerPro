//
//  DBManager+Introducer.m
//  CRM
//
//  Created by TimTiger on 5/14/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "DBManager+Introducer.h"
#import "NSString+Conversion.h"
#import "AccountManager.h"

@implementation DBManager (Introducer)
#pragma mark - IntroducerTableName

/*
 *@brief 插入一条介绍人数据 到介绍人表中
 *@param material 数据
 */
- (BOOL)insertIntroducer:(Introducer *)introducer
{
    //测试可以
    if (introducer == nil) {
        return NO;
    }
    
    __block BOOL ret = NO;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where intr_name = \"%@\" and user_id = \"%@\"",IntroducerTableName,introducer.intr_name,[AccountManager currentUserid]];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
       
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            ret = YES;
        }
        [set close];
    }];
    if (ret == YES) {
        ret = [self updateIntroducer:introducer];
        return ret;
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        /*
         @property (nonatomic,copy) NSString *intr_name;      //介绍人姓名
         @property (nonatomic,copy) NSString *intr_phone;     //电话
         @property (nonatomic,readwrite) NSInteger intr_level; //等级
         @property (nonatomic,copy) NSString *user_id;    //医生id
         @property (nonatomic,copy) NSString *creation_date;  //创建时间
         @property (nonatomic,copy) NSString *update_date;
         @property (nonatomic,copy) NSString *sync_time;  //同步时间

         */
        
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
        NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@)", IntroducerTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
        
    }];
    return ret;
}

/**
 *  根据电话查询介绍人是否已经存在
 *
 *  @param phone 电话号码
 *
 *  @return YES，OR no
 */
- (BOOL)isInIntroducerTable:(NSString *)phone {
    if (phone == nil) {
        return YES;
    }
    __block int count = 0;
    NSString *sqlStr = [NSString stringWithFormat:@"select count(*) as 'count' from %@ where intr_phone = '%@' and user_id = '%@' and creation_date > datetime('%@')",IntroducerTableName,phone,[AccountManager currentUserid], [NSString defaultDateString]];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            count = [set intForColumn:@"count"];
        }
        [set close];
    }];
    return count == 0 ? NO : YES;
}

- (BOOL)insertIntroducersWithArray:(NSArray *)array {
    if (array.count == 0) {
        return NO;
    }
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (Introducer *introducer in array) {
            ret = [self insertIntroducer:introducer withDB:db];
        }
    }];
    return ret;
}


- (BOOL)insertIntroducer:(Introducer *)introducer withDB:(FMDatabase *)db {
    //测试可以
    if (introducer == nil) {
        return NO;
    }
    
    __block BOOL ret = NO;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where (ckeyid = '%@' or intr_phone = '%@') and doctor_id = \"%@\"",IntroducerTableName,introducer.ckeyid,introducer.intr_phone,[AccountManager currentUserid]];
    
    FMResultSet *set = nil;
    set = [db executeQuery:sqlStr];
    if (set && [set next]) {
        ret = YES;
    }
    [set close];
    
    if (ret == YES) {
        ret = [self updateIntroducer:introducer];
        return ret;
    }
    
    
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
    NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@)", IntroducerTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
    ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
    
    if (ret == NO) {
        
    }
    
    return ret;
}

/**
 *  更新一条介绍人信息
 *
 *  @param introducer 介绍人信息
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)updateIntroducer:(Introducer *)introducer {
    //测试可以
    if (introducer == nil || [NSString isEmptyString:introducer.ckeyid]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
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
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
        
    }];
    return ret;
}

/**
 *  删除一条介绍人信息
 *
 *  @param introducerId 介绍人id
 *
 *  @return 成功yes，失败no
 */
- (BOOL)deleteIntroducerWithId_sync:(NSString *)introducerId {
    if ([NSString isEmptyString:introducerId]) {
        return NO;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where ckeyid = '%@'",IntroducerTableName,introducerId];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    return ret;
}

/**
 *  删除一条介绍人信息
 *
 *  @param introducerId 介绍人id
 *
 *  @return 成功yes，失败no
 */
- (BOOL)deleteIntroducerWithId:(NSString *)introducerId {
    if ([NSString isEmptyString:introducerId]) {
        return NO;
    }
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
       
        [columeArray addObject:@"creation_date"];
        
        [valueArray addObject:[NSString defaultDateString]];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=?  where ckeyid = '%@'", IntroducerTableName, [columeArray componentsJoinedByString:@"=?,"],introducerId];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
        
    }];
    return ret;

}

/*
 *@brief 获取介绍人表中全部介绍人
 *@return NSArray 返回介绍人数组，没有则为nil
 */
- (NSArray *)getAllIntroducerWithPage:(int)page
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sqlStr = [NSString stringWithFormat:@"select *,(select count(patient_id) from %@ pat where pat.[intr_id]=i.[ckeyid] and pat.intr_source like '%%B%%') as patientCount from %@ i where user_id = '%@' and creation_date > datetime('%@') order by patientCount desc limit %i,%i",PatIntrMapTableName,IntroducerTableName,[AccountManager currentUserid], [NSString defaultDateString],page * CommonPageSize,CommonPageSize];
         result = [db executeQuery:sqlStr];
         while ([result next])
         {
             Introducer * introducer = [Introducer introducerlWithResult:result];
             [resultArray addObject:introducer];
         }
         [result close];
     }];
    return resultArray;
}

- (NSArray *)getLocalIntroducerWithPage:(int)page{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         result = [db executeQuery:[NSString stringWithFormat:@"select *,(select count(ckeyid) from %@ where %@.[ckeyid]=%@.[introducer_id]) as patientCount from %@ where user_id = '%@' and creation_date > datetime('%@') and intr_id = '%@' order by creation_date desc limit %i,%i",PatientTableName,IntroducerTableName,PatientTableName,IntroducerTableName,[AccountManager currentUserid], [NSString defaultDateString],@"0",page * CommonPageSize,CommonPageSize]];
         while ([result next])
         {
             Introducer * introducer = [Introducer introducerlWithResult:result];
             [resultArray addObject:introducer];
         }
         [result close];
     }];
    return resultArray;
}

- (NSArray *)getIntroducerByName:(NSString *)name{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         result = [db executeQuery:[NSString stringWithFormat:@"select *,(select count(ckeyid) from %@ where %@.[ckeyid]=%@.[introducer_id]) as patientCount from %@ where user_id = '%@' and creation_date > datetime('%@') and intr_name like '%%%@%%' order by creation_date desc",PatientTableName,IntroducerTableName,PatientTableName,IntroducerTableName,[AccountManager currentUserid], [NSString defaultDateString],name]];
         while ([result next])
         {
             Introducer * introducer = [Introducer introducerlWithResult:result];
             [resultArray addObject:introducer];
         }
         [result close];
     }];
    return resultArray;
}

- (NSInteger)getIntroducerAllCount{
    __block FMResultSet* result = nil;
    __block NSInteger count = 0;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sqlString = [NSString stringWithFormat:@"select count(*) as 'count' from %@ where user_id = '%@' and creation_date > datetime('%@')",IntroducerTableName,[AccountManager currentUserid],[NSString defaultDateString]];
         
         result = [db executeQuery:sqlString];
         while (result.next) {
             count = [result intForColumn:@"count"];
         }
         [result close];
     }];
    
    return count;
}

/**
 *  获取介绍人介绍的病人个数
 *
 *  @param introducerId 介绍人id
 *
 *  @return 个数
 */
- (NSInteger)numberIntroducedWithIntroducerId:(NSString *)introducerId {
    
    if ([NSString isEmptyString:introducerId]) {
        return 0;
    }
    
    NSString *sqlStr = [NSString stringWithFormat:@"select count(patient_id) from %@ pat where pat.intr_id = '%@' and pat.intr_source like '%%B%%' and creation_date > datetime('%@')",PatIntrMapTableName,introducerId,[NSString defaultDateString]];
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
 *  @brief 根据介绍人id 查询患者表
 *  @param patientId 患者id
 *  @return 患者数组
 */
- (NSArray *)getPatientByIntroducerId:(NSString *)introducerId
{
    if ([NSString isEmptyString:introducerId]) {
        return nil;
    }
    
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    NSString * sqlString = [NSString stringWithFormat:@"select * from %@ p where p.ckeyid in (select patient_id from %@ pat where pat.intr_id = '%@' and pat.intr_source like '%%B%%' and pat.creation_date > datetime('%@'))",PatientTableName,PatIntrMapTableName,introducerId,[NSString defaultDateString]];
    
    __block Patient *patient = nil;
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlString];
        while ([result next]) {
            patient = [Patient patientlWithResult:result];
            [resultArray addObject:patient];
        }
        [result close];
    }];
    return resultArray;
}




/**
 *  @brief 根据患者id 查询MedicalCaseTableName表
 *  @param patientId 患者id
 *  @return 患者对象
 */
- (MedicalCase *)getMedicalCaseByPatientId:(NSString *)patientId
{
    if ([NSString isEmptyString:patientId]) {
        return nil;
    }
    
    NSString * sqlString = [NSString stringWithFormat:@"select * from %@ where patient_id = '%@' and creation_date_sync > datetime('%@')",MedicalCaseTableName,patientId, [NSString defaultDateString]];
    NSLog(@"getMedicalCase.sql:%@",sqlString);
    __block MedicalCase *medicalCase = nil;
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlString];
        if (result && result.next) {
            medicalCase = [MedicalCase medicalCaseWithResult:result];
        }
        [result close];
    }];
    return medicalCase;
}


- (PatientIntroducerMap *)getPatientIntroducerMapByPatientId:(NSString *)patientId{
    NSString * sqlString = [NSString stringWithFormat:@"select * from  %@ m where m.patient_id=\"%@\" and m.doctor_id=\"%@\"",PatIntrMapTableName,patientId,[AccountManager shareInstance].currentUser.userid];
   
    __block PatientIntroducerMap *map = nil;
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlString];
        if (result && result.next) {
            map = [PatientIntroducerMap patientIntroducerWithResult:result];
        }
        [result close];
    }];
    return map;
}
- (PatientIntroducerMap *)getPatientIntroducerMapByPatientId:(NSString *)patientId doctorId:(NSString *)doctorId intrId:(NSString *)intrId{
    NSString * sqlString = [NSString stringWithFormat:@"select * from %@ where patient_id = \"%@\" and doctor_id = \"%@\" and intr_id = \"%@\"",PatIntrMapTableName,patientId,doctorId,intrId];
    
    __block PatientIntroducerMap *map = nil;
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlString];
        if (result && result.next) {
            map = [PatientIntroducerMap patientIntroducerWithResult:result];
        }
        [result close];
    }];
    return map;
}


- (Introducer *)getIntroducerByCkeyId:(NSString *)ckeyId
{
    if (ckeyId < 0) {
        return nil;
    }
    
    NSString * sqlString = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\"",IntroducerTableName,ckeyId];
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

- (Introducer *)getIntroducerByIntrid:(NSString *)intrId{
    if (intrId < 0) {
        return nil;
    }
    NSString * sqlString = [NSString stringWithFormat:@"select * from %@ where intr_id = \"%@\" and doctor_id = \"%@\"",IntroducerTableName,intrId,[AccountManager shareInstance].currentUser.userid];
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

- (NSString *)getPatientIntrNameWithPatientId:(NSString *)patientId{
    
    NSString * sqlString = [NSString stringWithFormat:@"select m.*,i.intr_name as intr_name from %@ i,%@ m where m.[intr_id]=i.[ckeyid] and m.intr_source like '%%B' and m.doctor_id='%@' and m.patient_id='%@' union select m.*,i.doctor_name as intr_name from %@ i,%@ m where m.[intr_id]=i.[doctor_id] and m.intr_source like '%%I' and m.doctor_id='%@' and m.patient_id='%@'",IntroducerTableName,PatIntrMapTableName,[AccountManager currentUserid],patientId,DoctorTableName,PatIntrMapTableName,[AccountManager currentUserid],patientId];
    __block FMResultSet *result = nil;
    __block NSString *intrName = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlString];
        if (result && result.next) {
            intrName = [result stringForColumn:@"intr_name"];
        }
        [result close];
    }];
    return intrName;
}

@end
