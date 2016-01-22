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
#import "JSONKit.h"

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

+ (void)sendWeiXinReserveNotificationWithNewReserveId:(NSString *)newId oldReserveId:(NSString *)oldId isCancel:(BOOL)isCancel notification:(LocalNotification *)noti type:(NSString *)type success:(void (^)())success failure:(void (^)())failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/ReserveRecordHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"reservenotify";
    params[@"newReserveId"] = newId;
    params[@"oldReserveId"] = oldId;
    params[@"type"] = type;
    if (isCancel) {
        NSMutableDictionary *dataEntityParams = [NSMutableDictionary dictionary];
        dataEntityParams[@"therapy_doctor_id"] = noti.therapy_doctor_id;
        dataEntityParams[@"therapy_doctor_name"] = noti.therapy_doctor_name;
        dataEntityParams[@"ckeyid"] = noti.ckeyid;
        dataEntityParams[@"doctor_id"] = noti.doctor_id;
        dataEntityParams[@"reserve_content"] = noti.reserve_content;
        dataEntityParams[@"reserve_type"] = noti.reserve_type;
        dataEntityParams[@"reserve_time"] = noti.reserve_time;
        dataEntityParams[@"patient_id"] = noti.patient_id;
        
        params[@"reserve_entity"] = [dataEntityParams JSONString];
    }
    
    [CRMHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
    }];
}
+ (void)updateReserveRecordStatusWithReserveId:(NSString *)reserve_id success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/ReserveRecordHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"updatereservestatus";
    params[@"reserve_id"] = reserve_id;
    
    [CRMHttpTool GET:urlStr parameters:params success:^(id responseObject) {
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

+ (void)getReserveRecordByReserveId:(NSString *)reserve_id success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/ReserveRecordHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getreservebyckeyid";
    params[@"ckeyid"] = reserve_id;
    
    [CRMHttpTool GET:urlStr parameters:params success:^(id responseObject) {
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

+ (void)sendHuanXiMessageToPatientWithPatientId:(NSString *)patient_id contentType:(NSString *)content_type sendContent:(NSString *)send_content success:(void (^)())success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/SendMsgHandler.ashx",DomainName,Method_Weixin];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"to_patient";
    params[@"patient_id"] = patient_id;
    params[@"content_type"] = content_type;
    params[@"send_content"] = send_content;
    
    [CRMHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


@end
