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
#import "AccountManager.h"
#import "NSString+TTMAddtion.h"
#import "CRMUnEncryptedHttpTool.h"
#import "XLAutoSyncTool.h"

@implementation SysMessageTool
/**
 *  综合查询消息
 *
 *  @param queryModel 查询参数模型
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)getMessageByQueryModel:(XLMessageQueryModel *)queryModel success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/DoctorMessageHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"getMsgByQuery" TripleDESIsEncrypt:YES];
    params[@"query"] = [[queryModel.keyValues JSONString] TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
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

/**
 *  获取所有消息
 *
 *  @param doctorId 医生id
 *  @param syncTime 同步时间
 *  @param isRead   是否已读（0未读，1已读，非0和1为获取所有）
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)getMessagesWithDoctorId:(NSString *)doctorId syncTime:(NSString *)syncTime isRead:(SysMessageReadState)isRead success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/DoctorMessageHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"getMsg" TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctorId TripleDESIsEncrypt:YES];
    params[@"sync_time"] = [syncTime TripleDESIsEncrypt:YES];
    params[@"is_read"] = [[@(isRead) stringValue] TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
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


+ (void)getUnReadMessagesWithDoctorId:(NSString *)doctorId success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/DoctorMessageHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"getUnReadMsg" TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctorId TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
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

/**
 *  获取未读消息的数量
 *
 *  @param doctorId 医生id
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)getUnReadMessageCountWithDoctorId:(NSString *)doctorId success:(void (^)(NSString *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/DoctorMessageHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"getUnReadMsgCount" TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctorId TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        CRMHttpRespondModel *res = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if ([res.code integerValue] == 200) {
            if (success) {
                success([res.result stringValue]);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getReadedMessagesWithDoctorId:(NSString *)doctorId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/DoctorMessageHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"getReadedMsgByPage" TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctorId TripleDESIsEncrypt:YES];
    params[@"pageIndex"] = [[@(pageIndex) stringValue] TripleDESIsEncrypt:YES];
    params[@"pageSize"] = [[@(pageSize) stringValue] TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/DoctorMessageHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"deleteMsg" TripleDESIsEncrypt:YES];
    params[@"keyId"] = [[@(messageId) stringValue] TripleDESIsEncrypt:YES];
    
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

+ (void)setMessageReadedWithMessageId:(NSInteger)messageId success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/DoctorMessageHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"setMsgReaded" TripleDESIsEncrypt:YES];
    params[@"keyId"] = [[@(messageId) stringValue] TripleDESIsEncrypt:YES];
    
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

+ (void)sendWeiXinReserveNotificationWithNewReserveId:(NSString *)newId oldReserveId:(NSString *)oldId isCancel:(BOOL)isCancel notification:(LocalNotification *)noti type:(NSString *)type success:(void (^)())success failure:(void (^)())failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/ReserveRecordHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"reservenotify" TripleDESIsEncrypt:YES];
    params[@"newReserveId"] = [newId TripleDESIsEncrypt:YES];
    params[@"oldReserveId"] = [oldId TripleDESIsEncrypt:YES];
    params[@"type"] = [type TripleDESIsEncrypt:YES];
    if (isCancel) {
        NSMutableDictionary *dataEntityParams = [NSMutableDictionary dictionary];
        dataEntityParams[@"therapy_doctor_id"] = noti.therapy_doctor_id;
        dataEntityParams[@"therapy_doctor_name"] = noti.therapy_doctor_name;
        dataEntityParams[@"ckeyid"] = noti.ckeyid;
        dataEntityParams[@"doctor_id"] = [AccountManager currentUserid];
        dataEntityParams[@"reserve_content"] = noti.reserve_content;
        dataEntityParams[@"reserve_type"] = noti.reserve_type;
        dataEntityParams[@"reserve_time"] = noti.reserve_time;
        dataEntityParams[@"patient_id"] = noti.patient_id;
        
        params[@"reserve_entity"] = [[dataEntityParams JSONString] TripleDESIsEncrypt:YES];
    }
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
    }];
}
+ (void)updateReserveRecordStatusWithReserveId:(NSString *)reserve_id therapy_doctor_id:(NSString *)therapy_doctor_id success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/ReserveRecordHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"updatereservestatus" TripleDESIsEncrypt:YES];
    params[@"reserve_id"] = [reserve_id TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [[AccountManager currentUserid] TripleDESIsEncrypt:YES];
    params[@"therapy_doctor_id"] = [therapy_doctor_id TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:[[XLAutoSyncTool shareInstance] addCommenParams:params] success:^(id responseObject) {
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/ReserveRecordHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"getreservebyckeyid" TripleDESIsEncrypt:YES];
    params[@"ckeyid"] = [reserve_id TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
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

+ (void)sendHuanXiMessageToPatientWithPatientId:(NSString *)patient_id contentType:(NSString *)content_type sendContent:(NSString *)send_content doctorId:(NSString *)doctor_id success:(void (^)())success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/SendMsgHandler.ashx",DomainName,Method_Weixin,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"to_patient" TripleDESIsEncrypt:YES];
    params[@"patient_id"] = [patient_id TripleDESIsEncrypt:YES];
    params[@"content_type"] = [content_type TripleDESIsEncrypt:YES];
    params[@"send_content"] = [send_content TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctor_id TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)sendMessageWithDoctorId:(NSString *)doctor_id patientId:(NSString *)patient_id isWeixin:(BOOL)isWeixin isSms:(BOOL)isSms txtContent:(NSString *)content success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/SendMsgHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"ToPatient" TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctor_id TripleDESIsEncrypt:YES];
    params[@"patient_id"] = [patient_id TripleDESIsEncrypt:YES];
    params[@"is_weixin"] = isWeixin ? [@"1" TripleDESIsEncrypt:YES] : [@"0" TripleDESIsEncrypt:YES];
    params[@"is_sms"] =  isSms ? [@"1" TripleDESIsEncrypt:YES] : [@"0" TripleDESIsEncrypt:YES];
    params[@"txt_content"] = [content TripleDESIsEncrypt:YES];
    
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

@end


@implementation XLMessageQueryModel
- (instancetype)initWithIsRead:(NSNumber *)isRead
                      syncTime:(NSString *)syncTime
                     sortField:(NSString *)sortField
                         isAsc:(BOOL)isAsc
                     pageIndex:(NSInteger)pageIndex
                      pageSize:(NSInteger)pageSize{
    if (self = [super init]) {
        self.DoctorId = [AccountManager currentUserid];
        self.IsRead = isRead;
        self.MsgId = @"";
        self.MsgType = @"";
        self.SyncTime = syncTime;
        self.KeyWord = @"";
        self.SortField = sortField;
        self.IsAsc = isAsc;
        self.PageIndex = pageIndex;
        self.PageSize = pageSize;
    }
    return self;
}

@end
