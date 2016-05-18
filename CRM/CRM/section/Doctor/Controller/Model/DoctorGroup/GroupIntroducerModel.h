//
//  GroupIntroducerModel.h
//  CRM
//
//  Created by Argo Zhang on 15/12/9.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupIntroducerModel : NSObject

/**
 *  KeyId
 */
@property (nonatomic, assign)NSInteger keyId;
/**
 *  介绍人姓名
 */
@property (nonatomic, copy)NSString *intr_name;
/**
 *  介绍人电话
 */
@property (nonatomic, copy)NSString *intr_phone;
/**
 *  介绍人等级
 */
@property (nonatomic, assign)NSInteger intr_level;
/**
 *  创建时间
 */
@property (nonatomic, copy)NSString *creation_time;
/**
 *  医生id
 */
@property (nonatomic, copy)NSString *doctor_id;
/**
 *  介绍人id
 */
@property (nonatomic, copy)NSString *intr_id;
/**
 *  主键
 */
@property (nonatomic, copy)NSString *ckeyid;

@property (nonatomic, copy)NSString *short_url;
/**
 *  同步时间
 */
@property (nonatomic, copy)NSString *sync_time;

@end
