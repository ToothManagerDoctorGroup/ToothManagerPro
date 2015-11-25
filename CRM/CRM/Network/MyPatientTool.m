//
//  MyPatientTool.m
//  CRM
//
//  Created by Argo Zhang on 15/11/25.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "MyPatientTool.h"
#import "CRMHttpTool.h"
#import "CRMHttpRespondModel.h"

#define ActionParam @"action"
#define Patient_NameParam @"patient_name"
#define Patient_PhoneParam @"patient_phone"

@implementation MyPatientTool

+ (void)getWeixinStatusWithPatientName:(NSString *)patientName patientPhone:(NSString *)patientPhone success:(void(^)(CRMHttpRespondModel *respondModel))success failure:(void(^)(NSError *error))failure{
    
    NSString *urlStr = @"http://122.114.62.57/Weixin/ashx/PatientInfoHandler.ashx";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[ActionParam] = @"weixinBind";
    params[Patient_NameParam] = patientName;
    params[Patient_PhoneParam] = patientPhone;
    
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

@end
