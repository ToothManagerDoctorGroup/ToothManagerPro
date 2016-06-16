//
//  XLPatientTotalInfoModel.m
//  CRM
//
//  Created by Argo Zhang on 15/12/26.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLPatientTotalInfoModel.h"
#import "MJExtension.h"

@implementation XLPatientTotalInfoModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"baseInfo" : @"BaseInfo",
             @"medicalCase" : @"MedicalCase",
             @"medicalCourse" : @"MedicalCourse",
             @"cT" : @"CT",
             @"consultation" : @"Consultation",
             @"expense" : @"Expense",
             @"introducerMap":@"IntroducerMap"};
}

@end
