//
//  CRMHttpRequest+Doctor.h
//  CRM
//
//  Created by TimTiger on 11/4/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "CRMHttpRequest.h"


DEF_STATIC_CONST_STRING(Doctor_Prefix,Doctor);

//DEF_URL GetDoctorList_URL =  @"http://122.114.62.57/his.crm/ashx/DoctorInfoHandler.ashx?action=getdatabyid";
#define GetDoctorList_URL [NSString stringWithFormat:@"%@%@/ashx/DoctorInfoHandler.ashx?action=getdatabyid",DomainName,Method_His_Crm]

//DEF_URL SearchDoctor_URL = @"http://122.114.62.57/his.crm/ashx/DoctorInfoHandler.ashx?action=getdata";
#define SearchDoctor_URL [NSString stringWithFormat:@"%@%@/ashx/DoctorInfoHandler.ashx?action=getdata",DomainName,Method_His_Crm]

//DEF_URL Transfer_URL = @"http://122.114.62.57/his.crm/ashx/NotificationPatientHandler.ashx?action=transfer";
#define Transfer_URL [NSString stringWithFormat:@"%@%@/ashx/NotificationPatientHandler.ashx?action=transfer",DomainName,Method_His_Crm]

//DEF_URL WeiXin_URL = @"http://122.114.62.57/Weixin/ashx/DoctorPatientMapHandler.ashx";
#define WeiXin_URL [NSString stringWithFormat:@"%@%@/ashx/DoctorPatientMapHandler.ashx",DomainName,Method_Weixin]

//DEF_URL ClinicMessage_URL = @"http://122.114.62.57/his.crm/ashx/ClinicMessage.ashx";
#define ClinicMessage_URL [NSString stringWithFormat:@"%@%@/ashx/ClinicMessage.ashx",DomainName,Method_His_Crm]

//DEF_URL DoctorIcon_URL = @"http://122.114.62.57/his.crm/ashx/DoctorInfoHandler.ashx";
#define DoctorIcon_URL [NSString stringWithFormat:@"%@%@/ashx/DoctorInfoHandler.ashx",DomainName,Method_His_Crm]

//DEF_URL DoctorClinic_URL = @"http://122.114.62.57/his.crm/ashx/ClinicMessage.ashx";
#define DoctorClinic_URL [NSString stringWithFormat:@"%@%@/ashx/ClinicMessage.ashx",DomainName,Method_His_Crm]

//DEF_URL ClinicSeat_URL = @"http://122.114.62.57/clinicServer/ashx/SeatHandler.ashx";
#define ClinicSeat_URL [NSString stringWithFormat:@"%@%@/ashx/SeatHandler.ashx",DomainName,Method_ClinicServer]

//DEF_URL YuYueInfoByClinicSeatDate_URL = @"http://122.114.62.57/clinicServer/ashx/AppointmentsHandler.ashx";
#define YuYueInfoByClinicSeatDate_URL [NSString stringWithFormat:@"%@%@/ashx/AppointmentsHandler.ashx",DomainName,Method_ClinicServer]

//DEF_URL YuYueDuanXin_URL = @"http://122.114.62.57/Weixin/ashx/DoctorPatientMapHandler.ashx?action=getMessageItem";
#define YuYueDuanXin_URL [NSString stringWithFormat:@"%@%@/ashx/DoctorPatientMapHandler.ashx?action=getMessageItem",DomainName,Method_Weixin]

//DEF_URL YuYueTuiSongClinic_URL = @"http://122.114.62.57/his.crm/ashx/ClinicMessage.ashx?action=appoint";
#define YuYueTuiSongClinic_URL [NSString stringWithFormat:@"%@%@/ashx/ClinicMessage.ashx?action=appoint",DomainName,Method_His_Crm]

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
- (void)weiXinMessagePatient:(NSString *)patientIds fromDoctor:(NSString *)doctorId withMessageType:(NSString *)message_type withSendType:(NSString *)send_type withSendTime:(NSString *)send_time;

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
