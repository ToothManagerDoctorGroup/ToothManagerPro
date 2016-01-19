//
//  TimTabBarViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/7.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimTabBarViewController.h"
#import "TimFramework.h"
#import "ScheduleReminderViewController.h"
#import "AccountViewController.h"
#import "PatientSegumentController.h"
#import "MenuView.h"
#import "MenuButtonPushManager.h"
#import "SigninViewController.h"
#import "SignUpViewController.h"
#import "ChatViewController.h"
#import "MyScheduleReminderViewController.h"
#import "AutoSyncManager.h"
#import "CRMUserDefalut.h"
#import "AccountManager.h"
#import "AutoSyncGetManager.h"
#import "XLIntroducerViewController.h"
#import "XLGuideView.h"
//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";

@interface TimTabBarViewController ()<EMChatManagerDelegate,XLGuideViewDelegate>{
    UIButton *menuButton;
    MenuView *menuView;
    MenuButtonPushManager *manager;
    UIView *clearView;
    
    MyScheduleReminderViewController *_scheduleReminderVC;
    XLIntroducerViewController *_introducerVC;
    PatientSegumentController *_patientVc;
    AccountViewController *_account;
}
@property (strong, nonatomic) NSDate *lastPlaySoundDate;//最后一次响铃的时间

@property (nonatomic, strong)NSTimer *timer;//用于自动上传的定时器
@property (nonatomic, strong)NSTimer *syncGetTimer;//用于自动下载的定时器

@end

@implementation TimTabBarViewController


- (void)dealloc
{
    [self unregisterNotifications];
    //移除通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:AutoSyncTimeChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:AutoSyncStateChangeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建一个定时器(NSTimer)
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(autoSyncAction:) userInfo:nil repeats:YES];
    //将定时器添加到主队列中
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    
    //判断当前自动同步是否打开
//    [self createSyncGetTimer];
    
    //添加通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncGetTimeChange:) name:AutoSyncTimeChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createSyncGetTimer) name:AutoSyncStateChangeNotification object:nil];
    
    //if 使tabBarController中管理的viewControllers都符合 UIRectEdgeNone
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    /**
     *  注册通知
     */
    [self registerNotifications];
    //设置未读数
    [self setupUnreadMessageCount];
    
    //初始化
    [self makeMainView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 当自动下载时间改变时
- (void)syncGetTimeChange:(NSNotification *)noti{
    //创建自动下载定时器
    [self createSyncGetTimer];
}

- (void)createSyncGetTimer{
    if (self.syncGetTimer != nil) {
        [self.syncGetTimer invalidate];
        self.syncGetTimer = nil;
    }
    
    //判断当前自动同步是否打开
    NSString *autoOpen = [CRMUserDefalut objectForKey:AutoSyncOpenKey];
    if (autoOpen == nil) {
        autoOpen = Auto_Action_Open;
    }
    
    if ([autoOpen isEqualToString:Auto_Action_Open]) {
        //获取系统设置的自动下载的时间
        NSString *autoTime = [CRMUserDefalut objectForKey:AutoSyncTimeKey];
        NSTimeInterval duration = 0;
        if (autoTime == nil) {
            duration = 5.0 * 60;
        }else{
            if ([autoTime isEqualToString:AutoSyncTime_Five]) {
                duration = 5.0 * 60;
            }else if ([autoTime isEqualToString:AutoSyncTime_Ten]){
                duration = 10.0 * 60;
            }else{
                duration = 20.0 * 60;
            }
        }
        //重新创建定时器
        self.syncGetTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(autoSyncGetAction:) userInfo:nil repeats:YES];
        //将定时器添加到主队列中
        [[NSRunLoop mainRunLoop] addTimer:self.syncGetTimer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark - 定时器，自动下载
- (void)autoSyncGetAction:(NSTimer *)timer{
    [[AutoSyncGetManager shareInstance] startSyncGet];
}

#pragma mark - 定时器,自动上传
- (void)autoSyncAction:(NSTimer *)timer{
    //开始同步
    [[AutoSyncManager shareInstance] startAutoSync];
}

- (void)makeMainView
{
    //日程提醒
    _scheduleReminderVC = [[MyScheduleReminderViewController alloc] init];
    TimNavigationViewController *viewController1=[[TimNavigationViewController alloc]initWithRootViewController:_scheduleReminderVC];
    
    //介绍人
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    _introducerVC = [[XLIntroducerViewController alloc] init];
    [self setTabbarItemState:_introducerVC withTitle:@"介绍人" withImage1:@"ic_tabbar_jieshaoren_grey" withImage2:@"ic_tabbar_jiashaoren_blue"];
    _introducerVC.isHome = YES;
    TimNavigationViewController* ncViewController2=[[TimNavigationViewController alloc]initWithRootViewController:_introducerVC];
    
    //患者
    _patientVc = [[PatientSegumentController alloc] init];
    [self setTabbarItemState:_patientVc withTitle:@"患者" withImage1:@"ic_tabbar_library" withImage2:@"ic_tabbar_library_active"];
    TimNavigationViewController* ncViewController3=[[TimNavigationViewController alloc]initWithRootViewController:_patientVc];
    
    
    //我的空间
    _account = [storyboard instantiateViewControllerWithIdentifier:@"AccountViewController"];
    TimNavigationViewController* ncViewController4=[[TimNavigationViewController alloc]initWithRootViewController:_account];
    [self setTabbarItemState:_account withTitle:@"我的空间" withImage1:@"ic_tabbar_me" withImage2:@"ic_tabbar_me_active"];
    
    UIViewController *vc3 = [[UIViewController alloc]init];
    TimNavigationViewController* nc3=[[TimNavigationViewController alloc]initWithRootViewController:vc3];
    
    
    self.tabBar.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:viewController1, ncViewController3, nc3,ncViewController2, ncViewController4,nil];
    [self setViewControllers:array];
    
    menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 0, SCREEN_WIDTH/5-15, self.tabBar.height);
    [menuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateSelected];
    [menuButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setCenter:CGPointMake(SCREEN_WIDTH/2,(self.tabBar.frame.size.height)/2)];
    [self.tabBar addSubview:menuButton];
    
    
    XLGuideView *guideView = [XLGuideView new];
    guideView.delegate = self;
    guideView.step = XLGuideViewStepOne;
    [guideView showInView:self.view maskViewFrame:CGRectMake((kScreenWidth - menuButton.width) / 2, kScreenHeight - self.tabBar.height, SCREEN_WIDTH / 5 - 15, self.tabBar.height)];
    
}

-(void)click:(id)sender{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight)];
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc]init];
    [tapges addTarget:self action:@selector(disMissView)];
    tapges.numberOfTapsRequired = 1;
    [clearView addGestureRecognizer:tapges];
    [window addSubview:clearView];
    
    menuView = [[MenuView alloc]init];
    [menuView setFrame:CGRectMake(SCREEN_WIDTH/2-104/2, SCREEN_HEIGHT-self.tabBar.frame.size.height-88, 104, 88)];
    [menuView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"menuView"]]];
    [window addSubview:menuView];
    
    manager = [[MenuButtonPushManager alloc]init];
    manager.viewController = (UINavigationController *)self.selectedViewController;
    menuView.delegate = manager;
}
-(void)disMissView{
    [clearView removeFromSuperview];
    [menuView removeFromSuperview];
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
            _patientVc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _patientVc.tabBarItem.badgeValue = nil;
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
        
        NSString *title = @"xuxiaolong";
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
        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
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
            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
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

#pragma mark - XLGuideViewDelegate
- (void)guideView:(XLGuideView *)guideView didClickView:(UIView *)view step:(XLGuideViewStep)step{
    //第一步跳到第二步
    if (step == XLGuideViewStepOne) {
        [self click:nil];
        XLGuideView *gView = [XLGuideView new];
        gView.delegate = self;
        gView.step = XLGuideViewStepTwo;
        [gView showInView:[UIApplication sharedApplication].keyWindow maskViewFrame:CGRectMake((kScreenWidth - menuButton.width) / 2, kScreenHeight - self.tabBar.height - 100, SCREEN_WIDTH / 5 - 15, self.tabBar.height)];
    }else{
        [guideView dismiss];
    }
    
}

@end
