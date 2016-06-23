//
//  TimTabBarViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/7.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimTabBarViewController.h"
#import "TimFramework.h"
#import "AccountViewController.h"
#import "PatientSegumentController.h"
#import "MenuView.h"
#import "MenuButtonPushManager.h"
#import "ChatViewController.h"
#import "MyScheduleReminderViewController.h"
#import "AutoSyncManager.h"
#import "CRMUserDefalut.h"
#import "AccountManager.h"
#import "AutoSyncGetManager.h"
#import "XLIntroducerViewController.h"
#import "XLGuideView.h"
#import "XLGuideImageView.h"
#import "DBManager+Patients.h"
#import "UINavigationItem+Margin.h"
#import "CRMAppDelegate.h"
#import "Reachability.h"
#import "UITabBar+BadgeView.h"
#import "XLMenuButtonView.h"
#import "XLAutoGetSyncTool.h"
#import "MyDateTool.h"
#import "UIApplication+Version.h"
#import "XLMessageHandleManager.h"
#import "AutoSyncManager+Behaviour.h"
#import "XLLoginTool.h"
#import "UIApplication+Version.h"
#import "SysMessageTool.h"
#import "DBManager+AutoSync.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static const NSInteger kDefaultSyncGetTimeInterval = 5;
static const NSInteger kDefaultSyncPostTimeInterval = 2.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";

@interface TimTabBarViewController ()<EMChatManagerDelegate,XLGuideViewDelegate>{
    UIButton *menuButton;
    MyScheduleReminderViewController *_scheduleReminderVC;
    XLIntroducerViewController *_introducerVC;
    PatientSegumentController *_patientVc;
    AccountViewController *_account;
}
@property (strong, nonatomic) NSDate *lastPlaySoundDate;//最后一次响铃的时间

@property (nonatomic, strong)NSTimer *timer;//用于自动上传的定时器
@property (nonatomic, strong)NSTimer *syncGetTimer;//用于自动下载的定时器
@property (nonatomic, strong)NSTimer *localDataTimer;//本地数据处理的定时器


@end

@implementation TimTabBarViewController

- (void)dealloc
{
    NSLog(@"主页面被释放");
    [self unregisterNotifications];
    //移除kvo
    [[CRMAppDelegate appDelegate] removeObserver:self forKeyPath:@"connectionStatus"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //if 使tabBarController中管理的viewControllers都符合 UIRectEdgeNone
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //注册通知
    [self registerNotifications];
    //设置未读数
    [self setupUnreadMessageCount];
    //初始化
    [self makeMainView];
    //获取系统的版本限制
    [self getVersionLimit];
    //创建定时器
    [self createAllTimer];
}

#pragma mark - 关闭所有定时器
- (void)closeAllTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.syncGetTimer) {
        [self.syncGetTimer invalidate];
        self.syncGetTimer = nil;
    }
    
    if (self.localDataTimer) {
        [self.localDataTimer invalidate];
        self.localDataTimer = nil;
    }
}

#pragma mark - 创建定时器，添加网络监听
- (void)createAllTimer{
    [[CRMAppDelegate appDelegate] addObserver:self forKeyPath:@"connectionStatus" options:NSKeyValueObservingOptionNew context:nil];
    NetworkStatus status = [[CRMAppDelegate appDelegate].conn currentReachabilityStatus];
    //创建一个定时器(NSTimer)
    if (status != NotReachable) {
        [self createSyncPostTimer];
        [self createSyncGetTimer];
    }
    
    [self createLocalDataTimer];
}

#pragma mark - 监听网络状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"connectionStatus"]) {
        
       NetworkStatus status = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
        //网络发生变化时，发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:ConnectionStatusChangedNotification object:@(status)];
        if (status == NotReachable) {
            [self.timer invalidate];
            self.timer = nil;
            [self.syncGetTimer invalidate];
            self.syncGetTimer = nil;
        }else{
            [self createSyncPostTimer];
            [self createSyncGetTimer];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 创建自动上传定时器
- (void)createSyncPostTimer{
    if (self.timer == nil) {
        //创建一个定时器(NSTimer)
        self.timer = [NSTimer scheduledTimerWithTimeInterval:kDefaultSyncPostTimeInterval target:self selector:@selector(autoSyncAction:) userInfo:nil repeats:YES];
        //将定时器添加到主队列中
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark - 定时器,自动上传
- (void)autoSyncAction:(NSTimer *)timer{
    //开始同步
    [[AutoSyncManager shareInstance] startAutoSync];
    //设置未读消息
    [self requestUnreadMessageCount];
}

#pragma mark - 创建自动下载定时器
- (void)createSyncGetTimer{
    if (!self.syncGetTimer) {
        self.syncGetTimer = [NSTimer scheduledTimerWithTimeInterval:kDefaultSyncGetTimeInterval target:self selector:@selector(autoSyncGetAction:) userInfo:nil repeats:YES];
        //将定时器添加到主队列中
        [[NSRunLoop mainRunLoop] addTimer:self.syncGetTimer forMode:NSRunLoopCommonModes];
    }
}


#pragma mark - 定时器，自动下载
- (void)autoSyncGetAction:(NSTimer *)timer{
    //定时下载
//    [[XLAutoGetSyncTool shareInstance] getAllDataShowSuccess:NO];
    //处理行为表中的数据
    [[AutoSyncManager shareInstance] startBehaviour];
}

#pragma mark 消息定时器处理
- (void)createLocalDataTimer{
    if (!_localDataTimer) {
        _localDataTimer = [NSTimer timerWithTimeInterval:kDefaultSyncGetTimeInterval target:self selector:@selector(messageAutoHandle:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_localDataTimer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark 处理本地消息
- (void)messageAutoHandle:(NSTimer *)timer{
    //查询数据库，是否有未上传的数据
    NSArray *postErrors = [[DBManager shareInstance] getInfoListBySyncCountWithStatus:@"4"];
    NSArray *notPosts = [[DBManager shareInstance] getInfoListWithSyncStatus:@"0"];
    if (postErrors.count > 0 || notPosts.count > 0) {
        [self.tabBar showBadgeOnItemIndex:4];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:IsHaveLocalDataNotPostNotification object:@(YES)];
    }else{
        [self.tabBar hideBadgeOnItemIndex:4];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:IsHaveLocalDataNotPostNotification object:@(NO)];
    }
}

#pragma mark - 请求未读的消息数量
- (void)requestUnreadMessageCount{
    [SysMessageTool getUnReadMessageCountWithDoctorId:[AccountManager currentUserid] success:^(NSString *result) {
        if ([result integerValue] > 0) {
            _scheduleReminderVC.messageCountLabel.hidden = NO;
            [self.tabBar showBadgeOnItemIndex:0];
            _scheduleReminderVC.messageCountLabel.text = result;
        }else{
            [self.tabBar hideBadgeOnItemIndex:0];
            _scheduleReminderVC.messageCountLabel.hidden = YES;
        }
    } failure:^(NSError *error) {}];
}


#pragma mark - 获取系统版本限制
- (void)getVersionLimit{
    [XLLoginTool getVersionLimitSuccess:^(XLVersionLimitModel *limitM) {
        //获取当前版本号
        NSString *currentVersion = [UIApplication currentVersion];
        //判断是否需要强制更新
        if ([limitM.is_forcible_update isEqualToString:@"1"]) {
            //判断服务器的最低版本限制
            if ([self mustUpdateWithOldVersion:currentVersion limitVersion:limitM.ios_min_version]) {
                //判断
                [self showNewVersionWithoutCancel];
            }else{
                [self showNewVersion];
            }
        }else{
            //自愿更新
            [self showNewVersion];
        }
        
    } failure:^(NSError *error) {}];
}

#pragma mark - 显示新版本更新
- (void)showNewVersionWithoutCancel{
    //判断是否有新版本
    [UIApplication checkNewVersionWithAppleID:@"901754828" handler:^(BOOL newVersion, NSURL *updateURL) {
        if (newVersion) {
            TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"更新提示" message:@"种牙管家又有新版本啦!" cancel:nil certain:@"立即前往" cancelHandler:^{
            } comfirmButtonHandlder:^{
                [UIApplication updateApplicationWithURL:updateURL];
            }];
            [alertView show];
        }
    }];
}

#pragma mark -showNewVersion
- (void)showNewVersion{
    NSString *updateTime = [CRMUserDefalut objectForKey:NewVersionUpdate_TimeKey];
    if (updateTime == nil) {
        [self showAlertViewWithTime:updateTime];
    }else{
        //判断目标时间和当前时间的时间差
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:[MyDateTool dateWithStringWithSec:updateTime]];
        if (timeInterval > NewVersionUpdateTimeInterval) {
            [self showAlertViewWithTime:[MyDateTool stringWithDateWithSec:[NSDate date]]];
        }
    }
}

- (void)showAlertViewWithTime:(NSString *)time{
    //判断是否有新版本
    [UIApplication checkNewVersionWithAppleID:@"901754828" handler:^(BOOL newVersion, NSURL *updateURL) {
        [CRMUserDefalut setObject:time forKey:NewVersionUpdate_TimeKey];
        if (newVersion) {
            TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"更新提示" message:@"种牙管家又有新版本啦!" cancel:@"稍后更新" certain:@"立即前往" cancelHandler:^{
            } comfirmButtonHandlder:^{
                [UIApplication updateApplicationWithURL:updateURL];
            }];
            [alertView show];
        }
    }];
}

#pragma mark - 比较版本号
- (BOOL)mustUpdateWithOldVersion:(NSString *)oldVersion limitVersion:(NSString *)limitVersion{
    NSArray *olds = [oldVersion componentsSeparatedByString:@"."];//261
    NSArray *news = [limitVersion componentsSeparatedByString:@"."];//2711
    NSMutableString *oldStrM = [NSMutableString string];
    NSMutableString *newStrM = [NSMutableString string];
    for (int i = 0; i < olds.count; i++) {
        [oldStrM appendString:olds[i]];
    }
    for (int i = 0; i < news.count; i++) {
        [newStrM appendString:news[i]];
    }
    if (olds.count < news.count) {
        [oldStrM appendString:@"0"];
    }
    int oldV = [oldStrM intValue];
    int newV = [newStrM intValue];
    
    return oldV <= newV;
}

#pragma mark - 设置几个主视图
- (void)makeMainView
{
    //日程提醒
    _scheduleReminderVC = [[MyScheduleReminderViewController alloc] init];
    _scheduleReminderVC.executeSyncAction = self.executeSyncAction;
    [self setTabbarItemState:_scheduleReminderVC withTitle:@"日程表" withImage1:@"ic_tabbar_qi" withImage2:@"ic_tabbar_qi_active"];
    TimNavigationViewController *viewController1=[[TimNavigationViewController alloc]initWithRootViewController:_scheduleReminderVC];
    
    //介绍人
    _introducerVC = [[XLIntroducerViewController alloc] init];
    [self setTabbarItemState:_introducerVC withTitle:@"介绍人" withImage1:@"ic_tabbar_jieshaoren_grey" withImage2:@"ic_tabbar_jiashaoren_blue"];
    _introducerVC.isHome = YES;
    TimNavigationViewController* ncViewController2=[[TimNavigationViewController alloc]initWithRootViewController:_introducerVC];
    
    //患者
    _patientVc = [[PatientSegumentController alloc] init];
    [self setTabbarItemState:_patientVc withTitle:@"患者" withImage1:@"ic_tabbar_library" withImage2:@"ic_tabbar_library_active"];
    TimNavigationViewController* ncViewController3=[[TimNavigationViewController alloc]initWithRootViewController:_patientVc];
    
    
    //我的空间
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    _account = [storyboard instantiateViewControllerWithIdentifier:@"AccountViewController"];
    TimNavigationViewController* ncViewController4=[[TimNavigationViewController alloc]initWithRootViewController:_account];
    [self setTabbarItemState:_account withTitle:@"我" withImage1:@"ic_tabbar_me" withImage2:@"ic_tabbar_me_active"];
    
    UIViewController *vc3 = [[UIViewController alloc] init];
    TimNavigationViewController* nc3=[[TimNavigationViewController alloc]initWithRootViewController:vc3];
    
    self.tabBar.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:viewController1, ncViewController3,nc3,ncViewController2, ncViewController4,nil];
    [self setViewControllers:array];
    
    menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 0, SCREEN_WIDTH / 5, self.tabBar.height);
    [menuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateSelected];
    [menuButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setCenter:CGPointMake(SCREEN_WIDTH/2,(self.tabBar.frame.size.height)/2)];
    [self.tabBar addSubview:menuButton];
    
}


- (void)setExecuteSyncAction:(BOOL)executeSyncAction{
    _executeSyncAction = executeSyncAction;
    
    _scheduleReminderVC.executeSyncAction = executeSyncAction;
}

-(void)click:(id)sender{
    XLMenuButtonView *menuView = [[XLMenuButtonView alloc] init];
    menuView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    menuView.viewController = (UINavigationController *)self.selectedViewController;
    [menuView show];
    
}

-(void)setTabbarItemState:(UIViewController *)viewController withTitle:(NSString *)title withImage1:(NSString*)image1 withImage2:(NSString *)image2{
    UIImage *image11 = [[UIImage imageNamed:image1] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image21 = [[UIImage imageNamed:image2] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image11 selectedImage:image21];
    [viewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithRed:59.0f/255.0f green:161.0f/255.0f blue:233.0f/255.0f alpha:1], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    [viewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor lightGrayColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
}

#pragma mark - 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (_patientVc) {
        if (unreadCount > 0) {
            [self.tabBar showBadgeOnItemIndex:1];
            _patientVc.showTipView = YES;
        }else{
            [self.tabBar hideBadgeOnItemIndex:1];
            _patientVc.showTipView = NO;
        }
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

//网络状态发生变化
- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_patientVc networkChanged:connectionState];
}


#pragma mark - 注册代理
-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - IChatManagerDelegate 消息变化

- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [self setupUnreadMessageCount];
    [_patientVc refreshDataSource];
}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineMessages
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineCmdMessages
{
    
}

- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    return ret;
}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    BOOL needShowNotification = (message.messageType != eMessageTypeChat) ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
        
        //        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        //        if (!isAppActivity) {
        //            [self showNotificationWithMessage:message];
        //        }else {
        //            [self playSoundAndVibration];
        //        }
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        switch (state) {
            case UIApplicationStateActive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateInactive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateBackground:
                [self showNotificationWithMessage:message];
                break;
            default:
                break;
        }
#endif
    }
}

-(void)didReceiveCmdMessage:(EMMessage *)message
{
    [self showHint:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    NSLog(@"我被调用了");
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        NSString *title;
        Patient *patient = [[DBManager shareInstance] getPatientCkeyid:message.from];
        if (patient != nil) {
            title = patient.patient_name;
        }else{
            title = @"未知";
        }
        
        if (message.messageType == eMessageTypeGroupChat) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        else if (message.messageType == eMessageTypeChatRoom)
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username" ]];
            NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
            NSString *chatroomName = [chatrooms objectForKey:message.conversationChatter];
            if (chatroomName)
            {
                title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, chatroomName];
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.messageType] forKey:kMessageType];
    [userInfo setObject:message.conversationChatter forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
}

#pragma mark - public

- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
//        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
    }
    else if(_patientVc)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_patientVc];
    }
}

- (EMConversationType)conversationTypeFromMessageType:(EMMessageType)type
{
    EMConversationType conversatinType = eConversationTypeChat;
    switch (type) {
        case eMessageTypeChat:
            conversatinType = eConversationTypeChat;
            break;
        case eMessageTypeGroupChat:
            conversatinType = eConversationTypeGroupChat;
            break;
        case eMessageTypeChatRoom:
            conversatinType = eConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}


- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
//            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            //            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.chatter isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMMessageType messageType = [userInfo[kMessageType] intValue];
                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                        switch (messageType) {
                            case eMessageTypeGroupChat:
                            {
                                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                                for (EMGroup *group in groupArray) {
                                    if ([group.groupId isEqualToString:conversationChatter]) {
                                        chatViewController.title = group.groupSubject;
                                        break;
                                    }
                                }
                            }
                                break;
                            default:
                                chatViewController.title = conversationChatter;
                                break;
                        }
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = (ChatViewController *)obj;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMMessageType messageType = [userInfo[kMessageType] intValue];
                chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                switch (messageType) {
                    case eMessageTypeGroupChat:
                    {
                        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                        for (EMGroup *group in groupArray) {
                            if ([group.groupId isEqualToString:conversationChatter]) {
                                chatViewController.title = group.groupSubject;
                                break;
                            }
                        }
                    }
                        break;
                    default:
                        chatViewController.title = conversationChatter;
                        break;
                }
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_patientVc)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_patientVc];
    }
}

#pragma mark - 环信账号被踢出的回调
- (void)didLoginFromOtherDevice{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
}

@end
