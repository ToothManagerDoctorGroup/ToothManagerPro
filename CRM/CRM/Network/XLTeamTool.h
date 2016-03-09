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
@class XLTeamMemberParam,CRMHttpRespondModel,MedicalCase,XLCureProjectParam,XLCureProjectModel;
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

@end