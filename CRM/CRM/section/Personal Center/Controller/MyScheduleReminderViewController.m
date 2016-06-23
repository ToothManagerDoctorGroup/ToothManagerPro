//
//  MyScheduleReminderViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/14.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "MyScheduleReminderViewController.h"
#import "XLScheduleReminderCell.h"
#import "LocalNotificationCenter.h"
#import "DBManager+Patients.h"
#import "CRMMacro.h"
#import "PatientsCellMode.h"
#import "MudDatePickerView.h"
#import "SyncManager.h"
#import "PatientDetailViewController.h"
#import "LewPopupViewController.h"
#import "SchedulePopMenu.h"
#import "AppointDetailViewController.h"
#import "ScheduleDateButton.h"
#import "JTCalendar.h"
#import "DBManager+LocalNotification.h"
#import "MyDateTool.h"
#import "WMPageController.h"
#import "ReadMessageViewController.h"
#import "UnReadMessageViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "AutoSyncManager.h"
#import "SysMessageTool.h"
#import "JSONKit.h"
#import "DBManager+AutoSync.h"
#import "AutoSyncGetManager.h"
#import "XLAppointDetailViewController.h"
#import "CRMHttpRequest+Sync.h"
#import "XLGuideImageView.h"
#import "CRMUserDefalut.h"
#import "CRMAppDelegate.h"
#import "UIApplication+Version.h"
#import "UIImage+TTMAddtion.h"
#import "UITableView+NoResultAlert.h"
#import "ChatViewController.h"
#import "XLLoginTool.h"
#import "XLAutoGetSyncTool.h"
#import "MJRefresh.h"
#import "XLSysMessageViewController.h"
#import "XLMessageHandleManager.h"
#import "XLClinicAppointDetailViewController.h"
#import "CommonMacro.h"
#import "MBProgressHUD+XLHUD.h"

@interface MyScheduleReminderViewController ()<JTCalendarDataSource,JTCalendarDelegate,ScheduleDateButtonDelegate>

@property (nonatomic,strong) NSArray *remindArray;
@property (nonatomic, strong)NSDate *selectDate;
@property (nonatomic, strong)Patient *selectPatient;//当前选中的患者
@property (nonatomic, assign)BOOL isHide;
@property (strong, nonatomic) JTCalendar *calendar;//日历
@property (nonatomic, weak)JTCalendarContentView *contentView;
@property (nonatomic, weak)ScheduleDateButton *buttonView;
@property (nonatomic, strong)NSMutableArray *currentMonthArray;//当前月的数据
@property (nonatomic, strong)UILabel *noWlanTintView;//无网提示
@property (nonatomic, weak)UIView *dateSuperView;


@property (nonatomic, weak)MBProgressHUD *hud;
@end

@implementation MyScheduleReminderViewController

#pragma mark - ********************* Life Method ***********************
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"日程表";
    
    //设置子视图
    [self initSubViews];
    //加载数据
    [self initLocalData];
    //设置消息按钮
    [self setUpMessageItem];
    //更新registerId
    [self updateUserRegisterId];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (!self.calendar.calendarAppearance.isWeekMode && self.isHide == NO) {
        [self didClickDateButton];
        self.isHide = YES;
    }
    //显示引导页
    WS(weakSelf);
    [CRMUserDefalut isShowedForKey:Schedule_IsShowedKey showedBlock:^{
        XLGuideImageView *guideImage1 = [[XLGuideImageView alloc] initWithImage:[UIImage imageNamed:@"schedule_alertView"]];
        [guideImage1 showInView:[UIApplication sharedApplication].keyWindow dismissBlock:^{
            XLGuideImageView *guideImage2 = [[XLGuideImageView alloc] initWithImage:[UIImage imageNamed:@"schedule_patient_alertView"]];
            [guideImage2 showInView:[UIApplication sharedApplication].keyWindow autoDismiss:YES dismissBlock:^{
                //是否自动同步
                if (weakSelf.executeSyncAction) {
                    //进行自动同步
                    weakSelf.hud = [MBProgressHUD showMessag:@"正在获取最新数据" toView:[UIApplication sharedApplication].keyWindow];
                    [[AutoSyncGetManager shareInstance] startSyncGetShowSuccess:NO];
                    //进行同步操作
                    weakSelf.executeSyncAction = NO;
                }
            }];
        }];
    } noShowBlock:^{
        //是否自动同步
        if (self.executeSyncAction) {
            //进行自动同步
            self.hud = [MBProgressHUD showMessag:@"正在获取最新数据" toView:[UIApplication sharedApplication].keyWindow];
            [[AutoSyncGetManager shareInstance] startSyncGetShowSuccess:NO];
            //进行同步操作
            self.executeSyncAction = NO;
        }
    }];
}

- (void)dealloc {
    [self removeNotificationObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ********************* Private Method ***********************
#pragma mark 轻扫手势
- (void)swipUpAction:(UISwipeGestureRecognizer *)swip{
    if (!self.calendar.calendarAppearance.isWeekMode) {
        self.buttonView.isSelected = NO;
        [self didClickDateButton];
    }
}
- (void)swipDownAction:(UISwipeGestureRecognizer *)swip{
    if (self.calendar.calendarAppearance.isWeekMode) {
        self.buttonView.isSelected = YES;
        [self didClickDateButton];
    }
}

#pragma mark 下拉刷新事件
- (void)headerRefreshAction:(MJRefreshLegendHeader *)header{
    //请求所有的预约数据
    [[XLAutoGetSyncTool shareInstance] getReserverecordTableHasNext:NO];
}

#pragma mark 设置消息按钮
- (void)setUpMessageItem{
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [messageButton setImage:[UIImage imageNamed:@"schudle_xiaoxi"] forState:UIControlStateNormal];
    messageButton.titleLabel.font = [UIFont systemFontOfSize:15];
    messageButton.frame = CGRectMake(0, 0, 40, 44);
    [messageButton addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    
    _messageCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 4, 16, 16)];
    _messageCountLabel.layer.cornerRadius = 8;
    _messageCountLabel.layer.masksToBounds = YES;
    _messageCountLabel.backgroundColor = [UIColor redColor];
    _messageCountLabel.textColor = [UIColor whiteColor];
    _messageCountLabel.textAlignment = NSTextAlignmentCenter;
    _messageCountLabel.font = [UIFont systemFontOfSize:10];
    _messageCountLabel.hidden = YES;
    [messageButton addSubview:_messageCountLabel];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
}

#pragma mark 消息按钮点击事件
- (void)messageAction{
    XLSysMessageViewController *sysMessageVc = [[XLSysMessageViewController alloc] initWithStyle:UITableViewStylePlain];
    sysMessageVc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:sysMessageVc animated:YES];
}

#pragma mark 初始化子视图
- (void)initSubViews
{
    //日历选择页面
    UIView *dateSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    self.dateSuperView = dateSuperView;
    dateSuperView.backgroundColor = MyColor(246, 246, 246);
    [self.view addSubview:dateSuperView];
    //日期显示按钮
    ScheduleDateButton *buttonView = [[ScheduleDateButton alloc] initWithFrame:CGRectMake((dateSuperView.width - 100) / 2, 0, 100, 40)];
    buttonView.title = [self stringFromDate:[NSDate date]];
    self.selectDate = [NSDate date];
    buttonView.delegate = self;
    self.buttonView = buttonView;
    [dateSuperView addSubview:buttonView];
    
    //今天按钮
    UIButton *todayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [todayButton setTitle:@"今天" forState:UIControlStateNormal];
    todayButton.frame = CGRectMake(kScreenWidth - 50, 0, 50, 40);
    todayButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [todayButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [todayButton addTarget:self action:@selector(todayAction:) forControlEvents:UIControlEventTouchUpInside];
    [dateSuperView addSubview:todayButton];
    //日期显示
    JTCalendarContentView *contentView = [[JTCalendarContentView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 250)];
    UISwipeGestureRecognizer *swipUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipUpAction:)];
    swipUp.direction = UISwipeGestureRecognizerDirectionUp;
    [contentView addGestureRecognizer:swipUp];
    UISwipeGestureRecognizer *swipDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipDownAction:)];
    swipDown.direction = UISwipeGestureRecognizerDirectionDown;
    [contentView addGestureRecognizer:swipDown];
    self.contentView = contentView;
    [self.view addSubview:contentView];
    //日历
    self.calendar = [JTCalendar new];
    self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
    self.calendar.calendarAppearance.dayCircleRatio = 10. / 10.;
    self.calendar.calendarAppearance.ratioContentMenu = 1.;
    self.calendar.calendarAppearance.dayDotRatio = 1.5 / 9;
    self.calendar.calendarAppearance.dayDotColor = [UIColor redColor];
    
    [self.calendar setContentView:contentView];
    [self.calendar setCurrentDate:[NSDate date]];
    [self.calendar setDateDelegate:self];
    [self.calendar setDataSource:self];
    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40 + contentView.height, kScreenWidth, kScreenHeight - 64 - 49 - 40 - contentView.height) style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.tableFooterView = [UIView new];
    [self.view addSubview:m_tableView];
    //添加下拉刷新
    [m_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction:)];
    m_tableView.header.updatedTimeHidden = YES;
    
    //添加通知
    [self addNotificationObserver];
    //判断网络状态
    [self connectionStatusChanged];
}

#pragma mark 今日按钮点击
- (void)todayAction:(UIButton *)button{
    [self getAllDataWithCurrentDate:[NSDate date]];
    
     self.calendar.currentDateSelected = [NSDate date];
    [self calendarDidDateSelected:self.calendar date:[NSDate date]];
    [self.calendar setCurrentDate:[NSDate date]];
    self.buttonView.title = [self stringFromDate:[NSDate date]];
}
#pragma mark 标题按钮点击
- (void)titleButtonClick:(UIButton *)button{
    button.selected = !button.isSelected;
}

#pragma mark 加载数据
- (void)initLocalData {
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [self getAllDataWithCurrentDate:[NSDate date]];
}
#pragma mark 根据当前时间查询当月或当周所有的数据
- (void)getAllDataWithCurrentDate:(NSDate *)currentDate{
    self.remindArray = @[];
    [self.currentMonthArray removeAllObjects];
    //查询月数据
    NSString *startDate = [MyDateTool getMonthBeginWith:currentDate];
    NSString *endDate = [MyDateTool getMonthEndWith:startDate];
    NSArray *array = [[DBManager shareInstance] localNotificationListWithStartDate:startDate endDate:endDate];
    [self.currentMonthArray addObjectsFromArray:array];
    
    self.remindArray = [[LocalNotificationCenter shareInstance] localNotificationListWithString:[MyDateTool stringWithDateNoTime:currentDate] array:self.currentMonthArray];
    self.remindArray = [self updateListTimeArray:self.remindArray];
    
    [m_tableView createNoResultWithImageName:@"schedule_noresult_alert.png" ifNecessaryForRowCount:self.remindArray.count];
    
}

//按照时间排序  08:00  09:00 09:30
- (NSArray *)updateListTimeArray:(NSArray *)remindArray1{
    
    NSSortDescriptor *sorter=[[NSSortDescriptor alloc] initWithKey:@"reserve_time" ascending:YES];
    NSMutableArray *sortDescriptors=[[NSMutableArray alloc] initWithObjects:&sorter count:1];
    NSArray *sortArray=[remindArray1 sortedArrayUsingDescriptors:sortDescriptors];
    return sortArray;
}


#pragma mark - Notificaiton
- (void)addNotificationObserver {
    [self addObserveNotificationWithName:NotificationCreated];
    [self addObserveNotificationWithName:NOtificationUpdated];
    [self addObserveNotificationWithName:NotificationDeleted];
    [self addObserveNotificationWithName:SyncGetSuccessNotification];
    [self addObserveNotificationWithName:PatientDeleteNotification];
    [self addObserveNotificationWithName:ConnectionStatusChangedNotification];
}

- (void)removeNotificationObserver {
    [self removeObserverNotificationWithName:NotificationCreated];
    [self removeObserverNotificationWithName:NOtificationUpdated];
    [self removeObserverNotificationWithName:NotificationDeleted];
    [self removeObserverNotificationWithName:SyncGetSuccessNotification];
    [self removeObserverNotificationWithName:PatientDeleteNotification];
    [self removeObserverNotificationWithName:ConnectionStatusChangedNotification];
}

- (void)handNotification:(NSNotification *)notifacation {
    if ([notifacation.name isEqualToString:NotificationCreated] || [notifacation.name isEqualToString:NOtificationUpdated] || [notifacation.name isEqualToString:SyncGetSuccessNotification] || [notifacation.name isEqualToString:NotificationDeleted] || [notifacation.name isEqualToString:PatientDeleteNotification]) {
        
        //在主线程中刷新视图
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.hud) {
                [self.hud hideAnimated:YES];
            }
            if ([m_tableView.header isRefreshing]) {
                [m_tableView.header endRefreshing];
            }
            [self getAllDataWithCurrentDate:self.selectDate];
            
            [m_tableView reloadData];
            //刷新日历，显示红点
            [self.calendar reloadAppearance];
            [self.calendar reloadData];
        });
    }else if([notifacation.name isEqualToString:ConnectionStatusChangedNotification]){
        //判断当前的网络状态
        [self connectionStatusChanged];
    }
}

#pragma mark 判断网络状态，是否显示无网络提示视图
- (void)connectionStatusChanged{
    NetworkStatus status = [CRMAppDelegate appDelegate].connectionStatus;
    WS(weakSelf);
    if (status == NotReachable) {
        //添加无网提示视图
        [self.view addSubview:self.noWlanTintView];
        m_tableView.height -= 30;
        [UIView animateWithDuration:.35 animations:^{
            [weakSelf.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
                view.transform = CGAffineTransformMakeTranslation(0, 30);
            }];
        }];
    }else{
        if (!_noWlanTintView) return;
        m_tableView.height += 30;
        [UIView animateWithDuration:.35 animations:^{
            [weakSelf.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
                view.transform = CGAffineTransformIdentity;
            }];
        } completion:^(BOOL finished) {
            [_noWlanTintView removeFromSuperview];
            _noWlanTintView = nil;
        }];
    }
}

#pragma mark - ******************* Delegate / DataSource *********************
#pragma mark tableView delegate&dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.remindArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLScheduleReminderCell *cell = [XLScheduleReminderCell cellWithTableView:tableView];
    LocalNotification *notifi = [self.remindArray objectAtIndex:indexPath.row];
    Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:notifi.patient_id];
    
    cell.timeLabel.text = [notifi.reserve_time substringFromIndex:11];
    cell.patientNameLabel.text = patient.patient_name;
    cell.reserveTypeLabel.text = notifi.medical_place;
    cell.toothLabel.text = notifi.reserve_type;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocalNotification *notifi = [self.remindArray objectAtIndex:indexPath.row];
    Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:notifi.patient_id];
    self.selectPatient = patient;
    
    SchedulePopMenu *menuView = [SchedulePopMenu defaultPopupView];
    menuView.parentVC = self;
    
    __weak typeof(self) weakSelf = self;
    [self lew_presentPopupView:menuView animation:[LewPopupViewAnimationFade new] dismissed:^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        SEL jumpSelector = NSSelectorFromString([NSString stringWithFormat:@"junpTo%@WithNotification:",[weakSelf getSELNameWithValue:menuView.type]]);
        if(![weakSelf respondsToSelector:jumpSelector]) {
            NSLog(@"未实现此方法");
            return;
        }
        SuppressPerformSelectorLeakWarning(
                                           [weakSelf performSelector:jumpSelector withObject:notifi]);
    }];
}
#pragma mark - 获取SEL名称
- (NSString *)getSELNameWithValue:(SchedulePopMenuType)type{
    static NSDictionary *jumpMapping = nil;
    if (!jumpMapping) {
        jumpMapping = @{@(SchedulePopMenuType1) : @"AppointDetail",
                        @(SchedulePopMenuType2) : @"PatientDetail",
                        @(SchedulePopMenuType3) : @"Phone",
                        @(SchedulePopMenuType4) : @"Message"};
    }
    return jumpMapping[@(type)];
}

#pragma mark - 预约详情
- (void)junpToAppointDetailWithNotification:(LocalNotification *)notifi{
    //判断是否是诊所端预约
    if ([notifi.clinic_reserve_id integerValue] == 0) {
        //跳转到详情页面
        XLAppointDetailViewController *detailVc = [[XLAppointDetailViewController alloc] initWithStyle:UITableViewStylePlain];
        detailVc.localNoti = notifi;
        detailVc.hidesBottomBarWhenPushed = YES;
        [self pushViewController:detailVc animated:YES];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        XLClinicAppointDetailViewController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"XLClinicAppointDetailViewController"];
        detailVc.hidesBottomBarWhenPushed = YES;
        detailVc.localNoti = notifi;
        [self pushViewController:detailVc animated:YES];
    }
    
}

#pragma mark - 患者详情
- (void)junpToPatientDetailWithNotification:(LocalNotification *)notifi{
    PatientsCellMode *cellMode = [[PatientsCellMode alloc] init];
    cellMode.patientId = notifi.patient_id;
    //跳转到新的患者详情页面
    PatientDetailViewController *detailVc = [[PatientDetailViewController alloc] init];
    detailVc.patientsCellMode = cellMode;
    detailVc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:detailVc animated:YES];
}

#pragma mark - 打电话
- (void)junpToPhoneWithNotification:(LocalNotification *)notifi{
    
    if(![NSString isEmptyString:self.selectPatient.patient_phone]){
        TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"拨打电话%@",self.selectPatient.patient_phone] cancelHandler:^{
        } comfirmButtonHandlder:^{
            NSString *number = self.selectPatient.patient_phone;
            NSString *num = [[NSString alloc]initWithFormat:@"tel://%@",number];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }];
        [alertView show];
    }else{
        [SVProgressHUD showImage:nil status:@"患者未留电话"];
    }
}
#pragma mark - 发短信
- (void)junpToMessageWithNotification:(LocalNotification *)notifi{
    //跳转到即时通讯页面
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.selectPatient.ckeyid conversationType:eConversationTypeChat];
    chatController.title = self.selectPatient.patient_name;
    chatController.hidesBottomBarWhenPushed = YES;
    [self pushViewController:chatController animated:YES];
}

#pragma mark - ScheduleDateButtonDelegate
- (void)didClickDateButton{
    
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    NetworkStatus status = [CRMAppDelegate appDelegate].connectionStatus;
    
    CGFloat newHeight = 250;
    if (isPad) {
        newHeight = 350;
    }
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = 65.;
    }
    [UIView animateWithDuration:.5
                     animations:^{
                         self.contentView.height = newHeight;
                         if (status == NotReachable) {
                             m_tableView.frame = CGRectMake(0, 40 + newHeight + 30, kScreenWidth, kScreenHeight - 49 - 64 - 40 - newHeight - 30);
                         }else{
                              m_tableView.frame = CGRectMake(0, 40 + newHeight, kScreenWidth, kScreenHeight - 49 - 64 - 40 - newHeight);
                         }
                         
                         [self.view layoutIfNeeded];
                     }];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.contentView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.calendar reloadAppearance];
                         
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.contentView.layer.opacity = 1;
                                              
                                          }];
                     }];
    
    if (self.calendar.calendarAppearance.isWeekMode) {
        //定位到当前选择的时间
        self.calendar.currentDateSelected = self.selectDate;
        [self.calendar setCurrentDate:self.selectDate];
    }
    [m_tableView createNoResultWithImageName:@"schedule_noresult_alert.png" ifNecessaryForRowCount:self.remindArray.count];
}


#pragma mark - JTCalendarDataSource
- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *selectDateStr = [MyDateTool stringWithDateNoTime:date];
    NSArray *array = [[LocalNotificationCenter shareInstance] localNotificationListWithString:selectDateStr array:self.currentMonthArray];
    
    if (array.count > 0) {
        return YES;
    }else{
        return NO;
    }
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    
    self.selectDate = date;
    NSString *selectDateStr = [MyDateTool stringWithDateNoTime:date];
   self.remindArray = [[LocalNotificationCenter shareInstance] localNotificationListWithString:selectDateStr array:self.currentMonthArray];
    self.remindArray = [self updateListTimeArray:self.remindArray];
    
    [m_tableView createNoResultWithImageName:@"schedule_noresult_alert.png" ifNecessaryForRowCount:self.remindArray.count];
    
    [m_tableView reloadData];
}

#pragma mark - JTCalendarDelegate
- (void)calendar:(JTCalendar *)calendar startDate:(NSDate *)startDate endDate:(NSDate *)endDate currentDate:(NSDate *)currentDate isWeekMode:(BOOL)isWeekMode{
    NSLog(@"%@---%@",[MyDateTool stringWithDateNoTime:startDate],[MyDateTool stringWithDateNoTime:endDate]);
    self.buttonView.title = [self stringFromDate:currentDate];
    [self.currentMonthArray removeAllObjects];
    NSArray *array = [[DBManager shareInstance] localNotificationListWithStartDate:[MyDateTool stringWithDateNoTime:startDate] endDate:[MyDateTool stringWithDateNoTime:endDate]];
    [self.currentMonthArray addObjectsFromArray:array];
    [self.calendar reloadData];
}


- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    myFormatter.dateFormat = @"yyyy年M月";
    return [myFormatter stringFromDate:date];
}



#pragma mark - ********************* Lazy Method ***********************
#pragma mark 初始化控件
- (NSMutableArray *)currentMonthArray{
    if (!_currentMonthArray) {
        _currentMonthArray = [NSMutableArray array];
    }
    return _currentMonthArray;
}

#pragma mark 更新版本之后，需要调用，替换为registerId
- (void)updateUserRegisterId{
    NSString *registerId = [CRMUserDefalut objectForKey:RegisterId];
    if ([registerId isNotEmpty]) {
        [XLLoginTool updateUserRegisterId:[CRMUserDefalut objectForKey:RegisterId] success:^(CRMHttpRespondModel *respond) {} failure:^(NSError *error) {}];
    }
}
#pragma mark 无网提示视图
- (UILabel *)noWlanTintView{
    if (!_noWlanTintView) {
        _noWlanTintView = [[UILabel alloc] initWithFrame:CGRectMake(0, -30, kScreenWidth, 30)];
        _noWlanTintView.font = [UIFont systemFontOfSize:13];
        _noWlanTintView.textColor = [UIColor colorWithHex:0xf27e00];
        _noWlanTintView.backgroundColor = [UIColor colorWithHex:0xfff2b7];
        _noWlanTintView.textAlignment = NSTextAlignmentCenter;
        _noWlanTintView.text = @"当前网络不可用，请检查您的网络设置";
    }
    return _noWlanTintView;
}


@end
