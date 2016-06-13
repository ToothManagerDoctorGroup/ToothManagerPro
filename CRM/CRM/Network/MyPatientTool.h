//
//  MyPatientTool.h
//  CRM
//
//  Created by Argo Zhang on 15/11/25.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CRMHttpRespondModel,XLPatientTotalInfoModel,XLAppointImageUploadParam;
@interface MyPatientTool : NSObject

/**
 *  获取患者的keyid(用于二维码页面)
 *
 *  @param ckeyid  患者的ckeyid
 *  @param success 成功回调
 *  @param failure 失败回调
 *
 */
+ (void)getPateintKeyIdWithPatientCKeyId:(NSString *)ckeyid success:(void(^)(CRMHttpRespondModel *respondModel))success failure:(void(^)(NSError *error))failure;

/**
 *  获取患者下所有的信息包括ct片，会诊信息等数据
 *
 *  @param patientId 患者id
 *  @param doctorId  医生id
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)getPatientAllInfosWithPatientId:(NSString *)patientId doctorID:(NSString *)doctorId success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure;

/**
 *  获取患者是否绑定微信
 *
 *  @param patientName  患者姓名
 *  @param patientPhone 患者电话
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)getWeixinStatusWithPatientId:(NSString *)patientId success:(void(^)(CRMHttpRespondModel *respondModel))success failure:(void(^)(NSError *error))failure;

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

/**
 *  上传预约所需图片
 *
 *  @param param   参数模型
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)uploadAppointmentImageWithParam:(XLAppointImageUploadParam *)param imageData:(NSData *)imageData success:(void(^)(CRMHttpRespondModel *respondModel))success failure:(void(^)(NSError *error))failure;

/**
 *  获取患者CT的状态
 *
 *  @param ckeyIds CTLib的id，中间用“，”隔开
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getPatientCTStatusCTCkeyIds:(NSString *)ckeyIds success:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure;

@end

@interface XLPatientCTStatusModel : NSObject

@property (nonatomic, copy)NSString *ckeyid;
/**
 *  文件状态 -1=异常，0=正常，1=数据库无记录，2=有记录没文件
 */
@property (nonatomic, assign)NSInteger fileStatus;

@end
