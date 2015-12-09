//
//  TTMPatientTool.m
//  ToothManager
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 roger. All rights reserved.
//

#import "TTMPatientTool.h"
#import "TTMMyHttpTool.h"
#import "TTMMedicalCaseModel.h"
#import "TTMCTLibModel.h"

@implementation TTMPatientTool

+ (void)requestPatientInfoWithpatientId:(NSString *)patientId success:(void(^)(TTMPatientModel *result))success failure:(void(^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@his.crm/ashx/PatientHandler.ashx",DomainName];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getpatientbyid";
    params[@"pid"] = patientId;
    
    [TTMMyHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        TTMPatientModel *model = [TTMPatientModel objectWithKeyValues:responseObject[@"Result"]];
        if (success) {
            success(model);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)requestMedicalCaseWithPatientId:(NSString *)patientId success:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@his.crm/ashx/SyncGet.ashx",DomainName];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"table"] = @"medicalcase";
    params[@"sync_time"] = @"1970-01-01 00:00:00";
    params[@"patient_id"] = patientId;
    
    [TTMMyHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        
        NSArray *array = responseObject[@"Result"];
        NSMutableArray *arrayM = [NSMutableArray array];
        if (array.count > 0) {
            for (NSDictionary *dic in array) {
                TTMMedicalCaseModel *model = [TTMMedicalCaseModel objectWithKeyValues:dic];
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

+ (void)requestCTLibWithCaseId:(NSString *)caseId success:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@his.crm/ashx/SyncGet.ashx",DomainName];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"table"] = @"ctlib";
    params[@"sync_time"] = @"1970-01-01 00:00:00";
    params[@"case_id"] = caseId;
    
    [TTMMyHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        
        NSArray *array = responseObject[@"Result"];
        NSMutableArray *arrayM = [NSMutableArray array];
        if (array.count > 0) {
            for (NSDictionary *dic in array) {
                TTMCTLibModel *model = [TTMCTLibModel objectWithKeyValues:dic];
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

@end
