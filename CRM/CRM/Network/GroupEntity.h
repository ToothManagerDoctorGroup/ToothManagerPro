//
//  GroupEntity.h
//  CRM
//
//  Created by Argo Zhang on 15/12/9.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DoctorGroupModel.h"

/**
 *  新增分组的参数模型
 */

@interface GroupEntity : NSObject

/**
 *  分组名称
 */
@property (nonatomic, copy)NSString *group_name;
/**
 *  分组描述
 */
@property (nonatomic, copy)NSString *group_descrption;
/**
 *  医生id
 */
@property (nonatomic, copy)NSString *doctor_id;
/**
 *  主键
 */
@property (nonatomic, copy)NSString *ckeyid;
/**
 *  同步时间
 */
@property (nonatomic, copy)NSString *sync_time;
/**
 *  创建时间
 */
@property (nonatomic, copy)NSString *creation_time;
/**
 *  数据标识
 */
@property (nonatomic, assign)int data_flag;

- (instancetype)initWithName:(NSString *)groupName desc:(NSString *)groupDesc doctorId:(NSString *)doctorId;

- (instancetype)initWithName:(NSString *)groupName originGroup:(DoctorGroupModel *)group;

@end
