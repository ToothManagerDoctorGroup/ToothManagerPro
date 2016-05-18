//
//  GroupPatientModel.m
//  CRM
//
//  Created by Argo Zhang on 15/12/9.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "GroupPatientModel.h"

typedef NS_ENUM(NSInteger, PatientStatus) {
    PatientStatusUntreatment = 0 ,//未就诊
    PatientStatusUnplanted ,   //未种植
    PatientStatusUnrepaired , //已种植未修复
    PatientStatusRepaired ,   //已修复
    PatientStatuspeAll,    //所有患者
    PatientStatusUntreatUnPlanted, //未就诊 和 未种植的   0是未就诊，1未种植，2已种未修，3已修复。
};

@implementation GroupPatientModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.keyId = [dic[@"KeyId"] longValue];
        self.introducer_id = dic[@"introducer_id"];
        self.patient_name = dic[@"patient_name"];
        self.patient_status = [dic[@"patient_status"] longValue];
        self.intr_name = dic[@"intr_name"];
        self.ckeyid = dic[@"ckeyid"];
    }
    return self;
}

- (NSString *)statusStr{
    switch (self.patient_status) {
        case PatientStatusUntreatment:
            return @"未就诊";
            break;
        case PatientStatusUnplanted:
            return @"未种植";
            break;
        case PatientStatusUnrepaired:
            return @"已种未修";
            break;
        case PatientStatusRepaired:
            return @"已修复";
            break;
        default:
            return @"其它";
            break;
    }
}

@end
