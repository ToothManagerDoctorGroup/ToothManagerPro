//
//  DBManager+Patients.h
//  CRM
//
//  Created by TimTiger on 5/14/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "DBManager.h"

@interface DBManager (Patients)

/*
 *@brief 插入一条患者数据 到患者表中
 *@param patient 数据
 */
- (BOOL)insertPatient:(Patient *)patient;

- (BOOL)insertPatientBySync:(Patient *)patient;

- (BOOL)updateUpdateDate:(NSString *)patientId;
/**
 *  批量录入患者
 *
 *  @param array 患者数组
 *
 *  @return 成功yes,失败NO
 */
- (BOOL)insertPatientsWithArray:(NSArray *)array;

/**
 *  更新患者信息
 *
 *  @param patient 患者信息
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)updatePatient:(Patient *)patient;

- (BOOL)updatePatientBySync:(Patient *)patient;
/*
 *@brief 删除一条患者的数据
 *@param patient_id 患者KeyID
 */
- (BOOL)deletePatientByPatientID:(NSString *)patient_id;
- (BOOL)deletePatientByPatientID_sync:(NSString *)patient_id;

/**
 *  判断一个通讯录用户是否已经导入成了患者
 *
 *  @param phone 号码
 *
 *  @return YES, NO
 */
- (BOOL)isInPatientsTable:(NSString*)phone;
/*
 *@brief 获取患者表中全部患者
 *@return NSArray 返回患者数组，没有则为nil
 */
- (NSArray *)getAllPatient;

- (NSArray *)getAllPatientWithID:(NSString *)userid;

/**
 *  根据类型获取患者
 *
 *  @param status 患者状态
 *
 *  @return 患者数组
 */
- (NSArray *)getPatientsWithStatus:(PatientStatus )status;

/**
 *  获取患者信息
 *
 *  @param ckeyid 患者id
 *
 *  @return 患者信息
 */
- (Patient *)getPatientWithPatientCkeyid:(NSString *)ckeyid;

/*
 *@brief 通过患者表的introducer_id 获取介绍人表的信息
 *@return NSArray 返回患者数组，没有则为nil
 */
- (Introducer *)getIntroducerByIntroducerID:(NSString *)introducerId;

/**
 *  插入一条Patient Introducer Map
 *
 *  @param PatientIntroducerMap 患者介绍人对应表
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)insertPatientIntroducerMap:(PatientIntroducerMap *)PatIntro;

/**
 *  更新患者介绍人对应表
 *
 *  @param PatientIntroducerMap 患者介绍人对应表
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)updatePatientIntroducerMap:(PatientIntroducerMap *)PatIntro;

/**
 *  插入一条atient Introducer Map
 *
 *  @param medicalCase 病例信息
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)insertMedicalCase:(MedicalCase *)medicalCase;

/**
 *  更新病例
 *
 *  @param medicalCase 病例
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)updateMedicalCase:(MedicalCase *)medicalCase;

/**
 *  更具病例id获取病例
 *
 *  @param caseid 病例id
 *
 *  @return 病例
 */
- (MedicalCase *)getMedicalCaseWithCaseId:(NSString *)caseid;

- (BOOL)deleteMedicalCaseWithCaseId:(NSString *)caseid;

- (BOOL)deleteMedicalCaseWithPatientId:(NSString *)patientId;
- (BOOL)deleteMedicalCaseWithPatientId_sync:(NSString *)patientId;
- (BOOL)deleteMedicalExpenseWithCaseId_sync:(NSString *)caseid;

/**
 *  插入一条MedicalReserve
 */
- (BOOL)insertMedicalReserve:(MedicalReserve *)medicalReserve;

/**
 *  更新一条MedicalReserve
 *
 *  @param medicalReserve 预约记录
 *
 *  @return 成功yes,失败NO
 */
- (BOOL)updateMedicalReserve:(MedicalReserve *)medicalReserve;

/**
 *  获取病例预约信息
 *
 *  @param caseid 病例id
 *
 *  @return 病例信息
 */
- (MedicalReserve *)getMedicalReserveWithCaseId:(NSString *)caseid;

- (BOOL)deleteMedicalReservesWithPatientId:(NSString *)patientId;

- (BOOL)deleteMedicalReserveWithCaseId:(NSString *)caseid;


/**
 *  插入一条会诊信息
 *
 *  @param patientConsultation 会诊信息
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)insertPatientConsultation:(PatientConsultation *)patientConsultation;

/**
 *  更新一条会诊信息
 *
 *  @param patientConsultation 会诊信息
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)updatePatientConsultation:(PatientConsultation *)patientConsultation;

/**
 *  @brief 根据患者id获取会诊信息
 *
 *  @param patientId
 *
 *  @return 会诊信息数组
 */
- (NSArray *)getPatientConsultationWithPatientId:(NSString *)patientId;

//删除会诊信息
- (BOOL)deletePatientConsultationWithPatientId_sync:(NSString *)patientId;


/**
 *  插入一条病例记录
 *
 *  @param medicalRecord 病例记录信息
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)insertMedicalRecord:(MedicalRecord *)medicalRecord;

/**
 *  更新一条病例记录
 *
 *  @param medicalRecord 病例记录信息
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)updateMedicalRecord:(MedicalRecord *)medicalRecord;

/**
 *  删除一条病例记录
 *
 *  @param medicalRecordId 记录id
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)deleteMedicalRecordWithId:(NSString *)medicalRecordId;

- (BOOL)deleteMedicalRecordsWithPatientId:(NSString *)patientId;

- (BOOL)deleteMedicalRecordWithCaseId:(NSString *)caseid;

- (BOOL)deleteMedicalRecordWithId_Sync:(NSString *)medicalRecordId;

/**
 *  @brief 根据病例id获取病例记录
 *
 *  @param caseid 病例id
 *
 *  @return 病例记录数组
 */
- (NSArray *)getMedicalRecordWithCaseId:(NSString *)caseid;

/**
 *  插入一条CT记录
 *
 *  @param ctlib CT信息
 *
 *  @return 返回新插入信息的keyid
 */
- (BOOL)insertCTLib:(CTLib *)ctlib;

/**
 *  删除一条CTlib记录
 *
 *  @param libid ctLIb id
 *
 *  @return 成功yes ,失败NO
 */
- (BOOL)deleteCTlibWithLibId:(NSString *)libid;

- (BOOL)deleteCTlibWithCaseId:(NSString *)caseId;

- (BOOL)deleteCTlibWithPatientId:(NSString *)patientId;

- (BOOL)deleteCTlibWithLibId_sync:(NSString *)libid;

/**
 *  获取CTLib中所有数据，也就是照片合集
 *
 *  @param medicalcaseid 病例id
 *
 *  @return CTLib 数组
 */
- (NSArray*)getCTLibArrayWithCaseId:(NSString *)medicalcaseid;

/**
 *  获取CTLib 数据
 *
 *  @param PatientId 患者id
 *
 *  @return ctblib 数组
 */
- (NSArray *)getCTLibArrayWithPatientId:(NSString *)PatientId;

/**
 *  获取患者的病例
 *
 *  @param patientid 患者id
 *
 *  @return 病例数组
 */
- (NSArray *)getMedicalCaseArrayWithPatientId:(NSString *)patientid;

/**
 *  获取患者的就诊记录
 *
 *  @param patientid 患者id
 *  @param caseid 病例号
 *  @return 病例数组
 */
- (NSArray *)getMedicalRecordByPatientId:(NSString *)patientid AndCaseId:(NSString *)caseid;


@end
