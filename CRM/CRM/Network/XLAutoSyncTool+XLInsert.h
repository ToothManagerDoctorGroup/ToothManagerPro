//
//  XLAutoSyncTool+XLInsert.h
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
 *  自动同步insert数据
 */
@interface XLAutoSyncTool (XLInsert)

#pragma mark - Insert
#pragma mark -postAllNeedSyncPatient
/**
 *  上传所有新增加的患者信息
 *
 *  @param patient 患者信息
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)postAllNeedSyncPatient:(Patient *)patient success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;
#pragma mark -postAllNeedSyncMaterial
/**
 *  上传所有新增加的材料信息
 *
 *  @param material 材料信息
 *  @param success  成功回调
 *  @param failure  失败回调
 */
-(void)postAllNeedSyncMaterial:(Material *)material success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -postAllNeedSyncIntroducer
/**
 *  上传所有新增的的介绍人信息
 *
 *  @param introducer 介绍人信息
 *  @param success    成功回调
 *  @param failure    失败回调
 */
-(void)postAllNeedSyncIntroducer:(Introducer *)introducer success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;
#pragma mark -postAllNeedSyncPatientIntroducerMap
/**
 *  上传所有新增的介绍人患者的关系信息
 *
 *  @param patIntr 患者介绍人信息
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)postAllNeedSyncPatientIntroducerMap:(PatientIntroducerMap *)patIntr success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -postAllNeedSyncMedical_case
/**
 *  上传所有新增的病历信息
 *
 *  @param medical_case 病历信息
 *  @param success      成功回调
 *  @param failure      失败回调
 */
-(void)postAllNeedSyncMedical_case:(MedicalCase *)medical_case success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -postAllNeedSyncCt_lib
/**
 *  上传所有新增的ct片信息
 *
 *  @param ct_lib  ct片数据
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)postAllNeedSyncCt_lib:(CTLib *)ct_lib success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -postAllNeedSyncMedical_expense
/**
 *  上传所有新增的耗材信息
 *
 *  @param medical_expense 耗材信息
 *  @param success         成功回调
 *  @param failure         失败回调
 */
-(void)postAllNeedSyncMedical_expense:(MedicalExpense *)medical_expense success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -postAllNeedSyncMedical_record
/**
 *  上传所有新增的病历描述信息
 *
 *  @param medical_record 病历描述信息
 *  @param success        成功回调
 *  @param failure        失败回调
 */
-(void)postAllNeedSyncMedical_record:(MedicalRecord *)medical_record success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -postAllNeedSyncReserve_record
/**
 *  上传所有新增的预约信息
 *
 *  @param reserve_record 预约信息
 *  @param success        成功回调
 *  @param failure        失败回调
 */
-(void)postAllNeedSyncReserve_record:(LocalNotification *)reserve_record success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -postAllNeedSyncRepair_doctor
/**
 *  上传所有新增的修复医生的信息
 *
 *  @param repair_doctor 修复医生信息
 *  @param success       成功回调
 *  @param failure       失败回调
 */
-(void)postAllNeedSyncRepair_doctor:(RepairDoctor *)repair_doctor success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -postAllNeedSyncPatient_consultation
/**
 *  上传所有新增的患者会诊信息
 *
 *  @param patient_consultation 患者会诊信息
 *  @param success              成功回调
 *  @param failure              失败回调
 */
-(void)postAllNeedSyncPatient_consultation:(PatientConsultation *)patient_consultation success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

@end
