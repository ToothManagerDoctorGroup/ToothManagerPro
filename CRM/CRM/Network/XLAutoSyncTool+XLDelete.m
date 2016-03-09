//
//  XLAutoSyncTool+XLDelete.m
//  CRM
//
//  Created by Argo Zhang on 15/12/28.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLAutoSyncTool+XLDelete.h"
#import "CRMHttpTool.h"
#import "AccountManager.h"
#import "CRMUserDefalut.h"
#import "PatientManager.h"
#import "NSJSONSerialization+jsonString.h"
#import "JSONKit.h"
//patient表
#define POST_PATIENT_DELETE ([NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=patient&action=delete",DomainName,Method_His_Crm])
//material表
#define POST_MATERIAL_DELETE ([NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=material&action=delete",DomainName,Method_His_Crm])
//introducer表
#define POST_INTRODUCER_DELETE ([NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=introducer&action=delete",DomainName,Method_His_Crm])
//medical_case表
#define POST_MEDICALCASE_DELETE ([NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=medicalcase&action=delete",DomainName,Method_His_Crm])
//ctLib表
#define POST_CTLIB_DELETE ([NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=ctlib&action=delete",DomainName,Method_His_Crm])
//medical_expense表
#define POST_MEDICAL_EXPENSE_DELETE ([NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=medicalexpense&action=delete",DomainName,Method_His_Crm])
//medical_record表
#define POST_MEDICAL_RECORD_DELETE ([NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=medicalrecord&action=delete",DomainName,Method_His_Crm])
//reserve_record表(LocalNotification表)
#define POST_RESERVE_RECORD_DELETE ([NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=reserverecord&action=delete",DomainName,Method_His_Crm])
//repairDoctor表
#define POST_REPAIRDOCTOR_DELETE ([NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=repairdoctor&action=delete",DomainName,Method_His_Crm])
//patient_consultation表
#define POST_PATIENT_CONSULTATION_DELETE ([NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=patientconsultation&action=delete",DomainName,Method_His_Crm])
@implementation XLAutoSyncTool (XLDelete)

- (void)deleteAllNeedSyncPatient:(Patient *)patient success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [subParamDic setObject:patient.ckeyid forKey:@"ckeyid"];
    
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
    
    [params setObject:jsonString forKey:@"DataEntity"];
    
    [[CRMHttpTool shareInstance] POST:POST_PATIENT_DELETE parameters:[self addCommenParams:params] success:^(id responseObject) {
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

- (void)deleteAllNeedSyncMaterial:(Material *)material success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [subParamDic setObject:material.ckeyid forKey:@"ckeyid"];
#if 0
    [subParamDic setObject:material.sync_time forKey:@"sync_time"];
    [subParamDic setObject:material.mat_name forKey:@"mat_name"];
    [subParamDic setObject:[NSString stringWithFormat: @"%.2f", material.mat_price] forKey:@"mat_price"];
    [subParamDic setObject:[Material typeStringWith:material.mat_type] forKey:@"mat_type"];
    [subParamDic setObject:material.doctor_id forKey:@"doctor_id"];
#endif
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
    
    [params setObject:jsonString forKey:@"DataEntity"];
    
    [[CRMHttpTool shareInstance] POST:POST_MATERIAL_DELETE parameters:[self addCommenParams:params] success:^(id responseObject) {
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

- (void)deleteAllNeedSyncIntroducer:(Introducer *)introducer success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:7];
    
    [subParamDic setObject:introducer.ckeyid forKey:@"ckeyid"];
#if 0
    [subParamDic setObject:introducer.sync_time forKey:@"sync_time"];
    [subParamDic setObject:introducer.intr_name forKey:@"intr_name"];
    [subParamDic setObject:introducer.intr_phone forKey:@"intr_phone"];
    [subParamDic setObject:[NSString stringWithFormat: @"%d", intr.intr_level] forKey:@"intr_level"];
    [subParamDic setObject:introducer.creation_date forKey:@"creation_time"];
    [subParamDic setObject:introducer.doctor_id forKey:@"doctor_id"];
#endif
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
    
    [params setObject:jsonString forKey:@"DataEntity"];
    
    [[CRMHttpTool shareInstance] POST:POST_INTRODUCER_DELETE parameters:[self addCommenParams:params] success:^(id responseObject) {
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

- (void)deleteAllNeedSyncMedical_case:(MedicalCase *)medical_case success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
    
    [subParamDic setObject:medical_case.ckeyid forKey:@"ckeyid"];
    
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
    [params setObject:jsonString forKey:@"DataEntity"];
    
    [[CRMHttpTool shareInstance] POST:POST_MEDICALCASE_DELETE parameters:[self addCommenParams:params] success:^(id responseObject) {
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

- (void)deleteAllNeedSyncCt_lib:(CTLib *)ct_lib success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:7];
    
    [subParamDic setObject:ct_lib.ckeyid forKey:@"ckeyid"];
    
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
    
    [params setObject:jsonString forKey:@"DataEntity"];
    
    [[CRMHttpTool shareInstance] POST:POST_CTLIB_DELETE parameters:[self addCommenParams:params] success:^(id responseObject) {
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

- (void)deleteAllNeedSyncMedical_expense:(MedicalExpense *)medical_expense success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
    [subParamDic setObject:medical_expense.ckeyid forKey:@"ckeyid"];
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
    
    [params setObject:jsonString forKey:@"DataEntity"];
    
    [[CRMHttpTool shareInstance] POST:POST_MEDICAL_EXPENSE_DELETE parameters:[self addCommenParams:params] success:^(id responseObject) {
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

- (void)deleteAllNeedSyncMedical_record:(MedicalRecord *)medical_record success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
    [subParamDic setObject:medical_record.ckeyid forKey:@"ckeyid"];
    
    
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
    
    [params setObject:jsonString forKey:@"DataEntity"];
    
    [[CRMHttpTool shareInstance] POST:POST_MEDICAL_RECORD_DELETE parameters:[self addCommenParams:params] success:^(id responseObject) {
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

- (void)deleteAllNeedSyncReserve_record:(LocalNotification *)reserve_record success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [subParamDic setObject:reserve_record.ckeyid forKey:@"ckeyid"];
    
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
    
    [params setObject:jsonString forKey:@"DataEntity"];
    
    [[CRMHttpTool shareInstance] POST:POST_RESERVE_RECORD_DELETE parameters:[self addCommenParams:params] success:^(id responseObject) {
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
- (void)deleteAllNeedSyncRepair_doctor:(RepairDoctor *)repair_doctor success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [subParamDic setObject:repair_doctor.ckeyid forKey:@"ckeyid"];
    
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
    
    [params setObject:jsonString forKey:@"DataEntity"];
    
    [[CRMHttpTool shareInstance] POST:POST_REPAIRDOCTOR_DELETE parameters:[self addCommenParams:params] success:^(id responseObject) {
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

- (void)deleteAllNeedSyncPatient_consultation:(PatientConsultation *)patient_consultation success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [subParamDic setObject:patient_consultation.ckeyid forKey:@"ckeyid"];
    
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
    
    [params setObject:jsonString forKey:@"DataEntity"];
    
    [[CRMHttpTool shareInstance] POST:POST_PATIENT_CONSULTATION_DELETE parameters:[self addCommenParams:params] success:^(id responseObject) {
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
