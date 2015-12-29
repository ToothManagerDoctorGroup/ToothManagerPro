//
//  AppDelegate.m
//  CRM
//
//  Created by TimTiger on 4/5/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//  Yu0DYus5oGSY08r5FLwh3Dbd

#import "CRMAppDelegate.h"
#import "MobClick.h"
#import "DBManager.h"
#import "CRMViewAppearance.h"
#import "LeftMenuViewController.h"
#import "MMDrawerVisualState.h"
#import "UMFeedback.h"
#import "CRMMacro.h"
#import "UIApplication+Version.h"
#import "TimAlertView.h"
#import "RightMenuViewController.h"
#import "UMessage.h"
#import "CRMUserDefalut.h"
#import "RemoteNotificationCenter.h"
#import "AccountManager.h"
#import "SigninViewController.h"
#import "SyncManager.h"
#import "CRMMacro.h"
#import "UMOpus.h"
#import "SysMsgViewController.h"
#import "ScheduleReminderViewController.h"
#import "PatientsDisplayViewController.h"
#import "AccountViewController.h"
#import "DBManager+User.h"
#import "MenuButtonPushManager.h"
#import "MenuView.h"
#import "IntroducerViewController.h"
#import "PatientSegumentController.h"
#import "TTMUserGuideController.h"
#import "XLSignInViewController.h"
#import "XLPersonalStepOneViewController.h"

@implementation CRMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
/******************************环信集成Start*************************************/
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"toothManagerDoctor_dev";
#else
    apnsCertName = @"toothManagerDoctor_dis";
#endif
    
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"1222223232#toothmanagerdoctor" apnsCertName:apnsCertName otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
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
    //百度地图启动类
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"Yu0DYus5oGSY08r5FLwh3Dbd" generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }else{
        NSLog(@"manager start success!");
    }
    
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //[[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handNotification:) name:SignInSuccessNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handNotification:) name:SignUpSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handNotification:) name:SignOutSuccessNotification object:nil];
    
    //1.准备好数据库
    [[DBManager shareInstance] createdbFile];
    [[DBManager shareInstance] createTables];
    
    [self configThirdPart:launchOptions];
    
    //开启设备网络状态监控
     [[SyncManager shareInstance] opendSync];
    
    //通用的界面的设置
    [CRMViewAppearance setCRMAppearance];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
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
            if ([[[AccountManager shareInstance] currentUser].hospitalName isNotEmpty]) {
                self.window.rootViewController = self.tabBarController;
            }else{
                
                self.window.rootViewController = nav;
            }
        }else{
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
    
    return YES;
}

- (void)configThirdPart:(NSDictionary *)launchOptions {
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
    
    //注册微信
    [WXApi registerApp:@"wx43875d1f976c1ded"];
}
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
        TTMUserGuideController *guideController = [[TTMUserGuideController alloc] init];
        guideController.images = @[@"nav1.png", @"nav2.png", @"nav3.png"];
        guideController.showIndicator = NO;
        guideController.forwardController = nav;
        self.window.rootViewController = guideController;
        //保存当前版本号
        [CRMUserDefalut obtainAppVersion];
    }
    
}

- (void)handNotification:(NSNotification *)notification {
    if ([notification.name isEqualToString:SignInSuccessNotification]
        || [notification.name isEqualToString:SignUpSuccessNotification]) {
        if (self.tabBarController == nil) {
            self.tabBarController = [[TimTabBarViewController alloc] init];
        }
        self.window.rootViewController = self.tabBarController;
    } else if ([notification.name isEqualToString:SignOutSuccessNotification]) {
        [self makeLogin];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
     [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
//    if (self.tabBarController) {
//        [self.tabBarController didReceiveLocalNotification:notification];
//    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"deviceToken:%@",deviceToken);
    [UMessage registerDeviceToken:deviceToken];
    NSString *pushToken = [[[[deviceToken description]
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    [CRMUserDefalut setObject:pushToken forKey:DeviceToken];
    
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"注册失败");
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UMessage didReceiveRemoteNotification:userInfo];
    //定制自定的的弹出框
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
//        [UMessage sendClickReportForRemoteNotification:userInfo];
        [[RemoteNotificationCenter shareInstance] didReceiveRemoteNotification:userInfo];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[DBManager shareInstance] closeDB];
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[DBManager shareInstance] opendDB];
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - WXApi delegate
-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)onResp:(BaseResp*)resp
{
    /*
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
     */
}


#pragma mark - Application's Documents directory
// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
