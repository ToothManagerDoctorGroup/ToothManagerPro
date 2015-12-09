//
//  TTMDoctorTool.m
//  ToothManager
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 roger. All rights reserved.
//

#import "TTMDoctorTool.h"
#import "TTMMyHttpTool.h"

@implementation TTMDoctorTool

+ (void)requestDoctorInfoWithDoctorId:(NSString *)doctorId success:(void (^)(TTMDoctorModel *))success failure:(void (^)(NSError *))failure{

    NSString *urlStr = [NSString stringWithFormat:@"%@his.crm/ashx/DoctorInfoHandler.ashx",DomainName];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getdatabyid";
    params[@"userid"] = doctorId;
    
    [TTMMyHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        
        TTMDoctorModel *doctorInfo = [TTMDoctorModel objectWithKeyValues:[responseObject[@"Result"] lastObject]];
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
