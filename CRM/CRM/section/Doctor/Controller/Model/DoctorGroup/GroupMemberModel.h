//
//  GroupMemberModel.h
//  CRM
//
//  Created by Argo Zhang on 15/12/9.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *   "KeyId": 4826,
 "ckeyid": "612_20151123191137",
 "patient_name": "陈云",
 "patient_phone": "18310927054",
 "patient_gender": 0,
 "patient_age": 0,
 "weixin_id": null,
 "is_transfer": 0,
 "target_doctor_name": null,
 "expense_num": 0,
 "introducer_id": null,
 "intr_name": null,
 "creation_time": "2015-11-23 19:13:37",
 "patient_status": 0,
 "doctor_id": 612,
 "NickName": ""
 */
/**
 *  组员模型
 */
@interface GroupMemberModel : NSObject

@property (nonatomic, assign)int keyId;//KeyId
@property (nonatomic, copy)NSString *ckeyid;//ckeyid
@property (nonatomic, copy)NSString *patient_name;//患者姓名
@property (nonatomic, copy)NSString *patient_phone;//患者电话
@property (nonatomic, assign)int patient_gender;//性别
@property (nonatomic, assign)int patient_age;//患者年龄
@property (nonatomic, copy)NSString *weixin_id;//微信id
@property (nonatomic, assign)int is_transfer;//是否转诊
@property (nonatomic, copy)NSString *target_doctor_name;//转诊到的医生姓名
@property (nonatomic, assign)int expense_num;//耗材数量
@property (nonatomic, copy)NSString *introducer_id;//介绍人id
@property (nonatomic, copy)NSString *intr_name;//介绍人姓名
@property (nonatomic, copy)NSString *creation_time;//创建时间
@property (nonatomic, assign)int patient_status;//患者状态
@property (nonatomic, copy)NSString *doctor_id;//医生id
@property (nonatomic, copy)NSString *nickName;//当前医生下患者的昵称

/**
 *  是否被选中
 */
@property (nonatomic, assign)BOOL isChoose;

/**
 *  是否是组员
 */
@property (nonatomic, assign)BOOL isMember;

/**
 *  患者状态字符串
 */
@property (nonatomic, copy)NSString *statusStr;


@end
