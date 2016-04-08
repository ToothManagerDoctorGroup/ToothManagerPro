//
//  MyClinicTool.m
//  CRM
//
//  Created by Argo Zhang on 15/11/11.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "MyClinicTool.h"
#import "CRMHttpTool.h"
#import "ClinicModel.h"
#import "UnSignClinicModel.h"
#import "AssistCountModel.h"
#import "ClinicDetailModel.h"
#import "MaterialCountModel.h"
#import "NSString+TTMAddtion.h"

#define requestActionParam @"action"
#define doctorIdParam @"doctor_id"
#define clinicNameParam @"clinic_name"
#define clinicIdParam @"clinicid"
#define accessTokenParam @"AccessToken"
#define areacodeParam @"areacode"

#define clinic_idParam @"clinic_id"
#define mat_typeParam @"mat_type"



@implementation MyClinicTool

+ (void)requestClinicInfoWithDoctorId:(NSString *)doctocId success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{

//    NSString *urlStr = @"http://122.114.62.57/his.crm/ashx/ClinicMessage.ashx";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/ClinicMessage.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = [@"getClinic" TripleDESIsEncrypt:YES];
    params[doctorIdParam] = [doctocId TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        //将数据转换成模型对象，试用MJExtention
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"Result"]) {
            ClinicModel *clinic = [ClinicModel objectWithKeyValues:dic];
            [array addObject:clinic];
        }
        
        if (success) {
            success(array);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)searchClinicInfoWithDoctorId:(NSString *)doctorId clinicName:(NSString *)clinicName success:(void(^)(NSArray *clinics))success failure:(void(^)(NSError *error))failure{
//    NSString *urlStr = @"http://122.114.62.57/his.crm/ashx/ClinicMessage.ashx";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/ClinicMessage.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = [@"searchClinic" TripleDESIsEncrypt:YES];
    params[doctorIdParam] = [doctorId TripleDESIsEncrypt:YES];
    params[clinicNameParam] = [clinicName TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        //将数据转换成模型对象，使用MJExtention
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"Result"]) {
            ClinicModel *clinic = [ClinicModel objectWithKeyValues:dic];
            [array addObject:clinic];
        }
        
        if (success) {
            success(array);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)requestClinicDetailWithClinicId:(NSString *)clinicId accessToken:(NSString *)accessToken success:(void (^)(ClinicDetailModel *result))success failure:(void (^)(NSError *error))failure{
//    NSString *urlStr = @"http://122.114.62.57/clinicServer/ashx/ClinicHandler.ashx";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/ClinicHandler.ashx",DomainName,Method_ClinicServer,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = [@"getalldetail" TripleDESIsEncrypt:YES];
    params[clinicIdParam] = [clinicId TripleDESIsEncrypt:YES];
    params[accessTokenParam] = [accessToken TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        //将数据转换成模型对象，试用MJExtention
        ClinicDetailModel *model = [ClinicDetailModel objectWithKeyValues:responseObject[@"Result"]];
        
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}


+ (void)requestClinicInfoWithAreacode:(NSString *)areacode success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
//    NSString *urlStr = @"http://122.114.62.57/clinicServer/ashx/ClinicHandler.ashx";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/ClinicHandler.ashx",DomainName,Method_ClinicServer,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = [@"getList" TripleDESIsEncrypt:YES];
    params[areacodeParam] = [areacode TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        //将数据转换成模型对象，使用MJExtention
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"Result"]) {
            UnSignClinicModel *model = [UnSignClinicModel objectWithKeyValues:dic];
            [array addObject:model];
        }
        if (success) {
            success(array);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)requestClinicInfoWithAreacode:(NSString *)areacode clinicName:(NSString *)clinicName success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
//    NSString *urlStr = @"http://122.114.62.57/clinicServer/ashx/ClinicHandler.ashx";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/ClinicHandler.ashx",DomainName,Method_ClinicServer,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = [@"getListByNameAndArea" TripleDESIsEncrypt:YES];
    params[@"clinicname"] = [clinicName TripleDESIsEncrypt:YES];
    params[@"clinicarea"] = [areacode TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        //将数据转换成模型对象，使用MJExtention
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"Result"]) {
            UnSignClinicModel *model = [UnSignClinicModel objectWithKeyValues:dic];
            [array addObject:model];
        }
        if (success) {
            success(array);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)applyForClinicWithDoctorID:(NSString *)doctorId clinicId:(NSString *)clinicId success:(void (^)(NSString *result,NSNumber *status))success failure:(void (^)(NSError *error))failure{
//    NSString *urlStr = @"http://122.114.62.57/his.crm/ashx/ClinicMessage.ashx";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/ClinicMessage.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = [@"sign" TripleDESIsEncrypt:YES];
    params[doctorIdParam] = [doctorId TripleDESIsEncrypt:YES];
    params[clinic_idParam] = [clinicId TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        if (success) {
            success(responseObject[@"Result"],responseObject[@"Code"]);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getAssistentListWithClinicId:(NSString *)clinicId success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
//    NSString *urlStr = @"http://122.114.62.57/clinicServer/ashx/AssistantHandler.ashx";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/AssistantHandler.ashx",DomainName,Method_ClinicServer,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = [@"getList" TripleDESIsEncrypt:YES];
    params[clinicIdParam] = [clinicId TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        //将数据转换成模型对象，使用MJExtention
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"Result"]) {
            AssistCountModel *model = [AssistCountModel objectWithKeyValues:dic];
            model.num = 0.0;
            [array addObject:model];
        }
        if (success) {
            success(array);
        }
        
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getMaterialListWithClinicId:(NSString *)clinicId matType:(NSString *)type success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
//    NSString *urlStr = @"http://122.114.62.57/clinicServer/ashx/MaterialHandler.ashx";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/MaterialHandler.ashx",DomainName,Method_ClinicServer,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = [@"getList" TripleDESIsEncrypt:YES];
    params[clinicIdParam] = [clinicId TripleDESIsEncrypt:YES];
    params[mat_typeParam] = [type TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        //将数据转换成模型对象，使用MJExtention
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"Result"]) {
            MaterialCountModel *model = [MaterialCountModel objectWithKeyValues:dic];
            model.num = 0.0;
            [array addObject:model];
        }
        if (success) {
            success(array);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
