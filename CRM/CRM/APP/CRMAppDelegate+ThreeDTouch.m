//
//  CRMAppDelegate+ThreeDTouch.m
//  CRM
//
//  Created by Argo Zhang on 16/5/30.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "CRMAppDelegate+ThreeDTouch.h"
#import "RemoteNotificationCenter.h"
#import "TimNavigationViewController.h"
#import "XLAppointmentBaseViewController.h"
#import "XLQrcodePatientViewController.h"
#import "CommonMacro.h"

@implementation CRMAppDelegate (ThreeDTouch)
- (void)add3DViewWithApplication:(UIApplication *)application{
    UIApplicationShortcutIcon *searchIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3dtouch_search_huanzhe"];
    UIApplicationShortcutItem *searchItem = [[UIApplicationShortcutItem alloc] initWithType:ThreeDTouchSearchPatient localizedTitle:@"查找患者" localizedSubtitle:NULL icon:searchIcon userInfo:NULL];
    
    UIApplicationShortcutIcon *addPatientIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3dtouch_add_huanzhe"];
    UIApplicationShortcutItem *addPatientItem = [[UIApplicationShortcutItem alloc] initWithType:ThreeDTouchAddPatient localizedTitle:@"添加患者" localizedSubtitle:NULL icon:addPatientIcon userInfo:NULL];
    
    UIApplicationShortcutIcon *addReminderIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3dtouch_add_yuyue"];
    UIApplicationShortcutItem *addReminderItem = [[UIApplicationShortcutItem alloc] initWithType:ThreeDTouchAddReminder localizedTitle:@"添加预约" localizedSubtitle:NULL icon:addReminderIcon userInfo:NULL];

    application.shortcutItems = @[searchItem,addPatientItem,addReminderItem];
    
}

#ifdef IOS_9_OR_LATER
- (void)application:(UIApplication *)application performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void (^)(BOOL))completionHandler{
    
    if ([shortcutItem.type isEqualToString:ThreeDTouchSearchPatient])
    {
        [self pushToSearchpatientVc];
    }else if ([shortcutItem.type isEqualToString:ThreeDTouchAddPatient]){
        [self pushToAddPatientVc];
    }else if ([shortcutItem.type isEqualToString:ThreeDTouchAddReminder]){
        [self pushToAddReminderVc];
    }
}
#endif
- (void)pushToSearchpatientVc{
    // 取到tabbarcontroller
    TimTabBarViewController *tabBarController = (TimTabBarViewController *)[[RemoteNotificationCenter shareInstance] getCurrentVC];
    //如果是当前控制器是我的消息控制器的话，刷新数据即可
    if (tabBarController.selectedIndex == 1) {
        return;
    }
    // 否则，跳转到我的消息
    [tabBarController setSelectedViewController:[tabBarController.viewControllers objectAtIndex:1]];
}

- (void)pushToAddReminderVc{
    // 取到tabbarcontroller
    TimTabBarViewController *tabBarController = (TimTabBarViewController *)[[RemoteNotificationCenter shareInstance] getCurrentVC];
    // 取到navigationcontroller
    TimNavigationViewController *nav = (TimNavigationViewController *)tabBarController.selectedViewController;
    //取到nav控制器当前显示的控制器
    UIViewController * baseVC = (UIViewController *)nav.visibleViewController;
    //如果是当前控制器是我的消息控制器的话，刷新数据即可
    if([baseVC isKindOfClass:[XLAppointmentBaseViewController class]])
    {
        return;
    }
    // 否则，跳转到预约视图
    XLAppointmentBaseViewController *appointVc = [[XLAppointmentBaseViewController alloc] init];
    appointVc.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:appointVc animated:YES];
}

- (void)pushToAddPatientVc{
    // 取到tabbarcontroller
    TimTabBarViewController *tabBarController = (TimTabBarViewController *)[[RemoteNotificationCenter shareInstance] getCurrentVC];
    // 取到navigationcontroller
    TimNavigationViewController *nav = (TimNavigationViewController *)tabBarController.selectedViewController;
    //取到nav控制器当前显示的控制器
    UIViewController * baseVC = (UIViewController *)nav.visibleViewController;
    //如果是当前控制器是我的消息控制器的话，刷新数据即可
    if([baseVC isKindOfClass:[XLQrcodePatientViewController class]])
    {
        return;
    }
    // 否则，跳转到预约视图
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    XLQrcodePatientViewController *qrVC = [storyBoard instantiateViewControllerWithIdentifier:@"XLQrcodePatientViewController"];
    qrVC.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:qrVC animated:YES];
}

@end
