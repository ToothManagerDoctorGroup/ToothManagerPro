//
//  CRMHttpRequest+Sync.m
//  CRM
//
//  Created by du leiming on 23/10/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimFramework.h"
#import "CRMHttpRequest+Sync.h"
#import "DBManager+sync.h"
#import "DBManager+Doctor.h"
#import "DBManager+Materials.h"
#import "DBManager+Introducer.h"
#import "DBManager+Patients.h"
#import "DBManager+LocalNotification.h"
#import "DBManager+RepairDoctor.h"
#import "LocalNotificationCenter.h"
#import "NSError+Extension.h"
#import "CRMUserDefalut.h"
#import "NSString+Conversion.h"
#import "SVProgressHUD.h"
#import "CaseFunction.h"
#import "PatientManager.h"
#import <objc/runtime.h>
#import "JSONKit.h"
#import "SyncManager.h"

char* const ASSOCIATION_DATATABLE_SYNC = "ASSOCIATION_DATATABLE_SYNC";

@implementation CRMHttpRequest (Sync)


//用于统计是否上传成功的全局变量
NSInteger counterOfPatientPost = 0;
NSInteger counterOfPatientEdit = 0;
NSInteger counterOfPatientDelete = 0;

NSInteger counterOfMaterialPost = 0;
NSInteger counterOfMaterialEdit = 0;
NSInteger counterOfMaterialDelete = 0;

NSInteger counterOfIntroducerPost = 0;
NSInteger counterOfIntroducerEdit = 0;
NSInteger counterOfIntroducerDelete = 0;

NSInteger counterOfPatientIntroducerPost = 0;
NSInteger counterOfPatientIntroducerEdit = 0;
NSInteger counterOfPatientIntroducerDelete = 0;

NSInteger counterOfMedicalCasePost = 0;
NSInteger counterOfMedicalCaseEdit = 0;
NSInteger counterOfMedicalCaseDelete = 0;

NSInteger counterOfReserveRecPost = 0;
NSInteger counterOfReserveRecEdit = 0;
NSInteger counterOfReserveRecDelete = 0;
NSMutableArray* deletedReserveRecord = nil;

NSMutableArray* deletedMaterials = nil;
NSMutableArray* deletedIntroducers = nil;
NSMutableArray* downloadPatients = nil;
NSMutableArray* downloadMedicalCasesCT = nil;
NSMutableArray* downloadMedicalCasesME = nil;
NSMutableArray* downloadMedicalCasesMR = nil;
NSMutableArray* downloadMedicalCasesRS = nil;

NSMutableArray* deletedMedicalCase = nil;
NSMutableArray* deletedPatients = nil;
NSMutableArray* deleteMedicalCasesME = nil;
NSMutableArray* deletedPatientConsultation = nil;
NSInteger counterOfMedicalCaseMRPost = 0;
NSInteger counterOfMedicalCaseMREdit = 0;

NSInteger counterOfMedicalCaseMRDelete = 0;
NSMutableArray* deleteMedicalCasesMR = nil;

NSInteger counterOfMedicalCaseMEDelete = 0;
NSInteger counterOfMedicalCaseMEPost = 0;
NSInteger counterOfMedicalCaseMEEdit = 0;

NSInteger counterOfPatientConsultationPost = 0;
NSInteger counterOfPatientConsultationEdit = 0;
NSInteger counterOfPatientConsultationDelete = 0;

NSInteger counterOfMedicalCaseCTDelete = 0;
NSMutableArray* deleteMedicalCasesCT = nil;
NSInteger counterOfMedicalCaseCTPost = 0;
NSInteger counterOfMedicalCaseCTEdit = 0;

NSInteger counterOfRepairtDocPost = 0;
NSInteger counterOfRepairDoctorEdit = 0;
NSInteger counterOfRepairDocDelete = 0;
NSMutableArray* deletedRepairDoc = nil;

//对于medical case的分批处理
//每次下载病例最大患者数
NSInteger const curPatientsNum = 50;

//临时的数组，用来保存当前需要梳理的patient
NSMutableArray* curPatients = nil;
//本次同步的患者数，用于校验是不是同步引进成功
NSInteger curTimePatientsNum = 0;


//临时的数组，用来保存当前需要梳理的病例 ct_lib
NSMutableArray* curMC_ct = nil;
//本次同步的病例数，用于校验是不是同步引进成功 ct_lib
NSInteger curTimeMCNum_ct = 0;

//临时的数组，用来保存当前需要梳理的病例 medical_expense
NSMutableArray* curMC_me = nil;
//本次同步的病例数，用于校验是不是同步引进成功 medical_expense
NSInteger curTimeMCNum_me = 0;

//临时的数组，用来保存当前需要梳理的病例 medical_record
NSMutableArray* curMC_mr = nil;
//本次同步的病例数，用于校验是不是同步引进成功 medical_record
NSInteger curTimeMCNum_mr = 0;

//临时的数组，用来保存当前需要梳理的病例 medical_record
NSMutableArray* curMC_rs = nil;
//本次同步的病例数，用于校验是不是同步引进成功 medical_record
NSInteger curTimeMCNum_rs = 0;

- (id) delegate{
    
    id delegate = objc_getAssociatedObject(self, ASSOCIATION_DATATABLE_SYNC);
    
    return delegate;
}


-(void) setDelegate:(id) delegate {
    
    objc_setAssociatedObject(self,ASSOCIATION_DATATABLE_SYNC,delegate,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

//post

-(void)postAllNeedSyncPatient:(NSArray *)patient
{
    
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *matLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", PatientTableName, [AccountManager currentUserid]];
    
    [userDefalut setObject:[NSString currentDateString] forKey:matLastSynKey];
    [userDefalut synchronize];
    
    counterOfPatientPost = [patient count];
    //设置一个全局变量, 在开始同步的时候记录同步成功的条数，如果所有都同步成功，则更新同步成功时间作为下次同步的的时间戳
    for (int i=0; i<[patient count]; i++) {
     
        Patient *pat =patient[i];
     
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:10];
    
        [subParamDic setObject:pat.ckeyid forKey:@"ckeyid"];
        //[subParamDic setObject:@"201_20150125010101" forKey:@"ckeyid"];

        [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
 
#if 0
    if (nil != pat.sync_time) {
        [subParamDic setObject:pat.sync_time forKey:@"sync_time"];
    } else {
        [subParamDic setObject:@"1970-01-01 00:00:00" forKey:@"sync_time"];
    }
#endif
        
        [subParamDic setObject:pat.patient_name forKey:@"patient_name"];
        [subParamDic setObject:pat.patient_phone forKey:@"patient_phone"];
        [subParamDic setObject:@"bb.jpg" forKey:@"patient_avatar"];
        if (nil != pat.patient_gender) {
            [subParamDic setObject:pat.patient_gender forKey:@"patient_gender"];
        } else {
           [subParamDic setObject:@"0" forKey:@"patient_gender"];
        }
        if (nil != pat.patient_age) {
           [subParamDic setObject:pat.patient_age forKey:@"patient_age"];
        } else {
           [subParamDic setObject:@"" forKey:@"patient_age"];
        }
        [subParamDic setObject:[[NSNumber numberWithInt: pat.patient_status] stringValue] forKey:@"patient_status"];
        [subParamDic setObject:pat.introducer_id forKey:@"introducer_id"];
        [subParamDic setObject:pat.doctor_id forKey:@"doctor_id"];
        
     
        NSString *jsonString = [NSJSONSerialization jsonStringWithObject:subParamDic];
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:PATIENT_ADD_URL andParams:params withPrefix:DataSyncPost_Prefix];
        [self requestWithParams:param];
    }
}


-(void)postAllNeedSyncMaterial:(NSArray *)material
{
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *matLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", MaterialTableName, [AccountManager currentUserid]];
    
    [userDefalut setObject:[NSString currentDateString] forKey:matLastSynKey];
    [userDefalut synchronize];
    
    counterOfMaterialPost = [material count];
    
    for (int i=0; i<[material count]; i++) {
        
        Material *mat =material[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:6];

        [subParamDic setObject:mat.ckeyid forKey:@"ckeyid"];
        //[subParamDic setObject:mat.sync_time forKey:@"sync_time"];
        [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
        [subParamDic setObject:mat.mat_name forKey:@"mat_name"];
        [subParamDic setObject:[NSString stringWithFormat: @"%.2f", mat.mat_price] forKey:@"mat_price"];
        [subParamDic setObject:[NSString stringWithFormat:@"%d", mat.mat_type] forKey:@"mat_type"];
        [subParamDic setObject:[CRMUserDefalut latestUserId] forKey:@"doctor_id"];
        NSString *jsonString = [NSJSONSerialization jsonStringWithObject:subParamDic];
        [params setObject:jsonString forKey:@"DataEntity"];
        TimRequestParam *param = [TimRequestParam paramWithURLSting:MATERIAL_ADD_URL andParams:params withPrefix:DataSyncPost_Prefix];
        [self requestWithParams:param];
    }

    
}

-(void)postAllNeedSyncPatientIntroducerMap:(NSArray *)patIntr{
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *matLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", PatIntrMapTableName, [AccountManager currentUserid]];
    [userDefalut setObject:[NSString currentDateString] forKey:matLastSynKey];
    [userDefalut synchronize];
    
    counterOfPatientIntroducerPost = [patIntr count];
    
    for (int i=0; i<[patIntr count]; i++) {
        
        PatientIntroducerMap *map =patIntr[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:9];
        
        [subParamDic setObject:map.ckeyid forKey:@"ckeyid"];
        [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
        [subParamDic setObject:map.patient_id forKey:@"patient_id"];
        [subParamDic setObject:map.doctor_id forKey:@"doctor_id"];
        [subParamDic setObject:map.intr_id forKey:@"intr_id"];
        [subParamDic setObject:map.intr_time forKey:@"intr_time"];
        [subParamDic setObject:map.intr_source forKey:@"intr_source"];
        [subParamDic setObject:map.remark forKey:@"remark"];
        [subParamDic setObject:map.creation_date forKey:@"creation_time"];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:PATIENT_INTRODUCER_MAP_ADD_URL andParams:params withPrefix:DataSyncPost_Prefix];
        [self requestWithParams:param];
    }
}
-(void)postAllNeedSyncIntroducer:(NSArray *)introducer
{
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *matLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", IntroducerTableName, [AccountManager currentUserid]];
    
    [userDefalut setObject:[NSString currentDateString] forKey:matLastSynKey];
    [userDefalut synchronize];
    
    counterOfIntroducerPost = [introducer count];
    
    for (int i=0; i<[introducer count]; i++) {
        
        Introducer *intr =introducer[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:8];
        
        [subParamDic setObject:intr.ckeyid forKey:@"ckeyid"];
        //[subParamDic setObject:@"201_20141223123000" forKey:@"ckeyid"];
    //    if (nil == intr.sync_time) {
    //       [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
     //   } else {
     //      [subParamDic setObject:intr.sync_time forKey:@"sync_time"];
     //   }
        
        [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];

       
        //[subParamDic setObject:@"2014-12-23 12:30" forKey:@"sync_time"];
        
        [subParamDic setObject:intr.intr_name forKey:@"intr_name"];
        [subParamDic setObject:intr.intr_phone forKey:@"intr_phone"];
        [subParamDic setObject:[NSString stringWithFormat: @"%d", intr.intr_level] forKey:@"intr_level"];
        //[subParamDic setObject:@"2014-12-23 12:30" forKey:@"creation_time"];
        [subParamDic setObject:intr.creation_date forKey:@"creation_time"];
        [subParamDic setObject:intr.doctor_id forKey:@"doctor_id"];
        [subParamDic setObject:intr.intr_id forKey:@"intr_id"];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:INTRODUCE_ADD_URL andParams:params withPrefix:DataSyncPost_Prefix];
        [self requestWithParams:param];
    }

}

-(void)postAllNeedSyncCt_lib:(NSArray *)ct_lib
{
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *matLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", CTLibTableName, [AccountManager currentUserid]];
    
    [userDefalut setObject:[NSString currentDateString] forKey:matLastSynKey];
    [userDefalut synchronize];
    
    counterOfMedicalCaseCTPost = [ct_lib count];
    
    for (int i=0; i<[ct_lib count]; i++) {
        
        CTLib *lib =ct_lib[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:7];
        
        NSMutableDictionary *addParamDic = [NSMutableDictionary dictionaryWithCapacity:3];
        
        [subParamDic setObject:lib.ckeyid forKey:@"ckeyid"];
       // if (nil == lib.sync_time) {
        //    [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
        //} else {
         //   [subParamDic setObject:lib.sync_time forKey:@"sync_time"];
        //}
        [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
        
        [subParamDic setObject:lib.patient_id forKey:@"patient_id"];
        [subParamDic setObject:lib.case_id forKey:@"case_id"];
        [subParamDic setObject:lib.ct_desc forKey:@"ct_desc"];
        [subParamDic setObject:lib.ct_image forKey:@"ct_image"];
        [subParamDic setObject:lib.doctor_id forKey:@"doctor_id"];
        
       
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        if ([PatientManager IsImageExisting:lib.ct_image]) {
            
            [addParamDic setObject:lib.ct_image forKey:@"pic"];
            [addParamDic setObject:[PatientManager pathImageGetFromDisk:lib.ct_image] forKey:@"key"];
            
        }
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:CTLIB_ADD_URL andParams:params additionParams:addParamDic  withPrefix:DataSyncPost_Prefix];
        [param setTimeoutInterval:120];
        [self requestWithParams:param];
    }

    
}


-(void)postAllNeedSyncMedical_case:(NSArray *)medical_case
{
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *matLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", MedicalCaseTableName, [AccountManager currentUserid]];
    
    [userDefalut setObject:[NSString currentDateString] forKey:matLastSynKey];
    [userDefalut synchronize];
    
    counterOfMedicalCasePost = [medical_case count];
    
    for (int i=0; i<[medical_case count]; i++) {
        
        MedicalCase *cas =medical_case[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];

        [subParamDic setObject:cas.ckeyid forKey:@"ckeyid"];
        
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];
        
        [subParamDic setObject:curDate forKey:@"sync_time"];
        [subParamDic setObject:cas.patient_id forKey:@"patient_id"];
        [subParamDic setObject:cas.case_name forKey:@"case_name"];
        [subParamDic setObject:cas.creation_date forKey:@"createdate"];
        if (nil == cas.implant_time ||[cas.implant_time isEqualToString:@"0"]) {
            [subParamDic setObject:@"" forKey:@"implant_time"];
        } else {
            [subParamDic setObject:cas.implant_time forKey:@"implant_time"];
        }
        
        if ([cas.next_reserve_time isEqualToString:@"0"]) {
            [subParamDic setObject:@"" forKey:@"next_reserve_time"];
        } else {
            [subParamDic setObject:cas.next_reserve_time forKey:@"next_reserve_time"];
        }
        
        if ([cas.repair_time isEqualToString:@"0"]) {
            [subParamDic setObject:@"" forKey:@"repair_time"];
        } else {
            [subParamDic setObject:cas.repair_time forKey:@"repair_time"];
        }
        
        [subParamDic setObject:[NSString stringWithFormat: @"%d", cas.case_status] forKey:@"status"];
        [subParamDic setObject:cas.repair_doctor forKey:@"repair_doctor"];
        [subParamDic setObject:cas.doctor_id forKey:@"doctor_id"];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:MEDICAL_CASE_ADD_URL andParams:params withPrefix:DataSyncPost_Prefix];
        [self requestWithParams:param];
    }
}

-(void)postAllNeedSyncMedical_expense:(NSArray *)medical_expense
{
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *matLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", MedicalExpenseTableName, [AccountManager currentUserid]];
    
    [userDefalut setObject:[NSString currentDateString] forKey:matLastSynKey];
    [userDefalut synchronize];

    
    counterOfMedicalCaseMEPost = [medical_expense count];
    
    for (int i=0; i<[medical_expense count]; i++) {
        
        MedicalExpense *exp =medical_expense[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
        [subParamDic setObject:exp.ckeyid forKey:@"ckeyid"];
        [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
        [subParamDic setObject:exp.patient_id forKey:@"patient_id"];
        [subParamDic setObject:exp.case_id forKey:@"case_id"];
        [subParamDic setObject:exp.mat_id forKey:@"mat_id"];
        [subParamDic setObject:[NSString stringWithFormat:@"%d",exp.expense_num] forKey:@"expense_num"];
        [subParamDic setObject:[NSString stringWithFormat: @"%.2f", exp.expense_price] forKey:@"expense_price"];
        [subParamDic setObject:[NSString stringWithFormat: @"%.2f", exp.expense_money] forKey:@"expense_money"];
        
        [subParamDic setObject:exp.doctor_id forKey:@"doctor_id"];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];

        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:MEDICAL_EXPENSE_ADD_URL andParams:params withPrefix:DataSyncPost_Prefix];
        [self requestWithParams:param];
    }

    
}



-(void)postAllNeedSyncMedical_record:(NSArray *)medical_record
{
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *matLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", MedicalRecordableName, [AccountManager currentUserid]];
    
    [userDefalut setObject:[NSString currentDateString] forKey:matLastSynKey];
    [userDefalut synchronize];
    
    counterOfMedicalCaseMRPost = [medical_record count];
    
    for (int i=0; i<[medical_record count]; i++) {
        
        MedicalRecord *rec =medical_record[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
        
        [subParamDic setObject:rec.ckeyid forKey:@"ckeyid"];
        //if (nil == rec.sync_time) {
        //    [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
        //} else {
        //    [subParamDic setObject:rec.sync_time forKey:@"sync_time"];
        //}
        [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
        
        [subParamDic setObject:rec.patient_id forKey:@"patient_id"];
        [subParamDic setObject:rec.case_id forKey:@"case_id"];
        [subParamDic setObject:rec.record_content forKey:@"record_content"];
        [subParamDic setObject:rec.doctor_id forKey:@"doctor_id"];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:MEDICAL_RECORD_ADD_URL andParams:params withPrefix:DataSyncPost_Prefix];
        [self requestWithParams:param];
    }

    
}

-(void)postAllNeedSyncPatient_consultation:(NSArray *)patient_consultation{
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *matLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", PatientConsultationTableName, [AccountManager currentUserid]];
    [userDefalut setObject:[NSString currentDateString] forKey:matLastSynKey];
    [userDefalut synchronize];
    
    counterOfPatientConsultationPost = [patient_consultation count];
    for (int i=0; i<[patient_consultation count]; i++) {
        
        PatientConsultation *patientC = patient_consultation[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:10];
        
        [subParamDic setObject:patientC.ckeyid forKey:@"ckeyid"];
        [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
        [subParamDic setObject:patientC.patient_id forKey:@"patient_id"];
        [subParamDic setObject:patientC.doctor_id forKey:@"doctor_id"];
        [subParamDic setObject:patientC.doctor_name forKey:@"doctor_name"];
        [subParamDic setObject:patientC.amr_file forKey:@"amr_file"];
        [subParamDic setObject:patientC.amr_time forKey:@"amr_time"];
        [subParamDic setObject:patientC.cons_type forKey:@"cons_type"];
        [subParamDic setObject:patientC.cons_content forKey:@"cons_content"];
        [subParamDic setObject:[NSString stringWithFormat:@"%ld",(long)patientC.data_flag] forKey:@"data_flag"];
        
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:PATIENTCONSULTATION_ADD_URL andParams:params withPrefix:DataSyncPost_Prefix];
        [self requestWithParams:param];
    }
}

-(void)postAllNeedSyncReserve_record:(NSArray *)reserve_record
{
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *matLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", LocalNotificationTableName, [AccountManager currentUserid]];
    
    [userDefalut setObject:[NSString currentDateString] forKey:matLastSynKey];
    [userDefalut synchronize];
    
    counterOfReserveRecPost = [reserve_record count];
    
    for (int i=0; i<[reserve_record count]; i++) {
        
        LocalNotification *local =reserve_record[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
        
        [subParamDic setObject:local.ckeyid forKey:@"ckeyid"];
        //if (nil == local.sync_time) {
         //   [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
        //} else {
         //   [subParamDic setObject:local.sync_time forKey:@"sync_time"];
        //}
        
        [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
        [subParamDic setObject:local.patient_id forKey:@"patient_id"];
        [subParamDic setObject:local.reserve_time forKey:@"reserve_time"];
        [subParamDic setObject:local.reserve_type forKey:@"reserve_type"];
        [subParamDic setObject:local.reserve_content forKey:@"reserve_content"];
        [subParamDic setObject:local.medical_place forKey:@"medical_place"];
        [subParamDic setObject:local.medical_chair forKey:@"medical_chair"];
        [subParamDic setObject:local.doctor_id forKey:@"doctor_id"];
        
        [subParamDic setObject:local.tooth_position forKey:@"tooth_position"];
        [subParamDic setObject:local.clinic_reserve_id forKey:@"clinic_reserve_id"];
        [subParamDic setObject:local.duration forKey:@"duration"];
        
//        NSError *error;
//        NSString *jsonString;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
//                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
//                                                           options: 0
//                                                             error:&error];
//        if (! jsonData) {
//            NSLog(@"Got an error: %@", error);
//        }
//        else {
//            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@", jsonString);
//        }
        NSString *jsonString = [subParamDic JSONString];
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:RESERVERECORD_ADD_URL andParams:params withPrefix:DataSyncPost_Prefix];
        [self requestWithParams:param];
    }
    
    
}

-(void)postAllNeedSyncRepair_doctor:(NSArray *)repair_doctor {
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *matLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", RepairDocTableName, [AccountManager currentUserid]];
    
    [userDefalut setObject:[NSString currentDateString] forKey:matLastSynKey];
    [userDefalut synchronize];
    
    counterOfRepairtDocPost = [repair_doctor count];
    
    for (int i=0; i<[repair_doctor count]; i++) {
        
        RepairDoctor *reDoc =repair_doctor[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
        
        [subParamDic setObject:reDoc.ckeyid forKey:@"ckeyid"];
        
        [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
        
        [subParamDic setObject:reDoc.doctor_name forKey:@"doctor_name"];
        [subParamDic setObject:reDoc.doctor_phone forKey:@"doctor_phone"];
        [subParamDic setObject:reDoc.creation_time forKey:@"creation_time"];
        [subParamDic setObject:reDoc.doctor_id forKey:@"doctor_id"];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:REPAIRDOCTOR_ADD_URL andParams:params withPrefix:DataSyncPost_Prefix];
        [self requestWithParams:param];
    }
    

}

/*
-(void)postAllNeedSyncMedical_reserve:(NSArray *)medical_reserve
{
    for (int i=0; i<[medical_reserve count]; i++) {
    
    MedicalReserve *res =medical_reserve[i];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:[NSString stringWithFormat: @"%d", res.patientId] forKey:@"patientId"];
    [params setObject:[NSString stringWithFormat: @"%d", res.caseId] forKey:@"caseId"];
    [params setObject:res.reservedate forKey:@"reservedate"];
    [params setObject:res.actualdate forKey:@"actualdate"];
    [params setObject:res.repairdate forKey:@"repairdate"];
    [params setObject:res.creationdate forKey:@"creationdate"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:MEDICAL_RESEV_ADD_URL andParams:params withPrefix:DataSyncPost_Prefix];
    [self requestWithParams:param];
    }
}
*/
#pragma mark - Request CallBack
- (void)onDataSyncPostRequestSuccessWithResponse:(id)response withParam:(TimRequestParam *)param {
    NSError *error = nil;
    NSString *message = nil;
    if (response == nil || ![response isKindOfClass:[NSDictionary class]]) {
        //返回的不是字典
        message = @"返回内容错误";
        error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
        [self onDataSyncRequestFailureCallBackWith:error andParam:param];
        return;
    }
    @try {
        NSNumber *retCodeNum = [response objectForKey:@"Code"];
        if (retCodeNum == nil) {
            //没有code字段
            message = @"返回内容解析错误";
            error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
            [self onDataSyncRequestFailureCallBackWith:error andParam:param];
            return;
        }
        
        NSInteger retCode = [retCodeNum integerValue];
        if (retCode == 200) {
            [self onDataSyncPostSuccessCallBackWith:response andParam:param];
            return;
        } else {
            NSString *errorMessage = [response objectForKey:@"Result"];
            NSError *error = [NSError errorWithDomain:@"请求失败" localizedDescription:errorMessage errorCode:retCode];
            [self onDataSyncRequestFailureCallBackWith:error andParam:param];
            return;
        }
        
        NSDictionary *retDic = [response objectForKey:@"Result"];
        if (retDic == nil) {
            //没有result字段
            message = @"返回内容解析错误";
            error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
            [self onDataSyncRequestFailureCallBackWith:error andParam:param];
            return;
        }
    }
    @catch (NSException *exception) {
        [self onDataSyncRequestFailureCallBackWith:[NSError errorWithDomain:@"请求失败" localizedDescription:@"未知错误" errorCode:404] andParam:param];
    }
    @finally {
        
    }
    
}

- (void)onDataSyncPostRequestFailure:(NSError *)error withParam:(TimRequestParam *)param {
    [self onDataSyncRequestFailureCallBackWith:error andParam:param];
}

#pragma mark - Success
- (void)onDataSyncPostSuccessCallBackWith:(NSDictionary *)result andParam:(TimRequestParam *)param {
   /* if ([param.requestUrl isEqualToString:DOC_ADD_URL]) {
        [self requestAddDoctorSuccess:result andParam:param];
    } else */
    
    
    if ([param.requestUrl isEqualToString:MATERIAL_ADD_URL]) {
        [self requestAddMaterialSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:INTRODUCE_ADD_URL]) {
        [self requestAddIntroducerSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:PATIENT_ADD_URL]) {
        [self requestAddPatientSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:CTLIB_ADD_URL]) {
        [self requestAddCTLibSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_CASE_ADD_URL]) {
        [self requestAddMedicalCaseSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_EXPENSE_ADD_URL]) {
        [self requestAddMedicalExpenseSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_RECORD_ADD_URL]) {
        [self requestAddMedicalRecordSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:RESERVERECORD_ADD_URL]) {
        [self requestAddReserveRecordSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:REPAIRDOCTOR_ADD_URL]) {
        [self requestAddRepairDoctorSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:PATIENTCONSULTATION_ADD_URL]){
        [self requestAddPatientConsultationSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:PATIENT_INTRODUCER_MAP_ADD_URL]){
        [self requestAddPatientIntroducerMapSuccess:result andParam:param];
    }
}

- (void)requestAddDoctorSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    
    
    NSLog(@"requestAddDoctorSuccess");
    
    NSLog(@"total return number %d", [result count]);
    
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }

}

- (void)requestAddMaterialSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    
    NSLog(@"requestAddMaterialSuccess");
    
    NSLog(@"total return number %d", [result count]);
    
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    counterOfMaterialPost --;
    
    if (counterOfMaterialPost == 0) {
        
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *matLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", MaterialTableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:curDate forKey:matLastSynKey];
        [userDefalut synchronize];
        
    }

}

- (void)requestAddIntroducerSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    
    NSLog(@"requestAddMaterialSuccess");
    
    NSLog(@"total return number %d", [result count]);
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    counterOfIntroducerPost --;
    
    if (counterOfIntroducerPost == 0) {
        
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *intLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", IntroducerTableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:curDate forKey:intLastSynKey];
        [userDefalut synchronize];
        
    }

}

- (void)requestAddPatientIntroducerMapSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    NSLog(@"requestAddMaterialSuccess");
    
    NSLog(@"total return number %ld", [result count]);
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    counterOfPatientIntroducerPost --;
    
    if (counterOfPatientIntroducerPost == 0) {
        
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *intLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", PatIntrMapTableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:curDate forKey:intLastSynKey];
        [userDefalut synchronize];
        
    }
    
}
- (void)requestAddPatientSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    NSLog(@"requestAddPatientSuccess");
    
    NSLog(@"total return number %d", [result count]);
    
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    counterOfPatientPost--;
    
    if (counterOfPatientPost == 0) {
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *patLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", PatientTableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:[NSString currentDateString] forKey:patLastSynKey];
        [userDefalut synchronize];
        
    }

    
}

- (void)requestAddCTLibSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    NSLog(@"requestAddCTLibSuccess");
    
    NSLog(@"total return number %d", [result count]);
    
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }

    
    counterOfMedicalCaseCTPost --;
    
    if (counterOfMedicalCaseCTPost == 0) {
        
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *ctLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", CTLibTableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:curDate forKey:ctLastSynKey];
        [userDefalut synchronize];
        
    }
    
}

- (void)requestAddMedicalCaseSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    
    NSLog(@"requestAddMedicalCaseSuccess");
    
    NSLog(@"total return number %d", [result count]);
    
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }

    counterOfMedicalCasePost--;
    
    if (counterOfMedicalCasePost == 0) {
        
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *patLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", MedicalCaseTableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:curDate forKey:patLastSynKey];
        [userDefalut synchronize];
        
    }

    
}

- (void)requestAddMedicalExpenseSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    counterOfMedicalCaseMEPost--;
    
    if (counterOfMedicalCaseMEPost == 0) {
        
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *meLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", MedicalExpenseTableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:curDate forKey:meLastSynKey];
        [userDefalut synchronize];
        
    }

    
}

- (void)requestAddMedicalRecordSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    counterOfMedicalCaseMRPost--;
    
    if (counterOfMedicalCaseMRPost == 0) {
        
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *mrLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", MedicalRecordableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:curDate forKey:mrLastSynKey];
        [userDefalut synchronize];
        
    }

    
}

- (void)requestAddPatientConsultationSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    NSLog(@"requestAddPatientConsultationSuccess");
    
    NSLog(@"total return number %ld", [result count]);
    
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    counterOfPatientConsultationPost--;
    
    if (counterOfPatientConsultationPost == 0) {
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *patLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", PatientConsultationTableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:[NSString currentDateString] forKey:patLastSynKey];
        [userDefalut synchronize];
        
    }
}

- (void)requestAddMedicalResevSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    
}

- (void)requestAddReserveRecordSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
    }
    NSLog(@"数据插入成功***************");
    
    
    counterOfReserveRecPost--;
    
    if (0 == counterOfReserveRecPost) {
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *matLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", LocalNotificationTableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:[NSString currentDateString] forKey:matLastSynKey];
        [userDefalut synchronize];
    }
}


- (void)requestAddRepairDoctorSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    
    counterOfRepairtDocPost--;
    
    if (0 == counterOfRepairtDocPost) {
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *matLastSynKey = [NSString stringWithFormat:@"syncDataPost%@%@", RepairDocTableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:[NSString currentDateString] forKey:matLastSynKey];
        [userDefalut synchronize];
    }
}






#pragma mark - Failure
- (void)onDataSyncRequestFailureCallBackWith:(NSError *)error andParam:(TimRequestParam *)param {
   /* if ([param.requestUrl isEqualToString:DOC_ADD_URL]) {
        [self requestAddDoctorFailure:error andParam:param];
    } else */
        
    if ([param.requestUrl isEqualToString:MATERIAL_ADD_URL]) {
        [self requestAddMaterialFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:INTRODUCE_ADD_URL]) {
        [self requestAddIntroducerFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:PATIENT_ADD_URL]) {
        [self requestAddPatientFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:CTLIB_ADD_URL]) {
        [self requestAddCTLibFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_CASE_ADD_URL]) {
        [self requestAddMedicalCaseFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_EXPENSE_ADD_URL]) {
        [self requestAddMedicalExpenseFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_RECORD_ADD_URL]) {
        [self requestAddMedicalRecordFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:RESERVERECORD_ADD_URL]) {
        [self requestAddReserveRecordFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:REPAIRDOCTOR_ADD_URL]) {
        [self requestAddRepairDoctorFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:PATIENTCONSULTATION_ADD_URL]){
        [self requestAddPatientConsultationFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:PATIENT_INTRODUCER_MAP_ADD_URL]){
        [self requestAddPatientIntroducerMapFailure:error andParam:param];
    }
    
}

- (void)requestAddDoctorFailure:(NSError *)error andParam:(TimRequestParam *)param {
    
}

- (void)requestAddMaterialFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
}

- (void)requestAddIntroducerFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
}

- (void)requestAddPatientIntroducerMapFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
}

- (void)requestAddPatientFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
    
}

- (void)requestAddCTLibFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
}

- (void)requestAddMedicalCaseFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
}

- (void)requestAddMedicalExpenseFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
}

- (void)requestAddMedicalRecordFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
}

- (void)requestAddMedicalResevFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
}

- (void)requestAddReserveRecordFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
}

- (void)requestAddRepairDoctorFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
}

- (void)requestAddPatientConsultationFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %ld", [error code]);
}

//edit

-(void)editAllNeedSyncPatient:(NSArray *)patient
{
    counterOfPatientEdit = [patient count];
    for (int i=0; i<[patient count]; i++) {
        
        Patient *pat =patient[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:10];
        
        [subParamDic setObject:pat.ckeyid forKey:@"ckeyid"];
    
        
        [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
        [subParamDic setObject:[NSString currentDateString] forKey:@"update_time"];
        
        [subParamDic setObject:pat.patient_name forKey:@"patient_name"];
        [subParamDic setObject:pat.patient_phone forKey:@"patient_phone"];
        [subParamDic setObject:@"bb.jpg" forKey:@"patient_avatar"];
        if (nil != pat.patient_gender) {
            [subParamDic setObject:pat.patient_gender forKey:@"patient_gender"];
        } else {
            [subParamDic setObject:@"0" forKey:@"patient_gender"];
        }
        if (nil != pat.patient_age) {
            [subParamDic setObject:pat.patient_age forKey:@"patient_age"];
        } else {
            [subParamDic setObject:@"" forKey:@"patient_age"];
        }
        [subParamDic setObject:[[NSNumber numberWithInt: pat.patient_status] stringValue] forKey:@"patient_status"];
        [subParamDic setObject:pat.introducer_id forKey:@"introducer_id"];
        [subParamDic setObject:pat.doctor_id forKey:@"doctor_id"];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:PATIENT_EDIT_URL andParams:params withPrefix:DataSyncEdit_Prefix];
        [self requestWithParams:param];
    }

}


-(void)editAllNeedSyncMaterial:(NSArray *)material
{
    
    counterOfMaterialEdit = [material count];
    for (int i=0; i<[material count]; i++) {
        
        Material *mat =material[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:6];
        
        [subParamDic setObject:mat.ckeyid forKey:@"ckeyid"];
        [subParamDic setObject:mat.sync_time forKey:@"sync_time"];
        [subParamDic setObject:mat.mat_name forKey:@"mat_name"];
        [subParamDic setObject:[NSString stringWithFormat: @"%.2f", mat.mat_price] forKey:@"mat_price"];
        [subParamDic setObject:[Material typeStringWith:mat.mat_type] forKey:@"mat_type"];
        [subParamDic setObject:mat.doctor_id forKey:@"doctor_id"];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:MATERIAL_EDIT_URL andParams:params withPrefix:DataSyncEdit_Prefix];
        [self requestWithParams:param];
    }
    
    
}


-(void)editAllNeedSyncIntroducer:(NSArray *)introducer
{
    counterOfIntroducerEdit = [introducer count];
    for (int i=0; i<[introducer count]; i++) {
        
        Introducer *intr =introducer[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:8];
        
        [subParamDic setObject:intr.ckeyid forKey:@"ckeyid"];
        [subParamDic setObject:intr.sync_time forKey:@"sync_time"];
        [subParamDic setObject:intr.intr_name forKey:@"intr_name"];
        [subParamDic setObject:intr.intr_phone forKey:@"intr_phone"];
        [subParamDic setObject:[NSString stringWithFormat: @"%d", intr.intr_level] forKey:@"intr_level"];
        [subParamDic setObject:intr.creation_date forKey:@"creation_time"];
        [subParamDic setObject:intr.doctor_id forKey:@"doctor_id"];
        [subParamDic setObject:intr.intr_id forKey:@"intr_id"];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:INTRODUCE_EDIT_URL andParams:params withPrefix:DataSyncEdit_Prefix];
        [self requestWithParams:param];
    }
    
}


-(void)editAllNeedSyncPatient_consultation:(NSArray *)patient_consultation{
    counterOfPatientConsultationEdit = [patient_consultation count];
    for (int i=0; i<[patient_consultation count]; i++) {
        
        PatientConsultation *patientC =patient_consultation[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:10];
        
        [subParamDic setObject:patientC.ckeyid forKey:@"ckeyid"];
        [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
        [subParamDic setObject:patientC.patient_id forKey:@"patient_id"];
        [subParamDic setObject:patientC.doctor_id forKey:@"doctor_id"];
        [subParamDic setObject:patientC.doctor_name forKey:@"doctor_name"];
        [subParamDic setObject:patientC.amr_file forKey:@"amr_file"];
        [subParamDic setObject:patientC.amr_time forKey:@"amr_time"];
        [subParamDic setObject:patientC.cons_type forKey:@"cons_type"];
        [subParamDic setObject:patientC.cons_content forKey:@"cons_content"];
        [subParamDic setObject:[NSString stringWithFormat:@"%ld",patientC.data_flag] forKey:@"data_flag"];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:PATIENTCONSULTATION_EDIT_URL andParams:params withPrefix:DataSyncEdit_Prefix];
        [self requestWithParams:param];
    }
    
}


-(void)editAllNeedSyncCt_lib:(NSArray *)ct_lib
{
    counterOfMedicalCaseCTEdit = [ct_lib count];
    
    for (int i=0; i<[ct_lib count]; i++) {
        
        CTLib *lib =ct_lib[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:7];
        
        [subParamDic setObject:lib.ckeyid forKey:@"ckeyid"];
        [subParamDic setObject:lib.sync_time forKey:@"sync_time"];
        [subParamDic setObject:lib.patient_id forKey:@"patient_id"];
        [subParamDic setObject:lib.case_id forKey:@"case_id"];
        [subParamDic setObject:lib.ct_desc forKey:@"ct_desc"];
        [subParamDic setObject:lib.ct_image forKey:@"ct_image"];
        [subParamDic setObject:lib.doctor_id forKey:@"doctor_id"];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:CTLIB_EDIT_URL andParams:params withPrefix:DataSyncEdit_Prefix];
        [self requestWithParams:param];
    }
    
    
}


-(void)editAllNeedSyncMedical_case:(NSArray *)medical_case
{
     counterOfMedicalCaseEdit = [medical_case count];
     for (int i=0; i<[medical_case count]; i++) {
        
        MedicalCase *cas =medical_case[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
        
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];
        
        [subParamDic setObject:cas.ckeyid forKey:@"ckeyid"];
        [subParamDic setObject:curDate forKey:@"sync_time"];
        [subParamDic setObject:cas.patient_id forKey:@"patient_id"];
        [subParamDic setObject:cas.case_name forKey:@"case_name"];
        [subParamDic setObject:curDate forKey:@"createdate"];
        //[subParamDic setObject:cas.creation_date forKey:@"createdate"];
        
        if (nil == cas.implant_time) {
            [subParamDic setObject:@"" forKey:@"implant_time"];
        } else {
            [subParamDic setObject:cas.implant_time forKey:@"implant_time"];
        }
        
        if ([cas.next_reserve_time isEqualToString:@"0"]) {
            [subParamDic setObject:@"" forKey:@"next_reserve_time"];
        } else {
            [subParamDic setObject:cas.next_reserve_time forKey:@"next_reserve_time"];
        }
        
        if ([cas.repair_time isEqualToString:@"0"]) {
            [subParamDic setObject:@"" forKey:@"repair_time"];
        } else {
            [subParamDic setObject:cas.repair_time forKey:@"repair_time"];
        }
        
        [subParamDic setObject:[NSString stringWithFormat: @"%d", cas.case_status] forKey:@"status"];
        [subParamDic setObject:cas.repair_doctor forKey:@"repair_doctor"];
        [subParamDic setObject:cas.doctor_id forKey:@"doctor_id"];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:MEDICAL_CASE_EDIT_URL andParams:params withPrefix:DataSyncEdit_Prefix];
        [self requestWithParams:param];
    }
    
    
}


-(void)editAllNeedSyncMedical_expense:(NSArray *)medical_expense
{
    counterOfMedicalCaseMEEdit = [medical_expense count];
    
    for (int i=0; i<[medical_expense count]; i++) {
        
        MedicalExpense *exp =medical_expense[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
        [subParamDic setObject:exp.ckeyid forKey:@"ckeyid"];
        [subParamDic setObject:exp.sync_time forKey:@"sync_time"];
        [subParamDic setObject:exp.patient_id forKey:@"patient_id"];
        [subParamDic setObject:exp.case_id forKey:@"case_id"];
        [subParamDic setObject:exp.mat_id forKey:@"mat_id"];
        [subParamDic setObject:[NSString stringWithFormat: @"%d", exp.expense_num] forKey:@"expense_num"];
        [subParamDic setObject:[NSString stringWithFormat: @"%.2f", exp.expense_price] forKey:@"expense_price"];
        [subParamDic setObject:[NSString stringWithFormat: @"%.2f", exp.expense_money] forKey:@"expense_money"];
        
        [subParamDic setObject:exp.doctor_id forKey:@"doctor_id"];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:MEDICAL_EXPENSE_EDIT_URL andParams:params withPrefix:DataSyncEdit_Prefix];
        [self requestWithParams:param];
    }
    
    
}



-(void)editAllNeedSyncMedical_record:(NSArray *)medical_record
{
    counterOfMedicalCaseMREdit = [medical_record count];
    
    for (int i=0; i<[medical_record count]; i++) {
        
        MedicalRecord *rec =medical_record[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
        
        [subParamDic setObject:rec.ckeyid forKey:@"ckeyid"];
        [subParamDic setObject:rec.sync_time forKey:@"sync_time"];
        [subParamDic setObject:rec.patient_id forKey:@"patient_id"];
        [subParamDic setObject:rec.case_id forKey:@"case_id"];
        [subParamDic setObject:rec.record_content forKey:@"record_content"];
        [subParamDic setObject:rec.doctor_id forKey:@"doctor_id"];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:MEDICAL_RECORD_EDIT_URL andParams:params withPrefix:DataSyncEdit_Prefix];
        [self requestWithParams:param];
    }
    
    
}

-(void)editAllNeedSyncReserve_record:(NSArray *)reserve_record
{
    counterOfReserveRecEdit = [reserve_record count];
    
    for (int i=0; i<[reserve_record count]; i++) {
        
        LocalNotification *local =reserve_record[i];
        
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
        
        [subParamDic setObject:local.ckeyid forKey:@"ckeyid"];
        [subParamDic setObject:local.sync_time forKey:@"sync_time"];
        [subParamDic setObject:local.patient_id forKey:@"patient_id"];
        [subParamDic setObject:local.reserve_time forKey:@"reserve_time"];
        [subParamDic setObject:local.reserve_type forKey:@"reserve_type"];
        [subParamDic setObject:local.reserve_content forKey:@"reserve_content"];
        [subParamDic setObject:local.medical_place forKey:@"medical_place"];
        [subParamDic setObject:local.medical_chair forKey:@"medical_chair"];
        [subParamDic setObject:local.doctor_id forKey:@"doctor_id"];
        
        [subParamDic setObject:local.tooth_position forKey:@"tooth_position"];
        [subParamDic setObject:local.duration forKey:@"duration"];
        [subParamDic setObject:local.clinic_reserve_id forKey:@"clinic_reserve_id"];

        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                           error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:RESERVERECORD_EDIT_URL andParams:params withPrefix:DataSyncEdit_Prefix];
        [self requestWithParams:param];
    }
}


-(void)editAllNeedSyncRepair_Doctor:(NSArray *)repair_doctor{
    counterOfRepairDoctorEdit = [repair_doctor count];
    
    for (int i=0; i<[repair_doctor count]; i++) {
        
        RepairDoctor *reDoctor =repair_doctor[i];
        
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
        
        [subParamDic setObject:reDoctor.ckeyid forKey:@"ckeyid"];
        [subParamDic setObject:reDoctor.sync_time forKey:@"sync_time"];
        [subParamDic setObject:reDoctor.doctor_name forKey:@"doctor_name"];
        [subParamDic setObject:reDoctor.doctor_phone forKey:@"doctor_phone"];
        [subParamDic setObject:reDoctor.creation_time forKey:@"creation_time"];
        [subParamDic setObject:reDoctor.doctor_id forKey:@"doctor_id"];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:REPAIRDOCTOR_EDIT_URL andParams:params withPrefix:DataSyncEdit_Prefix];
        [self requestWithParams:param];
    }

}


#pragma mark - edit Request CallBack
- (void)onDataSyncEditRequestSuccessWithResponse:(id)response withParam:(TimRequestParam *)param {
    NSError *error = nil;
    NSString *message = nil;
    if (response == nil || ![response isKindOfClass:[NSDictionary class]]) {
        //返回的不是字典
        message = @"返回内容错误";
        error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
        [self onDataSyncEditFailureCallBackWith:error andParam:param];
        return;
    }
    @try {
        NSNumber *retCodeNum = [response objectForKey:@"Code"];
        if (retCodeNum == nil) {
            //没有code字段
            message = @"返回内容解析错误";
            error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
            [self onDataSyncEditFailureCallBackWith:error andParam:param];
            return;
        }
        
        NSInteger retCode = [retCodeNum integerValue];
        if (retCode == 200) {
            [self onDataSyncEditSuccessCallBackWith:response andParam:param];
            return;
        } else {
            NSString *errorMessage = [response objectForKey:@"Result"];
            NSError *error = [NSError errorWithDomain:@"请求失败" localizedDescription:errorMessage errorCode:retCode];
            [self onDataSyncEditFailureCallBackWith:error andParam:param];
            return;
        }
        
        NSDictionary *retDic = [response objectForKey:@"Result"];
        if (retDic == nil) {
            //没有result字段
            message = @"返回内容解析错误";
            error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
            [self onDataSyncEditFailureCallBackWith:error andParam:param];
            return;
        }
    }
    @catch (NSException *exception) {
        [self onDataSyncEditFailureCallBackWith:[NSError errorWithDomain:@"请求失败" localizedDescription:@"未知错误" errorCode:404] andParam:param];
    }
    @finally {
        
    }
    
}

- (void)onDataSyncEditRequestFailure:(NSError *)error withParam:(TimRequestParam *)param {
    [self onDataSyncEditFailureCallBackWith:error andParam:param];
}

#pragma mark - Success
- (void)onDataSyncEditSuccessCallBackWith:(NSDictionary *)result andParam:(TimRequestParam *)param {
    /* if ([param.requestUrl isEqualToString:DOC_ADD_URL]) {
     [self requestAddDoctorSuccess:result andParam:param];
     } else */
    
    
    if ([param.requestUrl isEqualToString:MATERIAL_EDIT_URL]) {
        [self requestEditMaterialSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:INTRODUCE_EDIT_URL]) {
        [self requestEditIntroducerSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:PATIENT_EDIT_URL]) {
        [self requestEditPatientSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:CTLIB_EDIT_URL]) {
        [self requestEditCTLibSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_CASE_EDIT_URL]) {
        [self requestEditMedicalCaseSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_EXPENSE_EDIT_URL]) {
        [self requestEditMedicalExpenseSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_RECORD_EDIT_URL]) {
        [self requestEditMedicalRecordSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:RESERVERECORD_EDIT_URL]) {
           [self requestEditReserveRecordSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:REPAIRDOCTOR_EDIT_URL]) {
        [self requestEditRepairDoctorSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:PATIENTCONSULTATION_EDIT_URL]){
        [self requestEditPatientConsultationSuccess:result andParam:param];
    }
    
}

- (void)requestEditDoctorSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    NSLog(@"requestAddDoctorSuccess");
    
    NSLog(@"total return number %d", [result count]);
    
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
}

- (void)requestEditMaterialSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    NSLog(@"requestAddDoctorSuccess");
    
    NSLog(@"total return number %d", [result count]);
    
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    counterOfMaterialEdit --;
    
    if (counterOfMaterialEdit == 0) {
        
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *matLastSynKey = [NSString stringWithFormat:@"syncDataEdit%@%@", MaterialTableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:curDate forKey:matLastSynKey];
        [userDefalut synchronize];
        
    }


    
}

- (void)requestEditIntroducerSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    NSLog(@"requestAddDoctorSuccess");
    
    NSLog(@"total return number %d", [result count]);
    
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
    }
    
    counterOfIntroducerEdit --;
    
    if (counterOfIntroducerEdit == 0) {
        
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *intLastSynKey = [NSString stringWithFormat:@"syncDataEdit%@%@", IntroducerTableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:curDate forKey:intLastSynKey];
        [userDefalut synchronize];
        
    }

    
}

- (void)requestEditPatientSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    NSLog(@"requestEditPatientSuccess");
    
    NSLog(@"total return number %d", [result count]);
    
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    counterOfPatientEdit--;
    
    if (counterOfPatientEdit == 0) {
        
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *patLastSynKey = [NSString stringWithFormat:@"syncDataEdit%@%@", PatientTableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:curDate forKey:patLastSynKey];
        [userDefalut synchronize];
        
    }
    

    
    
}

- (void)requestEditCTLibSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    counterOfMedicalCaseCTEdit--;
    
    if (counterOfMedicalCaseCTEdit == 0) {
        
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *ctLastSynKey = [NSString stringWithFormat:@"syncDataEdit%@%@", CTLibTableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:curDate forKey:ctLastSynKey];
        [userDefalut synchronize];
        
    }

}

- (void)requestEditMedicalCaseSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    NSLog(@"requestEditMedicalCaseSuccess");
    
    NSLog(@"total return number %d", [result count]);
    
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    counterOfMedicalCaseEdit--;
    
    if (counterOfMedicalCaseEdit == 0) {
        
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *mcLastSynKey = [NSString stringWithFormat:@"syncDataEdit%@%@", MedicalCaseTableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:curDate forKey:mcLastSynKey];
        [userDefalut synchronize];
        
    }


}

- (void)requestEditMedicalExpenseSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    counterOfMedicalCaseMEEdit--;
    
    if (counterOfMedicalCaseMEEdit == 0) {
        
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *meLastSynKey = [NSString stringWithFormat:@"syncDataEdit%@%@", MedicalExpenseTableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:curDate forKey:meLastSynKey];
        [userDefalut synchronize];
    }

}

- (void)requestEditMedicalRecordSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    counterOfMedicalCaseMREdit--;
    
    if (counterOfMedicalCaseMREdit == 0) {
        
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *mrLastSynKey = [NSString stringWithFormat:@"syncDataEdit%@%@", MedicalRecordableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:curDate forKey:mrLastSynKey];
        [userDefalut synchronize];
        
    }
}

- (void)requestEditPatientConsultationSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param{

    
    NSLog(@"requestEditPatientConsultationSuccess");
    
    NSLog(@"total return number %ld", [result count]);
    
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    counterOfPatientConsultationEdit--;
    
    if (counterOfPatientConsultationEdit == 0) {
        
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *patLastSynKey = [NSString stringWithFormat:@"syncDataEdit%@%@", PatientConsultationTableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:curDate forKey:patLastSynKey];
        [userDefalut synchronize];
        
    }
}
- (void)requestEditMedicalResevSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    
}

- (void)requestEditReserveRecordSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    counterOfReserveRecEdit--;
    
    if (counterOfReserveRecEdit == 0) {
        
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *mrLastSynKey = [NSString stringWithFormat:@"syncDataEdit%@%@", LocalNotificationTableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:curDate forKey:mrLastSynKey];
        [userDefalut synchronize];
        
    }
    
}

- (void)requestEditRepairDoctorSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    counterOfRepairDoctorEdit--;
    
    if (counterOfRepairDoctorEdit == 0) {
        
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *mrLastSynKey = [NSString stringWithFormat:@"syncDataEdit%@%@", RepairDocTableName, [AccountManager currentUserid]];
        
        [userDefalut setObject:curDate forKey:mrLastSynKey];
        [userDefalut synchronize];
        
    }
    
}


#pragma mark - Failure
- (void)onDataSyncEditFailureCallBackWith:(NSError *)error andParam:(TimRequestParam *)param {
    /* if ([param.requestUrl isEqualToString:DOC_ADD_URL]) {
     [self requestAddDoctorFailure:error andParam:param];
     } else */
    
    if ([param.requestUrl isEqualToString:MATERIAL_EDIT_URL]) {
        [self requestEditMaterialFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:INTRODUCE_EDIT_URL]) {
        [self requestEditIntroducerFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:PATIENT_EDIT_URL]) {
        [self requestEditPatientFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:CTLIB_EDIT_URL]) {
        [self requestEditCTLibFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_CASE_EDIT_URL]) {
        [self requestEditMedicalCaseFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_EXPENSE_EDIT_URL]) {
        [self requestEditMedicalExpenseFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_RECORD_EDIT_URL]) {
        [self requestEditMedicalRecordFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:RESERVERECORD_EDIT_URL]) {
        [self requestEditReserveRecordFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:REPAIRDOCTOR_EDIT_URL]) {
        [self requestEditRepairDoctorFailure:error andParam:param];
    }
}

- (void)requestEditDoctorFailure:(NSError *)error andParam:(TimRequestParam *)param {
    
}

- (void)requestEditMaterialFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
}

- (void)requestEditIntroducerFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
}

- (void)requestEditPatientFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
    
}

- (void)requestEditCTLibFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);

}

- (void)requestEditMedicalCaseFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
    
}

- (void)requestEditMedicalExpenseFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
}

- (void)requestEditMedicalRecordFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
}

- (void)requestEditMedicalResevFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
}

- (void)requestEditReserveRecordFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);

}

- (void)requestEditRepairDoctorFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
    
}


//delete

-(void)deletePatientsFromDataBase
{
    
    for (int i = 0; i < [deletedPatients count]; i++) {
        [[DBManager shareInstance] deletePatientByPatientID_sync: deletedPatients[i]];
    }
    
}

-(void)deleteAllNeedSyncPatient:(NSArray *)patient
{
    if (nil == deletedPatients)
    {
        deletedPatients = [[NSMutableArray alloc] init];
    }
    
    [deletedPatients removeAllObjects];
    
    counterOfPatientDelete = [patient count];
    
    for (int i=0; i<[patient count]; i++) {
        
        Patient *pat =patient[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:1];
        
        [subParamDic setObject:pat.ckeyid forKey:@"ckeyid"];
        
        [deletedPatients addObject:pat.ckeyid];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:PATIENT_DELETE_URL andParams:params withPrefix:DataSyncDelete_Prefix];
        [self requestWithParams:param];
    }
    
}

#pragma mark -- deletePatientConsultation
-(void)deletePatientConsultationFromDataBase
{
    for (int i = 0; i < [deletedPatientConsultation count]; i++) {
        [[DBManager shareInstance] deletePatientConsultationWithPatientId_sync:deletedPatientConsultation[i]];
    }
}

-(void)deleteAllNeedSyncPatient_consultation:(NSArray *)patient_consultation{
    if (nil == deletedPatientConsultation)
    {
        deletedPatientConsultation = [[NSMutableArray alloc] init];
    }
    
    [deletedPatientConsultation removeAllObjects];
    
    counterOfPatientConsultationDelete = [patient_consultation count];
    
    for (int i=0; i<[patient_consultation count]; i++) {
        
        PatientConsultation *patientC =patient_consultation[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:1];
        
        [subParamDic setObject:patientC.ckeyid forKey:@"ckeyid"];
        
        [deletedPatientConsultation addObject:patientC.ckeyid];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:PATIENTCONSULTATION_DELETE_URL andParams:params withPrefix:DataSyncDelete_Prefix];
        [self requestWithParams:param];
    }
}


-(void)deleteMaterialsFromDataBase
{
    
    for (int i = 0; i < [deletedMaterials count]; i++) {
        [[DBManager shareInstance] deleteMaterialWithId_sync: deletedMaterials[i]];
    }
    
    
}


-(void)deleteAllNeedSyncMaterial:(NSArray *)material
{
    if (nil == deletedMaterials)
    {
       deletedMaterials = [[NSMutableArray alloc] init];
    }
    
    [deletedMaterials removeAllObjects];
    
    counterOfMaterialDelete = [material count];
    
    for (int i=0; i<[material count]; i++) {
        
        Material *mat =material[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:1];
        
        [deletedMaterials addObject:mat.ckeyid];
        
        [subParamDic setObject:mat.ckeyid forKey:@"ckeyid"];
#if 0
        [subParamDic setObject:mat.sync_time forKey:@"sync_time"];
        [subParamDic setObject:mat.mat_name forKey:@"mat_name"];
        [subParamDic setObject:[NSString stringWithFormat: @"%.2f", mat.mat_price] forKey:@"mat_price"];
        [subParamDic setObject:[Material typeStringWith:mat.mat_type] forKey:@"mat_type"];
        [subParamDic setObject:mat.doctor_id forKey:@"doctor_id"];
#endif
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:MATERIAL_DELETE_URL andParams:params withPrefix:DataSyncDelete_Prefix];
        [self requestWithParams:param];
    }
    
    
}

-(void)deleteIntroducersFromDataBase
{
    for (int i = 0; i < [deletedIntroducers count]; i++) {
        [[DBManager shareInstance] deleteIntroducerWithId_sync: deletedIntroducers[i]];
    }
}


-(void)deleteAllNeedSyncIntroducer:(NSArray *)introducer
{
    if (nil == deletedIntroducers)
    {
        deletedIntroducers = [[NSMutableArray alloc] init];
    }
    
    [deletedIntroducers removeAllObjects];
    
    counterOfIntroducerDelete = [introducer count];

    for (int i=0; i<[introducer count]; i++) {
        
        Introducer *intr =introducer[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:7];
        
        [deletedIntroducers addObject:intr.ckeyid];
        
        [subParamDic setObject:intr.ckeyid forKey:@"ckeyid"];
#if 0
        [subParamDic setObject:intr.sync_time forKey:@"sync_time"];
        [subParamDic setObject:intr.intr_name forKey:@"intr_name"];
        [subParamDic setObject:intr.intr_phone forKey:@"intr_phone"];
        [subParamDic setObject:[NSString stringWithFormat: @"%d", intr.intr_level] forKey:@"intr_level"];
        [subParamDic setObject:intr.creation_date forKey:@"creation_time"];
        [subParamDic setObject:intr.doctor_id forKey:@"doctor_id"];
#endif
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:INTRODUCE_DELETE_URL andParams:params withPrefix:DataSyncDelete_Prefix];
        [self requestWithParams:param];
    }
    
}



-(void)deleteCtLibFromDataBase
{
    
    for (int i = 0; i < [deleteMedicalCasesCT count]; i++) {
        [[DBManager shareInstance] deleteCTlibWithLibId_sync:deleteMedicalCasesCT[i]];
    }
    
    
}

-(void)deleteAllNeedSyncCt_lib:(NSArray *)ct_lib
{
    if (nil == deleteMedicalCasesCT)
    {
        deleteMedicalCasesCT = [[NSMutableArray alloc] init];
    }
    
    [deleteMedicalCasesCT removeAllObjects];
    
    counterOfMedicalCaseCTDelete = [ct_lib count];
    
    for (int i=0; i<[ct_lib count]; i++) {
        
        CTLib *lib =ct_lib[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:7];
        
        [subParamDic setObject:lib.ckeyid forKey:@"ckeyid"];
               
        [deleteMedicalCasesCT addObject:lib.ckeyid];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:CTLIB_DELETE_URL andParams:params withPrefix:DataSyncDelete_Prefix];
        [self requestWithParams:param];
    }
    
    
}

-(void)deleteMedicalCaseFromDataBase
{
    
    for (int i = 0; i < [deletedMedicalCase count]; i++) {
        [[DBManager shareInstance] deleteMedicalExpenseWithCaseId_sync:deletedMaterials[i]];
    }
    
    
}

-(void)deleteAllNeedSyncMedical_case:(NSArray *)medical_case
{
    if (nil == deletedMedicalCase)
    {
        deletedMedicalCase = [[NSMutableArray alloc] init];
    }
    
    [deletedMedicalCase removeAllObjects];
    
    counterOfMedicalCaseDelete = [medical_case count];
    
    for (int i=0; i<[medical_case count]; i++) {
        
        MedicalCase *cas =medical_case[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
        
        [subParamDic setObject:cas.ckeyid forKey:@"ckeyid"];
        
        
        [deletedMedicalCase addObject:cas.ckeyid];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:MEDICAL_CASE_DELETE_URL andParams:params withPrefix:DataSyncDelete_Prefix];
        [self requestWithParams:param];
    }
    
    
}

-(void)deleteMedicalExpenseFromDataBase
{
    
    for (int i = 0; i < [deleteMedicalCasesME count]; i++) {
        [[DBManager shareInstance] deleteMedicalExpenseWithId_sync: deleteMedicalCasesME[i]];
    }
    
    
}


-(void)deleteAllNeedSyncMedical_expense:(NSArray *)medical_expense
{
    if (nil == deleteMedicalCasesME)
    {
        deleteMedicalCasesME = [[NSMutableArray alloc] init];
    }
    
    [deleteMedicalCasesME removeAllObjects];
    
    counterOfMedicalCaseMEDelete = [medical_expense count];
    
    for (int i=0; i<[medical_expense count]; i++) {
        
        MedicalExpense *exp =medical_expense[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
        [subParamDic setObject:exp.ckeyid forKey:@"ckeyid"];
                
        [deleteMedicalCasesME addObject:exp.ckeyid];
        
        [subParamDic setObject:exp.doctor_id forKey:@"doctor_id"];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:MEDICAL_EXPENSE_DELETE_URL andParams:params withPrefix:DataSyncDelete_Prefix];
        [self requestWithParams:param];
    }
    
    
}


-(void)deleteMedicalRecordFromDataBase
{
    
    for (int i = 0; i < [deleteMedicalCasesMR count]; i++) {
        [[DBManager shareInstance] deleteMedicalRecordWithId_Sync:deleteMedicalCasesMR[i]];
    }
    
}


-(void)deleteAllNeedSyncMedical_record:(NSArray *)medical_record
{
    if (nil == deleteMedicalCasesMR)
    {
        deleteMedicalCasesMR = [[NSMutableArray alloc] init];
    }
    
    [deleteMedicalCasesMR removeAllObjects];
    
    counterOfMedicalCaseMRDelete = [medical_record count];

    
    for (int i=0; i<[medical_record count]; i++) {
        
        MedicalRecord *rec =medical_record[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
        
        [deleteMedicalCasesMR addObject:rec.ckeyid];
        
        [subParamDic setObject:rec.ckeyid forKey:@"ckeyid"];
        
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:MEDICAL_RECORD_DELETE_URL andParams:params withPrefix:DataSyncDelete_Prefix];
        [self requestWithParams:param];
    }
    
    
}

-(void)deleteReserveRecordFromDataBase
{
    
    for (int i = 0; i < [deletedReserveRecord count]; i++) {
        [[DBManager shareInstance] deleteLocalNotification_Sync:deletedReserveRecord[i]];
    }
    
}

-(void)deleteRepairDoctorFromDataBase
{
    
    for (int i = 0; i < [deletedRepairDoc count]; i++) {
        [[DBManager shareInstance] deleteRepairDoctorWithCkeyId_sync:deletedRepairDoc[i]];
    }
    
}



-(void)deleteAllNeedSyncReserve_record:(NSArray *)reserve_record{
    
    if (nil == deletedReserveRecord)
    {
        deletedReserveRecord = [[NSMutableArray alloc] init];
    }
    
    [deletedReserveRecord removeAllObjects];
    
    counterOfReserveRecDelete = [reserve_record count];
    
    for (int i=0; i<[reserve_record count]; i++) {
        
        LocalNotification  *local =reserve_record[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:1];
        
        [subParamDic setObject:local.ckeyid forKey:@"ckeyid"];
        
        [deletedReserveRecord addObject:local.ckeyid];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:RESERVERECORD_DELETE_URL andParams:params withPrefix:DataSyncDelete_Prefix];
        [self requestWithParams:param];
    }
    
}


-(void)deleteAllNeedSyncRepair_doctor:(NSArray *)repair_doctor{
    if (nil == deletedRepairDoc)
    {
        deletedRepairDoc = [[NSMutableArray alloc] init];
    }
    
    [deletedRepairDoc removeAllObjects];
    
    counterOfRepairDocDelete = [repair_doctor count];
    
    for (int i=0; i<[repair_doctor count]; i++) {
        
        RepairDoctor  *reDoc =repair_doctor[i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:1];
        
        [subParamDic setObject:reDoc.ckeyid forKey:@"ckeyid"];
        
        [deletedRepairDoc addObject:reDoc.ckeyid];
        
        NSError *error;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                            //options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           options: 0
                                                             error:&error];
        
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
        [params setObject:jsonString forKey:@"DataEntity"];
        
        TimRequestParam *param = [TimRequestParam paramWithURLSting:REPAIRDOCTOR_DELETE_URL andParams:params withPrefix:DataSyncDelete_Prefix];
        [self requestWithParams:param];
    }

}

#pragma mark - edit Request CallBack
- (void)onDataSyncDeleteRequestSuccessWithResponse:(id)response withParam:(TimRequestParam *)param {
    NSError *error = nil;
    NSString *message = nil;
    if (response == nil || ![response isKindOfClass:[NSDictionary class]]) {
        //返回的不是字典
        message = @"返回内容错误";
        error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
        [self onDataSyncDeleteFailureCallBackWith:error andParam:param];
        return;
    }
    @try {
        NSNumber *retCodeNum = [response objectForKey:@"Code"];
        if (retCodeNum == nil) {
            //没有code字段
            message = @"返回内容解析错误";
            error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
            [self onDataSyncDeleteFailureCallBackWith:error andParam:param];
            return;
        }
        
        NSInteger retCode = [retCodeNum integerValue];
        if (retCode == 200) {
            [self onDataSyncDeleteSuccessCallBackWith:response andParam:param];
            return;
        } else {
            NSString *errorMessage = [response objectForKey:@"Result"];
            NSError *error = [NSError errorWithDomain:@"请求失败" localizedDescription:errorMessage errorCode:retCode];
            [self onDataSyncDeleteFailureCallBackWith:error andParam:param];
            return;
        }
        
        NSDictionary *retDic = [response objectForKey:@"Result"];
        if (retDic == nil) {
            //没有result字段
            message = @"返回内容解析错误";
            error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
            [self onDataSyncDeleteFailureCallBackWith:error andParam:param];
            return;
        }
    }
    @catch (NSException *exception) {
        [self onDataSyncDeleteFailureCallBackWith:[NSError errorWithDomain:@"请求失败" localizedDescription:@"未知错误" errorCode:404] andParam:param];
    }
    @finally {
        
    }
    
}

- (void)onDataSyncDeleteRequestFailure:(NSError *)error withParam:(TimRequestParam *)param {
    [self onDataSyncDeleteFailureCallBackWith:error andParam:param];
}

#pragma mark - Success
- (void)onDataSyncDeleteSuccessCallBackWith:(NSDictionary *)result andParam:(TimRequestParam *)param {
    /* if ([param.requestUrl isEqualToString:DOC_ADD_URL]) {
     [self requestAddDoctorSuccess:result andParam:param];
     } else */
    
    
    if ([param.requestUrl isEqualToString:MATERIAL_DELETE_URL]) {
        [self requestDeleteMaterialSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:INTRODUCE_DELETE_URL]) {
        [self requestDeleteIntroducerSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:PATIENT_DELETE_URL]) {
        [self requestDeletePatientSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:CTLIB_DELETE_URL]) {
        [self requestDeleteCTLibSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_CASE_DELETE_URL]) {
        [self requestDeleteMedicalCaseSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_EXPENSE_DELETE_URL]) {
        [self requestDeleteMedicalExpenseSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_RECORD_DELETE_URL]) {
        [self requestDeleteMedicalRecordSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:RESERVERECORD_DELETE_URL]) {
        [self requestDeleteReserveRecordSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:REPAIRDOCTOR_DELETE_URL]) {
        [self requestDeleteRepairDoctorSuccess:result andParam:param];
    }
}

- (void)requestDeleteDoctorSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    NSLog(@"requestAddDoctorSuccess");
    
    NSLog(@"total return number %d", [result count]);
    
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
}

- (void)requestDeleteMaterialSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    --counterOfMaterialDelete;
    
    if (0 == counterOfMaterialDelete) {
        
        [self deleteMaterialsFromDataBase];
    }
    

    
}

- (void)requestDeleteIntroducerSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }

    --counterOfIntroducerDelete;
    if (0 == counterOfIntroducerDelete) {
        [self deleteIntroducersFromDataBase];
    }
    
}

- (void)requestDeletePatientSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    --counterOfPatientDelete;
    
    if (0 == counterOfPatientDelete) {
        
        [self deletePatientsFromDataBase];
    }
    
    
}

- (void)requestDeleteCTLibSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    --counterOfMedicalCaseCTDelete;
    
    if (0 == counterOfMedicalCaseCTDelete) {
        
        [self deleteCtLibFromDataBase];
    }

    
}

- (void)requestDeleteMedicalCaseSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    --counterOfMedicalCaseDelete;
    
    if (0 == counterOfMedicalCaseDelete) {
        
        [self deleteCtLibFromDataBase];
    }
}

- (void)requestDeleteMedicalExpenseSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    --counterOfMedicalCaseMEDelete;
    
    if (0 == counterOfMedicalCaseMEDelete) {
        
        [self deleteMedicalExpenseFromDataBase];
    }
    
}

- (void)requestDeleteMedicalRecordSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    --counterOfMedicalCaseMRDelete;
    
    if (0 == counterOfMedicalCaseMRDelete) {
        
        [self deleteMedicalRecordFromDataBase];
    }
}

- (void)requestDeleteMedicalResevSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    
}

- (void)requestDeleteReserveRecordSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    --counterOfReserveRecDelete;
    
    if (0 == counterOfReserveRecDelete) {
        
        [self deleteReserveRecordFromDataBase];
    }

    
}

- (void)requestDeleteRepairDoctorSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {

    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    --counterOfRepairDocDelete;
    
    if (0 == counterOfRepairDocDelete) {
        
        [self deleteRepairDoctorFromDataBase];
    }
    
    
}





#pragma mark - Failure
- (void)onDataSyncDeleteFailureCallBackWith:(NSError *)error andParam:(TimRequestParam *)param {
    /* if ([param.requestUrl isEqualToString:DOC_ADD_URL]) {
     [self requestAddDoctorFailure:error andParam:param];
     } else */
    
    if ([param.requestUrl isEqualToString:MATERIAL_DELETE_URL]) {
        [self requestDeleteMaterialFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:INTRODUCE_DELETE_URL]) {
        [self requestDeleteIntroducerFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:PATIENT_DELETE_URL]) {
        [self requestDeletePatientFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:CTLIB_DELETE_URL]) {
        [self requestDeleteCTLibFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_CASE_DELETE_URL]) {
        [self requestDeleteMedicalCaseFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_EXPENSE_DELETE_URL]) {
        [self requestDeleteMedicalExpenseFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_RECORD_DELETE_URL]) {
        [self requestDeleteMedicalRecordFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:RESERVERECORD_DELETE_URL]) {
     [self requestDeleteReserveRecordFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:REPAIRDOCTOR_DELETE_URL]) {
        [self requestDeleteRepairDoctorFailure:error andParam:param];
    }
    
}

- (void)requestDeleteDoctorFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
}

- (void)requestDeleteMaterialFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
    
    NSInteger retCode = [error code];
    if (retCode == 201) {
        --counterOfMaterialDelete;
        
        if (0 == counterOfMaterialDelete) {
          [self deleteMaterialsFromDataBase];
            
        }
    }
}

- (void)requestDeleteIntroducerFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
    
    NSInteger retCode = [error code];
    if (retCode == 201) {
        --counterOfIntroducerDelete;
        if (0 == counterOfIntroducerDelete) {
            [self deleteIntroducersFromDataBase];
        }
    }
}

- (void)requestDeletePatientFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
    
    NSInteger retCode = [error code];
    if (retCode == 201) {
        --counterOfPatientDelete;
        
        if (0 == counterOfPatientDelete) {
            [self deletePatientsFromDataBase];
            
        }
    }
    
}

- (void)requestDeleteCTLibFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
    
    NSInteger retCode = [error code];
    if (retCode == 201) {
        --counterOfMedicalCaseCTDelete;
        
        if (0 == counterOfMedicalCaseCTDelete) {
            [self deleteCtLibFromDataBase];
            
        }
    }
}

- (void)requestDeleteMedicalCaseFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
    
    NSInteger retCode = [error code];
    if (retCode == 201) {
        --counterOfMedicalCaseDelete;
        
        if (0 == counterOfMedicalCaseDelete) {
            [self deleteMedicalCaseFromDataBase];
        }
    }
}

- (void)requestDeleteMedicalExpenseFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
    
    NSInteger retCode = [error code];
    if (retCode == 201) {
        --counterOfMedicalCaseMEDelete;
        
        if (0 == counterOfMedicalCaseMEDelete) {
            [self deleteMedicalExpenseFromDataBase];
            
        }
    }
    
}

- (void)requestDeleteMedicalRecordFailure:(NSError *)error andParam:(TimRequestParam *)param {
    
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);

    
    NSInteger retCode = [error code];
    if (retCode == 201) {
        --counterOfMedicalCaseMRDelete;
        
        if (0 == counterOfMedicalCaseMRDelete) {
            [self deleteMedicalRecordFromDataBase];
            
        }
    }
}

- (void)requestDeleteMedicalResevFailure:(NSError *)error andParam:(TimRequestParam *)param {
    
}


- (void)requestDeleteReserveRecordFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
    
    
    NSInteger retCode = [error code];
    if (retCode == 201) {
        --counterOfReserveRecDelete;
        
        if (0 == counterOfReserveRecDelete) {
            [self deleteReserveRecordFromDataBase];
            
        }
    }

}

- (void)requestDeleteRepairDoctorFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
    
    
    NSInteger retCode = [error code];
    if (retCode == 201) {
        --counterOfRepairDocDelete;
        
        if (0 == counterOfRepairDocDelete) {
            [self deleteRepairDoctorFromDataBase];
            
        }
    }
    
}


- (void)getDoctorTable{
    
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *docServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", DoctorTableName, [AccountManager currentUserid]];
    NSString *docServLastSyncDate = [userDefalut stringForKey:docServLastSynKey];
    
    if (nil == docServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        docServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    NSString *latest_userid = [CRMUserDefalut latestUserId];
    NSLog(@"last user id %@", latest_userid);
    
    [paramDic setObject:[CRMUserDefalut latestUserId] forKey:@"uid"];
    [paramDic setObject:docServLastSyncDate forKey:@"sync_time"];
     NSLog(@"sync time %@", docServLastSyncDate);
    
    TimRequestParam *param = [TimRequestParam paramWithURLSting:DOC_GET_URL andParams:paramDic withPrefix:DataSyncGet_Prefix];
    NSLog(@"enter getDoctorTable");
    [self requestWithParams:param];
    
}

- (void)getMaterialTable{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *matServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", MaterialTableName, [AccountManager currentUserid]];
    NSString *matServLastSyncDate = [userDefalut stringForKey:matServLastSynKey];
    
    if (nil == matServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        matServLastSyncDate = [dateFormatter stringFromDate:def];
    }

    [paramDic setObject:[CRMUserDefalut latestUserId] forKey:@"doctor_id"];
    [paramDic setObject:matServLastSyncDate forKey:@"sync_time"];
    
    TimRequestParam *param = [TimRequestParam paramWithURLSting:MATERIAL_GET_URL andParams:paramDic withPrefix:DataSyncGet_Prefix];
    [self requestWithParams:param];
}


- (void)getIntroducerTable{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *intServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", IntroducerTableName, [AccountManager currentUserid]];
    NSString *intServLastSyncDate = [userDefalut stringForKey:intServLastSynKey];
    
    if (nil == intServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        intServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    [paramDic setObject:[CRMUserDefalut latestUserId] forKey:@"doctor_id"];
    [paramDic setObject:intServLastSyncDate forKey:@"sync_time"];
    
    TimRequestParam *param = [TimRequestParam paramWithURLSting:INTRODUCE_GET_URL andParams:paramDic withPrefix:DataSyncGet_Prefix];
    [self requestWithParams:param];
}

- (void)getPatIntrMapTable{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *patInServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", PatIntrMapTableName, [AccountManager currentUserid]];
    NSString *patInServLastSyncDate = [userDefalut stringForKey:patInServLastSynKey];
    
    if (nil == patInServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        patInServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    [paramDic setObject:[CRMUserDefalut latestUserId] forKey:@"uid"];
    [paramDic setObject:patInServLastSyncDate forKey:@"sync_time"];
    
    TimRequestParam *param = [TimRequestParam paramWithURLSting:PATIENT_INTRODUCER_MAP_GET_URL andParams:paramDic withPrefix:DataSyncGet_Prefix];
    [self requestWithParams:param];

}

- (void)getRepairDoctorTable {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *reDocServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", RepairDocTableName, [AccountManager currentUserid]];
    NSString *reDocInServLastSyncDate = [userDefalut stringForKey:reDocServLastSynKey];
    
    if (nil == reDocInServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        reDocInServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    [paramDic setObject:[CRMUserDefalut latestUserId] forKey:@"doctor_id"];
    [paramDic setObject:reDocInServLastSyncDate forKey:@"sync_time"];
    
    TimRequestParam *param = [TimRequestParam paramWithURLSting:REPAIRDOCTOR_GET_URL andParams:paramDic withPrefix:DataSyncGet_Prefix];
    [self requestWithParams:param];
}

- (void)getReserverecordTable{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *rcServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", LocalNotificationTableName, [AccountManager currentUserid]];
    NSString *rcServLastSyncDate = [userDefalut stringForKey:rcServLastSynKey];
    
    if (nil == rcServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        rcServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    [paramDic setObject:[CRMUserDefalut latestUserId] forKey:@"doctor_id"];
    [paramDic setObject:rcServLastSyncDate forKey:@"sync_time"];
    
    TimRequestParam *param = [TimRequestParam paramWithURLSting:RESERVERECORD_GET_URL andParams:paramDic withPrefix:DataSyncGet_Prefix];
    [self requestWithParams:param];
}

- (void)getPatientTable{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *patServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", PatientTableName, [AccountManager currentUserid]];
    NSString *patServLastSyncDate = [userDefalut stringForKey:patServLastSynKey];
    
    if (nil == patServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        patServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    
    [paramDic setObject:[CRMUserDefalut latestUserId] forKey:@"doctor_id"];
    [paramDic setObject:patServLastSyncDate forKey:@"sync_time"];
    
    TimRequestParam *param = [TimRequestParam paramWithURLSting:PATIENT_GET_URL andParams:paramDic withPrefix:DataSyncGet_Prefix];
    [self requestWithParams:param];
}


- (void)getCTLibTable{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *libServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", CTLibTableName, [AccountManager currentUserid]];
    NSString *libServLastSyncDate = [userDefalut stringForKey:libServLastSynKey];

    if (nil == libServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        libServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    
    
    NSString *strCaseId = nil;
    
    if ((nil == curMC_ct) || (0 == [curMC_ct count])) {
        return;
    } else {
        for (int i = 0; i < [curMC_ct count]; i++) {
            if (nil == strCaseId) {
                strCaseId = [NSString stringWithString:curMC_ct[i]];
            } else {
                strCaseId = [strCaseId stringByAppendingString:@","];
                strCaseId = [strCaseId stringByAppendingString:curMC_ct[i]];
            }
        }
    }
    
    [paramDic setObject:strCaseId forKey:@"case_id"];
    [paramDic setObject:libServLastSyncDate forKey:@"sync_time"];
    
    TimRequestParam *param = [TimRequestParam paramWithURLSting:CTLIB_GET_URL andParams:paramDic withPrefix:DataSyncGet_Prefix];
    [self requestWithParams:param];
}


- (void)getMedicalCaseTable{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *caseServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", MedicalCaseTableName, [AccountManager currentUserid]];
    NSString *caseServLastSyncDate = [userDefalut stringForKey:caseServLastSynKey];
    
    if (nil == caseServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        caseServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    NSString *strPatientId = nil;
    
    curTimePatientsNum = [curPatients count];
    
    if ((nil == curPatients) || (0 == [curPatients count])) {
        return;
    } else {
        for (int i = 0; i < [curPatients count]; i++) {
            if (nil == strPatientId) {
                strPatientId = [NSString stringWithString:curPatients[i]];
            } else {
                strPatientId = [strPatientId stringByAppendingString:@","];
                strPatientId = [strPatientId stringByAppendingString:curPatients[i]];
            }
        }
    }
    
    [paramDic setObject:strPatientId forKey:@"patient_id"];
    [paramDic setObject:caseServLastSyncDate forKey:@"sync_time"];
    
    TimRequestParam *param = [TimRequestParam paramWithURLSting:MEDICAL_CASE_GET_URL andParams:paramDic withPrefix:DataSyncGet_Prefix];
    [self requestWithParams:param];
}


- (void)getMedicalExpenseTable{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *expeServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", MedicalExpenseTableName, [AccountManager currentUserid]];
    NSString *expServLastSyncDate = [userDefalut stringForKey:expeServLastSynKey];
    
    if (nil == expServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        expServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    
    NSString *strCaseId = nil;
    
    if ((nil == curMC_me) || (0 == [curMC_me count])) {
        return;
    } else {
        for (int i = 0; i < [curMC_me count]; i++) {
            if (nil == strCaseId) {
                strCaseId = [NSString stringWithString:curMC_me[i]];
            } else {
                strCaseId = [strCaseId stringByAppendingString:@","];
                strCaseId = [strCaseId stringByAppendingString:curMC_me[i]];
            }
        }
    }

    
    [paramDic setObject:strCaseId forKey:@"case_id"];
    [paramDic setObject:expServLastSyncDate forKey:@"sync_time"];
    
    TimRequestParam *param = [TimRequestParam paramWithURLSting:MEDICAL_EXPENSE_GET_URL andParams:paramDic withPrefix:DataSyncGet_Prefix];
    [self requestWithParams:param];
}


- (void)getMedicalRecordTable{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *recServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", MedicalRecordableName, [AccountManager currentUserid]];
    NSString *recServLastSyncDate = [userDefalut stringForKey:recServLastSynKey];
    
    if (nil == recServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        recServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    NSString *strCaseId = nil;
    
    if ((nil == curMC_mr) || (0 == [curMC_mr count])) {
        return;
    } else {
        for (int i = 0; i < [curMC_mr count]; i++) {
            if (nil == strCaseId) {
                strCaseId = [NSString stringWithString:curMC_mr[i]];
            } else {
                strCaseId = [strCaseId stringByAppendingString:@","];
                strCaseId = [strCaseId stringByAppendingString:curMC_mr[i]];
            }
        }
    }

    [paramDic setObject:strCaseId forKey:@"case_id"];
    [paramDic setObject:recServLastSyncDate forKey:@"sync_time"];
    
    TimRequestParam *param = [TimRequestParam paramWithURLSting:MEDICAL_RECORD_GET_URL andParams:paramDic withPrefix:DataSyncGet_Prefix];
    [self requestWithParams:param];
}

- (void)getPatientConsulationTable{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *caseServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", PatientConsultationTableName, [AccountManager currentUserid]];
    NSString *caseServLastSyncDate = [userDefalut stringForKey:caseServLastSynKey];
    
    if (nil == caseServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        caseServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    NSString *strPatientId = nil;
    
    curTimePatientsNum = [curPatients count];
    
    if ((nil == curPatients) || (0 == [curPatients count])) {
        return;
    } else {
        for (int i = 0; i < [curPatients count]; i++) {
            if (nil == strPatientId) {
                strPatientId = [NSString stringWithString:curPatients[i]];
            } else {
                strPatientId = [strPatientId stringByAppendingString:@","];
                strPatientId = [strPatientId stringByAppendingString:curPatients[i]];
            }
        }
    }
    
    [paramDic setObject:strPatientId forKey:@"patient_id"];
    [paramDic setObject:caseServLastSyncDate forKey:@"sync_time"];
    
    TimRequestParam *param = [TimRequestParam paramWithURLSting:PATIENTCONSULTATION_GET_URL andParams:paramDic withPrefix:DataSyncGet_Prefix];
    [self requestWithParams:param];
}


- (void)getMedicalResvTable{
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *resvServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", MedicalReserveTableName, [AccountManager currentUserid]];
    NSString *resvServLastSyncDate = [userDefalut stringForKey:resvServLastSynKey];
    
    if (nil == resvServLastSyncDate) {
        resvServLastSyncDate = [NSString currentDateString];
    }
    
    NSString *strCaseId = nil;
    
    if ((nil == downloadMedicalCasesRS) || (0 == [downloadMedicalCasesRS count])) {
        return;
    } else {
        for (int i = 0; i < [downloadMedicalCasesRS count]; i++) {
            if (nil == strCaseId) {
                strCaseId = [NSString stringWithString:downloadMedicalCasesRS[i]];
            } else {
                strCaseId = [strCaseId stringByAppendingString:@","];
                strCaseId = [strCaseId stringByAppendingString:downloadMedicalCasesRS[i]];
            }
        }
    }
    
    [paramDic setObject:strCaseId forKey:@"case_id"];
    [paramDic setObject:resvServLastSyncDate forKey:@"sync_time"];
    
    TimRequestParam *param = [TimRequestParam paramWithURLSting:MEDICAL_RESEV_GET_URL andParams:paramDic withPrefix:DataSyncGet_Prefix];
    [self requestWithParams:param];
}

#pragma mark - Request CallBack
- (void)onDataSyncGetRequestSuccessWithResponse:(id)response withParam:(TimRequestParam *)param {
    NSError *error = nil;
    NSString *message = nil;
    if (response == nil || ![response isKindOfClass:[NSDictionary class]]) {
        //返回的不是字典
        message = @"返回内容错误";
        error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
        [self onDataSyncGetRequestFailureCallBackWith:error andParam:param];
        return;
    }
    @try {
        NSNumber *retCodeNum = [response objectForKey:@"Code"];
        if (retCodeNum == nil) {
            //没有code字段
            message = @"返回内容解析错误";
            error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
            [self onDataSyncGetRequestFailureCallBackWith:error andParam:param];
            return;
        }
        
        NSInteger retCode = [retCodeNum integerValue];
        if (retCode == 200) {
            NSLog(@"data sync get succ");
            [self onDataSyncGetSuccessCallBackWith:response andParam:param];
            return;
        } else {
            NSString *errorMessage = [response objectForKey:@"Result"];
            NSError *error = [NSError errorWithDomain:@"请求失败" localizedDescription:errorMessage errorCode:retCode];
            [self onDataSyncGetRequestFailureCallBackWith:error andParam:param];
            return;
        }
        
        NSDictionary *retDic = [response objectForKey:@"Result"];
        if (retDic == nil) {
            //没有result字段
            message = @"返回内容解析错误";
            error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
            [self onDataSyncGetRequestFailureCallBackWith:error andParam:param];
            return;
        }
    }
    @catch (NSException *exception) {
        [self onDataSyncGetRequestFailureCallBackWith:[NSError errorWithDomain:@"请求失败" localizedDescription:@"未知错误" errorCode:404] andParam:param];
    }
    @finally {
        
    }
}

- (void)onDataSyncGetRequestFailure:(NSError *)error withParam:(TimRequestParam *)param {
    [self onDataSyncGetRequestFailureCallBackWith:error andParam:param];
}

#pragma mark - Success
- (void)onDataSyncGetSuccessCallBackWith:(NSDictionary *)result andParam:(TimRequestParam *)param {
    NSLog(@"sucess request URL %@", param.requestUrl);
    if ([param.requestUrl isEqualToString:DOC_GET_URL]) {
        [self requestGetDoctorSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:MATERIAL_GET_URL]) {
        [self requestGetMaterialSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:INTRODUCE_GET_URL]) {
        [self requestGetIntroducerSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:PATIENT_GET_URL]) {
        [self requestGetPatientSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:CTLIB_GET_URL]) {
        [self requestGetCTLibSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_CASE_GET_URL]) {
        [self requestGetMedicalCaseSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_EXPENSE_GET_URL]) {
        [self requestGetMedicalExpenseSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_RECORD_GET_URL]) {
        [self requestGetMedicalRecordSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_RESEV_GET_URL]) {
        [self requestGetMedicalResevSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:RESERVERECORD_GET_URL]) {
        [self requestGetReserveRecordSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:PATIENT_INTRODUCER_MAP_GET_URL]) {
        [self requestGetPatientIntroducerSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:REPAIRDOCTOR_GET_URL]) {
        [self requestGetRepairDoctorSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:PATIENTCONSULTATION_GET_URL]){
        [self requestGetPatientConsultationSuccess:result andParam:param];
    }
}

- (void)requestGetDoctorSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    
    NSLog(@"suc getDoctorTable");
    NSLog(@"total return number %d", [result count]);
    
    [self.delegate dataSycnResultWithTable:DoctorTableName isSucesseful: YES];

  
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
    }
    
    NSArray *docArray = [result objectForKey:@"Result"];
        
        for (int i=0; i<[docArray count]; i++) {
            
            NSDictionary *dic =docArray[i];
            
            Doctor *doctor = nil;
            
            if (0 != [dic count] ) {
                doctor = [Doctor DoctorFromDoctorResult:dic];
                [[DBManager shareInstance] insertDoctorWithDoctor:doctor];
            }
        }
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *docLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", DoctorTableName, [AccountManager currentUserid]];
    
    /*
    NSDate* currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *curDate = [dateFormatter stringFromDate:currentDate];
    */
    NSString *curDate = [NSString currentDateTenMinuteString];
    
    
    [userDefalut setObject:curDate forKey:docLastSynKey];
    [userDefalut synchronize];


}

- (void)requestGetMaterialSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    [self.delegate dataSycnResultWithTable:MaterialTableName isSucesseful: YES];
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    NSArray *matArray = [result objectForKey:@"Result"];
    
    for (int i=0; i<[matArray count]; i++) {
        
        NSDictionary *mat =matArray[i];
        
        Material *material = nil;
        
        if (0 != [matArray count] ) {
            material = [Material MaterialFromMaterialResult:mat];
            [[DBManager shareInstance] insertMaterial:material];
        }
    }
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *matLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", MaterialTableName, [AccountManager currentUserid]];
    
    /*
    NSDate* currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *curDate = [dateFormatter stringFromDate:currentDate];*/
    NSString *curDate = [NSString currentDateTenMinuteString];
    
    [userDefalut setObject:curDate forKey:matLastSynKey];
    [userDefalut synchronize];

}

- (void)requestGetIntroducerSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    [self.delegate dataSycnResultWithTable:IntroducerTableName isSucesseful: YES];
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
    }
    
    NSArray *inteArray = [result objectForKey:@"Result"];
    
    for (int i=0; i<[inteArray count]; i++) {
        
        NSDictionary *inte =inteArray[i];
        
        Introducer *introducer = nil;
        
        if (0 != [inteArray count] ) {
            introducer = [Introducer IntroducerFromIntroducerResult:inte];
            [[DBManager shareInstance] insertIntroducer:introducer];
            //稍后条件判断是否成功的代码
        }
    }
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *intLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", IntroducerTableName, [AccountManager currentUserid]];
    /*
    NSDate* currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *curDate = [dateFormatter stringFromDate:currentDate];*/
    
    NSString *curDate = [NSString currentDateTenMinuteString];
    
    [userDefalut setObject:curDate forKey:intLastSynKey];
    [userDefalut synchronize];


}

- (void)requestGetPatientSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    [self.delegate dataSycnResultWithTable:PatientTableName isSucesseful: YES];
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    if (nil == downloadPatients) {
        downloadPatients = [[NSMutableArray alloc] init];
    }
    
    NSArray *patientArray = [result objectForKey:@"Result"];
    
    for (int i=0; i<[patientArray count]; i++) {
        
        NSDictionary *pat =patientArray[i];
        
        Patient *patient = nil;
        
        if (0 != [pat count] ) {
            patient = [Patient PatientFromPatientResult:pat];
            //将获得的患者id保存下来，后续下载病例时使用
            if (NSNotFound == [downloadPatients indexOfObject:patient.ckeyid]) {
                [downloadPatients addObject:patient.ckeyid];
            }
         //   [[DBManager shareInstance] insertPatient:patient];
            //稍后条件判断是否成功的代码
            [[DBManager shareInstance]insertPatientBySync:patient];
        }
        
    }
  
    if (0 == [patientArray count]){
#pragma mark - ***********************同步结束
//        [SVProgressHUD showSuccessWithStatus:@"同步完成"];
//        [NSThread sleepForTimeInterval:1.0];
//        [SVProgressHUD dismiss];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"tongbu" object:nil];
    }
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *patServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", PatientTableName, [AccountManager currentUserid]];
    /*
    NSDate* currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *curDate = [dateFormatter stringFromDate:currentDate]; */
    
    NSString *curDate = [NSString currentDateTenMinuteString];
    
    
    
    [userDefalut setObject:curDate forKey:patServLastSynKey];
    [userDefalut synchronize];
    
    if (0 != [downloadPatients count]) {
        
        if (nil == curPatients) {
            curPatients = [[NSMutableArray alloc] init];
        }
        
        if ([downloadPatients count] <= curPatientsNum) {
            for (int i=0; i < [downloadPatients count]; i++) {
                [curPatients addObject:[downloadPatients objectAtIndex:i]];
            }
        } else {
            for (int i=0; i < curPatientsNum; i++) {
                [curPatients addObject:[downloadPatients objectAtIndex:i]];
            }
        }
        
        [self getPatientConsulationTable];
        [self getMedicalCaseTable];
    }
}


-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

- (void)requestGetCTLibSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    

    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    NSArray *medicalCTArray = [result objectForKey:@"Result"];
    
    for (int i=0; i<[medicalCTArray count]; i++) {
        
        NSDictionary *medCT =medicalCTArray[i];
        
        CTLib *ctlib = nil;
        
        if (0 != [medCT count] ) {
            ctlib = [CTLib CTLibFromCTLibResult:medCT];
            
            [[DBManager shareInstance] insertCTLib:ctlib];
            
#if 1
            if ([ctlib.ct_image isNotEmpty]) {
            
                NSString *urlImage = [NSString stringWithFormat:@"%@%@_%@", ImageDown, ctlib.ckeyid, ctlib.ct_image];
            
                //ctlib.ct_image
            
                UIImage *image = [self getImageFromURL:urlImage];
            
                if (nil != image) {
                   // [CaseFunction saveImageWithImage:image AndWithCTLib:ctlib];
                    [PatientManager pathImageSaveToDisk:image withKey:ctlib.ct_image];
                }

            }
#endif
            
            //稍后条件判断是否成功的代码
            if (nil != downloadMedicalCasesCT) {
                NSInteger index = [downloadMedicalCasesCT indexOfObject:ctlib.case_id];
                if (NSNotFound != index) {
                    [downloadMedicalCasesCT removeObjectAtIndex:index];
                }
            }
        }
    }
    
    
    for (int i=0; i<[curMC_ct count]; i++) {
        [downloadMedicalCasesCT removeObject:[curMC_ct objectAtIndex:i]];
    }
    
    [curMC_ct removeAllObjects];
    
    if ([downloadMedicalCasesCT count] != 0) {
        if ([downloadMedicalCasesCT count] <= curPatientsNum) {
            for (int i=0; i < [downloadMedicalCasesCT count]; i++) {
                [curMC_ct addObject:[downloadMedicalCasesCT objectAtIndex:i]];
            }
        } else {
            for (int i=0; i < curPatientsNum; i++) {
                [curMC_ct addObject:[downloadMedicalCasesCT objectAtIndex:i]];
            }
        }
        
        [self getCTLibTable];
        
    } else {
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *ctServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", CTLibTableName, [AccountManager currentUserid]];
        
        //[userDefalut setObject:[NSString currentDateString] forKey:ctServLastSynKey];
        [userDefalut setObject:[NSString currentDateTenMinuteString] forKey:ctServLastSynKey];
        
        [userDefalut synchronize];
        
        [self.delegate dataSycnResultWithTable:CTLibTableName isSucesseful: YES];
        
#pragma mark - ***************************第二次同步结束
        [SVProgressHUD showSuccessWithStatus:@"同步完成"];
        [NSThread sleepForTimeInterval:1.0];
        [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tongbu" object:nil];
        
        return;
    }
    
#pragma mark - ***********************同步结束
    [SVProgressHUD showSuccessWithStatus:@"同步完成"];
    [NSThread sleepForTimeInterval:1.0];
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tongbu" object:nil];
}

- (void)requestGetMedicalCaseSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    
    if (nil == downloadMedicalCasesCT) {
        downloadMedicalCasesCT = [[NSMutableArray alloc] init];
    }
    
    if (nil == downloadMedicalCasesME) {
        downloadMedicalCasesME = [[NSMutableArray alloc] init];
    }
    
    if (nil == downloadMedicalCasesMR) {
        downloadMedicalCasesMR = [[NSMutableArray alloc] init];
    }
    
    if (nil == downloadMedicalCasesRS) {
        downloadMedicalCasesRS = [[NSMutableArray alloc] init];
    }
    
    
    
    NSArray *medicalCaseArray = [result objectForKey:@"Result"];
    
    for (int i=0; i<[medicalCaseArray count]; i++) {
        
        NSDictionary *medcas =medicalCaseArray[i];
        
        MedicalCase *medicalCase = nil;
        
        if (0 != [medcas count] ) {
            medicalCase = [MedicalCase MedicalCaseFromPatientMedicalCase:medcas];
            
            [[DBManager shareInstance] insertMedicalCase:medicalCase];
            //稍后条件判断是否成功的代码
            
          
            if (NSNotFound == [downloadMedicalCasesCT indexOfObject:medicalCase.ckeyid]) {
                    [downloadMedicalCasesCT addObject:medicalCase.ckeyid];
            }
            
            if (NSNotFound == [downloadMedicalCasesME indexOfObject:medicalCase.ckeyid]) {
                    [downloadMedicalCasesME addObject:medicalCase.ckeyid];
            }
            
            if (NSNotFound == [downloadMedicalCasesMR indexOfObject:medicalCase.ckeyid]) {
                    [downloadMedicalCasesMR addObject:medicalCase.ckeyid];
            }
            
            if (NSNotFound == [downloadMedicalCasesRS indexOfObject:medicalCase.ckeyid]) {
                [downloadMedicalCasesRS addObject:medicalCase.ckeyid];
            }
            
            if (nil != downloadPatients) {
                NSInteger index = [downloadMedicalCasesCT indexOfObject:medicalCase.patient_id];
                if (NSNotFound != index) {
                    [downloadPatients removeObjectAtIndex:index];
                }
                
            }
            
        }
    }
    
    
    for (int i=0; i<[curPatients count]; i++) {
        [downloadPatients removeObject:[curPatients objectAtIndex:i]];
    }
    
    [curPatients removeAllObjects];
    
    if ([downloadPatients count] > 0) {
        if ([downloadPatients count] <= curPatientsNum) {
            for (int i=0; i < [downloadPatients count]; i++) {
                [curPatients addObject:[downloadPatients objectAtIndex:i]];
            }
        } else {
            for (int i=0; i < curPatientsNum; i++) {
                [curPatients addObject:[downloadPatients objectAtIndex:i]];
            }
        }
        
        [self getMedicalCaseTable];
        
    } else {
        
        if (0 != [downloadMedicalCasesME count]) {
            
            if (nil == curMC_me) {
                curMC_me = [[NSMutableArray alloc] init];
            }
            
            if ([downloadMedicalCasesME count] <= curPatientsNum) {
                for (int i=0; i < [downloadMedicalCasesME count]; i++) {
                    [curMC_me addObject:[downloadMedicalCasesME objectAtIndex:i]];
                }
            } else {
                for (int i=0; i < curPatientsNum; i++) {
                    [curMC_me addObject:[downloadMedicalCasesME objectAtIndex:i]];
                }
            }
            
            [self getMedicalExpenseTable];
        }
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *patServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", MedicalCaseTableName, [AccountManager currentUserid]];
        /*
        NSDate* currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];*/
        NSString *curDate = [NSString currentDateTenMinuteString];
        
        [userDefalut setObject:curDate forKey:patServLastSynKey];
        [userDefalut synchronize];
        
        [self.delegate dataSycnResultWithTable:MedicalCaseTableName isSucesseful: YES];
#pragma mark - ***************************************** 第一次同步结束
        
    }
    
#if 0
    //在这里获取CT，ME，MR的信息
    [self getMedicalRecordTable];
    [self getCTLibTable];
    [self getMedicalExpenseTable];
#endif
}

- (void)requestGetMedicalExpenseSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    NSArray *medicalExArray = [result objectForKey:@"Result"];
    
    for (int i=0; i<[medicalExArray count]; i++) {
        
        NSDictionary *medEx =medicalExArray[i];
        
        MedicalExpense *medicalexpense = nil;
        
        if (0 != [medEx count] ) {
            medicalexpense = [MedicalExpense MEFromMEResult:medEx];
            
            [[DBManager shareInstance] insertMedicalExpenseWith:medicalexpense];
            //稍后条件判断是否成功的代码
            if (nil != downloadMedicalCasesME) {
                NSInteger index = [downloadMedicalCasesME indexOfObject:medicalexpense.case_id];
                if (NSNotFound != index) {
                    [downloadMedicalCasesME removeObjectAtIndex:index];
                }
                
            }
            
        }
    }
    
    
    for (int i=0; i<[curMC_me count]; i++) {
        [downloadMedicalCasesME removeObject:[curMC_me objectAtIndex:i]];
    }
    
    [curMC_me removeAllObjects];
    
    if ([downloadMedicalCasesME count] != 0) {
        if ([downloadMedicalCasesME count] <= curPatientsNum) {
            for (int i=0; i < [downloadMedicalCasesME count]; i++) {
                [curMC_me addObject:[downloadMedicalCasesME objectAtIndex:i]];
            }
        } else {
            for (int i=0; i < curPatientsNum; i++) {
                [curMC_me addObject:[downloadMedicalCasesME objectAtIndex:i]];
            }
        }
        
        [self getMedicalExpenseTable];
    } else {
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *meServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", MedicalExpenseTableName, [AccountManager currentUserid]];
        /*
        NSDate* currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];*/
        NSString *curDate = [NSString currentDateTenMinuteString];
        
        [userDefalut setObject:curDate forKey:meServLastSynKey];
        [userDefalut synchronize];
        
        [self.delegate dataSycnResultWithTable:MedicalExpenseTableName isSucesseful: YES];

        
        if (0 != [downloadMedicalCasesMR count]) {
            
            if (nil == curMC_mr) {
                curMC_mr = [[NSMutableArray alloc] init];
            }
            
            if ([downloadMedicalCasesMR count] <= curPatientsNum) {
                for (int i=0; i < [downloadMedicalCasesMR count]; i++) {
                    [curMC_mr addObject:[downloadMedicalCasesMR objectAtIndex:i]];
                }
            } else {
                for (int i=0; i < curPatientsNum; i++) {
                    [curMC_mr addObject:[downloadMedicalCasesMR objectAtIndex:i]];
                }
            }
            
            [self getMedicalRecordTable];
        }
    }

}

- (void)requestGetPatientConsultationSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    
    
    NSLog(@"suc getPatientConsultationTable");
    NSLog(@"total return number %ld", (unsigned long)[result count]);
    
    [self.delegate dataSycnResultWithTable:PatientConsultationTableName isSucesseful: YES];
    
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
    }
    
    NSArray *patientConsultationArray = [result objectForKey:@"Result"];
    
    for (int i=0; i<[patientConsultationArray count]; i++) {
        
        NSDictionary *dic =patientConsultationArray[i];
        
        PatientConsultation *patientC = nil;
        
        if (0 != [dic count] ) {
            patientC = [PatientConsultation PCFromPCResult:dic];
            
            [[DBManager shareInstance]insertPatientConsultation:patientC];
        }
    }
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *docLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", PatientConsultationTableName, [AccountManager currentUserid]];
    
    /*
    NSDate* currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *curDate = [dateFormatter stringFromDate:currentDate];*/
    NSString *curDate = [NSString currentDateTenMinuteString];
    
    [userDefalut setObject:curDate forKey:docLastSynKey];
    [userDefalut synchronize];
    
    
}
- (void)requestGetMedicalRecordSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    NSArray *medicalReArray = [result objectForKey:@"Result"];
    
    for (int i=0; i<[medicalReArray count]; i++) {
        
        NSDictionary *medRe =medicalReArray[i];
        
        MedicalRecord *medicalrecord = nil;
        
        if (0 != [medRe count] ) {
            medicalrecord = [MedicalRecord MRFromMRResult:medRe];
            
            [[DBManager shareInstance] insertMedicalRecord:medicalrecord];
            //稍后条件判断是否成功的代码
            if (nil != downloadMedicalCasesMR) {
                NSInteger index = [downloadMedicalCasesMR indexOfObject:medicalrecord.case_id];
                if (NSNotFound != index) {
                    [downloadMedicalCasesMR removeObjectAtIndex:index];
                }
            }
        }
    }
    
    
    for (int i=0; i<[curMC_mr count]; i++) {
        [downloadMedicalCasesMR removeObject:[curMC_mr objectAtIndex:i]];
    }
    
    [curMC_mr removeAllObjects];
    
    if ([downloadMedicalCasesMR count] != 0) {
        if ([downloadMedicalCasesMR count] <= curPatientsNum) {
            for (int i=0; i < [downloadMedicalCasesMR count]; i++) {
                [curMC_mr addObject:[downloadMedicalCasesMR objectAtIndex:i]];
            }
        } else {
            for (int i=0; i < curPatientsNum; i++) {
                [curMC_mr addObject:[downloadMedicalCasesMR objectAtIndex:i]];
            }
        }
        
        [self getMedicalRecordTable];
    } else {
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *mrServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", MedicalRecordableName, [AccountManager currentUserid]];
        /*
        NSDate* currentDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [dateFormatter stringFromDate:currentDate];*/
        NSString *curDate = [NSString currentDateTenMinuteString];
        
        [userDefalut setObject:curDate forKey:mrServLastSynKey];
        [userDefalut synchronize];
        
        if (0 != [downloadMedicalCasesCT count]) {
            
            if (nil == curMC_ct) {
                curMC_ct = [[NSMutableArray alloc] init];
            }
            
            if ([downloadMedicalCasesCT count] <= curPatientsNum) {
                for (int i=0; i < [downloadMedicalCasesCT count]; i++) {
                    [curMC_ct addObject:[downloadMedicalCasesCT objectAtIndex:i]];
                }
            } else {
                for (int i=0; i < curPatientsNum; i++) {
                    [curMC_ct addObject:[downloadMedicalCasesCT objectAtIndex:i]];
                }
            }
            
            [self getCTLibTable];
            
        }
//        else{
//            [self.delegate dataSycnResultWithTable:MedicalRecordableName isSucesseful: YES];
//        }
    }
}

- (void)requestGetMedicalResevSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    //  
    
    
    [self.delegate dataSycnResultWithTable:MedicalReserveTableName isSucesseful: YES];
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    NSArray *medicalRsArray = [result objectForKey:@"Result"];
    
    for (int i=0; i<[medicalRsArray count]; i++) {
        
        NSDictionary *medRs =medicalRsArray[i];
        
        MedicalReserve *medicalreserve = nil;
        
        if (0 != [medRs count] ) {
            medicalreserve = [MedicalReserve MRSFromMRSResult:medRs];
            
            [[DBManager shareInstance] insertMedicalReserve:medicalreserve];
            //稍后条件判断是否成功的代码
            if (nil != downloadMedicalCasesRS) {
                NSInteger index = [downloadMedicalCasesRS indexOfObject:medicalreserve.case_id];
                if (NSNotFound != index) {
                    [downloadMedicalCasesRS removeObjectAtIndex:index];
                }
                
            }
            
        }
    }

    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *mrServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", MedicalReserveTableName, [AccountManager currentUserid]];
    /*
    NSDate* currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *curDate = [dateFormatter stringFromDate:currentDate];*/
    NSString *curDate = [NSString currentDateTenMinuteString];
    
    [userDefalut setObject:curDate forKey:mrServLastSynKey];
    [userDefalut synchronize];

}

- (void)requestGetReserveRecordSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    [self.delegate dataSycnResultWithTable:LocalNotificationTableName isSucesseful: YES];
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    NSArray *reserveRecordArray = [result objectForKey:@"Result"];
    
    for (int i=0; i<[reserveRecordArray count]; i++) {
        
        NSDictionary *resR =reserveRecordArray[i];
        
        LocalNotification *local = nil;
        
        if (0 != [resR count] ) {
            local = [LocalNotification LNFromLNFResult:resR];
            
            [[DBManager shareInstance] insertLocalNotification:local];
            //稍后条件判断是否成功的代码
        
        }
    }
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *ctServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", LocalNotificationTableName, [AccountManager currentUserid]];
    /*
    NSDate* currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *curDate = [dateFormatter stringFromDate:currentDate];*/
    NSString *curDate = [NSString currentDateTenMinuteString];
    
    [userDefalut setObject:curDate forKey:ctServLastSynKey];
    [userDefalut synchronize];
    
}

- (void)requestGetPatientIntroducerSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    //  
    
    [self.delegate dataSycnResultWithTable:PatIntrMapTableName isSucesseful: YES];
    
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    NSArray *patientIntroducerArray = [result objectForKey:@"Result"];
    
    for (int i=0; i<[patientIntroducerArray count]; i++) {
        NSDictionary *resPI =patientIntroducerArray[i];
        PatientIntroducerMap *pI = nil;
        if (0 != [resPI count] ) {
            pI = [PatientIntroducerMap PIFromMIResult:resPI];
            [[DBManager shareInstance] insertPatientIntroducerMap:pI];
            //稍后条件判断是否成功的代码
        }
    }
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *piServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", PatIntrMapTableName, [AccountManager currentUserid]];
    /*
    NSDate* currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *curDate = [dateFormatter stringFromDate:currentDate];*/
    NSString *curDate = [NSString currentDateTenMinuteString];
    
    [userDefalut setObject:curDate forKey:piServLastSynKey];
    [userDefalut synchronize];
    
}

- (void)requestGetRepairDoctorSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    //  
    
    
    [self.delegate dataSycnResultWithTable:RepairDocTableName isSucesseful: YES];
    
    for( NSString *aKey in [result allKeys] )
    {
        // do something like a log:
        NSLog(@"%@", aKey);
        NSLog(@"value %@", [result valueForKey:aKey]);
        
    }
    
    NSArray *repairDoctorArray = [result objectForKey:@"Result"];
    
    for (int i=0; i<[repairDoctorArray count]; i++) {
        
        NSDictionary *resRD =repairDoctorArray[i];
        
        RepairDoctor *rD = nil;
        
        if (0 != [resRD count] ) {
            rD = [RepairDoctor  repairDoctorFromDoctorResult:resRD];
            
            [[DBManager shareInstance] insertRepairDoctor:rD];
            //稍后条件判断是否成功的代码
            
        }
    }
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *rDServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", RepairDocTableName, [AccountManager currentUserid]];
    /*
    NSDate* currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *curDate = [dateFormatter stringFromDate:currentDate];*/
    NSString *curDate = [NSString currentDateTenMinuteString];
    
    [userDefalut setObject:curDate forKey:rDServLastSynKey];
    [userDefalut synchronize];
    
}

#pragma mark - Failure
- (void)onDataSyncGetRequestFailureCallBackWith:(NSError *)error andParam:(TimRequestParam *)param {
    if ([param.requestUrl isEqualToString:DOC_GET_URL]) {
        [self requestGetDoctorFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:MATERIAL_GET_URL]) {
        [self requestGetMaterialFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:INTRODUCE_GET_URL]) {
        [self requestGetIntroducerFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:PATIENT_GET_URL]) {
        [self requestGetPatientFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:CTLIB_GET_URL]) {
        [self requestGetCTLibFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_CASE_GET_URL]) {
        [self requestGetMedicalCaseFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_EXPENSE_GET_URL]) {
        [self requestGetMedicalExpenseFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_RECORD_GET_URL]) {
        [self requestGetMedicalRecordFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:MEDICAL_RESEV_GET_URL]) {
        [self requestGetMedicalResevFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:RESERVERECORD_GET_URL]) {
        [self requestGetReserveRecordFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:PATIENT_INTRODUCER_MAP_GET_URL]) {
        [self requestGetPatientIndroducerFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:REPAIRDOCTOR_GET_URL]) {
        [self requestGetRepairDoctorFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:PATIENTCONSULTATION_GET_URL]){
        [self requestGetPatientConsultationFailure:error andParam:param];
    }
}

- (void)requestGetDoctorFailure:(NSError *)error andParam:(TimRequestParam *)param {
      NSLog(@"fail getDoctorTable");
      NSLog(@"error: %@", [error localizedDescription]);
      NSLog(@"error: %d", [error code]);
}

- (void)requestGetMaterialFailure:(NSError *)error andParam:(TimRequestParam *)param {

    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
}

- (void)requestGetIntroducerFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
}

- (void)requestGetPatientFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %ld", (long)[error code]);
    
    #pragma mark - ***********************同步结束
    [SVProgressHUD showSuccessWithStatus:@"同步完成"];
    [NSThread sleepForTimeInterval:1.0];
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tongbu" object:nil];
    
   
}

- (void)requestGetCTLibFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"CT片同步失败error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
    
    //重新请求时
    [self getCTLibTable];
    
  //  static NSInteger retry = 5;
    
  //  if (--retry != 0)
  //  {
//        [self getCTLibTable];
    
  //  }

}

- (void)requestGetMedicalCaseFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"获取病历信息失败:error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
    
  //  static NSInteger retry = 5;
    
  //  if (--retry != 0)
  //  {
        [self getMedicalCaseTable];

  //  }
    
    
}

- (void)requestGetMedicalExpenseFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"获取病历Expense失败error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
    
   // static NSInteger retry = 5;
    
   // if (--retry != 0)
   // {
      [self getMedicalExpenseTable];
    
   // }
}

- (void)requestGetMedicalRecordFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"获取病历记录失败:error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
    
  //  static NSInteger retry = 5;
    
  //  if (--retry != 0)
   // {
        [self getMedicalRecordTable];
    
   // }
}

- (void)requestGetMedicalResevFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
}

- (void)requestGetReserveRecordFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
    
}

- (void)requestGetPatientIndroducerFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
    
}

- (void)requestGetRepairDoctorFailure:(NSError *)error andParam:(TimRequestParam *)param {
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %d", [error code]);
    
}

- (void)requestGetPatientConsultationFailure:(NSError *)error andParam:(TimRequestParam *)param{
    NSLog(@"error: %@", [error localizedDescription]);
    NSLog(@"error: %ld", [error code]);
}



@end

