//
//  DBManager+Introducer.h
//  CRM
//
//  Created by TimTiger on 5/14/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "DBManager.h"

@interface DBManager (Introducer)
#pragma mark - IntroducerTableName

/*
 *@brief 插入一条介绍人数据 到介绍人表中
 *@param material 数据
 */
- (BOOL)insertIntroducer:(Introducer *)introducer;

/**
 *  批量插入介绍人
 *
 *  @param array 介绍人数组
 *
 *  @return 成功YES，失败NO
 */
- (BOOL)insertIntroducersWithArray:(NSArray *)array;

/**
 *  更新一条介绍人信息
 *
 *  @param introducer 介绍人信息
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)updateIntroducer:(Introducer *)introducer;

/**
 *  删除一条介绍人信息
 *
 *  @param introducerId 介绍人id
 *
 *  @return 成功yes，失败no
 */
- (BOOL)deleteIntroducerWithId:(NSString *)introducerId;
- (BOOL)deleteIntroducerWithId_sync:(NSString *)introducerId;

/**
 *  根据电话查询介绍人是否已经存在
 *
 *  @param phone 电话号码
 *
 *  @return YES，OR no
 */
- (BOOL)isInIntroducerTable:(NSString *)phone;

/*
 *@brief 获取患者表中全部患者
 *@return NSArray 返回患者数组，没有则为nil
 */
- (NSArray *)getAllIntroducerWithPage:(int)page;

/**
 *  获取本地介绍人数据
 *
 *  @param page 页码
 *
 *  @return 介绍人数组
 */
- (NSArray *)getLocalIntroducerWithPage:(int)page;

/**
 *  根据介绍人姓名模糊查询
 *
 *  @param name 介绍人姓名
 *
 *  @return 介绍人数组
 */
- (NSArray *)getIntroducerByName:(NSString *)name;
/**
 *  获取介绍人总数
 *
 *  @return 介绍人总数
 */
- (NSInteger)getIntroducerAllCount;
/**
 *  获取介绍人介绍的病人个数
 *
 *  @param introducerId 介绍人id
 *
 *  @return 个数
 */
- (NSInteger)numberIntroducedWithIntroducerId:(NSString *)introducerId;

/**
 *  @brief 根据介绍人id 查询患者表
 *  @param patientId 患者id
 *  @return 患者数组
 */
- (NSArray *)getPatientByIntroducerId:(NSString *)introducerId;

/**
 *  @brief 根据患者id 查询MedicalCaseTableName表
 *  @param patientId 患者id
 *  @return 患者对象
 */
- (MedicalCase *)getMedicalCaseByPatientId:(NSString *)patientId;


- (PatientIntroducerMap *)getPatientIntroducerMapByPatientId:(NSString *)patientId;
- (PatientIntroducerMap *)getPatientIntroducerMapByPatientId:(NSString *)patientId doctorId:(NSString *)doctorId intrId:(NSString *)intrId;
- (Introducer *)getIntroducerByCkeyId:(NSString *)ckeyId;
- (Introducer *)getIntroducerByIntrid:(NSString *)intrId;

/**
 *  获取患者的介绍人信息
 *
 *  @param patientId 患者id
 *
 *  @return 介绍人姓名
 */
- (NSString *)getPatientIntrNameWithPatientId:(NSString *)patientId;
@end
