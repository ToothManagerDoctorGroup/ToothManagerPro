//
//  MyPatientTool.h
//  CRM
//
//  Created by Argo Zhang on 15/11/25.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CRMHttpRespondModel;
@interface MyPatientTool : NSObject
/**
 *  获取患者是否绑定微信
 *
 *  @param patientName  患者姓名
 *  @param patientPhone 患者电话
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)getWeixinStatusWithPatientName:(NSString *)patientName patientPhone:(NSString *)patientPhone success:(void(^)(CRMHttpRespondModel *respondModel))success failure:(void(^)(NSError *error))failure;

/**
 *  发送预约信息到服务器
 *
 *  @param patientId      患者id
 *  @param clinic_name    诊所名称
 *  @param clinic_id      诊所id
 *  @param doctor_id      医生id
 *  @param appoint_time   预约时间
 *  @param duration       时长
 *  @param seat_price     椅位价格
 *  @param appoint_money  预约价格
 *  @param appoint_type   预约类型
 *  @param seat_id        椅位id
 *  @param tooth_position 牙位
 *  @param assist         助手数组
 *  @param material       材料数组
 *  @param success        成功回调
 *  @param failure        失败回调
 */
+ (void)postAppointInfoTuiSongClinic:(NSString *)patientId withClinicName:(NSString*)clinic_name withCliniId:(NSString*)clinic_id withDoctorId:(NSString*)doctor_id withAppointTime:(NSString *)appoint_time withDuration:(float)duration withSeatPrice:(float)seat_price withAppointMoney:(float)appoint_money withAppointType:(NSString *)appoint_type withSeatId:(NSString *)seat_id withToothPosition:(NSString *)tooth_position withAssist:(NSArray *)assist withMaterial:(NSArray *)material success:(void(^)(CRMHttpRespondModel *respondModel))success failure:(void(^)(NSError *error))failure;


@end
