//
//  XLMessageTemplateTool.m
//  CRM
//
//  Created by Argo Zhang on 16/1/25.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLMessageTemplateTool.h"
#import "CRMHttpTool.h"
#import "XLMessageTemplateModel.h"
#import "MJExtension.h"
#import "JSONKit.h"
#import "XLMessageTemplateParam.h"
#import "CRMHttpRespondModel.h"

@implementation XLMessageTemplateTool

+ (void)getMessageTemplateByDoctorId:(NSString *)doctor_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/MessageTemplate.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"gettemplateitem";
    params[@"uid"] = doctor_id;
    params[@"templateid"] = @"U_DIY";
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        NSMutableArray *arrayM = [NSMutableArray array];
        NSArray *array = responseObject[@"Result"];
        for (NSDictionary *dic in array) {
            XLMessageTemplateModel *model = [XLMessageTemplateModel objectWithKeyValues:dic];
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

+ (void)addMessageTemplateWithParam:(XLMessageTemplateParam *)param success:(void (^)(CRMHttpRespondModel *model))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/DoctorMessageTemplateDetailHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"add";
    params[@"DataEntity"] = [param.keyValues JSONString];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
        CRMHttpRespondModel *model = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)editMessageTemplateWithParam:(XLMessageTemplateParam *)param success:(void (^)(CRMHttpRespondModel *model))success failure:(void (^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/DoctorMessageTemplateDetailHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"edit";
    params[@"DataEntity"] = [param.keyValues JSONString];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
        CRMHttpRespondModel *model = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)deleteMessageTemplateWithParam:(XLMessageTemplateParam *)param success:(void (^)(CRMHttpRespondModel *model))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/DoctorMessageTemplateDetailHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"delete";
    params[@"DataEntity"] = [param.keyValues JSONString];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
        CRMHttpRespondModel *model = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
