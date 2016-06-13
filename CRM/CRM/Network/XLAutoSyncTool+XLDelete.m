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
#import "NSString+TTMAddtion.h"
//6214830124339606


@implementation XLAutoSyncTool (XLDelete)

- (void)deleteAllNeedSyncPatient:(Patient *)patient success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [subParamDic setObject:patient.ckeyid forKey:@"ckeyid"];
    [subParamDic setObject:patient.doctor_id forKey:@"doctor_id"];
    
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
    params[@"table"] = [@"patient" TripleDESIsEncrypt:YES];
    params[@"action"] = [@"delete" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [jsonString TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] logWithUrlStr:POST_COMMONURL params:[self addCommenParams:params]];
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

- (void)deleteAllNeedSyncMaterial:(Material *)material success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [subParamDic setObject:material.ckeyid forKey:@"ckeyid"];
    [subParamDic setObject:material.doctor_id forKey:@"doctor_id"];
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
    params[@"table"] = [@"material" TripleDESIsEncrypt:YES];
    params[@"action"] = [@"delete" TripleDESIsEncrypt:YES];
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

- (void)deleteAllNeedSyncIntroducer:(Introducer *)introducer success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:7];
    
    [subParamDic setObject:introducer.ckeyid forKey:@"ckeyid"];
    [subParamDic setObject:introducer.doctor_id forKey:@"doctor_id"];
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
    params[@"table"] = [@"introducer" TripleDESIsEncrypt:YES];
    params[@"action"] = [@"delete" TripleDESIsEncrypt:YES];
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

- (void)deleteAllNeedSyncMedical_case:(MedicalCase *)medical_case success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
    
    [subParamDic setObject:medical_case.ckeyid forKey:@"ckeyid"];
    [subParamDic setObject:medical_case.doctor_id forKey:@"doctor_id"];
    
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
    params[@"action"] = [@"delete" TripleDESIsEncrypt:YES];
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

- (void)deleteAllNeedSyncCt_lib:(CTLib *)ct_lib success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:7];
    
    [subParamDic setObject:ct_lib.ckeyid forKey:@"ckeyid"];
    [subParamDic setObject:ct_lib.doctor_id forKey:@"doctor_id"];
    
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
    params[@"action"] = [@"delete" TripleDESIsEncrypt:YES];
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
    params[@"table"] = [@"medicalexpense" TripleDESIsEncrypt:YES];
    params[@"action"] = [@"delete" TripleDESIsEncrypt:YES];
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

- (void)deleteAllNeedSyncMedical_record:(MedicalRecord *)medical_record success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
    [subParamDic setObject:medical_record.ckeyid forKey:@"ckeyid"];
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
    params[@"action"] = [@"delete" TripleDESIsEncrypt:YES];
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

- (void)deleteAllNeedSyncReserve_record:(LocalNotification *)reserve_record success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [subParamDic setObject:reserve_record.ckeyid forKey:@"ckeyid"];
    [subParamDic setObject:reserve_record.doctor_id forKey:@"doctor_id"];
    
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
    params[@"table"] = [@"reserverecord" TripleDESIsEncrypt:YES];
    params[@"action"] = [@"delete" TripleDESIsEncrypt:YES];
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
- (void)deleteAllNeedSyncRepair_doctor:(RepairDoctor *)repair_doctor success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [subParamDic setObject:repair_doctor.ckeyid forKey:@"ckeyid"];
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
    params[@"action"] = [@"delete" TripleDESIsEncrypt:YES];
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

- (void)deleteAllNeedSyncPatient_consultation:(PatientConsultation *)patient_consultation success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [subParamDic setObject:patient_consultation.ckeyid forKey:@"ckeyid"];
    //删除会诊信息时，不管是否是自己创建的，都要进行删除，所以传当前登录人的id
    [subParamDic setObject:[AccountManager currentUserid] forKey:@"doctor_id"];
    
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
    params[@"action"] = [@"delete" TripleDESIsEncrypt:YES];
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
