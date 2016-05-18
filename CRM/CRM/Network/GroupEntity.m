//
//  GroupEntity.m
//  CRM
//
//  Created by Argo Zhang on 15/12/9.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "GroupEntity.h"
#import "MyDateTool.h"

@implementation GroupEntity

- (instancetype)initWithName:(NSString *)groupName desc:(NSString *)groupDesc doctorId:(NSString *)doctorId{
    if (self = [super init]) {
        
        self.group_name = groupName;
        self.group_descrption = groupDesc;
        self.doctor_id = doctorId;
        self.ckeyid = [NSString stringWithFormat:@"%@_%@",doctorId,[MyDateTool stringWithDateyyyyMMddHHmmss:[NSDate date]]];
        self.sync_time = @"1970-01-01 00:00:00";
        self.creation_time = [MyDateTool stringWithDateWithSec:[NSDate date]];
        self.data_flag = 1;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)groupName originGroup:(DoctorGroupModel *)group{
    if (self = [super init]) {
        
        self.group_name = groupName;
        self.group_descrption = group.group_descrption;
        self.doctor_id = group.doctor_id;
        self.ckeyid = group.ckeyid;
        self.sync_time = group.sync_time;
        self.creation_time = group.creation_time;
        self.data_flag = group.data_flag;
    }
    return self;
}



@end
