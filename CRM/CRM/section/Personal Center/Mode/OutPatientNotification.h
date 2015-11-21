//
//  outPatientNotification.h
//  CRM
//
//  Created by fankejun on 15/5/7.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OutPatientNotification : NSObject

@property (nonatomic, copy) NSString *patient_id;
@property (nonatomic, copy) NSString *patient_name;
@property (nonatomic, copy) NSString *doctor_info_id;
@property (nonatomic, copy) NSString *doctor_info_name;
@property (nonatomic, copy) NSString *intro_time;
@property (nonatomic, copy) NSString *doctor_info_image;
@property (nonatomic, copy) NSString *patient_count;
@property (nonatomic, copy) NSString *patients;

+ (OutPatientNotification *)outpatientNotificationWithDic:(NSDictionary *)dic;

@end
