//
//  DBManager.h
//  CRM
//
//  Created by TimTiger on 5/6/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "DBTableMode.h"
#import "CommonMacro.h"
#import "AccountManager.h"

DEF_STATIC_CONST_STRING(DoctorTableName,doctor_version2);         //医生表名
DEF_STATIC_CONST_STRING(MaterialTableName,material_version2);
DEF_STATIC_CONST_STRING(IntroducerTableName,introducer_version2);
DEF_STATIC_CONST_STRING(PatientTableName,patient_version2);
DEF_STATIC_CONST_STRING(CTLibTableName,ct_lib_version2);
DEF_STATIC_CONST_STRING(MedicalCaseTableName,medical_case_version2);
DEF_STATIC_CONST_STRING(MedicalExpenseTableName,medical_expense_version2);
DEF_STATIC_CONST_STRING(MedicalRecordableName,medical_record_version2);
DEF_STATIC_CONST_STRING(MedicalReserveTableName,medical_reserve_version2);
DEF_STATIC_CONST_STRING(LocalNotificationTableName, local_notificaion_version2);
DEF_STATIC_CONST_STRING(UserTableName,user_table_version2);
DEF_STATIC_CONST_STRING(SysMsgTableName, sys_msg_version2);
DEF_STATIC_CONST_STRING(PatIntrMapTableName, patient_introducer_map_version2);
DEF_STATIC_CONST_STRING(RepairDocTableName, repair_doctor_version2)
DEF_STATIC_CONST_STRING(PatientConsultationTableName, patient_consultation_version2);
DEF_STATIC_CONST_STRING(InfoAutoSyncTableName, info_auto_sync_version2);

@interface DBManager : NSObject

@property (nonatomic,readonly) FMDatabaseQueue *fmDatabaseQueue;

Declare_ShareInstance(DBManager);

//create .db file and create tables
- (BOOL)createdbFile;
- (BOOL)createTables;

- (BOOL)createdbFileWithUserId:(NSString *)userId;

- (BOOL)opendDB;
- (BOOL)closeDB;
//更新表数据
- (void)updateDB;

//清空本地数据
- (BOOL)clearLocalData;

@end
