//
//  DoctorTool.h
//  CRM
//
//  Created by Argo Zhang on 15/11/18.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DoctorInfoModel,CRMHttpRespondModel,XLQueryModel;
@interface DoctorTool : NSObject

/*获取医生的详细信息*/
+ (void)requestDoctorInfoWithDoctorId:(NSString *)doctorId success:(void(^)(DoctorInfoModel *dcotorInfo))success failure:(void(^)(NSError *error))failure;
/**
 *  更新医生的个人信息
 *
 *  @param doctorInfo 医生模型
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)updateUserInfoWithDoctorInfoModel:(DoctorInfoModel *)doctorInfo ckeyId:(NSString *)ckeyId success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure;

/**
 *  上传用户头像
 *
 *  @param image   上传的图片
 *  @param userId  用户的id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)composeTeacherHeadImg:(UIImage *)image userId:(NSString *)userId success:(void(^)())success failure:(void(^)(NSError *error))failure;


/**
 *  删除医生好友
 *
 *  @param doctorId 医生id
 *  @param introId  介绍人id
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)deleteFriendWithDoctorId:(NSString *)doctorId introId:(NSString *)introId success:(void(^)(CRMHttpRespondModel *result))success failure:(void(^)(NSError *error))failure;

/**
 *  短信预约信息获取
 *
 *  @param patientId    患者id
 *  @param doctorId     医生id
 *  @param message_type 信息类型
 *  @param send_type    发送类型
 *  @param send_time    发送时间
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)yuYueMessagePatient:(NSString *)patientId fromDoctor:(NSString *)doctorId withMessageType:(NSString *)message_type withSendType:(NSString *)send_type withSendTime:(NSString *)send_time success:(void(^)(CRMHttpRespondModel *result))success failure:(void(^)(NSError *error))failure;
/**
 *  获取医生的好友列表
 *
 *  @param doctor  医生id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getDoctorFriendListWithDoctorId:(NSString *)doctorId success:(void(^)(NSArray *array))success failure:(void(^)(NSError *error))failure;
/**
 *  转诊患者
 *
 *  @param patientId  患者id
 *  @param doctorId   当前医生的id
 *  @param receiverId 接收方id
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)transferPatientWithPatientId:(NSString *)patientId doctorId:(NSString *)doctorId receiverId:(NSString *)receiverId success:(void(^)(CRMHttpRespondModel *result))success failure:(void(^)(NSError *error))failure;

/**
 *  分页查询好友信息
 *
 *  @param doctorId  医生id
 *  @param sync_time 同步时间
 *  @param info      排序字段
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)getDoctorFriendListWithDoctorId:(NSString *)doctorId syncTime:(NSString *)sync_time queryInfo:(XLQueryModel *)info success:(void(^)(NSArray *array))success failure:(void(^)(NSError *error))failure;

/**
 *  根据种植时间查询患者
 *
 *  @param doctor_id  医生id
 *  @param begin_date 种植开始时间
 *  @param end_date   种植结束时间
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)queryPlantPatientsWithDoctorId:(NSString *)doctor_id beginDate:(NSString *)begin_date endDate:(NSString *)end_date success:(void(^)(NSArray *array))success failure:(void(^)(NSError *error))failure;

/**
 *  根据修复时间段和修复医生查询患者信息
 *
 *  @param doctor_id        医生id
 *  @param begin_date       修复开始时间
 *  @param end_date         修复结束时间
 *  @param repair_doctor_id 修复医生id
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+ (void)queryRepairPatientsWithDoctorId:(NSString *)doctor_id beginDate:(NSString *)begin_date endDate:(NSString *)end_date repairDoctorId:(NSString *)repair_doctor_id success:(void(^)(NSArray *array))success failure:(void(^)(NSError *error))failure;
/**
 *  发送意见反馈
 *
 *  @param doctor_id 医生id
 *  @param content   反馈内容
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)sendAdviceWithDoctorId:(NSString *)doctor_id content:(NSString *)content success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure;
@end
