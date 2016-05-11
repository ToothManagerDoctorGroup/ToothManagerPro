//
//  XLAutoSyncTool+XLDelete.h
//  CRM
//
//  Created by Argo Zhang on 15/12/28.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLAutoSyncTool.h"
#import "CommonMacro.h"
#import "DBTableMode.h"
#import "CRMHttpRespondModel.h"
#import "LocalNotificationCenter.h"

/**
 *  自动同步delete数据
 */
@interface XLAutoSyncTool (XLDelete)

#pragma mark - delete
#pragma mark -deleteAllNeedSyncPatient
/**
 *  上传所有删除的患者信息
 *
 *  @param patient 患者信息
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)deleteAllNeedSyncPatient:(Patient *)patient success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -deleteAllNeedSyncMaterial
/**
 *  上传所有删除的材料数据
 *
 *  @param material 材料数据
 *  @param success  成功回调
 *  @param failure  失败回调
 */
-(void)deleteAllNeedSyncMaterial:(Material *)material success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -deleteAllNeedSyncIntroducer
/**
 *  上传所有删除的介绍人信息
 *
 *  @param introducer 介绍人信息
 *  @param success    成功回调
 *  @param failure    失败回调
 */
-(void)deleteAllNeedSyncIntroducer:(Introducer *)introducer success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -deleteAllNeedSyncMedical_case
/**
 *  上传所有删除的病历信息
 *
 *  @param medical_case 病历信息
 *  @param success      成功回调
 *  @param failure      失败回调
 */
-(void)deleteAllNeedSyncMedical_case:(MedicalCase *)medical_case success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -deleteAllNeedSyncCt_lib
/**
 *  上传所有删除的ct片信息
 *
 *  @param ct_lib  ct片信息
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)deleteAllNeedSyncCt_lib:(CTLib *)ct_lib success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -deleteAllNeedSyncMedical_expense
/**
 *  上传所有删除的耗材信息
 *
 *  @param medical_expense 耗材信息
 *  @param success         成功回调
 *  @param failure         失败回调
 */
-(void)deleteAllNeedSyncMedical_expense:(MedicalExpense *)medical_expense success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -deleteAllNeedSyncMedical_record
/**
 *  上传所有删除的病历记录信息
 *
 *  @param medical_record 病历记录信息
 *  @param success        成功回调
 *  @param failure        失败回调
 */
-(void)deleteAllNeedSyncMedical_record:(MedicalRecord *)medical_record success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -deleteAllNeedSyncReserve_record
/**
 *  上传所有删除的预约信息
 *
 *  @param reserve_record 预约信息
 *  @param success        成功回调
 *  @param failure        失败回调
 */
-(void)deleteAllNeedSyncReserve_record:(LocalNotification *)reserve_record success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -deleteAllNeedSyncRepair_doctor
/**
 *  上传所有删除的修复医生的信息
 *
 *  @param repair_doctor 修复医生信息
 *  @param success       成功回调
 *  @param failure       失败回调
 */
-(void)deleteAllNeedSyncRepair_doctor:(RepairDoctor *)repair_doctor success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -deleteAllNeedSyncPatient_consultation
/**
 *  上传所有删除的患者就诊信息
 *
 *  @param patient_consultation 就诊信息
 *  @param success              成功回调
 *  @param failure              失败回调
 */
-(void)deleteAllNeedSyncPatient_consultation:(PatientConsultation *)patient_consultation success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

@end
