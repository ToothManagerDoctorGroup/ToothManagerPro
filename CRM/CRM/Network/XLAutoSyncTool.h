//
//  XLAutoSyncTool.h
//  CRM
//
//  Created by Argo Zhang on 15/12/28.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonMacro.h"
#import "DBTableMode.h"
#import "CRMHttpRespondModel.h"
#import "LocalNotificationCenter.h"

#define AddReserveType @"新增预约"
#define CancelReserveType @"取消预约"
#define UpdateReserveType @"修改预约"

#define POST_COMMONURL ([NSString stringWithFormat:@"%@%@/%@/SyncPost.ashx",DomainName,Method_His_Crm,Method_Ashx])
#define POST_PATIENT_INTRODUCERMAP_INSERT [NSString stringWithFormat:@"%@%@/%@/PatientIntroducerMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx]
/**
 *  自动同步Edit数据
 */
@interface XLAutoSyncTool : NSObject
Declare_ShareInstance(XLAutoSyncTool);

- (NSMutableDictionary *)addCommenParams:(NSMutableDictionary *)params;

#pragma mark - Edit
#pragma mark -editAllNeedSyncPatient
/**
 *  上传所有的修改后的患者信息
 *
 *  @param patient 患者信息
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)editAllNeedSyncPatient:(Patient *)patient success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;
#pragma mark -editAllNeedSyncMaterial
/**
 *  上传所有修改后的材料信息
 *
 *  @param material 材料信息
 *  @param success  成功回调
 *  @param failure  失败回调
 */
-(void)editAllNeedSyncMaterial:(Material *)material success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -editAllNeedSyncIntroducer
/**
 *  上传所有修改后的介绍人信息
 *
 *  @param introducer 介绍人信息
 *  @param success    成功回调
 *  @param failure    失败回调
 */
-(void)editAllNeedSyncIntroducer:(Introducer *)introducer success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;
#pragma mark -editAllNeedSyncMedical_case
/**
 *  上传所有修改后病历信息
 *
 *  @param medical_case 病历信息
 *  @param success      成功回调
 *  @param failure      失败回调
 */
-(void)editAllNeedSyncMedical_case:(MedicalCase *)medical_case success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -editAllNeedSyncCt_lib
/**
 *  上传所有修改后的ct片的数据
 *
 *  @param ct_lib  ct片的数据
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)editAllNeedSyncCt_lib:(CTLib *)ct_lib success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -editAllNeedSyncMedical_expense
/**
 *  上传所有修改后的耗材信息
 *
 *  @param medical_expense 耗材信息
 *  @param success         成功回调
 *  @param failure         失败回调
 */
-(void)editAllNeedSyncMedical_expense:(MedicalExpense *)medical_expense success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;
#pragma mark -editAllNeedSyncMedical_record
/**
 *  上传所有修改后的病历记录信息
 *
 *  @param medical_record 病历记录信息
 *  @param success        成功回调
 *  @param failure        失败回调
 */
-(void)editAllNeedSyncMedical_record:(MedicalRecord *)medical_record success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -editAllNeedSyncReserve_record
/**
 *  上传所有修改后的预约信息
 *
 *  @param reserve_record 预约信息
 *  @param success        成功回调
 *  @param failure        失败回调
 */
-(void)editAllNeedSyncReserve_record:(LocalNotification *)reserve_record success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -editAllNeedSyncRepair_Doctor
/**
 *  上传所有修改后的修复医生的信息
 *
 *  @param repair_doctor 修复医生信息
 *  @param success       成功回调
 *  @param failure       失败回调
 */
-(void)editAllNeedSyncRepair_Doctor:(RepairDoctor *)repair_doctor success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

#pragma mark -editAllNeedSyncPatient_consultation
/**
 *  上传所有修改后的会诊信息
 *
 *  @param patient_consultation 会诊信息
 *  @param success              成功回调
 *  @param failure              失败回调
 */
-(void)editAllNeedSyncPatient_consultation:(PatientConsultation *)patient_consultation success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

@end
