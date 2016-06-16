//
//  DBManager+Patients.h
//  CRM
//
//  Created by TimTiger on 5/14/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "DBManager.h"

@class XLPatientTotalInfoModel;
@interface DBManager (Patients)

#pragma mark - Patient
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
- (NSArray *)getAllPatientWithPage:(int)page;

- (NSArray *)getAllPatientWithID:(NSString *)userid;

- (NSArray *)getPatientWithKeyWords:(NSString *)keyWord;

/**
 *  根据类型获取患者信息
 *
 *  @param userid 好友的id
 *  @param type   类型：（我转出去的，别人转给我的，修复的）
 *
 *  @return 患者数组
 */
- (NSArray *)getAllPatientWIthID:(NSString *)userid type:(NSString *)type;
/**
 *  根据类型获取患者的数量
 *
 *  @param userid 好友的id
 *  @param type   类型：（我转出去的，别人转给我的，修复的）
 *
 *  @return 数量
 */
- (NSInteger)getPatientCountWithID:(NSString *)userid type:(NSString *)type;

/**
 *  根据类型获取患者
 *
 *  @param status 患者状态
 *
 *  @return 患者数组
 */
- (NSArray *)getPatientsWithStatus:(PatientStatus )status page:(int)page;
/**
 *  根据类型和时间查询患者
 *
 *  @param status    患者状态 （已种植和已修复）
 *  @param startTime 开始时间 （种植时间或修复时间）
 *  @param endTime   结束时间 （种植时间或修复时间）
 *  @param cureDoctors 治疗医生
 *  @param page      分页
 *
 *  @return 患者数
 */
- (NSArray *)getPatientsWithStatus:(PatientStatus)status startTime:(NSString *)startTime endTime:(NSString *)endTime cureDoctors:(NSArray *)cureDoctors page:(int)page;
/**
 *  根据创建时间查询患者
 *
 *  @param startTime 开始时间
 *  @param endTime   结束时间
 *  @param page      页数
 *
 *  @return 患者数
 */
- (NSArray *)getPatientsWithStartTime:(NSString *)startTime endTime:(NSString *)endTime page:(int)page;
/**
 *  根据类型获取患者统计数量
 *
 *  @param status 患者状态
 *
 *  @return 患者数组
 */
- (int)getPatientsCountWithStatus:(PatientStatus )status;
/**
 *  判断这个患者是否存在
 *
 *  @param patient 患者
 *
 *  @return YES/NO
 */
- (BOOL)patientIsExist:(Patient *)patient;

/**
 *  获取患者总数
 *
 *  @return 患者总数
 */
- (NSInteger)getAllPatientCount;

/**
 *  获取患者信息
 *
 *  @param ckeyid 患者id
 *
 *  @return 患者信息
 */
- (Patient *)getPatientWithPatientCkeyid:(NSString *)ckeyid;
/**
 *  获取患者信息
 *
 *  @param ckeyid 患者id
 *
 *  @return 患者信息
 */
- (Patient *)getPatientCkeyid:(NSString *)ckeyid;


#pragma mark - PatientIntroducerMap
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
 *  插入一条Patient Introducer Map,同步时用到
 *
 *  @param PatientIntroducerMap 患者介绍人对应表
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)insertPatientIntroducerMap_Sync:(PatientIntroducerMap *)PatIntro;

/**
 *  更新患者介绍人对应表
 *
 *  @param PatientIntroducerMap 患者介绍人对应表
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)updatePatientIntroducerMap:(PatientIntroducerMap *)PatIntro;
/**
 *  更新患者介绍人对应表,同步时使用
 *
 *  @param PatientIntroducerMap 患者介绍人对应表
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)updatePatientIntroducerMap_Sync:(PatientIntroducerMap *)PatIntro;

/**
 *  插入一条patient Introducer Map
 *
 *  @param medicalCase 病例信息
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)insertMedicalCase:(MedicalCase *)medicalCase;

/**
 *  删除患者的关系数据
 *
 *  @param patientId 患者id
 *
 *  @return 成功YES 失败NO
 */
- (BOOL)deletePatientIntroducerMap:(NSString *)patientId;
/**
 *  删除指定的PatientIntroducerMap
 *
 *  @param patIntrMap PatientIntroducerMap
 *
 *  @return 是否删除成功
 */
- (BOOL)deletePatientIntroducerMapWithMap:(PatientIntroducerMap *)patIntrMap;

/**
 *  获取患者的转诊记录
 *
 *  @param patientId 患者id
 *
 *  @return 转诊记录数组
 */
- (NSArray *)getPatientTransferRecordWithPatientId:(NSString *)patientId;


#pragma mark - MedicalCase
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
//删除本地数据库中的病历数据（包括CT，耗材信息，病情描述信息）
- (BOOL)deleteMedicalCaseWithCase_AutoSync:(MedicalCase *)mCase;


#pragma mark - MedicalReserve
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


#pragma mark - PatientConsultation
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
/**
 *  获取会诊信息
 *
 *  @param ckeyid 会诊信息主键
 *
 *  @return 会诊信息
 */
- (PatientConsultation *)getPatientConsultationWithCkeyId:(NSString *)ckeyid;

//删除会诊信息
- (BOOL)deletePatientConsultationWithPatientId_sync:(NSString *)patientId;
/**
 *  删除单条会诊信息
 *
 *  @param ckeyId ckeyId
 *
 *  @return 是否删除成功
 */
- (BOOL)deletePatientConsultationWithCkeyId_sync:(NSString *)ckeyId;


#pragma mark - MedicalRecord
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

- (BOOL)deleteMedicalRecordWithCaseId_sync:(NSString *)caseid;

- (BOOL)deleteMedicalRecordWithId_Sync:(NSString *)medicalRecordId;

/**
 *  @brief 根据病例id获取病例记录
 *
 *  @param caseid 病例id
 *
 *  @return 病例记录数组
 */
- (NSArray *)getMedicalRecordWithCaseId:(NSString *)caseid;

- (MedicalRecord *)getMedicalRecordWithCkeyId:(NSString *)ckeyId;


#pragma mark - CTLib
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
//删除一条ct数据，然后自动上传
- (BOOL)deleteCTlibWithCTLib_AutoSync:(CTLib *)ctLib;
//获取ct片数据
- (CTLib *)getCTLibWithCKeyId:(NSString *)ckeyId;
//设置ct片为主ct
- (BOOL)setUpMainCT:(CTLib *)ctLib patientId:(NSString *)patientId;
//获取当前病历下的主ct片
- (NSArray *)getMainCTWithPatientId:(NSString *)patient_id;
//更新ct片
- (BOOL)updateMainCTLib:(CTLib *)ctLib;

/**
 *  获取CTLib中所有数据，也就是照片合集
 *
 *  @param medicalcaseid 病例id
 *  @param asc 是否是升序排列
 *
 *  @return CTLib 数组
 */
- (NSArray*)getCTLibArrayWithCaseId:(NSString *)medicalcaseid isAsc:(BOOL)asc;

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

/**
 *  保存患者的所有信息到数据库
 *
 *  @param infoModel 患者所有信息模型
 *
 *  @return 是否保存成功
 */
- (BOOL)saveAllDownloadPatientInfoWithPatientModel:(XLPatientTotalInfoModel *)model;

/**
 *  更新患者的状态
 *
 *  @param status    状态
 *  @param patientId 患者id
 *
 *  @return 是否更新成功
 */
- (BOOL)updatePatientStatus:(PatientStatus)status withPatientId:(NSString *)patientId;

@end
