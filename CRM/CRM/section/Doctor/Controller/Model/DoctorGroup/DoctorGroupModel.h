//
//  DoctorGroupModel.h
//  CRM
//
//  Created by Argo Zhang on 15/12/9.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

/**
 *  分组信息模型
 */
@class GroupEntity;
@interface DoctorGroupModel : NSObject<MJKeyValue>


@property (nonatomic, assign)int keyId;
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
 *  本地数据删除后，服务器是否保存此数据
 */
@property (nonatomic, assign)int data_flag;
/**
 *  分组下病人人数
 */
@property (nonatomic, assign)int patient_count;

/**
 *  判断是否选中，临时字段
 */
@property (nonatomic, assign)BOOL isSelect;

- (instancetype)initWithGroupEntity:(GroupEntity *)entity;

@end
