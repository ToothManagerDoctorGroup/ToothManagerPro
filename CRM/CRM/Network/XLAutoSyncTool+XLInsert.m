//
//  XLAutoSyncTool+XLInsert.m
//  CRM
//
//  Created by Argo Zhang on 15/12/28.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLAutoSyncTool+XLInsert.h"
#import "CRMHttpTool.h"
#import "AccountManager.h"
#import "CRMUserDefalut.h"
#import "PatientManager.h"
#import "NSJSONSerialization+jsonString.h"
#import "JSONKit.h"
#import "NSString+TTMAddtion.h"

@implementation XLAutoSyncTool (XLInsert)

- (void)postAllNeedSyncPatient:(Patient *)patient success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [subParamDic setObject:patient.ckeyid forKey:@"ckeyid"];
    [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
    [subParamDic setObject:patient.patient_name forKey:@"patient_name"];
    [subParamDic setObject:patient.patient_phone forKey:@"patient_phone"];
    [subParamDic setObject:@"bb.jpg" forKey:@"patient_avatar"];
    if (nil != patient.patient_gender) {
        [subParamDic setObject:patient.patient_gender forKey:@"patient_gender"];
    } else {
        [subParamDic setObject:@"0" forKey:@"patient_gender"];
    }
    if (nil != patient.patient_age) {
        [subParamDic setObject:patient.patient_age forKey:@"patient_age"];
    } else {
        [subParamDic setObject:@"" forKey:@"patient_age"];
    }
    [subParamDic setObject:[[NSNumber numberWithInt: patient.patient_status] stringValue] forKey:@"patient_status"];
    [subParamDic setObject:patient.introducer_id forKey:@"introducer_id"];
    [subParamDic setObject:patient.doctor_id forKey:@"doctor_id"];
    
    [subParamDic setObject:patient.patient_remark forKey:@"patient_remark"];
    [subParamDic setObject:patient.patient_allergy forKey:@"patient_allergy"];
    [subParamDic setObject:patient.anamnesis forKey:@"Anamnesis"];
    [subParamDic setObject:patient.nickName forKey:@"NickName"];
    
    
    NSString *jsonString = [NSJSONSerialization jsonStringWithObject:subParamDic];
    
    params[@"table"] = [@"patient" TripleDESIsEncrypt:YES];
    params[@"action"] = [@"add" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [jsonString TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:POST_COMMONURL parameters:[self addCommenParams:params] success:^(id responseObject) {
        CRMHttpRespondModel *model = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postAllNeedSyncMaterial:(Material *)material success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:6];
    
    [subParamDic setObject:material.ckeyid forKey:@"ckeyid"];
    [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
    [subParamDic setObject:material.mat_name forKey:@"mat_name"];
    [subParamDic setObject:[NSString stringWithFormat: @"%.2f", material.mat_price] forKey:@"mat_price"];
    [subParamDic setObject:[NSString stringWithFormat:@"%ld", (long)material.mat_type] forKey:@"mat_type"];
    [subParamDic setObject:[CRMUserDefalut latestUserId] forKey:@"doctor_id"];
    NSString *jsonString = [NSJSONSerialization jsonStringWithObject:subParamDic];
    
    params[@"table"] = [@"material" TripleDESIsEncrypt:YES];
    params[@"action"] = [@"add" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [jsonString TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:POST_COMMONURL parameters:[self addCommenParams:params] success:^(id responseObject) {
        CRMHttpRespondModel *model = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postAllNeedSyncIntroducer:(Introducer *)introducer success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:8];
    
    [subParamDic setObject:introducer.ckeyid forKey:@"ckeyid"];
    [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
    [subParamDic setObject:introducer.intr_name forKey:@"intr_name"];
    [subParamDic setObject:introducer.intr_phone forKey:@"intr_phone"];
    [subParamDic setObject:[NSString stringWithFormat: @"%ld", (long)introducer.intr_level] forKey:@"intr_level"];
    [subParamDic setObject:introducer.creation_date forKey:@"creation_time"];
    [subParamDic setObject:introducer.doctor_id forKey:@"doctor_id"];
    [subParamDic setObject:introducer.intr_id forKey:@"intr_id"];
    
    NSError *error;
    NSString *jsonString;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                                                       options: 0
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    }
    else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
    }
    params[@"table"] = [@"introducer" TripleDESIsEncrypt:YES];
    params[@"action"] = [@"add" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [jsonString TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:POST_COMMONURL parameters:[self addCommenParams:params] success:^(id responseObject) {
        CRMHttpRespondModel *model = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postAllNeedSyncPatientIntroducerMap:(PatientIntroducerMap *)patIntr success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionaryWithCapacity:5];
    [dataEntity setObject:patIntr.patient_id forKey:@"patient_id"];
    [dataEntity setObject:patIntr.doctor_id forKey:@"doctor_id"];
    [dataEntity setObject:patIntr.intr_id forKey:@"intr_id"];
    [dataEntity setObject:patIntr.intr_source forKey:@"intr_source"];
    [dataEntity setObject:[NSString currentDateString] forKey:@"intr_time"];
    
    NSString *jsonString = [NSJSONSerialization jsonStringWithObject:dataEntity];
    paramDic[@"action"] = [@"add" TripleDESIsEncrypt:YES];
    paramDic[@"DataEntity"] = [jsonString TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:POST_PATIENT_INTRODUCERMAP_INSERT parameters:[self addCommenParams:paramDic] success:^(id responseObject) {
        CRMHttpRespondModel *model = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postAllNeedSyncMedical_case:(MedicalCase *)medical_case success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
    
    [subParamDic setObject:medical_case.ckeyid forKey:@"ckeyid"];
    
    NSDate* currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *curDate = [dateFormatter stringFromDate:currentDate];
    
    [subParamDic setObject:curDate forKey:@"sync_time"];
    [subParamDic setObject:medical_case.patient_id forKey:@"patient_id"];
    [subParamDic setObject:medical_case.case_name forKey:@"case_name"];
    [subParamDic setObject:medical_case.creation_date forKey:@"createdate"];
    if (nil == medical_case.implant_time ||[medical_case.implant_time isEqualToString:@"0"]) {
        [subParamDic setObject:@"" forKey:@"implant_time"];
    } else {
        [subParamDic setObject:medical_case.implant_time forKey:@"implant_time"];
    }
    
    if ([medical_case.next_reserve_time isEqualToString:@"0"]) {
        [subParamDic setObject:@"" forKey:@"next_reserve_time"];
    } else {
        [subParamDic setObject:medical_case.next_reserve_time forKey:@"next_reserve_time"];
    }
    
    if ([medical_case.repair_time isEqualToString:@"0"]) {
        [subParamDic setObject:@"" forKey:@"repair_time"];
    } else {
        [subParamDic setObject:medical_case.repair_time forKey:@"repair_time"];
    }
    
    [subParamDic setObject:[NSString stringWithFormat: @"%ld", (long)medical_case.case_status] forKey:@"status"];
    [subParamDic setObject:medical_case.repair_doctor forKey:@"repair_doctor"];
    [subParamDic setObject:medical_case.doctor_id forKey:@"doctor_id"];
    [subParamDic setObject:medical_case.repair_doctor_name forKey:@"repair_doctor_name"];
    [subParamDic setObject:medical_case.tooth_position forKey:@"tooth_position"];
    
    NSError *error;
    NSString *jsonString;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                                                       options: 0
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    }
    else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
    }
    params[@"table"] = [@"medicalcase" TripleDESIsEncrypt:YES];
    params[@"action"] = [@"add" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [jsonString TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:POST_COMMONURL parameters:[self addCommenParams:params] success:^(id responseObject) {
        CRMHttpRespondModel *model = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postAllNeedSyncCt_lib:(CTLib *)ct_lib success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:7];

    [subParamDic setObject:ct_lib.ckeyid forKey:@"ckeyid"];
    [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
    [subParamDic setObject:ct_lib.patient_id forKey:@"patient_id"];
    [subParamDic setObject:ct_lib.case_id forKey:@"case_id"];
    [subParamDic setObject:ct_lib.ct_desc forKey:@"ct_desc"];
    [subParamDic setObject:ct_lib.ct_image forKey:@"ct_image"];
    [subParamDic setObject:ct_lib.doctor_id forKey:@"doctor_id"];
    [subParamDic setObject:ct_lib.is_main forKey:@"is_main"];

    NSError *error;
    NSString *jsonString;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                                                       options: 0
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    }
    else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
    }
    
    params[@"table"] = [@"ctlib" TripleDESIsEncrypt:YES];
    params[@"action"] = [@"add" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [jsonString TripleDESIsEncrypt:YES];
    
    //如果ctlib有图片数据
    if ([PatientManager IsImageExisting:ct_lib.ct_image]) {
        MyUploadParam *upLoadParam = [[MyUploadParam alloc] init];
        upLoadParam.data = (NSData *)[PatientManager pathImageGetFromDisk:ct_lib.ct_image];
        upLoadParam.name = @"uploadfile";
        upLoadParam.fileName = ct_lib.ct_image;
        upLoadParam.mimeType = @"image/png,image/jpeg,image/pjpeg";
        
        [[CRMHttpTool shareInstance] POST:POST_COMMONURL parameters:[self addCommenParams:params] uploadParam:upLoadParam success:^(id responseObject) {
            CRMHttpRespondModel *model = [CRMHttpRespondModel objectWithKeyValues:responseObject];
            if (success) {
                success(model);
            }
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];

    }else{
        //没有图片数据
        [[CRMHttpTool shareInstance] POST:POST_COMMONURL parameters:[self addCommenParams:params] success:^(id responseObject) {
            CRMHttpRespondModel *model = [CRMHttpRespondModel objectWithKeyValues:responseObject];
            if (success) {
                success(model);
            }
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    }
}

- (void)postAllNeedSyncMedical_expense:(MedicalExpense *)medical_expense success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
    [subParamDic setObject:medical_expense.ckeyid forKey:@"ckeyid"];
    [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
    [subParamDic setObject:medical_expense.patient_id forKey:@"patient_id"];
    [subParamDic setObject:medical_expense.case_id forKey:@"case_id"];
    [subParamDic setObject:medical_expense.mat_id forKey:@"mat_id"];
    [subParamDic setObject:[NSString stringWithFormat:@"%ld",(long)medical_expense.expense_num] forKey:@"expense_num"];
    [subParamDic setObject:[NSString stringWithFormat: @"%.2f", medical_expense.expense_price] forKey:@"expense_price"];
    [subParamDic setObject:[NSString stringWithFormat: @"%.2f", medical_expense.expense_money] forKey:@"expense_money"];
    
    [subParamDic setObject:medical_expense.doctor_id forKey:@"doctor_id"];
    
    NSError *error;
    NSString *jsonString;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                                                       options: 0
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    }
    else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
    }
    params[@"table"] = [@"medicalexpense" TripleDESIsEncrypt:YES];
    params[@"action"] = [@"add" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [jsonString TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:POST_COMMONURL parameters:[self addCommenParams:params] success:^(id responseObject) {
        CRMHttpRespondModel *model = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postAllNeedSyncMedical_record:(MedicalRecord *)medical_record success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
    
    [subParamDic setObject:medical_record.ckeyid forKey:@"ckeyid"];
    [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
    
    [subParamDic setObject:medical_record.patient_id forKey:@"patient_id"];
    [subParamDic setObject:medical_record.case_id forKey:@"case_id"];
    [subParamDic setObject:medical_record.record_content forKey:@"record_content"];
    [subParamDic setObject:medical_record.doctor_id forKey:@"doctor_id"];
    
    NSError *error;
    NSString *jsonString;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                                                       options: 0
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    }
    else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
    }
    params[@"table"] = [@"medicalrecord" TripleDESIsEncrypt:YES];
    params[@"action"] = [@"add" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [jsonString TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:POST_COMMONURL parameters:[self addCommenParams:params] success:^(id responseObject) {
        CRMHttpRespondModel *model = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postAllNeedSyncReserve_record:(LocalNotification *)reserve_record success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
    
    [subParamDic setObject:reserve_record.ckeyid forKey:@"ckeyid"];
    [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
    [subParamDic setObject:reserve_record.patient_id forKey:@"patient_id"];
    [subParamDic setObject:reserve_record.reserve_time forKey:@"reserve_time"];
    [subParamDic setObject:reserve_record.reserve_type forKey:@"reserve_type"];
    [subParamDic setObject:reserve_record.reserve_content forKey:@"reserve_content"];
    [subParamDic setObject:reserve_record.medical_place forKey:@"medical_place"];
    [subParamDic setObject:reserve_record.medical_chair forKey:@"medical_chair"];
    [subParamDic setObject:reserve_record.doctor_id forKey:@"doctor_id"];
    
    [subParamDic setObject:reserve_record.tooth_position forKey:@"tooth_position"];
    [subParamDic setObject:reserve_record.clinic_reserve_id forKey:@"clinic_reserve_id"];
    [subParamDic setObject:reserve_record.duration forKey:@"duration"];
    
    [subParamDic setObject:reserve_record.therapy_doctor_id forKey:@"therapy_doctor_id"];
    [subParamDic setObject:reserve_record.therapy_doctor_name forKey:@"therapy_doctor_name"];
    [subParamDic setObject:reserve_record.reserve_status forKey:@"reserve_status"];
    [subParamDic setObject:reserve_record.case_id forKey:@"case_id"];
    
    NSString *jsonString = [subParamDic JSONString];
    
    params[@"table"] = [@"reserverecord" TripleDESIsEncrypt:YES];
    params[@"action"] = [@"add" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [jsonString TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:POST_COMMONURL parameters:[self addCommenParams:params] success:^(id responseObject) {
        CRMHttpRespondModel *model = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postAllNeedSyncRepair_doctor:(RepairDoctor *)repair_doctor success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
    
    [subParamDic setObject:repair_doctor.ckeyid forKey:@"ckeyid"];
    [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
    [subParamDic setObject:repair_doctor.doctor_name forKey:@"doctor_name"];
    [subParamDic setObject:repair_doctor.doctor_phone forKey:@"doctor_phone"];
    [subParamDic setObject:repair_doctor.creation_time forKey:@"creation_time"];
    [subParamDic setObject:repair_doctor.doctor_id forKey:@"doctor_id"];
    
    NSError *error;
    NSString *jsonString;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                                                       options: 0
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    }
    else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
    }
    params[@"table"] = [@"repairdoctor" TripleDESIsEncrypt:YES];
    params[@"action"] = [@"add" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [jsonString TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:POST_COMMONURL parameters:[self addCommenParams:params] success:^(id responseObject) {
        CRMHttpRespondModel *model = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postAllNeedSyncPatient_consultation:(PatientConsultation *)patient_consultation success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [subParamDic setObject:patient_consultation.ckeyid forKey:@"ckeyid"];
    [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
    [subParamDic setObject:patient_consultation.patient_id forKey:@"patient_id"];
    [subParamDic setObject:patient_consultation.doctor_id forKey:@"doctor_id"];
    [subParamDic setObject:patient_consultation.doctor_name forKey:@"doctor_name"];
    [subParamDic setObject:patient_consultation.amr_file forKey:@"amr_file"];
    [subParamDic setObject:patient_consultation.amr_time forKey:@"amr_time"];
    [subParamDic setObject:patient_consultation.cons_type forKey:@"cons_type"];
    [subParamDic setObject:patient_consultation.cons_content forKey:@"cons_content"];
    [subParamDic setObject:[NSString stringWithFormat:@"%ld",(long)patient_consultation.data_flag] forKey:@"data_flag"];
    
    NSError *error;
    NSString *jsonString;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subParamDic
                                                       options: 0
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    }
    else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
    }
    params[@"table"] = [@"patientconsultation" TripleDESIsEncrypt:YES];
    params[@"action"] = [@"add" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [jsonString TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:POST_COMMONURL parameters:[self addCommenParams:params] success:^(id responseObject) {
        CRMHttpRespondModel *model = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
