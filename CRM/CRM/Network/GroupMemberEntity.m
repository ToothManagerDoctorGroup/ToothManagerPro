//
//  GroupMemberEntity.m
//  CRM
//
//  Created by Argo Zhang on 15/12/9.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "GroupMemberEntity.h"
#import "MyDateTool.h"

@implementation GroupMemberEntity

- (instancetype)initWithGroupName:(NSString *)groupName groupId:(NSString *)groupId doctorId:(NSString *)doctorId patientId:(NSString *)patientId patientName:(NSString *)patientName ckeyId:(NSString *)ckeyId{
    if (self = [super init]) {
        self.group_name = groupName;
        self.group_id = groupId;
        self.doctor_id = doctorId;
        self.patient_id = patientId;
        self.patient_name = patientName;
        self.ckeyid = @"";
        self.sync_time = @"1970-01-01 00:00:00";
        self.creation_time = [MyDateTool stringWithDateWithSec:[NSDate date]];
        self.data_flag = 1;
        self.ispublic = 1;
    }
    return self;
}

@end
