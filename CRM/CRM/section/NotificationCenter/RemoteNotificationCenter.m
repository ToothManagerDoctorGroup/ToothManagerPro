//
//  RemoteNotificationCenter.m
//  CRM
//
//  Created by TimTiger on 11/6/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "RemoteNotificationCenter.h"
#import "WMPageController.h"
#import "UnReadMessageViewController.h"
#import "ReadMessageViewController.h"
#import "TimTabBarViewController.h"
#import "WMPageController.h"
#import "TimNavigationViewController.h"
#import "XLSysMessageViewController.h"

NSString *const IntroducerRequestNotification = @"IntroducerRequestNotification";

@interface RemoteNotificationCenter ()<UIAlertViewDelegate>

@property (nonatomic, strong)NSDictionary *userinfo;

@end

@implementation RemoteNotificationCenter
Realize_ShareInstance(RemoteNotificationCenter);

- (void)didReceiveRemoteNotification:(NSDictionary *)userinfo {
    self.userinfo = userinfo;
    NSDictionary *aps = [userinfo objectForKey:@"aps"];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"消息提醒" message:[aps objectForKey:@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即前往", nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
        {
            //跳转到消息页面
            [self pushToMessageVc];
        }
            break;
            
        default:
            break;
    }
}

- (void)pushToMessageVc{
    // 取到tabbarcontroller
    TimTabBarViewController *tabBarController = (TimTabBarViewController *)[self getCurrentVC];
    // 取到navigationcontroller
    TimNavigationViewController * nav = (TimNavigationViewController *)tabBarController.selectedViewController;
    //取到nav控制器当前显示的控制器
    UIViewController * baseVC = (UIViewController *)nav.visibleViewController;
    //如果是当前控制器是我的消息控制器的话，刷新数据即可
    if([baseVC isKindOfClass:[XLSysMessageViewController class]])
    {
        NSLog(@"刷新数据");
        return;
    }
    // 否则，跳转到我的消息
    XLSysMessageViewController *sysMessageVc = [[XLSysMessageViewController alloc] initWithStyle:UITableViewStylePlain];
    sysMessageVc.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:sysMessageVc animated:YES];
//    WMPageController *pageController = [self p_defaultController];
//    pageController.title = @"我的消息";
//    pageController.menuViewStyle = WMMenuViewStyleLine;
//    pageController.titleSizeSelected = 15;
//    pageController.titleColorSelected = MyColor(0, 139, 232);
//    pageController.menuHeight = 44;
//    pageController.bounces = NO;
//    pageController.hidesBottomBarWhenPushed = YES;
//    [nav pushViewController:pageController animated:YES];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

#pragma mark - 创建控制器
- (WMPageController *)p_defaultController {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    Class class;
    for (int i = 0; i < 2; i++) {
        NSString *title;
        if (i == 0) {
            title = @"未读";
            class = [UnReadMessageViewController class];
        }else{
            title = @"已读";
            class = [ReadMessageViewController class];
        }
        [viewControllers addObject:class];
        [titles addObject:title];
    }
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageVC.pageAnimatable = YES;
    pageVC.menuItemWidth = kScreenWidth * 0.5;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    return pageVC;
}


@end
