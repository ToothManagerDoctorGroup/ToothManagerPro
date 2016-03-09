//
//  XLCureProjectParam.h
//  CRM
//
//  Created by Argo Zhang on 16/3/7.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  治疗方案param
 */
@interface XLCureProjectParam : NSObject

/**
 *  {“case_id":"1","patient_id":"123","therapist_id":1,"therapist_name":"yi","tooth_position":"yawei","medical_item":"定方案","end_date":"2016-03-03 11:53:31","gold_count":10,"status":1,"create_user":11,"create_time":"2016-03-01 11:53:31"}
 */
@property (nonatomic, copy)NSString *case_id; //病历id
@property (nonatomic, copy)NSString *patient_id;//患者id
@property (nonatomic, strong)NSNumber *therapist_id;//主治医生id
@property (nonatomic, copy)NSString *therapist_name;//主治医生名称
@property (nonatomic, copy)NSString *tooth_position;//牙位
@property (nonatomic, copy)NSString *medical_item;//治疗类型
@property (nonatomic, copy)NSString *end_date;//截止时间
@property (nonatomic, strong)NSNumber *gold_count;//金币数量
@property (nonatomic, strong)NSNumber *status;//治疗状态
@property (nonatomic, strong)NSNumber *create_user;//创建人的id
@property (nonatomic, copy)NSString *create_time;//创建时间

- (instancetype)initWithCaseId:(NSString *)case_id patientId:(NSString *)patient_id therapistId:(NSNumber *)therapist_id therapistName:(NSString *)therapist_name toothPosition:(NSString *)tooth_position medicalItem:(NSString *)medical_item endDate:(NSString *)end_date goldCount:(NSNumber *)gold_count status:(NSNumber *)status;

@end
