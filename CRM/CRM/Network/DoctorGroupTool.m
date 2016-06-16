//
//  DoctorGroupTool.m
//  CRM
//
//  Created by Argo Zhang on 15/12/9.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "DoctorGroupTool.h"
#import "CRMHttpTool.h"
#import "DoctorGroupModel.h"
#import "JSONKit.h"
#import "GroupMemberModel.h"
#import "GroupDetailModel.h"
#import "GroupPatientModel.h"
#import "GroupIntroducerModel.h"
#import "NSString+TTMAddtion.h"

@implementation GroupAndPatientParam


@end

@implementation DoctorGroupTool

+ (void)getGroupPatientsWithDoctorId:(NSString *)doctorId success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/PatientHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"listpatientbydoctorid" TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctorId TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        NSMutableArray *arrayM = [NSMutableArray array];
        if ([responseObject[@"Code"] intValue] == 200) {
            for (NSDictionary *dic in responseObject[@"Result"]) {
                GroupMemberModel *model = [GroupMemberModel objectWithKeyValues:dic];
                [arrayM addObject:model];
            }
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

+ (void)getGroupPatientsWithDoctorId:(NSString *)doctorId groupId:(NSString *)groupId queryModel:(XLQueryModel *)queryModel success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    //htp://118.244.234.207/his.crm/ashx/GroupPatientMapHandler.ashx?action=CanAddMemberByPage&group_id=971_20160113212334&doctor_id=971&query_info={"KeyWord":"","SortField":"姓名","IsAsc":true,"PageIndex":1,"PageSize":5}
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/GroupPatientMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"CanAddMemberByPage" TripleDESIsEncrypt:YES];
    params[@"group_id"] = [groupId TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctorId TripleDESIsEncrypt:YES];
    params[@"query_info"] = [[queryModel.keyValues JSONString] TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        NSMutableArray *arrayM = [NSMutableArray array];
        if ([responseObject[@"Code"] intValue] == 200) {
            for (NSDictionary *dic in responseObject[@"Result"]) {
                GroupMemberModel *model = [GroupMemberModel objectWithKeyValues:dic];
                [arrayM addObject:model];
            }
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


+ (void)getPatientsWithDoctorId:(NSString *)doctorId success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/SyncGet.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"table"] = [@"patient" TripleDESIsEncrypt:YES];
    params[@"sync_time"] = [@"1970-01-01 00:00:00" TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctorId TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {

        NSMutableArray *arrayM = [NSMutableArray array];
        if ([responseObject[@"Code"] intValue] == 200) {
            for (NSDictionary *dic in responseObject[@"Result"]) {
                GroupPatientModel *model = [[GroupPatientModel alloc] initWithDic:dic];
                [arrayM addObject:model];
            }
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

+ (void)getIntroducersWithDoctorId:(NSString *)doctorId success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/SyncGet.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"table"] = [@"Introducer" TripleDESIsEncrypt:YES];
    params[@"sync_time"] = [@"1970-01-01 00:00:00" TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctorId TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        NSMutableArray *arrayM = [NSMutableArray array];
        if ([responseObject[@"Code"] intValue] == 200) {
            for (NSDictionary *dic in responseObject[@"Result"]) {
                GroupIntroducerModel *model = [GroupIntroducerModel objectWithKeyValues:dic];
                [arrayM addObject:model];
            }
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

+ (void)getMedicalExpensesWithPatientIdStr:(NSString *)patientIdStr success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/SyncGet.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"table"] = [@"medicalexpense" TripleDESIsEncrypt:YES];
    params[@"sync_time"] = [@"1970-01-01 00:00:00" TripleDESIsEncrypt:YES];
    params[@"patient_id"] = [patientIdStr TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
//        NSMutableArray *arrayM = [NSMutableArray array];
//        if ([responseObject[@"Code"] intValue] == 200) {
//            for (NSDictionary *dic in responseObject[@"Result"]) {
//                GroupIntroducerModel *model = [GroupIntroducerModel objectWithKeyValues:dic];
//                [arrayM addObject:model];
//            }
//        }
//        if (success) {
//            success(arrayM);
//        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getGroupListWithDoctorId:(NSString *)doctorId ckId:(NSString *)ckId patientId:(NSString *)patient_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/GroupsHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"GroupListByDoctorId" TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctorId TripleDESIsEncrypt:YES];
    params[@"patient_id"] = [patient_id TripleDESIsEncrypt:YES];
    params[@"ckeyid"] = [ckId TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        NSMutableArray *arrayM = [NSMutableArray array];
        if ([responseObject[@"Code"] intValue] == 200) {
            for (NSDictionary *dic in responseObject[@"Result"]) {
                DoctorGroupModel *model = [DoctorGroupModel objectWithKeyValues:dic];
                [arrayM addObject:model];
            }
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

+ (void)addNewGroupWithGroupEntity:(GroupEntity *)dataEntity success:(void (^)(CRMHttpRespondModel *respondModel))success failure:(void (^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/GroupsHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"add" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [[dataEntity.keyValues JSONString] TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
        
        CRMHttpRespondModel *respondModel = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(respondModel);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

+ (void)updateGroupWithGroupEntity:(GroupEntity *)dataEntity success:(void (^)(CRMHttpRespondModel *respondModel))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/GroupsHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"edit" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [[dataEntity.keyValues JSONString] TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
        
        CRMHttpRespondModel *respondModel = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(respondModel);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)deleteGroupWithCkId:(NSString *)ckId success:(void (^)(CRMHttpRespondModel *respondModel))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/GroupsHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"delete" TripleDESIsEncrypt:YES];
    params[@"ckeyid"] = [ckId TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        CRMHttpRespondModel *respondModel = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(respondModel);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)queryGroupMembersWithCkId:(NSString *)ckId success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/GroupPatientMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"GroupListByCkeyId" TripleDESIsEncrypt:YES];
    params[@"ckeyid"] = [ckId TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        NSMutableArray *arrayM = [NSMutableArray array];
        if ([responseObject[@"Code"] intValue] == 200) {
            for (NSDictionary *dic in responseObject[@"Result"]) {
                GroupMemberModel *model = [GroupMemberModel objectWithKeyValues:dic];
                [arrayM addObject:model];
            }
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

+ (void)queryGroupMembersWithCkId:(NSString *)ckId queryModel:(XLQueryModel *)queryModel success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/GroupPatientMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"PatientPageListByGroupId" TripleDESIsEncrypt:YES];
    params[@"ckeyid"] = [ckId TripleDESIsEncrypt:YES];
    params[@"query_info"] = [[queryModel.keyValues JSONString] TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        NSMutableArray *arrayM = [NSMutableArray array];
        if ([responseObject[@"Code"] intValue] == 200) {
            for (NSDictionary *dic in responseObject[@"Result"]) {
                GroupMemberModel *model = [GroupMemberModel objectWithKeyValues:dic];
                [arrayM addObject:model];
            }
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

+ (void)queryGroupDetailsWithDoctorId:(NSString *)doctorId patientId:(NSString *)patientId success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/GroupPatientMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"GroupListByDoctorIdAndPatientId" TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctorId TripleDESIsEncrypt:YES];
    params[@"patient_id"] = [patientId TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        NSMutableArray *arrayM = [NSMutableArray array];
        if ([responseObject[@"Code"] intValue] == 200) {
            for (NSDictionary *dic in responseObject[@"Result"]) {
                GroupDetailModel *model = [GroupDetailModel objectWithKeyValues:dic];
                [arrayM addObject:model];
            }
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

+ (void)addGroupMemberWithGroupMemberEntity:(NSArray *)dataEntitys success:(void (^)(CRMHttpRespondModel *respondModel))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/GroupPatientMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"add" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [[dataEntitys JSONString] TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
        
        CRMHttpRespondModel *respondModel = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(respondModel);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)addPateintToGroupsWithGroupMemberEntity:(NSString *)jsonData success:(void (^)(CRMHttpRespondModel *respondModel))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/GroupPatientMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"add" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [jsonData TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
        
        CRMHttpRespondModel *respondModel = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(respondModel);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)deleteGroupMemberWithCkId:(NSString *)ckId groupId:(NSString *)groupid success:(void (^)(CRMHttpRespondModel *respondModel))success failure:(void (^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/GroupPatientMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"newdelete" TripleDESIsEncrypt:YES];
    params[@"ckeyid"] = [ckId TripleDESIsEncrypt:YES];
    params[@"groupid"] = [groupid TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        CRMHttpRespondModel *respondModel = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(respondModel);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)deleteGroupMemberWithModel:(GroupAndPatientParam *)param success:(void (^)(CRMHttpRespondModel *respondModel))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/GroupPatientMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"newdelete" TripleDESIsEncrypt:YES];
    params[@"ckeyid"] = [param.patientIds TripleDESIsEncrypt:YES];
    params[@"groupid"] = [param.groupIds TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        CRMHttpRespondModel *respondModel = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(respondModel);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
