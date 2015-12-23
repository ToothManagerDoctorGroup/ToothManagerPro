//
//  GroupMemberModel.m
//  CRM
//
//  Created by Argo Zhang on 15/12/9.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "GroupMemberModel.h"
#import "MJExtension.h"

typedef NS_ENUM(NSInteger, PatientStatus) {
    PatientStatusUntreatment = 0 ,//未就诊
    PatientStatusUnplanted ,   //未种植
    PatientStatusUnrepaired , //已种植未修复
    PatientStatusRepaired ,   //已修复
    PatientStatuspeAll,    //所有患者
    PatientStatusUntreatUnPlanted, //未就诊 和 未种植的   0是未就诊，1未种植，2已种未修，3已修复。
};

@implementation GroupMemberModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"keyId" : @"KeyId",@"nickName" : @"NickName"};
}

+ (NSArray *)ignoredCodingPropertyNames{
    return @[@"isChoose",@"isMember",@"statusStr"];
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
