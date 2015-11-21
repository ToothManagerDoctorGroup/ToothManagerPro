//
//  DBManager+RepairDoctor.h
//  CRM
//
//  Created by doctor on 15/4/24.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "DBManager.h"

@interface DBManager (RepairDoctor)

/*
 *@brief 插入一条修复医生数据 到修复医生表中
 *@param material 数据
 */
- (BOOL)insertRepairDoctor:(RepairDoctor *)doctorobj;

/**
 *  更新一条修复医生信息
 *
 *  @param repairDoctor 修复医生信息
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)updateRepairDoctor:(RepairDoctor *)doctorobj;

/**
 *  删除一条修复医生信息
 *
 *  @param userobj 医生信息
 *
 *  @return 是否成功
 */
- (BOOL)deleteRepairDoctorWithCkeyId:(NSString *)doctorobj;
- (BOOL)deleteRepairDoctorWithCkeyId_sync:(NSString *)user_id;

/**
 *  获取一条医生信息
 *
 *  @param userobj 医生id
 *
 *  @return 医生信息
 */
- (RepairDoctor *)getRepairDoctorWithCkeyId:(NSString *)user_id;



/*
 *@brief 获取修复医生表中全部修复医生
 *@return NSArray 返回患者数组，没有则为nil
 */
- (NSArray *)getAllRepairDoctor;

/**
 *  获取修复医生修复的病人个数
 *
 *  @param introducerId 介绍人id
 *
 *  @return 个数
 */
- (NSInteger)numberPatientsWithRepairDoctorId:(NSString *)repairDoctorId;

/**
 *  @brief 根据修复医生id 查询患者表
 *  @param patientId 患者id
 *  @return 患者数组
 */
- (NSArray *)getPatientByRepairDoctorId:(NSString *)repairDoctorId;

- (BOOL)isInRepairDoctorTable:(NSString *)phone;

@end
