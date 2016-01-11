//
//  XLPatientTotalInfoModel.h
//  CRM
//
//  Created by Argo Zhang on 15/12/26.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  患者详细信息数据
 */
@interface XLPatientTotalInfoModel : NSObject

@property (nonatomic, strong)NSDictionary *baseInfo;//患者的基本信息BaseInfo
@property (nonatomic, strong)NSArray *medicalCase;//病历数据MedicalCase
@property (nonatomic, strong)NSArray *medicalCourse;//病历描述MedicalCourse
@property (nonatomic, strong)NSArray *cT;//ct数据CT
@property (nonatomic, strong)NSArray *consultation;//会诊信息数据Consultation
@property (nonatomic, strong)NSArray *expense;//耗材数据Expense
@property (nonatomic, strong)NSArray *introducerMap;//患者介绍人关系表IntroducerMap


@end
