//
//  DoctorManager.h
//  CRM
//
//  Created by TimTiger on 10/25/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimManager.h"
#import "CommonMacro.h"
#import "DBTableMode.h"
#import "TimManager.h"
#import "FriendNotification.h"

@class FriendNotification;
@interface DoctorManager : TimManager

Declare_ShareInstance(DoctorManager);

/**
 *  通过介绍人姓名搜索介绍人
 *
 *  @param introname 介绍人姓名
 */
- (void)searchDoctorWithName:(NSString *)doctorname successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 *  根据id获取医生列表
 *
 *  @param userid       医生id
 */
- (void)getDoctorListWithUserId:(NSString *)userid successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 *  转诊病人
 *
 *  @param patientIds:病人id  doctorId:医生id  receiver_id:接收人id
 **/
- (void)trasferPatient:(NSString *)patientIds fromDoctor:(NSString *)doctorId toReceiver:(NSString *)receiverId successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;


/**
 *  医生签约诊所列表
 *
 *  @param doctorId:医生id
 **/
- (void)doctorClinic:(NSString *)doctorId successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 *  诊所椅位列表
 *
 *  @param clinicId:诊所id
 **/
- (void)clinicSeat:(NSString *)clinicId successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 *  预约信息列表
 *
 *  @param clinicId:诊所id
 *  @param seatId:椅位id
 *  @param date:日期
 **/
- (void)yuYueInfoByClinicSeatDate:(NSString *)clinicId withSeatId:(NSString *)seatId withDate:(NSString *)date successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 *  医生微信消息推送
 *
 *  @param patientIds:病人id  doctorId:医生id  message_type:类型   send_type  send_time
 **/
- (void)weiXinMessagePatient:(NSString *)patientIds fromDoctor:(NSString *)doctorId toDoctor:(NSString *)toDoctorId withMessageType:(NSString *)message_type withSendType:(NSString *)send_type withSendTime:(NSString *)send_time successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 *  预约推送到诊所端
 *
 *  @param patientId:病人id  doctorId:医生id
 **/
- (void)YuYueTuiSongClinic:(NSString *)patientId withClinicName:(NSString*)clinic_name withCliniId:(NSString*)clinic_id withDoctorId:(NSString*)doctor_id withAppointTime:(NSString *)appoint_time withDuration:(float)duration withSeatPrice:(float)seat_price withAppointMoney:(float)appoint_money withAppointType:(NSString *)appoint_type withSeatId:(NSString *)seat_id withToothPosition:(NSString *)tooth_position withAssist:(NSArray *)assist withMaterial:(NSArray *)material successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 *  预约短信消息推送
 *
 *  @param patientId:病人id  doctorId:医生id  message_type:类型   send_type  send_time
 **/
- (void)yuYueMessagePatient:(NSString *)patientId fromDoctor:(NSString *)doctorId withMessageType:(NSString *)message_type withSendType:(NSString *)send_type withSendTime:(NSString *)send_time successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 *  添加医生到医生库
 *
 *  @param doctorid 医生id
 */
- (void)addDoctorToDoctorLibrary:(FriendNotificationItem *)aDoctor;

#pragma mark - 数据解析
- (NSMutableArray *)arrayWithDoctorResult:(NSArray *)dicArray;

@end
