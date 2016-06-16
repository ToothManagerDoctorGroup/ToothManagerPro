//
//  SysMessageModel.h
//  CRM
//
//  Created by Argo Zhang on 15/12/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

//新增患者
extern NSString * const AttainNewPatient;
extern NSString * const AttainNewFriend;
extern NSString * const CancelReserveRecord;
extern NSString * const UpdateReserveRecord;
extern NSString * const InsertReserveRecord;
extern NSString * const ClinicReserver;

@interface SysMessageModel : NSObject

/**
 *  主键
 */
@property (nonatomic, assign)NSInteger keyId;
/**
 *  消息id
 */
@property (nonatomic, copy)NSString *message_id;
/**
 *  消息的类型
 */
@property (nonatomic, copy)NSString *message_type;
/**
 *  消息的内容
 */
@property (nonatomic, copy)NSString *message_content;
/**
 *  医生id
 */
@property (nonatomic, copy)NSString *doctor_id;
/**
 * 是否已读
 */
@property (nonatomic, assign)NSInteger is_read;
/**
 *  创建时间
 */
@property (nonatomic, copy)NSString *create_time;

@end
