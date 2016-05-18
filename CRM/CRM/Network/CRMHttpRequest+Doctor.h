//
//  CRMHttpRequest+Doctor.h
//  CRM
//
//  Created by TimTiger on 11/4/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "CRMHttpRequest.h"


DEF_STATIC_CONST_STRING(Doctor_Prefix,Doctor);

#define GetOrSearchDoctorList_AndIcon_Common_URL [NSString stringWithFormat:@"%@%@/%@/DoctorInfoHandler.ashx",DomainName,Method_His_Crm,Method_Ashx]

#define Transfer_URL [NSString stringWithFormat:@"%@%@/%@/NotificationPatientHandler.ashx",DomainName,Method_His_Crm,Method_Ashx]

#define WeiXin_SMS_Common_URL [NSString stringWithFormat:@"%@%@/%@/DoctorPatientMapHandler.ashx",DomainName,Method_Weixin,Method_Ashx]

#define ClinicMessage_Common_URL [NSString stringWithFormat:@"%@%@/%@/ClinicMessage.ashx",DomainName,Method_His_Crm,Method_Ashx]

#define ClinicSeat_URL [NSString stringWithFormat:@"%@%@/%@/SeatHandler.ashx",DomainName,Method_ClinicServer,Method_Ashx]

#define YuYueInfoByClinicSeatDate_URL [NSString stringWithFormat:@"%@%@/%@/AppointmentsHandler.ashx",DomainName,Method_ClinicServer,Method_Ashx]

@interface CRMHttpRequest (Doctor)

/**
 *  获取个人的医生列表
 *
 *  @param userid 个人id
 */
- (void)getDoctorListWithUserid:(NSString *)userid;

/**
 *  上传医生头像
 *
 *  @param
 */
- (void)doctorIconWithUserId:(NSString *)userid withData:(NSData *)data;


/**
 *  更具姓名搜索医生
 *
 *  @param doctorname 医生名
 */
- (void)searchDoctorWithName:(NSString *)doctorname;

/**
 *  转诊病人
 *
 *  @param patientIds:病人id  doctorId:医生id  receiver_id:接收人id
 **/
- (void)trasferPatient:(NSString *)patientIds fromDoctor:(NSString *)doctorId toReceiver:(NSString *)receiverId;


/**
 *  医生预约列表
 *
 *  @param doctorId:医生id
 **/
- (void)clinicMessage:(NSString *)doctorId;

/**
 *  医生签约诊所列表
 *
 *  @param doctorId:医生id
 **/
- (void)doctorClinic:(NSString *)doctorId;

/**
 *  诊所椅位列表
 *
 *  @param clinicId:诊所id
 **/
- (void)clinicSeat:(NSString *)clinicId;


/**
 *  预约信息列表
 *
 *  @param clinicId:诊所id
 *  @param seatId:椅位id
 *  @param date:日期
 **/
- (void)yuYueInfoByClinicSeatDate:(NSString *)clinicId withSeatId:(NSString *)seatId withDate:(NSString *)date;

/**
 *  医生微信消息推送
 *
 *  @param patientIds:病人id  doctorId:医生id  message_type:类型   send_type  send_time
 **/
- (void)weiXinMessagePatient:(NSString *)patientIds fromDoctor:(NSString *)doctorId toDoctor:(NSString *)toDoctor withMessageType:(NSString *)message_type withSendType:(NSString *)send_type withSendTime:(NSString *)send_time;

/**
 *  预约短信消息推送
 *
 *  @param patientId:病人id  doctorId:医生id  message_type:类型   send_type  send_time
 **/
- (void)yuYueMessagePatient:(NSString *)patientId fromDoctor:(NSString *)doctorId withMessageType:(NSString *)message_type withSendType:(NSString *)send_type withSendTime:(NSString *)send_time;

/**
 *  预约推送到诊所端
 *
 *  @param patientId:病人id  doctorId:医生id
 **/
- (void)YuYueTuiSongClinic:(NSString *)patientId withClinicName:(NSString*)clinic_name withCliniId:(NSString*)clinic_id withDoctorId:(NSString*)doctor_id withAppointTime:(NSString *)appoint_time withDuration:(float)duration withSeatPrice:(float)seat_price withAppointMoney:(float)appoint_money withAppointType:(NSString *)appoint_type withSeatId:(NSString *)seat_id withToothPosition:(NSString *)tooth_position withAssist:(NSArray *)assist withMaterial:(NSArray *)material;

@end

@protocol CRMHttpRequestDoctorDelegate <NSObject>

@optional
//按姓名搜索医生
- (void)searchDoctorWithNameSuccessWithResult:(NSDictionary *)result;
- (void)searchDoctorWithNameFailedWithError:(NSError *)error;

//获取用户的医生列表
- (void)getDoctorListSuccessWithResult:(NSDictionary *)result;
- (void)getDoctorListFailedWithError:(NSError *)error;

//转诊病人
- (void)transferPatientSuccessWithResult:(NSDictionary *)result;
- (void)transferPatientFailedWithError:(NSError *)error;

//微信
- (void)weiXinMessageSuccessWithResult:(NSDictionary *)result;
- (void)weiXinMessageFailedWithError:(NSError *)error;

//医生预约列表
- (void)clinicMessageSuccessWithResult:(NSDictionary *)result;
- (void)clinicMessageFailedWithError:(NSError *)error;

//医生头像
- (void)doctorIconSuccessWithResult:(NSDictionary *)result;
- (void)doctorIconFailedWithError:(NSError *)error;

//医生签约诊所列表
- (void)doctorClinicSuccessWithResult:(NSDictionary *)result;
- (void)doctorClinicFailedWithError:(NSError *)error;

//诊所椅位列表
- (void)clinicSeatSuccessWithResult:(NSDictionary *)result;
- (void)clinicSeatFailedWithError:(NSError *)error;

//预约信息列表
- (void)yuYueInfoByClinicSeatDateSuccessWithResult:(NSDictionary *)result;
- (void)yuYueInfoByClinicSeatDateFailedWithError:(NSError *)error;

//预约短信
- (void)yuYueMessageSuccessWithResult:(NSDictionary *)result;
- (void)yuYueMessageFailedWithError:(NSError *)error;

//预约推送到诊所端
- (void)yuYueTuiSongClinicSuccessWithResult:(NSDictionary *)result;
- (void)yuYueTuiSongClinicFailedWithError:(NSError *)error;
@end
