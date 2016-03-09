//
//  XLTeamMemberParam.m
//  CRM
//
//  Created by Argo Zhang on 16/3/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLTeamMemberParam.h"
#import "MyDateTool.h"

@implementation XLTeamMemberParam

- (instancetype)initWithCaseId:(NSString *)case_id patientId:(NSString *)patient_id teamNickName:(NSString *)team_nick_name memberId:(NSNumber *)member_id nickName:(NSString *)nick_name memberName:(NSString *)member_name isConsociation:(BOOL)isConsociation createUserId:(NSNumber *)create_user{
    if (self = [super init]) {
        self.case_id = case_id;
        self.patient_id = patient_id;
        self.team_nick_name = team_nick_name;
        self.member_id = member_id;
        self.nick_name = nick_name;
        self.member_name = member_name;
        self.is_consociation = isConsociation ? @(1) : @(0);
        self.create_user = create_user;
        self.create_time = [MyDateTool stringWithDateWithSec:[NSDate date]];
    }
    return self;
}

@end
