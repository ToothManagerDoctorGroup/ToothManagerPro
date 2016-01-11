//
//  DoctorTool.h
//  CRM
//
//  Created by Argo Zhang on 15/11/18.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DoctorInfoModel,CRMHttpRespondModel;
@interface DoctorTool : NSObject

/*获取医生的详细信息*/
+ (void)requestDoctorInfoWithDoctorId:(NSString *)doctorId success:(void(^)(DoctorInfoModel *dcotorInfo))success failure:(void(^)(NSError *error))failure;

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


@end
