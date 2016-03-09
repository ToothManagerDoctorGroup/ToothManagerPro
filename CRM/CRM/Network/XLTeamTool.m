//
//  XLTeamTool.m
//  CRM
//
//  Created by Argo Zhang on 16/3/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLTeamTool.h"
#import "CRMHttpTool.h"
#import "MJExtension.h"
#import "JSONKit.h"
#import "XLTeamMemberParam.h"
#import "CRMHttpRespondModel.h"
#import "XLTeamMemberModel.h"
#import "DBManager+Patients.h"
#import "MyDateTool.h"
#import "XLCureProjectModel.h"
#import "XLCureProjectParam.h"

@implementation XLTeamTool

+ (void)addMedicalCaseWithMCase:(MedicalCase *)mCase success:(void (^)(MedicalCase *resultCase))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/SyncPost.ashx?table=medicalcase&action=add",DomainName,Method_His_Crm];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:11];
    
    [subParamDic setObject:mCase.ckeyid forKey:@"ckeyid"];
    [subParamDic setObject:[MyDateTool stringWithDateWithSec:[NSDate date]] forKey:@"sync_time"];
    [subParamDic setObject:mCase.patient_id forKey:@"patient_id"];
    [subParamDic setObject:mCase.case_name forKey:@"case_name"];
    [subParamDic setObject:mCase.creation_date forKey:@"createdate"];
    if (nil == mCase.implant_time ||[mCase.implant_time isEqualToString:@"0"]) {
        [subParamDic setObject:@"" forKey:@"implant_time"];
    } else {
        [subParamDic setObject:mCase.implant_time forKey:@"implant_time"];
    }
    
    if ([mCase.next_reserve_time isEqualToString:@"0"]) {
        [subParamDic setObject:@"" forKey:@"next_reserve_time"];
    } else {
        [subParamDic setObject:mCase.next_reserve_time forKey:@"next_reserve_time"];
    }
    
    if ([mCase.repair_time isEqualToString:@"0"]) {
        [subParamDic setObject:@"" forKey:@"repair_time"];
    } else {
        [subParamDic setObject:mCase.repair_time forKey:@"repair_time"];
    }
    
    [subParamDic setObject:[NSString stringWithFormat: @"%ld", (long)mCase.case_status] forKey:@"status"];
    [subParamDic setObject:mCase.repair_doctor forKey:@"repair_doctor"];
    [subParamDic setObject:mCase.doctor_id forKey:@"doctor_id"];
    
    NSString *jsonString = [subParamDic JSONString];
    
    [params setObject:jsonString forKey:@"DataEntity"];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
        MedicalCase *mcase = [MedicalCase MedicalCaseFromPatientMedicalCase:responseObject[@"Result"]];
        if (success) {
            success(mcase);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)queryMedicalCasesWithPatientId:(NSString *)patient_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/MedicalCaseHandler.ashx",DomainName,Method_His_Crm];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"listcasebypatientid";
    params[@"patient_id"] = patient_id;
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)queryMedicalCasesDetailWithPatientId:(NSString *)patient_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/MedicalCaseHandler.ashx",DomainName,Method_His_Crm];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"listcaseallinfobypatientid";
    params[@"patient_id"] = patient_id;
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)addTeamMemberWithParam:(XLTeamMemberParam *)param success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/CureTeamHandler.ashx",DomainName,Method_His_Crm];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"add";
    params[@"DataEntity"] = [param.keyValues JSONString];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
        CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(respond);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)addTeamMemberWithArray:(NSArray *)array success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/CureTeamHandler.ashx",DomainName,Method_His_Crm];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"batchadd";
    params[@"DataEntity"] = [array JSONString];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
        CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(respond);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)removeTeamMemberWithMemberId:(NSNumber *)member_id success:(void (^)    (CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/CureTeamHandler.ashx",DomainName,Method_His_Crm];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"delete";
    params[@"KeyId"] = member_id;
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
        
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)queryMedicalCaseMembersWithCaseId:(NSString *)case_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/CureTeamHandler.ashx",DomainName,Method_His_Crm];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"listmemberbycaseid";
    params[@"case_id"] = case_id;
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"Result"]) {
            XLTeamMemberModel *model = [XLTeamMemberModel objectWithKeyValues:dic];
            [arrayM addObject:model];
        }
        if (success) {
            success(arrayM);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//-------------------------治疗方案相关----------------------------------
+ (void)addNewCureProWithParam:(XLCureProjectParam *)param success:(void (^)( XLCureProjectModel *model))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/CureProjectHandler.ashx",DomainName,Method_His_Crm];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"add";
    params[@"DataEntity"] = [param.keyValues JSONString];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        XLCureProjectModel *modelTmp = [XLCureProjectModel objectWithKeyValues:responseObject[@"Result"]];
        if (success) {
            success(modelTmp);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)deleteCureProWithKeyId:(NSString *)keyId success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/CureProjectHandler.ashx",DomainName,Method_His_Crm];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"delete";
    params[@"KeyId"] = keyId;
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        CRMHttpRespondModel *respondTmp = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(respondTmp);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
+ (void)editNewCureProWithModel:(XLCureProjectModel *)model success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))  failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/CureProjectHandler.ashx",DomainName,Method_His_Crm];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"edit";
    params[@"DataEntity"] = [model.keyValues JSONString];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        CRMHttpRespondModel *respondTmp = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(respondTmp);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)queryCureProsWithCaseId:(NSString *)case_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/CureProjectHandler.ashx",DomainName,Method_His_Crm];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"listitembycaseid";
    params[@"case_id"] = case_id;
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        NSMutableArray *arrayM = [NSMutableArray array];
        NSArray *array = responseObject[@"Result"];
        for (NSDictionary *dic in array) {
            XLCureProjectModel *model = [XLCureProjectModel objectWithKeyValues:dic];
            [arrayM addObject:model];
        }
    
        if (success) {
            success(arrayM);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//-------------------------病程记录相关----------------------------------
+ (void)queryAllDiseaseRecordWithCaseId:(NSString *)case_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/MedicalCourseHandler.ashx",DomainName,Method_His_Crm];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"listcoursebycaseid";
    params[@"case_id"] = case_id;
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end