//
//  RemoteNotificationCenter.h
//  CRM
//
//  Created by TimTiger on 11/6/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimManager.h"
#import "CommonMacro.h"

TIM_EXTERN NSString *const IntroducerRequestNotification;

@interface RemoteNotificationCenter : TimManager
Declare_ShareInstance(RemoteNotificationCenter);

- (void)didReceiveRemoteNotification:(NSDictionary *)userinfo;

- (void)pushToMessageVc;

@end
