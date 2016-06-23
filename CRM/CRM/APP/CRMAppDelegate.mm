//
//  AppDelegate.m
//  CRM
//
//  Created by TimTiger on 4/5/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//  Yu0DYus5oGSY08r5FLwh3Dbd

#import "CRMAppDelegate.h"
#import "DBManager.h"
#import "CRMViewAppearance.h"
#import "CRMMacro.h"
#import "UIApplication+Version.h"
#import "CRMUserDefalut.h"
#import "RemoteNotificationCenter.h"
#import "AccountManager.h"
#import "SyncManager.h"
#import "DBManager+User.h"
#import "PatientSegumentController.h"
#import "TTMUserGuideController.h"
#import "XLSignInViewController.h"
#import "XLPersonalStepOneViewController.h"
#import "CRMAppDelegate+Reachability.h"
#import "CRMAppDelegate+EaseMob.h"
#import "CRMAppDelegate+JPush.h"
#import "CRMAppDelegate+ThreeDTouch.h"
#import "CRMAppDelegate+Pay.h"
#import "JPUSHService.h"
#import "NSString+TTMAddtion.h"

@interface CRMAppDelegate ()

//@property (nonatomic, strong)XLAdvertisementView *adImageView;//启动广告页

@end

@implementation CRMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //配置第三方SDK
    [self configThirdPartWithApplication:application option:launchOptions];
    //开启设备网络状态监控
    [self addNetWorkNotification];
    //通用的界面的设置
    [CRMViewAppearance setCRMAppearance];
    //准备数据库
    [[DBManager shareInstance] createdbFile];
    [[DBManager shareInstance] createTables];
    //更新数据库表结构
//    [[DBManager shareInstance] updateDB];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //页面跳转
    [self turnToMainVcWithOptions:launchOptions];
    //设置3dtouch按钮,iOS9.0之后可用
    if (IOS_9_OR_LATER) {
        [self add3DViewWithApplication:application];
    }

    return YES;
}

+ (CRMAppDelegate *)appDelegate{
    return (CRMAppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - 配置第三方SDK
- (void)configThirdPartWithApplication:(UIApplication *)application option:(NSDictionary *)launchOptions {
    
    //注册环信
    [self registerEaseMobConfigWithapplication:application options:launchOptions];
    //注册友盟
//    [self registerUMessageConfigWithOptions:launchOptions];
    //注册极光推送
    [self registerJPushConfigWithOptions:launchOptions];
    
    //百度地图
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    [_mapManager start:@"Yu0DYus5oGSY08r5FLwh3Dbd" generalDelegate:nil];
    //注册微信
//    [WXApi registerApp:@"wx43875d1f976c1ded"];
    [WXApi registerApp:@"wx26acde952c8251cf"];
    
    //样式设置，添加通知
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handNotification:) name:SignInSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handNotification:) name:SignUpSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handNotification:) name:SignOutSuccessNotification object:nil];
}


#pragma mark - 跳转到主页面
- (void)turnToMainVcWithOptions:(NSDictionary *)options{
    //判断用户是否登录
    if ([[AccountManager shareInstance] isLogin]) {
        if (self.tabBarController == nil) {
            self.tabBarController = [[TimTabBarViewController alloc] init];
        }
        //个人信息完善界面
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        XLPersonalStepOneViewController *oneVC = [storyBoard instantiateViewControllerWithIdentifier:@"XLPersonalStepOneViewController"];
        TimNavigationViewController *nav = [[TimNavigationViewController alloc]initWithRootViewController:oneVC];
        
        NSString *newVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        NSString *oldVersion = [CRMUserDefalut getAppVersion];
        if ([newVersion isEqualToString:oldVersion]) {
            if ([[[AccountManager shareInstance] currentUser].hospitalName isNotEmpty] && ![[[AccountManager shareInstance] currentUser].hospitalName isEqualToString:@"无"]) {
                self.window.rootViewController = self.tabBarController;
            }else{
                //如果未填写个人信息  直接跳转到登录界面
                [AccountManager shareInstance].currentUser.userid = nil;
                [AccountManager shareInstance].currentUser.accesstoken = nil;
                [CRMUserDefalut setLatestUserId:nil];
                //取消所有的下载操作
                [[CRMHttpRequest shareInstance] cancelAllOperations];
                
                [self makeLogin];
            }
        }else{
            //更新数据库表结构
            [[DBManager shareInstance] updateDB];
            TTMUserGuideController *guideController = [[TTMUserGuideController alloc] init];
            guideController.images = @[@"nav1.png", @"nav2.png", @"nav3.png"];
            guideController.showIndicator = NO;
            if ([[[AccountManager shareInstance] currentUser].hospitalName isNotEmpty]) {
                guideController.forwardController = self.tabBarController;
            }else{
                guideController.forwardController = nav;
            }
            self.window.rootViewController = guideController;
            //保存当前版本号
            [CRMUserDefalut obtainAppVersion];
        }
    } else {
        [self makeLogin];
    }
}

#pragma mark - 登录
- (void)makeLogin {
    self.tabBarController = nil;
    //获取版本号
    NSString *newVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString *oldVersion = [CRMUserDefalut getAppVersion];
    //获取登录页面
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    XLSignInViewController *signinVC = [storyBoard instantiateViewControllerWithIdentifier:@"XLSignInViewController"];
    TimNavigationViewController *nav = [[TimNavigationViewController alloc]initWithRootViewController:signinVC];
    //比较版本号
    if ([newVersion isEqualToString:oldVersion]) {
        self.window.rootViewController = nav;
    }else{
        //更新数据库表结构
        [[DBManager shareInstance] updateDB];
        TTMUserGuideController *guideController = [[TTMUserGuideController alloc] init];
        guideController.images = @[@"nav1.png", @"nav2.png", @"nav3.png"];
        guideController.showIndicator = NO;
        guideController.forwardController = nav;
        self.window.rootViewController = guideController;
        //保存当前版本号
        [CRMUserDefalut obtainAppVersion];
    }
    
}
#pragma mark - 接收到通知处理
- (void)handNotification:(NSNotification *)notification {
    if ([notification.name isEqualToString:SignInSuccessNotification]) {
        if (self.tabBarController == nil) {
            self.tabBarController = [[TimTabBarViewController alloc] init];
        }
        self.tabBarController.executeSyncAction = YES;
        self.window.rootViewController = self.tabBarController;
    } else if ([notification.name isEqualToString:SignOutSuccessNotification]) {
        [self makeLogin];
    }
}

#pragma mark - Another Method
- (void)applicationWillResignActive:(UIApplication *)application
{
     [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"收到本地通知:%@",notification);
    if ([[notification.userInfo allKeys] containsObject:@"aps"]) {
        if (![[notification.userInfo allKeys] containsObject:@"m"]) {
            [[RemoteNotificationCenter shareInstance] didReceiveRemoteNotification:notification.userInfo];
        }
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"deviceToken:%@",deviceToken);
//    [UMessage registerDeviceToken:deviceToken];
    [JPUSHService registerDeviceToken:deviceToken];
    NSString *pushToken = [[[[deviceToken description]
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""] ;
     NSString *reister = [JPUSHService registrationID];
    [CRMUserDefalut setObject:pushToken forKey:DeviceToken];
    [CRMUserDefalut setObject:reister forKey:RegisterId];
    
    NSLog(@"registerId:%@",reister);
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}


// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"注册失败");
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //定制自定义的弹出框
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        [[RemoteNotificationCenter shareInstance] didReceiveRemoteNotification:userInfo];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
//        [JPUSHService handleRemoteNotification:userInfo];
        //自定义弹出样式
        NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        {
            [[RemoteNotificationCenter shareInstance] didReceiveRemoteNotification:userInfo];
        }else{
            //判断是否是环信的推送
            if (![[userInfo allKeys] containsObject:@"m"]) {
                [[RemoteNotificationCenter shareInstance] pushToMessageVc];
            }
        }
    
    //这里设置app的图片的角标为0，红色角标就会消失
    [UIApplication sharedApplication].applicationIconBadgeNumber  =  0;
    completionHandler(UIBackgroundFetchResultNewData);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
        [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification
    completionHandler:(void (^)())completionHandler {
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {

}
#endif

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [BMKMapView didForeGround];//当应用恢复前台状态时调用，恢复地图的渲染和opengl相关的操作
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

- (void)dealloc{
    [self removeNetWorkNotification];
}
#pragma mark - Application's Documents directory
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
