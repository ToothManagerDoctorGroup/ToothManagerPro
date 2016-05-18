//
//  XLJoinTeamModel.h
//  CRM
//
//  Created by Argo Zhang on 16/3/11.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  参与治疗/会诊所用模型
 */
@interface XLJoinTeamModel : NSObject

@property (nonatomic, copy)NSString *case_id; //病历id
@property (nonatomic, strong)NSNumber *doctor_id;//首诊医生id
@property (nonatomic, copy)NSString *doctor_name;//首诊医生姓名
@property (nonatomic, copy)NSString *patient_id;//患者id
@property (nonatomic, copy)NSString *patient_name;//患者姓名
@property (nonatomic, strong)NSNumber *therapist_id;//治疗医生id
@property (nonatomic, strong)NSNumber *status;//治疗状态
@property (nonatomic, copy)NSString *status_name;//治疗状态的名称
@property (nonatomic, copy)NSString *doctor_image;//首诊医生的头像
@property (nonatomic, copy)NSString *end_date;//截止时间


@end
