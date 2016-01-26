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

@implementation XLMessageTemplateTool

+ (void)getMessageTemplateByDoctorId:(NSString *)doctor_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/MessageTemplate.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"gettemplateitem";
    params[@"uid"] = doctor_id;
    params[@"templateid"] = @"U_DIY";
    
    [CRMHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        
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

@end
