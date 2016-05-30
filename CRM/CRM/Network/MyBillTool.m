//
//  MyBillTool.m
//  CRM
//
//  Created by Argo Zhang on 15/11/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "MyBillTool.h"
#import "CRMHttpTool.h"
#import "BillModel.h"
#import "BillDetailModel.h"
#import "PayParam.h"
#import "CRMHttpRespondModel.h"
#import "NSString+TTMAddtion.h"
#import "CRMUnEncryptedHttpTool.h"

#define requestActionParam @"action"
#define doctorIdParam @"doctor_id"
#define clinicNameParam @"clinic_name"
#define clinicIdParam @"clinicid"
#define accessTokenParam @"AccessToken"
#define areacodeParam @"areacode"
#define typeParam @"get_type"
#define billIdParam @"bill_id"
#define keyIdParam @"Keyid"
#define dataEntityParam @"DataEntity"

@implementation MyBillTool

+ (void)requestBillsWithDoctorId:(NSString *)doctocId type:(NSString *)type success:(void(^)(NSArray *bills))success failure:(void(^)(NSError *error))failure{
    
//    NSString *urlStr = @"http://122.114.62.57/his.crm/ashx/ClinicMessage.ashx";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/ClinicMessage.ashx",DomainName,Method_His_Crm,@"ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = @"getBill";
    params[doctorIdParam] = doctocId;
    params[typeParam] = type;
    
    NSLog(@"%@",params);
    
    [[CRMUnEncryptedHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        //将数据转换成模型对象，使用MJExtention
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"Result"]) {
            BillModel *bill = [BillModel objectWithKeyValues:dic];
            [array addObject:bill];
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

+ (void)requestBillDetailWithBillId:(NSString *)billId success:(void(^)(BillDetailModel *billDetail))success failure:(void(^)(NSError *error))failure{
//    NSString *urlStr = @"http://122.114.62.57/his.crm/ashx/ClinicMessage.ashx";
     NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/ClinicMessage.ashx",DomainName,Method_His_Crm,@"ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = @"getBillDetail";
    params[billIdParam] = billId;
    
    [[CRMUnEncryptedHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        BillDetailModel *detailModel = [BillDetailModel objectWithKeyValues:responseObject[@"Result"]];
        
        if (success) {
            success(detailModel);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


+ (void)cancleAppointWithAppointId:(NSString *)appointId success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/ClinicMessage.ashx",DomainName,Method_His_Crm,@"ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = @"cancelreserve";
    params[@"keyid"] = appointId;
    
    [[CRMUnEncryptedHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
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

+ (void)payWithPayParam:(PayParam *)payParam success:(void(^)(CRMHttpRespondModel *respondModel))success failure:(void(^)(NSError *error))failure{
//    NSString *urlStr = @"http://122.114.62.57/his.crm/ashx/ClinicMessage.ashx";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/ClinicMessage.ashx",DomainName,Method_His_Crm,@"ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = @"pay";
    params[dataEntityParam] = [self dictionaryToJson:payParam.keyValues];
    
    [[CRMUnEncryptedHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
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
/**
 *  字典转json
 *
 *  @param dic 字典
 *
 *  @return json字符串
 */
+ (NSString *)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString *)arrayToJson:(NSArray *)array{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
