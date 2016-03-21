//
//  CRMAppDelegate+UMessage.m
//  CRM
//
//  Created by Argo Zhang on 16/3/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "CRMAppDelegate+UMessage.h"
#import "UMessage.h"
#import "MobClick.h"
#import "CRMMacro.h"
#import "CommonMacro.h"
#import "UMOpus.h"
#import "UMFeedback.h"

@implementation CRMAppDelegate (UMessage)

- (void)registerUMessageConfigWithOptions:(NSDictionary *)launchOptions{
    //2.友盟统计（主要是用来统计错误）
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:BATCH channelId:@"App Store"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    //set AppKey and AppSecret
    [UMessage startWithAppkey:UMENG_APPKEY launchOptions:launchOptions];
#ifdef __IPHONE_8_0
    if (IOS_8_OR_LATER) {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
    }
#endif
    if (!IOS_8_OR_LATER) {
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
    
    //友盟用户反馈
    [UMOpus setAudioEnable:YES];
    [UMFeedback setAppkey:UMENG_APPKEY];
    [UMFeedback setLogEnabled:YES];
    [[UMFeedback sharedInstance] setFeedbackViewController:[UMFeedback feedbackViewController] shouldPush:YES];
    NSDictionary *notificationDict = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ([notificationDict valueForKey:@"aps"]) // 点击推送进入
    {
        [UMFeedback didReceiveRemoteNotification:notificationDict];
    }
}

@end
