//
//  DoctorTool.m
//  CRM
//
//  Created by Argo Zhang on 15/11/18.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "DoctorTool.h"
#import "CRMHttpTool.h"
#import "DoctorInfoModel.h"


#define userIdParam @"userid"
#define requestActionParam @"action"
@implementation DoctorTool

+ (void)requestDoctorInfoWithDoctorId:(NSString *)doctorId success:(void(^)(DoctorInfoModel *dcotorInfo))success failure:(void(^)(NSError *error))failure{
    
    NSString *urlStr = @"http://122.114.62.57/his.crm/ashx/DoctorInfoHandler.ashx";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = @"getdatabyid";
    params[userIdParam] = doctorId;
    
    
    [CRMHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        
        DoctorInfoModel *doctorInfo = [DoctorInfoModel objectWithKeyValues:[responseObject[@"Result"] lastObject]];
        if (success) {
            success(doctorInfo);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
