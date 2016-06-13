//
//  DBManager+User.m
//  CRM
//
//  Created by TimTiger on 9/6/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "DBManager+User.h"
#import "NSString+Conversion.h"
#import "NSString+TTMAddtion.h"

@implementation DBManager (User)


/**
 *  插入一条用户信息
 *
 *  @param userobj 用户信息
 *
 *  @return 是否成功
 */
-(BOOL)insertUserWithUserObject:(UserObject *)userobj {
    if (userobj == nil || [userobj.userid isEmpty]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where user_id = %@",UserTableName,userobj.userid];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            ret = YES;
        }
        [set close];
    }];
    if (ret == YES) {
        ret = [self updateUserWithUserObject:userobj];
        return ret;
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        
        NSDate* currentDate = [NSDate date];


        [columeArray addObject:@"accesstoken"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"name"];
        [columeArray addObject:@"phone"];
        [columeArray addObject:@"email"];
        [columeArray addObject:@"hospital_name"];
        [columeArray addObject:@"department"];
        [columeArray addObject:@"title"];
        [columeArray addObject:@"degree"];
        [columeArray addObject:@"auth_status"];
        [columeArray addObject:@"auth_text"];
        [columeArray addObject:@"auth_pic"];
        [columeArray addObject:@"creation_date"]; //创建时间
        [columeArray addObject:@"img"];
#warning 新添加元素
        [columeArray addObject:@"doctor_birthday"];
        [columeArray addObject:@"doctor_gender"];
        [columeArray addObject:@"doctor_cv"];
        [columeArray addObject:@"doctor_skill"];
        
        [valueArray addObject:userobj.accesstoken];
        [valueArray addObject:userobj.userid];
        [valueArray addObject:userobj.name];
        [valueArray addObject:userobj.phone];
        [valueArray addObject:userobj.email];
        [valueArray addObject:userobj.hospitalName];
        [valueArray addObject:userobj.department];
        [valueArray addObject:userobj.title];
        [valueArray addObject:userobj.degree];
        [valueArray addObject:[NSNumber numberWithInteger:userobj.authStatus]];
        [valueArray addObject:userobj.authText];
        [valueArray addObject:userobj.authPic];
        [valueArray addObject:[NSString stringWithString:[currentDate description]]];
        [valueArray addObject:userobj.img];
#warning 新添加元素
        [valueArray addObject:userobj.doctor_birthday];
        [valueArray addObject:userobj.doctor_gender];
        [valueArray addObject:userobj.doctor_cv];
        [valueArray addObject:userobj.doctor_skill];
        
        
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
#warning 新添加元素
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@)", UserTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
        NSLog(@"insertPatientString:%@",sqlQuery);
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
    }];
    return ret;
}

/**
 *  更新一条用户信息
 *
 *  @param userobj 用户信息
 *
 *  @return 是否成功
 */
- (BOOL)updateUserWithUserObject:(UserObject *)userobj {
    if (userobj == nil || [userobj.userid isEmpty]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        NSDate* currentDate = [NSDate date];
        
//        [columeArray addObject:@"accesstoken"];
        [columeArray addObject:@"name"];
        [columeArray addObject:@"phone"];
//        [columeArray addObject:@"email"];
        [columeArray addObject:@"hospital_name"];
        [columeArray addObject:@"department"];
        [columeArray addObject:@"title"];
        [columeArray addObject:@"degree"];
        [columeArray addObject:@"auth_status"];
        [columeArray addObject:@"auth_text"];
        [columeArray addObject:@"auth_pic"];
        [columeArray addObject:@"update_date"]; //更新时间
        [columeArray addObject:@"img"];
#warning 新添加元素
        [columeArray addObject:@"doctor_birthday"];
        [columeArray addObject:@"doctor_gender"];
        [columeArray addObject:@"doctor_cv"];
        [columeArray addObject:@"doctor_skill"];
        
//        [valueArray addObject:userobj.accesstoken];
        [valueArray addObject:userobj.name];
        [valueArray addObject:userobj.phone];
//        [valueArray addObject:userobj.email];
        [valueArray addObject:userobj.hospitalName];
        [valueArray addObject:userobj.department];
        [valueArray addObject:userobj.title];
        [valueArray addObject:userobj.degree];
        [valueArray addObject:[NSNumber numberWithInteger:userobj.authStatus]];
        [valueArray addObject:userobj.authText];
        [valueArray addObject:userobj.authPic];
        [valueArray addObject:[NSString stringWithString:[currentDate description]]];
        [valueArray addObject:userobj.img];
#warning 新添加元素
        [valueArray addObject:userobj.doctor_birthday];
        [valueArray addObject:userobj.doctor_gender];
        [valueArray addObject:userobj.doctor_cv];
        [valueArray addObject:userobj.doctor_skill];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where user_id = %@", UserTableName, [columeArray componentsJoinedByString:@"=?,"],userobj.userid];
        NSLog(@"insertPatientString:%@",sqlQuery);
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {
            
        }
    }];
    return ret;
}

/**
 *  删除一条用户信息
 *
 *  @param userobj 用户信息
 *
 *  @return 是否成功
 */
- (BOOL)deleteUserWithUserObject:(UserObject *)userobj {
    if (userobj.userid <= 0) {
        return NO;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where user_id = %@",UserTableName,userobj.userid];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    return ret;
}

/**
 *  获取一条用户信息
 *
 *  @param userobj 用户id
 *
 *  @return 用户信息
 */
- (UserObject *)getUserObjectWithUserId:(NSString *)userid {
    if ([userid isEmpty]) {
        return nil;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where user_id = %@",UserTableName,userid];
    __block UserObject *user = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            user = [UserObject userobjectWithResult:set];
        }
        [set close];
    }];
    return user;
}

- (BOOL)upDateUserHeaderImageUrlWithUserId:(NSString *)userId imageUrl:(NSString *)imageUrl{
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set img = '%@' where user_id = %@", UserTableName, imageUrl,userId];
        ret = [db executeUpdate:sqlQuery];
    }];
    return ret;
}

/**
 *  就诊人数
 *
 *  @return 就诊人数
 */
- (NSInteger)countPatient {
    //    //select count(keyid) from patient
    //    select sum(expense_num) from medical_expense
    //    select count(keyid) from patient where keyid not in(select patient_id from medical_case)
    NSString *sqlStr = [NSString stringWithFormat:@"select count(ckeyid) from %@ where creation_date_sync > datetime('%@')",PatientTableName, [NSString defaultDateString]];
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
 *  种植个数
 *
 *  @return 种植个数
 */
- (NSInteger)countMedicalExpense {
    
    NSString *sqlStr = [NSString stringWithFormat:@"select sum(expense_num) from %@ where creation_date_sync > datetime('%@')",MedicalExpenseTableName, [NSString defaultDateString]];
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
 *  未处理预约数
 *
 *  @return 人数
 */
- (NSInteger)countUnTreatReserve {
    NSString *sqlStr = [NSString stringWithFormat:@"select count(ckeyid) from %@ where ckeyid not in(select patient_id from %@)",PatientTableName,MedicalCaseTableName];
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

@end
