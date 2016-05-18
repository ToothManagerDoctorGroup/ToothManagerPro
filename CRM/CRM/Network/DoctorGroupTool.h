//
//  DoctorGroupTool.h
//  CRM
//
//  Created by Argo Zhang on 15/12/9.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupEntity.h"
#import "GroupMemberEntity.h"
#import "CRMHttpRespondModel.h"
#import "XLQueryModel.h"

/**
 *  批量删除分组下患者时所用到的模型
 */
@interface GroupAndPatientParam : NSObject

@property (nonatomic, copy)NSString *groupIds;
@property (nonatomic, copy)NSString *patientIds;

@end

@interface DoctorGroupTool : NSObject
/**
 *  获取分组中每个医生的所有患者列表信息
 *
 *  @param doctorId 医生id
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)getGroupPatientsWithDoctorId:(NSString *)doctorId success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;
/**
 *  分页获取医生下所有的患者信息(不包括所传分组里的患者信息)
 *
 *  @param doctorId   医生id
 *  @param groupId   分组id
 *  @param queryModel 分页模型
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)getGroupPatientsWithDoctorId:(NSString *)doctorId groupId:(NSString *)groupId queryModel:(XLQueryModel *)queryModel success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;

/**
 *  获取当前医生所有患者的基本信息
 *
 *  @param doctorId 医生id
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)getPatientsWithDoctorId:(NSString *)doctorId success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;
/**
 *  获取医生所有的介绍人信息
 *
 *  @param doctorId 医生id
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)getIntroducersWithDoctorId:(NSString *)doctorId success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;
/**
 *  获取患者的所有种植信息
 *
 *  @param patientIdStr 患者id，可以传多个，以“,”隔开
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)getMedicalExpensesWithPatientIdStr:(NSString *)patientIdStr success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;

/**
 *  查询指定医生下的分组(如果传了患者的id，则查询当前医生下指定患者所在的所有分组)
 *
 *  @param doctorId 医生id
 *  @param ckId     分组的id（选填）
 *  @param patient_id 患者的id（选填）
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)getGroupListWithDoctorId:(NSString *)doctorId ckId:(NSString *)ckId patientId:(NSString *)patient_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;
/**
 *  添加一个医生分组
 *
 *  @param dataEntity 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)addNewGroupWithGroupEntity:(GroupEntity *)dataEntity success:(void (^)(CRMHttpRespondModel *respondModel))success failure:(void (^)(NSError *error))failure;
/**
 *  修改一个医生分组
 *
 *  @param dataEntity 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)updateGroupWithGroupEntity:(GroupEntity *)dataEntity success:(void (^)(CRMHttpRespondModel *respondModel))success failure:(void (^)(NSError *error))failure;
/**
 *  删除分组
 *
 *  @param ckId    主键id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)deleteGroupWithCkId:(NSString *)ckId success:(void (^)(CRMHttpRespondModel *respondModel))success failure:(void (^)(NSError *error))failure;
/**
 *  查询指定分组的所有成员
 *
 *  @param ckId    主键id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)queryGroupMembersWithCkId:(NSString *)ckId success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;

/**
 *  分页获取分组下患者的信息
 *
 *  @param doctorId   患者的id
 *  @param queryModel 分页以及模糊查询的模型
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)queryGroupMembersWithCkId:(NSString *)ckId queryModel:(XLQueryModel *)queryModel success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;

/**
 *  查询指定分组的详细信息（查询指定医生下指定患者所在分组的详细信息）
 *
 *  @param doctorId  医生id
 *  @param patientId 患者id
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)queryGroupDetailsWithDoctorId:(NSString *)doctorId patientId:(NSString *)patientId success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;
/**
 *  分组下新增患者
 *
 *  @param dataEntitys 参数模型数组
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)addGroupMemberWithGroupMemberEntity:(NSArray *)dataEntitys success:(void (^)(CRMHttpRespondModel *respondModel))success failure:(void (^)(NSError *error))failure;
/**
 *  将患者插入多个分组
 *
 *  @param jsonData 患者数据
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)addPateintToGroupsWithGroupMemberEntity:(NSString *)jsonData success:(void (^)(CRMHttpRespondModel *respondModel))success failure:(void (^)(NSError *error))failure;
/**
 *  分组下删除患者
 *
 *  @param ckId    患者主键
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)deleteGroupMemberWithCkId:(NSString *)ckId groupId:(NSString *)groupid success:(void (^)(CRMHttpRespondModel *respondModel))success failure:(void (^)(NSError *error))failure;
/**
 *  分组下批量删除患者
 *
 *  @param param   参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)deleteGroupMemberWithModel:(GroupAndPatientParam *)param success:(void (^)(CRMHttpRespondModel *respondModel))success failure:(void (^)(NSError *error))failure;

@end
