//
//  SysMessageTool.m
//  CRM
//
//  Created by Argo Zhang on 15/12/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "SysMessageTool.h"
#import "CRMHttpTool.h"
#import "SysMessageModel.h"

@implementation SysMessageTool

+ (void)getUnReadMessagesWithDoctorId:(NSString *)doctorId success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/DoctorMessageHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getUnReadMsg";
    params[@"doctor_id"] = doctorId;
    
    [CRMHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        
        NSMutableArray *arrayM = [NSMutableArray array];

        if ([responseObject[@"Code"] intValue] == 200) {
            for (NSDictionary *dic in responseObject[@"Result"]) {
                SysMessageModel *model = [SysMessageModel objectWithKeyValues:dic];
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

+ (void)getReadedMessagesWithDoctorId:(NSString *)doctorId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/DoctorMessageHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getReadedMsgByPage";
    params[@"doctor_id"] = doctorId;
    params[@"pageIndex"] = @(pageIndex);
    params[@"pageSize"] = @(pageSize);
    
    [CRMHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        
        NSMutableArray *arrayM = [NSMutableArray array];
        if ([responseObject[@"Code"] intValue] == 200) {
            for (NSDictionary *dic in responseObject[@"Result"]) {
                SysMessageModel *model = [SysMessageModel objectWithKeyValues:dic];
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

+ (void)deleteMessageWithMessageId:(NSInteger)messageId success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/DoctorMessageHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"deleteMsg";
    params[@"keyId"] = @(messageId);
    
    [CRMHttpTool POST:urlStr parameters:params success:^(id responseObject) {
        
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

+ (void)setMessageReadedWithMessageId:(NSInteger)messageId success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/DoctorMessageHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"setMsgReaded";
    params[@"keyId"] = @(messageId);
    
    [CRMHttpTool POST:urlStr parameters:params success:^(id responseObject) {
        
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

@end
