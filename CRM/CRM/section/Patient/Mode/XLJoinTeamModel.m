//
//  XLJoinTeamModel.m
//  CRM
//
//  Created by Argo Zhang on 16/3/11.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLJoinTeamModel.h"

@implementation XLJoinTeamModel

- (NSString *)end_date{
    if ([_end_date isEqualToString:@"0001-01-01 00:00:00"]) {
        return @"";
    }else{
        return _end_date;
    }
}

@end
