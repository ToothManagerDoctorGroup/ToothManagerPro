//
//  DBManager+Materials.h
//  CRM
//
//  Created by TimTiger on 5/14/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "DBManager.h"


@interface DBManager (Materials)

#pragma mark - MaterialTableName

/*
 *@brief 插入一条耗材数据 到耗材表中
 *@param material 数据
 */
- (BOOL)insertMaterial:(Material *)material;

/*
 *@brief 获取耗材库中全部耗材
 *@return NSArray 返回耗材数组，没有则为nil
 */
- (NSArray *)getAllMaterials;

/*
 *@brief 获取耗材库中的耗材
 *@param type 耗材类型
 *@param min/max 价格区间
 *@return NSArray 返回耗材数组，没有则为nil
 */
- (NSArray *)getMaterialArrayWithType:(MaterialType)type minPrice:(CGFloat)min maxPrice:(CGFloat)max;

/**
 *  @brief 根据耗材id获取耗材信息
 *  @param mid 耗材id
 *  @return 耗材类
 */
- (Material *)getMaterialWithId:(NSString *)mid;

/**
 *  @brief 通过耗材id找到患者们
 */
- (NSArray *)getPatientByMaterialId:(NSString *)materialId;

/**
 *  @brief 根据耗材id删除一件耗材
 *  @param mid 耗材id
 *  @return 成功返回YES,失败返回NO
 */
- (BOOL)deleteMaterialWithId:(NSString *)mid;

- (BOOL)deleteMaterialWithId_sync:(NSString *)mid;

/**
 *  获取单个患者种植体消耗个数
 *
 *  @param patientId 患者id
 *
 *  @return 个数
 */
- (NSInteger)numberMaterialsExpenseWithPatientId:(NSString *)patientId;

#pragma mark - Medical_expense

/**
 *  @brief 插入一条消耗记录
 *  @param expense 消耗记录mode
 *  @return 成功返回YES,失败返回NO
 */
- (BOOL)insertMedicalExpenseWith:(MedicalExpense *)expense;

/**
 *  更新一条消耗记录
 *
 *  @param expense 消耗记录
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)updateMedicalExpenseWith:(MedicalExpense *)expense;

/**
 *  删除一条消耗记录
 *
 *  @param expenseId 消耗记录id
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)deleteMedicalExpenseWithId:(NSString *)expenseId;

- (BOOL)deleteMedicalExpenseWithCaseId:(NSString *)caseid;

- (BOOL)deleteMedicalExpenseWithPatientId:(NSString *)patientId;

- (BOOL)deleteMedicalExpenseWithPatientId_sync:(NSString *)patientId;

- (BOOL)deleteMedicalExpenseWithId_sync:(NSString *)expenseId;

/**
 *  @brief 根据患者id 查询消耗（MedicalExpense）
 *  @param patientId 患者id
 *  @return 消耗数组(MedicalExpense组成的数组)
 */
- (NSArray *)getMedicalExpenseArrayWithPatientId:(NSString *)patientId;

/**
 *  @brief 根据病例id 查询消耗（MedicalExpense）
 *  @param patientId 患者id
 *  @return 消耗数组(MedicalExpense组成的数组)
 */
- (NSArray *)getMedicalExpenseArrayWithMedicalCaseId:(NSString *)caseId;

/**
 *  获取耗材信息
 *
 *  @param ckeyId 主键
 *
 *  @return 耗材信息
 */
- (MedicalExpense *)getMedicalExpenseWithCkeyId:(NSString *)ckeyId;
/**
 *  判断耗材信息是否存在
 *
 *  @param materialName 材料的名称
 *
 *  @return 存在（yes） 不存在（no）
 */
- (BOOL)materialIsExistWithMaterialName:(NSString *)materialName;

@end
