//
//  XLCureProjectModel.h
//  CRM
//
//  Created by Argo Zhang on 16/3/7.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CureProjectStatus) {
    //以下是枚举成员
    CureProjectWaitHandle = 0,//待处理
    CureProjectWaitPay = 1,//待付款
    CureProjectPayed = 2  //已付款
    
};
@interface XLCureProjectModel : NSObject

//{"Code":200,"Result":{"KeyId":1,"case_id":"1","patient_id":"123","therapist_id":1,"therapist_name":"yi","tooth_position":"yawei","medical_item":"定方案","end_date":"2016-03-03 11:53:31","gold_count":10,"status":1,"create_user":11,"create_time":"2016-03-01 11:53:31"}}

@property (nonatomic, strong)NSNumber *keyId; //服务器端用到的主键
@property (nonatomic, copy)NSString *case_id;//病历id
@property (nonatomic, copy)NSString *patient_id;//患者id
@property (nonatomic, strong)NSNumber *therapist_id;//主治医生id
@property (nonatomic, copy)NSString *therapist_name;//主治医生姓名
@property (nonatomic, copy)NSString *doctor_image;//主治医生的头像
@property (nonatomic, copy)NSString *tooth_position;//牙位
@property (nonatomic, copy)NSString *medical_item;//治疗类型
@property (nonatomic, copy)NSString *end_date;//截止时间
@property (nonatomic, strong)NSNumber *gold_count;//金币数量
@property (nonatomic, strong)NSNumber *status;//状态
@property (nonatomic, strong)NSNumber *create_user;//创建人id
@property (nonatomic, copy)NSString *create_time;//创建时间


/**
 *  步骤，仅本地使用
 */
@property (nonatomic, assign)NSInteger step;

@end
