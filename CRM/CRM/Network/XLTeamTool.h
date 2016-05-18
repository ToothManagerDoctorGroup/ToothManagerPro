//
//  XLTeamTool.h
//  CRM
//
//  Created by Argo Zhang on 16/3/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  团队协作网络工具
 */
@class XLTeamMemberParam,CRMHttpRespondModel,MedicalCase,XLCureProjectParam,XLCureProjectModel,XLTeamPatientModel,XLCureCountModel;
@interface XLTeamTool : NSObject
//-------------------------病历相关----------------------------------
/**
 *  创建病历
 *
 *  @param mCase   病历模型
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)addMedicalCaseWithMCase:(MedicalCase *)mCase success:(void (^)(MedicalCase *resultCase))success failure:(void (^)(NSError *error))failure;
/**
 *  查询患者下的所有病历
 *
 *  @param patient_id 患者id
 *  @param success    成功回调
 *  @param failure    失败回调
*/
+ (void)queryMedicalCasesWithPatientId:(NSString *)patient_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;
/**
 *  查找患者下所有病历相关信息（包含治疗团队，治疗方案，预约记录，病程记录，使用耗材）
 *
 *  @param patient_id 患者id
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)queryMedicalCasesDetailWithPatientId:(NSString *)patient_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;
//-------------------------治疗团队相关----------------------------------
/**
 *  新增治疗团队成员
 *
 *  @param param   参数模型
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)addTeamMemberWithParam:(XLTeamMemberParam *)param success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;
/**
 *  批量添加治疗团队成员
 *
 *  @param array   数组
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)addTeamMemberWithArray:(NSArray *)array success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

/**
 *  移除治疗团队成员
 *
 *  @param member_id 成员id
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)removeTeamMemberWithMemberId:(NSNumber *)member_id success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;
/**
 *  批量移除治疗团队成员
 *
 *  @param ids     团队成员的id，中间以“,”隔开
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)removeTeamMemberWithIds:(NSString *)ids success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;
/**
 *  修改昵称
 *
 *  @param param   参数模型
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)editNickNameWithParam:(XLTeamMemberParam *)param success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;
/**
 *  查询指定病历下的团队成员
 *
 *  @param case_id 病历id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)queryMedicalCaseMembersWithCaseId:(NSString *)case_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;

//-------------------------治疗方案相关----------------------------------
/**
 *  创建治疗方案
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)addNewCureProWithParam:(XLCureProjectParam *)param success:(void (^)(XLCureProjectModel *model))success failure:(void (^)(NSError *error))failure;
/**
 *  删除治疗方案
 *
 *  @param keyId   主键
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)deleteCureProWithKeyId:(NSString *)keyId success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;
/**
 *   修改治疗方案
 *
 *  @param model   模型
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)editNewCureProWithModel:(XLCureProjectModel *)model success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;
/**
 *  查询指定病历下的所有治疗方案
 *
 *  @param case_id 病历id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)queryCureProsWithCaseId:(NSString *)case_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;


//-------------------------病程记录相关----------------------------------
/**
 *  查询指定病历下的病程记录
 *
 *  @param case_id 病历id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)queryAllDiseaseRecordWithCaseId:(NSString *)case_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;

//----------------------------耗材相关----------------------------------
/**
 *  查询指定病历下的所有耗材信息
 *
 *  @param case_id 病历id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)queryAllExpensesWithCaseId:(NSString *)case_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;


//----------------------------医生详情相关----------------------------------
/**
 *  获取转入/转出的患者信息
 *      转出的患者（我转给TA的，介绍人是我，接受人是TA）
 *      转入的患者（TA转给我的，接受人是我，介绍人是TA）
 *
 *  @param doctor_id 医生id
 *  @param intr_id   介绍人id
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)queryTransferPatientsWithDoctorId:(NSString *)doctor_id intrId:(NSString *)intr_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;
/**
 *  获取我治疗的患者
 *      治疗我的患者（我邀请TA治疗的患者）
 *      治疗别人的患者（TA邀请我治疗的患者）
 *
 *  @param doctor_id         首诊医生id
 *  @param therapt_doctor_id 治疗医生的id
 *  @param success           成功回调
 *  @param failure           失败回调
 */
+ (void)queryJoinTreatePatientsWithDoctorId:(NSString *)doctor_id theraptDocId:(NSString *)therapt_doctor_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;
/**
 *  查询所有不同类型患者的数量
 *
 *  @param doctor_id         当前医生的id
 *  @param therapt_doctor_id 治疗医生的id
 *  @param success           成功回调
 *  @param failure           失败回调
 */
+ (void)queryAllCountOfPatientWithDoctorId:(NSString *)doctor_id theraptDocId:(NSString *)therapt_doctor_id success:(void (^)(XLCureCountModel *model))success failure:(void (^)(NSError *error))failure;

//----------------------------团队协作相关----------------------------------
/**
 *  查询我参与会诊的所有患者信息
 *
 *  @param doctor_id 医生的id
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)queryJoinConsultationPatientsWithDoctorId:(NSString *)doctor_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;
/**
 *   查询我合作治疗的所有患者信息
 *
 *  @param doctor_id 医生id
 *  @param status    类型（-1表示查询所有，(0:待处理，1:待付款，3:已付款)）
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)queryJoinOtherCurePatientsWithDoctorId:(NSString *)doctor_id status:(NSNumber *)status success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;
@end
