//
//  CRMAppDelegate+EaseMob.m
//  CRM
//
//  Created by Argo Zhang on 16/3/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "CRMAppDelegate+EaseMob.h"

@implementation CRMAppDelegate (EaseMob)

- (void)registerEaseMobConfigWithapplication:(UIApplication *)application options:(NSDictionary *)launchOptions{
    /******************************环信集成Start*************************************/
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"toothManagerDoctor_dev";
#else
    apnsCertName = @"toothManagerDoctor_dis";
#endif
    //如果是测试环境
    NSString *appKeyStr;
    if ([DomainName isEqualToString:@"http://118.244.234.207/"]) {
        appKeyStr = @"zijingyiyuan#zygjtest";
    }else if([DomainName isEqualToString:@"http://211.149.247.149/"]){
        appKeyStr = @"zijingyiyuan#betazygj";
    }else{
        appKeyStr = @"zijingyiyuan#zygj";
    }
    [[EaseMob sharedInstance] registerSDKWithAppKey:appKeyStr apnsCertName:apnsCertName otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    //ios9
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    //ios8以下
    else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    //注册通知，可以接收环信消息
    [self registerEaseMobNotification];
    /******************************环信集成End*************************************/
}

@end
