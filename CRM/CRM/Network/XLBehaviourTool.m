//
//  XLBehaviourTool.m
//  CRM
//
//  Created by Argo Zhang on 16/6/1.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLBehaviourTool.h"
#import "MJExtension.h"
#import "NSString+TTMAddtion.h"
#import "CRMHttpTool.h"
#import "CRMHttpRespondModel.h"
#import "XLBehaviourModel.h"
#import "CRMUserDefalut.h"

@implementation XLBehaviourTool

/**
 *  新增用户行为
 *
 *  @param model   行为模型
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)addNewBehaviourWithBehaviourModel:(XLBehaviourModel *)model success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/UserActionHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"add" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [[model paramToJosnString] TripleDESIsEncrypt:YES];
    
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


/**
 *  查询所有的用户行为
 *
 *  @param doctorId 医生id
 *  @param syncTime 同步时间
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)queryNewBehavioursWithDoctorId:(NSString *)doctorId syncTime:(NSString *)syncTime success:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/UserActionHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"listbyuseridanddate" TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctorId TripleDESIsEncrypt:YES];
    params[@"sync_time"] = [syncTime TripleDESIsEncrypt:YES];
//    params[@"device_token"] = [[CRMUserDefalut objectForKey:DeviceToken] TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
        CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dic in respond.result) {
            XLBehaviourModel *model = [XLBehaviourModel objectWithKeyValues:dic];
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
