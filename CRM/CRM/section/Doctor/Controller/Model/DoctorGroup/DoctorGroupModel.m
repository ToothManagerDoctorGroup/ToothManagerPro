//
//  DoctorGroupModel.m
//  CRM
//
//  Created by Argo Zhang on 15/12/9.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "DoctorGroupModel.h"
#import "GroupEntity.h"

@implementation DoctorGroupModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"keyId" : @"KeyId"};
}

+ (NSArray *)ignoredCodingPropertyNames{
    return @[@"isSelect"];
}

- (instancetype)initWithGroupEntity:(GroupEntity *)entity{
    if (self = [super init]) {
        self.keyId = 0;
        self.group_name = entity.group_name;
        self.group_descrption = entity.group_descrption;
        self.doctor_id = entity.doctor_id;
        self.ckeyid = entity.ckeyid;
        self.sync_time = entity.sync_time;
        self.creation_time = entity.creation_time;
        self.data_flag = entity.data_flag;
        self.patient_count = 0;
    }
    return self;
}

@end
