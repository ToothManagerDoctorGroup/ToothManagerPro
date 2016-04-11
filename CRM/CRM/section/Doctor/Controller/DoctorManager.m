//
//  DoctorManager.m
//  CRM
//
//  Created by TimTiger on 10/25/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "DoctorManager.h"
#import "NSError+Extension.h"
#import "CRMHttpRequest+Doctor.h"
#import "NSDictionary+Extension.h"
#import "DBManager+Doctor.h"

@implementation DoctorManager
Realize_ShareInstance(DoctorManager);

/**
 *  通过介绍人姓名搜索介绍人
 *
 *  @param introname 介绍人姓名
 */
- (void)searchDoctorWithName:(NSString *)doctorname successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    if (doctorname == nil) {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"医生名不能为空" errorCode:400]);
        return;
    }
    [[CRMHttpRequest shareInstance] searchDoctorWithName:doctorname];
    successBlock();
}

/**
 *  根据id获取医生列表
 *
 *  @param userid       医生id
 */
- (void)getDoctorListWithUserId:(NSString *)userid successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    if (userid == nil) {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"请登录" errorCode:400]);
        return;
    }
    [[CRMHttpRequest shareInstance] getDoctorListWithUserid:userid];
    successBlock();
}

/**
 *  转诊病人
 *
 *  @param patientIds:病人id  doctorId:医生id  receiver_id:接收人id
 **/
- (void)trasferPatient:(NSString *)patientIds fromDoctor:(NSString *)doctorId toReceiver:(NSString *)receiverId successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    if (patientIds == nil) {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"请先选择患者" errorCode:400]);
        return;
    }
    if (doctorId == nil) {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"请登录" errorCode:400]);
        return;
    }
    if (receiverId == nil) {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"请先接诊医生" errorCode:400]);
        return;
    }
    [[CRMHttpRequest shareInstance] trasferPatient:patientIds fromDoctor:doctorId toReceiver:receiverId];
    successBlock();
}

/**
 *  医生微信消息推送
 *
 *  @param patientIds:病人id  doctorId:医生id  message_type:类型   send_type  send_time
 **/
- (void)weiXinMessagePatient:(NSString *)patientIds fromDoctor:(NSString *)doctorId toDoctor:(NSString *)toDoctorId withMessageType:(NSString *)message_type withSendType:(NSString *)send_type withSendTime:(NSString *)send_time successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock{
    if(patientIds == nil){
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"请先选择患者" errorCode:400]);
    }
    if(doctorId == nil){
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"请登录" errorCode:400]);
    }
    [[CRMHttpRequest shareInstance] weiXinMessagePatient:patientIds fromDoctor:doctorId toDoctor:toDoctorId withMessageType:message_type withSendType:send_type withSendTime:send_time];
    
    successBlock();
}

/**
 *  预约推送到诊所端
 *
 *  @param patientId:病人id  doctorId:医生id
 **/
- (void)YuYueTuiSongClinic:(NSString *)patientId withClinicName:(NSString*)clinic_name withCliniId:(NSString*)clinic_id withDoctorId:(NSString*)doctor_id withAppointTime:(NSString *)appoint_time withDuration:(float)duration withSeatPrice:(float)seat_price withAppointMoney:(float)appoint_money withAppointType:(NSString *)appoint_type withSeatId:(NSString *)seat_id withToothPosition:(NSString *)tooth_position withAssist:(NSArray *)assist withMaterial:(NSArray *)material successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock{
    if(patientId == nil){
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"请先选择患者" errorCode:400]);
    }
    if(doctor_id == nil){
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"请登录" errorCode:400]);
    }
    [[CRMHttpRequest shareInstance] YuYueTuiSongClinic:patientId withClinicName:clinic_name withCliniId:clinic_id withDoctorId:doctor_id withAppointTime:appoint_time withDuration:duration withSeatPrice:seat_price withAppointMoney:appoint_money withAppointType:appoint_type withSeatId:seat_id withToothPosition:tooth_position withAssist:assist withMaterial:material];
    successBlock();
}
/**
 *  预约短信消息推送
 *
 *  @param patientId:病人id  doctorId:医生id  message_type:类型   send_type  send_time
 **/
- (void)yuYueMessagePatient:(NSString *)patientId fromDoctor:(NSString *)doctorId withMessageType:(NSString *)message_type withSendType:(NSString *)send_type withSendTime:(NSString *)send_time successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock{
    if(patientId == nil){
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"请先选择患者" errorCode:400]);
    }
    if(doctorId == nil){
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"请登录" errorCode:400]);
    }
    [[CRMHttpRequest shareInstance]yuYueMessagePatient:patientId fromDoctor:doctorId withMessageType:message_type withSendType:send_type withSendTime:send_time];
    
    successBlock();
}

/**
 *  医生签约诊所列表
 *
 *  @param doctorId:医生id
 **/
- (void)doctorClinic:(NSString *)doctorId successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock{
    [[CRMHttpRequest shareInstance]doctorClinic:doctorId];
    successBlock();
}

/**
 *  诊所椅位列表
 *
 *  @param clinicId:诊所id
 **/
- (void)clinicSeat:(NSString *)clinicId successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock{
    [[CRMHttpRequest shareInstance]clinicSeat:clinicId];
    successBlock();
}

/**
 *  预约信息列表
 *
 *  @param clinicId:诊所id
 *  @param seatId:椅位id
 *  @param date:日期
 **/
- (void)yuYueInfoByClinicSeatDate:(NSString *)clinicId withSeatId:(NSString *)seatId withDate:(NSString *)date successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock{
    [[CRMHttpRequest shareInstance]yuYueInfoByClinicSeatDate:clinicId withSeatId:seatId withDate:date];
    successBlock();
}
/**
 *  添加医生到医生库
 *
 *  @param doctorid 医生id
 */
- (void)addDoctorToDoctorLibrary:(FriendNotificationItem *)aDoctor {
    Doctor *tmpDoctor = [[DBManager shareInstance] getDoctorWithName:aDoctor.receiver_name];
    if (tmpDoctor == nil) {
        tmpDoctor = [[Doctor alloc] init];
        tmpDoctor.ckeyid = aDoctor.receiver_id;
        tmpDoctor.doctor_name = aDoctor.receiver_name;
        [[DBManager shareInstance] insertDoctorWithDoctor:tmpDoctor];
    }
}

#pragma mark -
- (NSMutableArray *)arrayWithDoctorResult:(NSArray *)dicArray {
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in dicArray) {
        Doctor *tmpDoctor = [Doctor DoctorFromDoctorResult:dic];
        [resultArray addObject:tmpDoctor];
    }
    return resultArray;
}

@end
