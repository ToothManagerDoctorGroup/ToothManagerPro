//
//  outPatientNotification.m
//  CRM
//
//  Created by fankejun on 15/5/7.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "outPatientNotification.h"
#import "NSDictionary+Extension.h"

@implementation OutPatientNotification
+ (OutPatientNotification *)outpatientNotificationWithDic:(NSDictionary *)dic {
    OutPatientNotification *outnotification = [[OutPatientNotification alloc] init];
    outnotification.patient_id = [dic stringForKey:@"patient_id"];
    outnotification.patient_name = [dic stringForKey:@"patient_name"];
    outnotification.doctor_info_id = [dic stringForKey:@"doctor_info_id"];
    outnotification.doctor_info_name = [dic stringForKey:@"doctor_info_name"];
    outnotification.intro_time = [dic stringForKey:@"intro_time"];
    outnotification.doctor_info_image = [dic stringForKey:@"doctor_info_image"];
    outnotification.patient_count = [dic stringForKey:@"patient_count"];
    outnotification.patients = [dic stringForKey:@"patients"];
    return outnotification;
}
@end
