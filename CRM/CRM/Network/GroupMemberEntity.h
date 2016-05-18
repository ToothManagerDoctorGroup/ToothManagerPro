//
//  GroupMemberEntity.h
//  CRM
//
//  Created by Argo Zhang on 15/12/9.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  新增组员的参数模型
 */
@interface GroupMemberEntity : NSObject

/**
 *  分组名称
 */
@property (nonatomic, copy)NSString *group_name;
/**
 *  组id
 */
@property (nonatomic, copy)NSString *group_id;
/**
 *  医生id
 */
@property (nonatomic, strong)NSString *doctor_id;
/**
 *  患者id
 */
@property (nonatomic, copy)NSString *patient_id;
/**
 *  患者名称
 */
@property (nonatomic, copy)NSString *patient_name;
/**
 *  主键
 */
@property (nonatomic, copy)NSString *ckeyid;
/**
 *  同步时间
 */
@property (nonatomic, copy)NSString *sync_time;
/**
 *  创建日期
 */
@property (nonatomic, copy)NSString *creation_time;
/**
 *  存储标识
 */
@property (nonatomic, assign)int data_flag;
/**
 *  是否公开
 */
@property (nonatomic, assign)int ispublic;

- (instancetype)initWithGroupName:(NSString *)groupName groupId:(NSString *)groupId doctorId:(NSString *)doctorId patientId:(NSString *)patientId patientName:(NSString *)patientName ckeyId:(NSString *)ckeyId;

@end
