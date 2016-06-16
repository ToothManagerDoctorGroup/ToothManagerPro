//
//  DoctorTool.h
//  CRM
//
//  Created by Argo Zhang on 15/11/18.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DoctorInfoModel,CRMHttpRespondModel,XLQueryModel,XLAdviceDetailModel,XLChatRecordQueryModel,XLChatModel;
@interface DoctorTool : NSObject

/**
 *  获取个人的医生列表
 *
 *  @param userid 个人id
 */
+ (void)getDoctorListWithUserid:(NSString *)userid success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure;

/**
 *  获取医生的详细信息
 *
 *  @param doctorId 医生id
 *  @param success  成功回调
 *  @param failure  失败回调
 */
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
+ (void)composeTeacherHeadImg:(UIImage *)image userId:(NSString *)userId success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure;


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
 *  短信预约信息获取（旧）
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
 *  短信预约信息获取（新）
 *
 *  @param patientId    患者id
 *  @param doctorId     医生id
 *  @param therapyDoctorId 治疗医生id
 *  @param message_type 信息类型
 *  @param send_type    发送类型
 *  @param send_time    发送时间
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)newYuYueMessagePatient:(NSString *)patientId fromDoctor:(NSString *)doctorId therapyDoctorId:(NSString *)therapyDoctorId withMessageType:(NSString *)message_type withSendType:(NSString *)send_type withSendTime:(NSString *)send_time success:(void(^)(CRMHttpRespondModel *result))success failure:(void(^)(NSError *error))failure;
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
/**
 *  获取用户帮助
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getAllUsingHelpSuccess:(void(^)(NSArray *array))success failure:(void(^)(NSError *error))failure;

#pragma mark - *************************医嘱相关********************
/**
 *  查询所有的医嘱类型
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getMedicalAdviceTypeSuccess:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure;
/**
 *  查询指定类型下的所有医嘱
 *
 *  @param doctorId   医生id（必填）
 *  @param ckeyId     医嘱主键（选填）
 *  @param keyWord    关键字（选填）
 *  @param adviceId   医嘱的id（必填）
 *  @param adviceName 医嘱的名称（必填）
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)getMedicalAdviceOfTypeByDoctorId:(NSString *)doctorId ckeyid:(NSString *)ckeyId keyWord:(NSString *)keyWord adviceId:(NSString *)adviceId adviceName:(NSString *)adviceName success:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure;
/**
 *  新增一条医嘱
 *
 *  @param model   医嘱模型
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)addNewMedicalAdviceOfTypeByAdviceDetailModel:(XLAdviceDetailModel *)model success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure;
/**
 *  删除一条医嘱
 *
 *  @param ckeyId  医嘱id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)deleteMedicalAdviceOfTypeByCkeyId:(NSString *)ckeyId success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure;
/**
 *  编辑一条医嘱
 *
 *  @param model   医嘱模型
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)editMedicalAdviceOfTypeByAdviceDetailModel:(XLAdviceDetailModel *)model success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure;
/**
 *  获取所有的患教信息
 *
 *  @param type    信息类型
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getPatientEducationWithType:(NSString *)type success:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure;

#pragma mark ********************聊天记录相关*************************
/**
 *  模糊查询所有聊天记录
 *
 *  @param queryModel 查询模型
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)getAllChatRecordWithChatQueryModel:(XLChatRecordQueryModel *)queryModel success:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure;
/**
 *  新增聊天记录
 *
 *  @param chatModel 聊天记录模型
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)addNewChatRecordWithChatModel:(XLChatModel *)chatModel success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure;

/**
 *  删除聊天记录
 *
 *  @param keyId      某个聊天记录主键（可不传）
 *  @param receiverId 接收者id（多个接收者，中间用“，”隔开）
 *  @param senderId   发送者id (多个发送者，中间用“，”隔开）
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)deleteChatRecordWithKeyId:(NSString *)keyId receiverId:(NSString *)receiverId senderId:(NSString *)senderId success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure;

#pragma mark - ************************医生好友相关***********************
/**
 *  根据医生姓名查询医生
 *
 *  @param doctorName 医生姓名
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)searchDoctorWithDoctorName:(NSString *)doctorName success:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure;

#pragma mark - ************************二维码相关***********************
/**
 *  获取患者或者医生的二维码
 *
 *  @param patientKeyId 患者的keyId
 *  @param isDoctor     是否是医生
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)getQrCodeWithPatientKeyId:(NSString *)patientKeyId isDoctor:(BOOL)isDoctor success:(void(^)(NSDictionary *result))success failure:(void(^)(NSError *error))failure;

@end
