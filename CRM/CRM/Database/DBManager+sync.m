//
//  DBManager+sync.m
//  CRM
//
//  Created by du leiming on 03/11/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DBManager+sync.h"
#import "TimFramework.h"
#import "DBManager+LocalNotification.h"
#import "NSString+Conversion.h"

#import "MyDateTool.h"


@implementation DBManager (Sync)


/*
 *@brief 获取Material表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncMaterial
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *matLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", MaterialTableName, [AccountManager currentUserid]];
    NSString *matLastSyncDate = [userDefalut stringForKey:matLastSynKey];
    
    if (nil == matLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        matLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date > datetime('%@') and sync_time = datetime('%@') and user_id = '%@'", MaterialTableName, matLastSyncDate, [NSString defaultDateString], [AccountManager currentUserid]]];
        
        while ([result next]) {
            Material * material = [Material materialWithResult:result];
            [resultArray addObject:material];
        }
        [result close];
    }];

    
    return resultArray;
    
}

/*
 *@brief 获取Material表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllEditNeedSyncMaterial
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *matLastSynKey = [NSString stringWithFormat:@"syncDataEdit%@%@", MaterialTableName, [AccountManager currentUserid]];
    NSString *matLastSyncDate = [userDefalut stringForKey:matLastSynKey];
    
    if (nil == matLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        matLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where update_date > datetime('%@') and user_id = '%@'", MaterialTableName, matLastSyncDate, [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            Material * material = [Material materialWithResult:result];
            [resultArray addObject:material];
        }
        [result close];
    }];
    
    
    return resultArray;
    
}

/*
 *@brief 获取Material表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllDeleteNeedSyncMaterial
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *defaultDate;

    NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    defaultDate = [dateFormatter stringFromDate:def];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date = datetime('%@') and user_id = '%@'", MaterialTableName, defaultDate, [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            Material * material = [Material materialWithResult:result];
            [resultArray addObject:material];
        }
        [result close];
    }];
    
    
    return resultArray;
    
}

/*
 *@brief 获取patient_introducer_map表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncPatientIntroducerMap{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *intLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", PatIntrMapTableName, [AccountManager currentUserid]];
    NSString *intLastSyncDate = [userDefalut stringForKey:intLastSynKey];
    
    if (nil == intLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        intLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date > datetime('%@') and sync_time = datetime('%@') and user_id = '%@'", PatIntrMapTableName, intLastSyncDate, [NSString defaultDateString], [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            PatientIntroducerMap *map = [PatientIntroducerMap patientIntroducerWithResult:result];
            [resultArray addObject:map];
        }
        [result close];
    }];
    
    
    return resultArray;
}

/*
 *@brief 获取Introducer表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncIntroducer
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *intLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", IntroducerTableName, [AccountManager currentUserid]];
    NSString *intLastSyncDate = [userDefalut stringForKey:intLastSynKey];
    
    if (nil == intLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        intLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date > datetime('%@') and sync_time = datetime('%@') and user_id = '%@'", IntroducerTableName, intLastSyncDate, [NSString defaultDateString], [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            Introducer * introducer = [Introducer introducerlWithResult:result];
            [resultArray addObject:introducer];
        }
        [result close];
    }];

    
    return resultArray;
    
}

/*
 *@brief 获取Introducer表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllEditNeedSyncIntroducer
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *intLastSynKey = [NSString stringWithFormat:@"syncDataEdit%@%@", IntroducerTableName, [AccountManager currentUserid]];
    NSString *intLastSyncDate = [userDefalut stringForKey:intLastSynKey];
    
    if (nil == intLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        intLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where update_date > datetime('%@') and user_id = '%@'", IntroducerTableName, intLastSyncDate, [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            Introducer * introducer = [Introducer introducerlWithResult:result];
            [resultArray addObject:introducer];
        }
        [result close];
    }];
    
    
    return resultArray;
    
}

/*
 *@brief 获取Introducer表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllDeleteNeedSyncIntroducer
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *defaultDate;
    
    NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    defaultDate = [dateFormatter stringFromDate:def];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date = datetime('%@') and user_id = '%@'", IntroducerTableName, defaultDate, [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            Introducer * introducer = [Introducer introducerlWithResult:result];
            [resultArray addObject:introducer];
        }
        [result close];
    }];
    
    
    return resultArray;
    
}

/*
 *@brief 获取Patient表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncPatient
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *patLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", PatientTableName, [AccountManager currentUserid]];
    NSString *patLastSyncDate = [userDefalut stringForKey:patLastSynKey];
    
    if (nil == patLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        patLastSyncDate = [dateFormatter stringFromDate:def];
    }

    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date > datetime('%@') and sync_time = datetime('%@') and user_id = '%@'", PatientTableName, patLastSyncDate, [NSString defaultDateString], [AccountManager currentUserid]]];
        while ([result next]) {
            Patient *patient = [Patient patientlWithResult:result];
            [resultArray addObject:patient];
        }
        [result close];
    }];

    
    return resultArray;
}

/*
 *@brief 获取Patient表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllEditNeedSyncPatient
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *patLastSynKey = [NSString stringWithFormat:@"syncDataEdit%@%@", PatientTableName, [AccountManager currentUserid]];
    NSString *patLastSyncDate = [userDefalut stringForKey:patLastSynKey];
    
    if (nil == patLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        patLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where update_date > datetime('%@') and user_id = '%@'", PatientTableName, patLastSyncDate, [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            Patient * patient = [Patient patientlWithResult:result];
            [resultArray addObject:patient];
        }
        [result close];
    }];
    
    
    return resultArray;
}

/*
 *@brief 获取Patient表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllDeleteNeedSyncPatient
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
 
    NSString *defaultDate;
    
    NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    defaultDate = [dateFormatter stringFromDate:def];

    
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date = datetime('%@') and user_id = '%@'", PatientTableName, defaultDate, [AccountManager currentUserid]]];
        
        while ([result next]) {
            Patient * patient = [Patient patientlWithResult:result];
            [resultArray addObject:patient];
        }
        [result close];
    }];
    
    
    return resultArray;
}

/*
 *@brief 获取CT表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncCt_lib
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *ctLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", CTLibTableName, [AccountManager currentUserid]];
    NSString *ctLastSyncDate = [userDefalut stringForKey:ctLastSynKey];
    
    if (nil == ctLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        ctLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date_sync > datetime('%@') and sync_time = datetime('%@') and user_id = '%@'", CTLibTableName, ctLastSyncDate, [NSString defaultDateString], [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            CTLib * lib = [CTLib libWithResult:result];
            [resultArray addObject:lib];
        }
        [result close];
    }];

    
    return resultArray;
}

/*
 *@brief 获取CT表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllEditNeedSyncCt_lib
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *ctLastSynKey = [NSString stringWithFormat:@"syncDataEdit%@%@", CTLibTableName, [AccountManager currentUserid]];
    NSString *ctLastSyncDate = [userDefalut stringForKey:ctLastSynKey];
    
    if (nil == ctLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        ctLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where update_date > datetime('%@') and user_id = '%@'", CTLibTableName, ctLastSyncDate, [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            CTLib * lib = [CTLib libWithResult:result];
            [resultArray addObject:lib];
        }
        [result close];
    }];
    
    
    return resultArray;
}

/*
 *@brief 获取CT表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllDeleteNeedSyncCt_lib
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *defaultDate;

    NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    defaultDate = [dateFormatter stringFromDate:def];
    
    
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date_sync = datetime('%@') and user_id = '%@'", CTLibTableName, defaultDate, [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            CTLib * lib = [CTLib libWithResult:result];
            [resultArray addObject:lib];
        }
        [result close];
    }];
    
    
    return resultArray;
}


/*
 *@brief 获取Medical case表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */

-(NSArray *)getAllNeedSyncMedical_case
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *medCaseLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", MedicalCaseTableName, [AccountManager currentUserid]];
    NSString *medCaseLastSyncDate = [userDefalut stringForKey:medCaseLastSynKey];
    
    if (nil == medCaseLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        medCaseLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date_sync > datetime('%@') and sync_time = datetime('%@') and user_id = '%@'", MedicalCaseTableName, medCaseLastSyncDate, [NSString defaultDateString], [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            MedicalCase * medicalCase = [MedicalCase medicalCaseWithResult:result];
            [resultArray addObject:medicalCase];
        }
        [result close];
    }];

    
    return resultArray;
}

/*
 *@brief 获取Medical case表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllEditNeedSyncMedical_case
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *medCaseLastSynKey = [NSString stringWithFormat:@"syncDataEdit%@%@", MedicalCaseTableName, [AccountManager currentUserid]];
    NSString *medCaseLastSyncDate = [userDefalut stringForKey:medCaseLastSynKey];
    
    if (nil == medCaseLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        medCaseLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where update_date > datetime('%@') and user_id = '%@'", MedicalCaseTableName, medCaseLastSyncDate, [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            MedicalCase * medicalCase = [MedicalCase medicalCaseWithResult:result];
            [resultArray addObject:medicalCase];
        }
        [result close];
    }];
    
    
    return resultArray;
}

/*
 *@brief 获取Medical case表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllDeleteNeedSyncMedical_case
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *defaultDate;
    
    NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    defaultDate = [dateFormatter stringFromDate:def];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date_sync = datetime('%@') and user_id = '%@'", MedicalCaseTableName, defaultDate, [AccountManager currentUserid]]];
        
        while ([result next]) {
            MedicalCase * medicalCase = [MedicalCase medicalCaseWithResult:result];
            [resultArray addObject:medicalCase];
        }
        [result close];
    }];
    
    
    return resultArray;
}


/*
 *@brief 获取Medical expense表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncMedical_expense
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *medExpLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", MedicalExpenseTableName, [AccountManager currentUserid]];
    NSString *medExpLastSyncDate = [userDefalut stringForKey:medExpLastSynKey];
    
    if (nil == medExpLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        medExpLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date_sync > datetime('%@') and sync_time = datetime('%@') and user_id = '%@'", MedicalExpenseTableName, medExpLastSyncDate, [NSString defaultDateString], [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            MedicalExpense * medicalExpense = [MedicalExpense expenseWithResult:result];
            [resultArray addObject:medicalExpense];
        }
        [result close];
    }];

    
    return resultArray;
}

/*
 *@brief 获取Medical expense表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllEditNeedSyncMedical_expense
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *medExpLastSynKey = [NSString stringWithFormat:@"syncDataEdit%@%@", MedicalExpenseTableName, [AccountManager currentUserid]];
    NSString *medExpLastSyncDate = [userDefalut stringForKey:medExpLastSynKey];
    
    if (nil == medExpLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        medExpLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where update_date > datetime('%@') and user_id = '%@'", MedicalExpenseTableName, medExpLastSyncDate, [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            MedicalExpense * medicalExpense = [MedicalExpense expenseWithResult:result];
            [resultArray addObject:medicalExpense];
        }
        [result close];
    }];
    
    
    return resultArray;
}

/*
 *@brief 获取Medical expense表中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllDeleteNeedSyncMedical_expense
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *defaultDate;
   
    NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    defaultDate = [dateFormatter stringFromDate:def];
    
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date_sync = datetime('%@') and user_id = '%@'", MedicalExpenseTableName, defaultDate, [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            MedicalExpense * medicalExpense = [MedicalExpense expenseWithResult:result];
            [resultArray addObject:medicalExpense];
        }
        [result close];
    }];
    
    
    return resultArray;
}

/*
 *@brief 获取Patient Consultation中全部需要更新的表项  会诊信息
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncPatient_consultation{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *medRecLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", PatientConsultationTableName, [AccountManager currentUserid]];
    NSString *medRecLastSyncDate = [userDefalut stringForKey:medRecLastSynKey];
    
    if (nil == medRecLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        medRecLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date > datetime('%@') and sync_time = datetime('%@') and user_id = '%@'", PatientConsultationTableName, medRecLastSyncDate, [NSString defaultDateString], [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            PatientConsultation * patientConsultation = [PatientConsultation patientConsultationWithResult:result];
            [resultArray addObject:patientConsultation];
        }
        [result close];
    }];
    
    
    return resultArray;
}

/*
 *@brief 获取Medical Record中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllEditNeedSyncPatient_consultation{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *defaultDate;
    
    NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    defaultDate = [dateFormatter stringFromDate:def];
    
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date_sync = datetime('%@') and user_id = '%@'", PatientConsultationTableName, defaultDate, [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            PatientConsultation * patientConsultation = [PatientConsultation patientConsultationWithResult:result];
            [resultArray addObject:patientConsultation];
        }
        [result close];
    }];
    
    
    return resultArray;
}


/*
 *@brief 获取Medical Record中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllDeleteNeedSyncPatient_consultation{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *defaultDate;
    
    NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    defaultDate = [dateFormatter stringFromDate:def];
    
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date_sync = datetime('%@') and user_id = '%@'", PatientConsultationTableName, defaultDate, [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            PatientConsultation * patientConsultation = [PatientConsultation patientConsultationWithResult:result];
            [resultArray addObject:patientConsultation];
        }
        [result close];
    }];
    
    
    return resultArray;
}

/*
 *@brief 获取Medical Record中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncMedical_record
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *medRecLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", MedicalRecordableName, [AccountManager currentUserid]];
    NSString *medRecLastSyncDate = [userDefalut stringForKey:medRecLastSynKey];
    
    if (nil == medRecLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        medRecLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date_sync > datetime('%@') and sync_time = datetime('%@') and user_id = '%@'", MedicalRecordableName, medRecLastSyncDate, [NSString defaultDateString], [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            MedicalRecord * medicalRecord = [MedicalRecord medicalRecordWithResult:result];
            [resultArray addObject:medicalRecord];
        }
        [result close];
    }];

    
    return resultArray;
}


/*
 *@brief 获取Medical Record中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllEditNeedSyncMedical_record
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *medRecLastSynKey = [NSString stringWithFormat:@"syncDataEdit%@%@", MedicalRecordableName, [AccountManager currentUserid]];
    NSString *medRecLastSyncDate = [userDefalut stringForKey:medRecLastSynKey];
    
    if (nil == medRecLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        medRecLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where update_date > datetime('%@') and user_id = '%@'", MedicalRecordableName, medRecLastSyncDate, [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            MedicalRecord * medicalRecord = [MedicalRecord medicalRecordWithResult:result];
            [resultArray addObject:medicalRecord];
        }
        [result close];
    }];
    
    
    return resultArray;
}

/*
 *@brief 获取Medical Record中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllDeleteNeedSyncMedical_record
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *defaultDate;
    
    NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    defaultDate = [dateFormatter stringFromDate:def];
    
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date_sync = datetime('%@') and user_id = '%@'", MedicalRecordableName, defaultDate, [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            MedicalRecord * medicalRecord = [MedicalRecord medicalRecordWithResult:result];
            [resultArray addObject:medicalRecord];
        }
        [result close];
    }];
    
    
    return resultArray;
}



/*
 *@brief 获取local notification中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncLocal_Notification
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];

    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *localNotiLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", LocalNotificationTableName, [AccountManager currentUserid]];
    NSString *localNotiLastSyncDate = [userDefalut stringForKey:localNotiLastSynKey];
    
//    NSDate *tempDate = [MyDateTool dateWithStringWithSec:localNotiLastSyncDate];
//    tempDate = [tempDate dateByAddingTimeInterval:-60 * 2];
//    localNotiLastSyncDate = [MyDateTool stringWithDateWithSec:tempDate];

    if (nil == localNotiLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        localNotiLastSyncDate = [dateFormatter stringFromDate:def];
    }

    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date > datetime('%@') and sync_time = datetime('%@') and user_id = '%@'", LocalNotificationTableName, localNotiLastSyncDate, [NSString defaultDateString], [AccountManager currentUserid]]];
    
    
        while ([result next]) {
            LocalNotification * localNoti = [LocalNotification notificaitonWithResult:result];
            [resultArray addObject:localNoti];
        }
        [result close];
    }];
    
    return resultArray;
}


-(NSArray *)getAllEditNeedSyncLocal_Notification {
    
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];

    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *localNotiLastSynKey = [NSString stringWithFormat:@"syncDataEdit%@%@", LocalNotificationTableName, [AccountManager currentUserid]];
    NSString *localNotiLastSyncDate = [userDefalut stringForKey:localNotiLastSynKey];

    if (nil == localNotiLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        localNotiLastSyncDate = [dateFormatter stringFromDate:def];
    }

    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where update_date > datetime('%@') and user_id = '%@'", LocalNotificationTableName, localNotiLastSyncDate, [AccountManager currentUserid]]];
    
        while ([result next]) {
            LocalNotification * localNoti = [LocalNotification notificaitonWithResult:result];
            [resultArray addObject:localNoti];
        }
        [result close];
    }];


    return resultArray;
}

-(NSArray *)getAllDeleteNeedSyncLocal_Notification{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *defaultDate;
    
    NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    defaultDate = [dateFormatter stringFromDate:def];
    
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date = datetime('%@') and user_id = '%@'", LocalNotificationTableName, defaultDate, [AccountManager currentUserid]]];
        while ([result next]) {
            LocalNotification * localNoti = [LocalNotification notificaitonWithResult:result];
            [resultArray addObject:localNoti];        }
        [result close];
    }];
    
    return resultArray;
}

/*
 *@brief 获取local notification中全部需要更新的表项
 *@return NSArray 返回表项数组，没有则为nil
 */
-(NSArray *)getAllNeedSyncRepair_Doctor
{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *repairDoctorLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", RepairDocTableName, [AccountManager currentUserid]];
    NSString *repairDoctorLastSyncDate = [userDefalut stringForKey:repairDoctorLastSynKey];
    
    if (nil == repairDoctorLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        repairDoctorLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date > datetime('%@') and sync_time = datetime('%@') and user_id = '%@'", RepairDocTableName, repairDoctorLastSyncDate, [NSString defaultDateString], [AccountManager currentUserid]]];
        
        while ([result next]) {
            RepairDoctor * repairDoctor = [RepairDoctor repairDoctorlWithResult:result];
            [resultArray addObject:repairDoctor];
        }
        [result close];
    }];
    
    return resultArray;
}


-(NSArray *)getAllEditNeedSyncRepair_Doctor {
    
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *repairDoctorLastSynKey = [NSString stringWithFormat:@"syncDataEdit%@%@", RepairDocTableName, [AccountManager currentUserid]];
    NSString *repairDoctorLastSyncDate = [userDefalut stringForKey:repairDoctorLastSynKey];
    
    if (nil == repairDoctorLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        repairDoctorLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where update_date > datetime('%@') and user_id = '%@'", RepairDocTableName, repairDoctorLastSyncDate, [AccountManager currentUserid]]];
        
        
        while ([result next]) {
            RepairDoctor * repairDoctor = [RepairDoctor repairDoctorlWithResult:result];
            [resultArray addObject:repairDoctor];
        }
        [result close];
    }];
    
    
    return resultArray;
}

-(NSArray *)getAllDeleteNeedSyncRepair_Doctor{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *defaultDate;
    
    NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    defaultDate = [dateFormatter stringFromDate:def];
    
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date = datetime('%@') and user_id = '%@'", RepairDocTableName, defaultDate, [AccountManager currentUserid]]];
        while ([result next]) {
            RepairDoctor * repairDoctor = [RepairDoctor repairDoctorlWithResult:result];
            [resultArray addObject:repairDoctor];        }
        [result close];
    }];
    
    return resultArray;
}



@end
