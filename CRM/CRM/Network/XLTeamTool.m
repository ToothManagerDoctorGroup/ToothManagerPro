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
#import "XLTeamPatientModel.h"
#import "XLJoinTeamModel.h"
#import "XLCureCountModel.h"
#import "NSString+TTMAddtion.h"

@implementation XLTeamTool

+ (void)addMedicalCaseWithMCase:(MedicalCase *)mCase success:(void (^)(MedicalCase *resultCase))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/SyncPost.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
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
    params[@"table"] = [@"medicalcase" TripleDESIsEncrypt:YES];
    params[@"action"] = [@"add" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [jsonString TripleDESIsEncrypt:YES];
    
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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/MedicalCaseHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"listcasebypatientid" TripleDESIsEncrypt:YES];
    params[@"patient_id"] = [patient_id TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)queryMedicalCasesDetailWithPatientId:(NSString *)patient_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/MedicalCaseHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"listcaseallinfobypatientid" TripleDESIsEncrypt:YES];
    params[@"patient_id"] = [patient_id TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)addTeamMemberWithParam:(XLTeamMemberParam *)param success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/CureTeamHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"add" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [[param.keyValues JSONString] TripleDESIsEncrypt:YES];
    
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/CureTeamHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"batchadd" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [[array JSONString] TripleDESIsEncrypt:YES];
    
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/CureTeamHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"delete" TripleDESIsEncrypt:YES];
    params[@"KeyId"] = [[member_id stringValue] TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
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

+ (void)removeTeamMemberWithIds:(NSString *)ids success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/CureTeamHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"batchdelete" TripleDESIsEncrypt:YES];
    params[@"KeyIds"] = [ids TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
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


+ (void)queryMedicalCaseMembersWithCaseId:(NSString *)case_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/CureTeamHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"listmemberbycaseid" TripleDESIsEncrypt:YES];
    params[@"case_id"] = [case_id TripleDESIsEncrypt:YES];
    
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/CureProjectHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"add" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [[param.keyValues JSONString] TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/CureProjectHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"delete" TripleDESIsEncrypt:YES];
    params[@"KeyId"] = [keyId TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/CureProjectHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"edit" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [[model.keyValues JSONString] TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/CureProjectHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"listitembycaseid" TripleDESIsEncrypt:YES];
    params[@"case_id"] = [case_id TripleDESIsEncrypt:YES];
    
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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/MedicalCourseHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"listcoursebycaseid" TripleDESIsEncrypt:YES];
    params[@"case_id"] = [case_id TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        if (success) {
            success(responseObject[@"Result"]);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
//-------------------------耗材相关----------------------------------
+ (void)queryAllExpensesWithCaseId:(NSString *)case_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/MedicalExpenseHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"listexpensebycaseid" TripleDESIsEncrypt:YES];
    params[@"case_id"] = [case_id TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"Result"]) {
            MedicalExpense *expense = [MedicalExpense MEFromMEResult:dic];
            expense.mat_name = dic[@"mat_name"];
            [arrayM addObject:expense];
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

//-------------------------医生好友相关----------------------------------

+ (void)queryTransferPatientsWithDoctorId:(NSString *)doctor_id intrId:(NSString *)intr_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/PatientIntroducerMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"listtransferpatient" TripleDESIsEncrypt:YES];
    params[@"intr_id"] = [intr_id TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctor_id TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"Result"]) {
            XLTeamPatientModel *model = [XLTeamPatientModel objectWithKeyValues:dic];
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

+ (void)queryJoinTreatePatientsWithDoctorId:(NSString *)doctor_id theraptDocId:(NSString *)therapt_doctor_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/CureProjectHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"listpateint" TripleDESIsEncrypt:YES];
    params[@"Therapt_ doctor_id"] = [therapt_doctor_id TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctor_id TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"Result"]) {
            XLTeamPatientModel *model = [XLTeamPatientModel objectWithKeyValues:dic];
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

+ (void)queryAllCountOfPatientWithDoctorId:(NSString *)doctor_id theraptDocId:(NSString *)therapt_doctor_id success:(void (^)(XLCureCountModel *model))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/PatientHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"patientByDoctorIdAndIntroId" TripleDESIsEncrypt:YES];
    params[@"therapt_doctor_id"] = [therapt_doctor_id TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctor_id TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        XLCureCountModel *model = [XLCureCountModel objectWithKeyValues:responseObject[@"Result"]];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//----------------------------团队协作相关----------------------------------
+ (void)queryJoinConsultationPatientsWithDoctorId:(NSString *)doctor_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/CureTeamHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"listpartpatient" TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctor_id TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
            NSMutableArray *arrayM = [NSMutableArray array];
            for (NSDictionary *dic in responseObject[@"Result"]) {
                XLJoinTeamModel *model = [XLJoinTeamModel objectWithKeyValues:dic];
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

+ (void)queryJoinOtherCurePatientsWithDoctorId:(NSString *)doctor_id status:(NSNumber *)status success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/CureTeamHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"listcurepatient" TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctor_id TripleDESIsEncrypt:YES];
    params[@"status"] = [[status stringValue] TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
            NSMutableArray *arrayM = [NSMutableArray array];
            for (NSDictionary *dic in responseObject[@"Result"]) {
                XLJoinTeamModel *model = [XLJoinTeamModel objectWithKeyValues:dic];
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

@end
