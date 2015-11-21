//
//  MyClinicTool.h
//  CRM
//
//  Created by Argo Zhang on 15/11/11.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ClinicDetailModel;
@interface MyClinicTool : NSObject
/*
    请求签约诊所的具体信息
 */
+ (void)requestClinicInfoWithDoctorId:(NSString *)doctocId success:(void(^)(NSArray *clinics))success failure:(void(^)(NSError *error))failure;


/*
    搜索签约诊所的信息
 */
+ (void)searchClinicInfoWithDoctorId:(NSString *)doctorId clinicName:(NSString *)clinicName success:(void(^)(NSArray *clinics))success failure:(void(^)(NSError *error))failure;


/*
    查询诊所详细信息
 */
+ (void)requestClinicDetailWithClinicId:(NSString *)clinicId accessToken:(NSString *)accessToken success:(void (^)(ClinicDetailModel *result))success failure:(void (^)(NSError *error))failure;

/*
    根据地址查询诊所信息
 */
+ (void)requestClinicInfoWithAreacode:(NSString *)areacode success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;

/*
 根据地址或者诊所名称查询诊所信息
 */
+ (void)requestClinicInfoWithAreacode:(NSString *)areacode clinicName:(NSString *)clinicName success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;

/*
    医生申请签约
 */
+ (void)applyForClinicWithDoctorID:(NSString *)doctorId clinicId:(NSString *)clinicId success:(void (^)(NSString *result,NSNumber *status))success failure:(void (^)(NSError *error))failure;

@end
