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

@implementation DoctorGroupTool

+ (void)getPatientsWithDoctorId:(NSString *)doctorId success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/SyncGet.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"table"] = @"Patient";
    params[@"sync_time"] = @"1970-01-01 00:00:00";
    params[@"doctor_id"] = doctorId;
    
    [CRMHttpTool GET:urlStr parameters:params success:^(id responseObject) {

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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/SyncGet.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"table"] = @"Introducer";
    params[@"sync_time"] = @"1970-01-01 00:00:00";
    params[@"doctor_id"] = doctorId;
    
    [CRMHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        
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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/SyncGet.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"table"] = @"medicalexpense";
    params[@"sync_time"] = @"1970-01-01 00:00:00";
    params[@"patient_id"] = patientIdStr;
    
    [CRMHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        
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

+ (void)getGroupListWithDoctorId:(NSString *)doctorId ckId:(NSString *)ckId success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/GroupsHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"GroupListByDoctorId";
    params[@"doctor_id"] = doctorId;
//    params[@"ckeyid"] = ckId;
    
    [CRMHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        
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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/GroupsHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"add";
    params[@"DataEntity"] = [dataEntity.keyValues JSONString];
    
    [CRMHttpTool POST:urlStr parameters:params success:^(id responseObject) {
        
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/GroupsHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"edit";
    params[@"DataEntity"] = [dataEntity.keyValues JSONString];
    
    [CRMHttpTool POST:urlStr parameters:params success:^(id responseObject) {
        
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/GroupsHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"delete";
    params[@"ckeyid"] = ckId;
    
    [CRMHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        
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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/GroupPatientMapHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"GroupListByCkeyId";
    params[@"ckeyid"] = ckId;
    
    [CRMHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/GroupPatientMapHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"GroupListByDoctorIdAndPatientId";
    params[@"doctor_id"] = doctorId;
    params[@"patient_id"] = patientId;
    
    [CRMHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        
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

+ (void)addGroupMemberWithGroupMemberEntity:(GroupMemberEntity *)dataEntity success:(void (^)(CRMHttpRespondModel *respondModel))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/GroupPatientMapHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"add";
    params[@"DataEntity"] = [dataEntity.keyValues JSONString];
    
    [CRMHttpTool POST:urlStr parameters:params success:^(id responseObject) {
        
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

+ (void)deleteGroupMemberWithCkId:(NSString *)ckId success:(void (^)(CRMHttpRespondModel *respondModel))success failure:(void (^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/GroupPatientMapHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"delete";
    params[@"ckeyid"] = ckId;
    
    [CRMHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        
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
