//
//  MyClinicTool.h
//  CRM
//
//  Created by Argo Zhang on 15/11/11.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ClinicDetailModel,XLOperationStatusModel,XLClinicQueryModel,CRMHttpRespondModel;
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

/**
 *  获取诊所所有的助手信息
 *
 *  @param clinicId 诊所id
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)getAssistentListWithClinicId:(NSString *)clinicId success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;

/**
 *  获取诊所所有材料的信息
 *
 *  @param clinicId 诊所id
 *  @param type     材料的类型 1为种植材料，2为其他材料，不传值返回所有材料
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)getMaterialListWithClinicId:(NSString *)clinicId matType:(NSString *)type success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;

/**
 *  根据诊所id查找指定时间内的营业状态
 *
 *  @param clinicId   诊所id
 *  @param curDateStr 当前时间
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)getOperatingStatusWithClinicId:(NSString *)clinicId curDateStr:(NSString *)curDateStr success:(void (^)(XLOperationStatusModel *statusModel))success failure:(void (^)(NSError *error))failure;

/**
 *  模糊搜索诊所列表
 *
 *  @param queryModel 查询的model
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)getClinicListWithQueryModel:(XLClinicQueryModel *)queryModel success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;

@end
