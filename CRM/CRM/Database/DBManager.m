//
//  DBManager.m
//  CRM
//
//  Created by TimTiger on 5/6/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "DBManager.h"
#import "DBManager+Materials.h"
#import "NSString+Conversion.h"
#import "AccountManager.h"
#import "CRMMacro.h"
#import "FMDatabaseAdditions.h"

@interface DBManager ()
{
    FMDatabaseQueue *_fmDatabaseQueue;
}

@end

@implementation DBManager
@synthesize fmDatabaseQueue = _fmDatabaseQueue;
Realize_ShareInstance(DBManager);

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initMaterial) name:SignInSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initMaterial) name:SignUpSuccessNotification object:nil];
    }
    return self;
}

//create .db file and create tables
- (BOOL)createdbFile {

    //创建db文件
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"iscrm.db"];
    _fmDatabaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    
    //打开数据库
    __block BOOL result = NO;
    [_fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db open];
    }];
    
    return result;
}

- (BOOL)createdbFileWithUserId:(NSString *)userId{
    //创建db文件
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_iscrm.db",userId]];
    _fmDatabaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    
    //打开数据库
    __block BOOL result = NO;
    [_fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db open];
    }];
    
    return result;
}

- (BOOL)createDBTableWithTableName:(NSString *)tableName andParams:(NSString *)params {
    //参数判断
    if ([tableName isEmpty] || [params isEmpty]) {
        return NO;
    }
    
    NSString *sqlstr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)", tableName, params];
    
    __block BOOL ret = NO;
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlstr];
        if (ret != YES)
        {
        }
    }];
    return ret;
}

- (BOOL)opendDB {
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db open];
    }];
    return ret;
}

- (BOOL)closeDB {
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
       ret = [db close];
    }];
    return ret;
}

- (BOOL)createTables {
    
    
    
//  integer PRIMARY KEY AUTOINCREMENT,\n\t INTEGER integer
    [self createDBTableWithTableName:DoctorTableName andParams:@"doctor_name text, doctor_dept text,doctor_phone text, user_id text, doctor_email text, doctor_hospital text, doctor_position text, doctor_degree text, doctor_image text, auth_status integer, auth_text text, auth_pic text,doctor_certificate text,creation_date text, update_date text, isopen integer, ckeyid text PRIMARY KEY, sync_time text, doctor_id text, doctor_birthday text, doctor_gender text, doctor_cv text, doctor_skill text"];

//TODO: Tiger 我去掉了所有表的 主键。 应该没影响吧
//    [self createDBTableWithTableName:DoctorTableName andParams:@"doctor_name text, doctor_dept text,doctor_phone text, user_id text PRIMARY KEY, doctor_email text, doctor_hospital text, doctor_position text, doctor_degree text, auth_status integer, auth_text text, auth_pic text,doctor_certificate text,creation_date text, update_date text, isopen integer, ckeyid text, sync_time text"];
    
    [self createDBTableWithTableName:MaterialTableName andParams:@"mat_name text, mat_price double, mat_type integer,user_id text, creation_date text, update_date text, ckeyid text PRIMARY KEY, sync_time text, doctor_id text"];
    
    [self createDBTableWithTableName:IntroducerTableName andParams:@"intr_name text, intr_phone text,intr_level integer,user_id text, intr_id text,creation_date text, update_date text, ckeyid text PRIMARY KEY, sync_time text, doctor_id text"];
    
    [self createDBTableWithTableName:PatientTableName andParams:@"patient_name text, patient_phone text,patient_avatar text,patient_gender text,patient_age text, introducer_id text , patient_status integer , ori_user_id text, user_id text, creation_date text, update_date text, ckeyid text PRIMARY KEY, sync_time text, doctor_id text,patient_allergy text,patient_remark text,idCardNum text,patient_address text,anamnesis text,nickName text"];
    
    [self createDBTableWithTableName:CTLibTableName andParams:@"patient_id text, case_id text, ct_image text, ct_desc text, creation_date text, user_id text, creation_date_sync text, update_date text, ckeyid text PRIMARY KEY, sync_time text, doctor_id text,is_main text"];

    [self createDBTableWithTableName:MedicalCaseTableName andParams:@"case_name text, creation_date text , patient_id text, case_status integer, repair_time text,next_reserve_time text,implant_time text,user_id text,repair_doctor text, creation_date_sync text, update_date text, ckeyid text PRIMARY KEY, sync_time text, doctor_id text,repair_doctor_name text,tooth_position text,team_notice text,hxGroupId text"];
    
    [self createDBTableWithTableName:MedicalExpenseTableName andParams:@"patient_id text, case_id text , mat_id text, expense_num integer, expense_price float, expense_money float,user_id text, creation_date text,creation_date_sync text, update_date text, ckeyid text PRIMARY KEY, sync_time text, doctor_id text"];
    
    [self createDBTableWithTableName:MedicalRecordableName andParams:@"patient_id text, case_id text ,record_content text, creation_date text, user_id text, creation_date_sync text, update_date text, ckeyid text PRIMARY KEY, sync_time text, doctor_id text"];
    
    [self createDBTableWithTableName:PatientConsultationTableName andParams:@"patient_id text, doctor_name text , amr_file text, amr_time text, cons_type text, cons_content text,creation_date text, data_flag integer, user_id text, update_date text, ckeyid text PRIMARY KEY, sync_time text, doctor_id text"];
    
    [self createDBTableWithTableName:MedicalReserveTableName andParams:@"patient_id text, case_id text , reserve_time text, actual_time text, repair_time text, creation_date text, user_id text, creation_date_sync text, update_date text, ckeyid text PRIMARY KEY, sync_time text, doctor_id text"];
    
    [self createDBTableWithTableName:LocalNotificationTableName andParams:@"patient_id text, reserve_type text , reserve_time text, reserve_content text, medical_place text, medical_chair text, user_id text, creation_date text, update_date text, ckeyid text PRIMARY KEY, sync_time text, doctor_id text, tooth_position text, clinic_reserve_id text, duration text,therapy_doctor_id text,therapy_doctor_name text,reserve_status text,case_id text"];
    
    [self createDBTableWithTableName:UserTableName andParams:@"accesstoken text,user_id text,name text, phone text,email text, hospital_name text, department text, title text, degree text, auth_status integer, auth_text text, auth_pic text, creation_date text, update_date text, ckeyid text, sync_time text, doctor_id text,img text,doctor_birthday text,doctor_gender text,doctor_cv text,doctor_skill text"];
    
    [self createDBTableWithTableName:PatIntrMapTableName andParams:@"patient_id text, intr_id text, intr_time text, intr_source text, remark text, creation_date text, update_date text, ckeyid text PRIMARY KEY, sync_time text, doctor_id text, user_id text"];
    
    [self createDBTableWithTableName:RepairDocTableName andParams:@"doctor_name text, doctor_phone text, creation_time text, ckeyid text PRIMARY KEY, sync_time text, doctor_id text, user_id text,creation_date text, update_date text"];
    
    //创建自动同步的表
    [self createDBTableWithTableName:InfoAutoSyncTableName andParams:@"id INTEGER PRIMARY KEY AUTOINCREMENT,data_type text,post_type text,dataEntity text,sync_status text,autoSync_CreateDate text,syncCount int"];
    
    return YES;
}

#pragma mark - 程序更新的时候判断是否修改数据库
- (void)updateDB{
    //更新数据库的版本
    [self updateTableWithColumName:@"syncCount" tableName:InfoAutoSyncTableName type:@"int" defaultStr:@(0)];
    
    //UserTableName
    [self updateTableWithColumName:@"doctor_birthday" tableName:UserTableName type:@"text" defaultStr:nil];
    [self updateTableWithColumName:@"doctor_gender" tableName:UserTableName type:@"text" defaultStr:nil];
    [self updateTableWithColumName:@"doctor_cv" tableName:UserTableName type:@"text" defaultStr:nil];
    [self updateTableWithColumName:@"doctor_skill" tableName:UserTableName type:@"text" defaultStr:nil];
    
    //CTLibTableName
    [self updateTableWithColumName:@"is_main" tableName:CTLibTableName type:@"text" defaultStr:@(0)];
}

//为表添加字段
- (void)updateTableWithColumName:(NSString *)columName tableName:(NSString *)tableName type:(NSString *)type defaultStr:(NSNumber *)defaultStr{
    //判断字段是否存在
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        BOOL ret = [db columnExists:columName inTableWithName:tableName];
        if (!ret) {
            NSString *sql;
            if (defaultStr == nil) {
                sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ %@",tableName,columName,type];
            }else{
                if ([type isEqualToString:@"text"]) {
                    sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ %@ DEFAULT %@",tableName,columName,type,[defaultStr stringValue]];
                }else if([type isEqualToString:@"int"]){
                    sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ %@ DEFAULT %d",tableName,columName,type,[defaultStr intValue]];
                }
            }
            [db executeUpdate:sql];
        }
    }];
}

- (BOOL)clearLocalData{
    __block BOOL ret;
    NSArray *tables = @[DoctorTableName,MaterialTableName,IntroducerTableName,PatientTableName,CTLibTableName,MedicalCaseTableName,MedicalExpenseTableName,MedicalRecordableName,MedicalReserveTableName,LocalNotificationTableName,PatIntrMapTableName,RepairDocTableName,PatientConsultationTableName];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        
        for (int i = 0; i < tables.count; i++) {
            NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@",tables[i]];
            ret = [db executeUpdate:sqlStr];
            if (!ret) {
                [db rollback];
                return;
            }
        }
        [db commit];
    }];
    return ret;
}


- (void)initMaterial{
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
