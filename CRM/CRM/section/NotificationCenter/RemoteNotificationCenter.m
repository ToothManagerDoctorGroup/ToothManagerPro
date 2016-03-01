//
//  RemoteNotificationCenter.m
//  CRM
//
//  Created by TimTiger on 11/6/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "RemoteNotificationCenter.h"

NSString *const IntroducerRequestNotification = @"IntroducerRequestNotification";

@implementation RemoteNotificationCenter
Realize_ShareInstance(RemoteNotificationCenter);

- (void)didReceiveRemoteNotification:(NSDictionary *)userinfo {
//    key	__NSCFString *	@"introducerid"	0x155de140
    NSString *action = [userinfo objectForKey:@"action"];
    if ([action isEqualToString:IntroducerRequestNotification]) {
//        NSString *introducerid = [userinfo objectForKey:@"introducerid"];
        NSDictionary *aps = [userinfo objectForKey:@"aps"];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提醒" message:[aps objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

@end
