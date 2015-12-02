//
//  ScheduleReminderViewController.m
//  CRM
//
//  Created by doctor on 14/10/23.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "ScheduleReminderViewController.h"
#import "ScheduleReminderCell.h"
#import "PatientsDisplayViewController.h"
#import "LocalNotificationCenter.h"
#import "DBManager+Patients.h"
#import "CRMMacro.h"
#import "PatientInfoViewController.h"
#import "PatientsCellMode.h"
#import "TimAlertView.h"
#import "MudDatePickerView.h"
#import "SyncManager.h"
#import "PatientDetailViewController.h"
#import "SysMsgViewController.h"
#import "PMCalendar.h"
#import "LewPopupViewController.h"
#import "SchedulePopMenu.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "AppointDetailViewController.h"

@interface ScheduleReminderViewController ()<MudDatePickerViewDelegate,PMCalendarControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    MudDatePickerView *datePickerView;
}
@property (nonatomic,retain) NSArray *remindArray;

@property (nonatomic, weak)PMCalendarController *pmCalenderController;

@property (nonatomic, strong)NSDate *selectDate;

@property (nonatomic, strong)Patient *selectPatient;//当前选中的患者

@end

@implementation ScheduleReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"日程提醒";
    
    self.view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1];
    
    [self setLeftBarButtonWithImage:[UIImage imageNamed:@"ic_nav_tongbu"]];
    [self setRightBarButtonWithTitle:@"消息"];
    //[self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back.png"]];
    

    
    UIImage *image1 = [[UIImage imageNamed:@"ic_tabbar_qi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image2 = [[UIImage imageNamed:@"ic_tabbar_qi_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:image1 selectedImage:image2];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIColor colorWithRed:59.0f/255.0f green:161.0f/255.0f blue:233.0f/255.0f alpha:1], NSForegroundColorAttributeName,
                                             nil] forState:UIControlStateSelected];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIColor lightGrayColor], NSForegroundColorAttributeName,
                                             nil] forState:UIControlStateNormal];
    
}

-(void)onLeftButtonAction:(id)sender{
    
    
    [SVProgressHUD showWithStatus:@"同步中..."];
    if ([[AccountManager shareInstance] isLogin]) {
        [NSTimer scheduledTimerWithTimeInterval:0.2
                                         target:self
                                       selector:@selector(callSync)
                                       userInfo:nil
                                        repeats:NO];
        
    } else {
        NSLog(@"User did not login");
        [SVProgressHUD showWithStatus:@"同步失败，请先登录..."];
        [SVProgressHUD dismiss];
        [NSThread sleepForTimeInterval: 1];
    }
}
- (void)callSync {
    [[SyncManager shareInstance] startSync];
}

- (void)onRightButtonAction:(id)sender
{
    
    UIStoryboard *storypcboard = [UIStoryboard storyboardWithName:@"PersonalCenterStoryboard" bundle:nil];
    SysMsgViewController *sysmsgVC = [storypcboard instantiateViewControllerWithIdentifier:@"SysMsgViewController"];
    sysmsgVC.hidesBottomBarWhenPushed = YES;
    [self pushViewController:sysmsgVC animated:YES];
}

- (void)initView
{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 70)];
    imageView.image = [UIImage imageNamed:@"ad_top"];
    [self.view addSubview:imageView];
    
    UIButton *beforeDayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    beforeDayButton.frame = CGRectMake(0, 0+70, 100, 40);
    [beforeDayButton setTitle:@"前一天" forState:UIControlStateNormal];
    beforeDayButton.tag = 0;
    beforeDayButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [beforeDayButton setTitleColor:[UIColor colorWithRed:59.0f/255.0f green:161.0f/255.0f blue:233.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [beforeDayButton addTarget:self action:@selector(daySelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beforeDayButton];
    
    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 10+70, 10, 20)];
    leftImageView.image = [UIImage imageNamed:@"leftArrow.png"];
    [self.view addSubview:leftImageView];
    
    UIButton *selectDayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectDayButton.frame = CGRectMake(110, 0+70, 100, 40);
    selectDayButton.tag = 2;
    [selectDayButton addTarget:self action:@selector(daySelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectDayButton];
    
    dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 4, 100, 15)];
    dayLabel.backgroundColor = [UIColor clearColor];
    dayLabel.font = [UIFont systemFontOfSize:15.0f];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    [selectDayButton addSubview:dayLabel];

    NSString *startDateString = [dateFormatter stringFromDate:[NSDate date]];
    dayLabel.text = startDateString;
    
    weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 21, 100, 15)];
    weekLabel.backgroundColor = [UIColor clearColor];
    weekLabel.font = [UIFont systemFontOfSize:15.0f];
    weekLabel.text  = [self getWeekdayFromDate:[NSDate date]];
    weekLabel.textAlignment = NSTextAlignmentCenter;
    [selectDayButton addSubview:weekLabel];
    
    UIButton *afterDayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    afterDayButton.frame = CGRectMake(220, 0+70, 100, 40);
    [afterDayButton setTitle:@"后一天" forState:UIControlStateNormal];
    afterDayButton.tag = 1;
    afterDayButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [afterDayButton setTitleColor:[UIColor colorWithRed:59.0f/255.0f green:161.0f/255.0f blue:233.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [afterDayButton addTarget:self action:@selector(daySelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:afterDayButton];
    
    UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-23, 10+70, 10, 20)];
    rightImageView.image = [UIImage imageNamed:@"rightArrow.png"];
    [self.view addSubview:rightImageView];
    
    m_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40+70, self.view.frame.size.width, self.view.frame.size.height-40-70) style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    [self.view addSubview:m_tableView];
    [self setExtraCellLineHidden:m_tableView];
    
    [self addNotificationObserver];
}

- (void)initData {
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startDateString = [dateFormatter stringFromDate:[NSDate date]];
    self.remindArray = [[LocalNotificationCenter shareInstance] localNotificationListWithString:startDateString];
    self.remindArray = [self updateListTimeArray:self.remindArray];
}

//按照时间排序  08:00  09:00 09:30
- (NSArray *)updateListTimeArray:(NSArray *)remindArray1{
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *remindArray = remindArray1;
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
    for(NSInteger i =0;i<remindArray.count;i++){
        LocalNotification *notifi = [remindArray objectAtIndex:i];
        NSMutableDictionary *dir=[[NSMutableDictionary alloc]init];
        [dir setObject:[notifi.reserve_time substringWithRange:NSMakeRange(11, 5)] forKey:@"time"];
        [dataArray addObject:dir];
    }
    
    NSMutableArray *myArray=[[NSMutableArray alloc]initWithCapacity:0];
    [myArray addObjectsFromArray:dataArray];
    NSSortDescriptor *sorter=[[NSSortDescriptor alloc]initWithKey:@"time" ascending:YES];
    NSMutableArray *sortDescriptors=[[NSMutableArray alloc]initWithObjects:&sorter count:1];
    NSArray *sortArray=[myArray sortedArrayUsingDescriptors:sortDescriptors];
    
    for (int i=0; i<[sortArray count]; i++) {
        NSString *sortString = [[sortArray objectAtIndex:i] objectForKey:@"time"];
        for(NSInteger i =0;i<remindArray.count;i++){
            LocalNotification *notifi = [remindArray objectAtIndex:i];
            NSString *string = [notifi.reserve_time substringWithRange:NSMakeRange(11, 5)];
            if([string isEqualToString:sortString]){
                [resultArray addObject:notifi];
            }
        }
    }
    return resultArray;
}
- (NSString *)getWeekdayFromDate:(NSDate*)date
{
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    components = [calendar components:unitFlags fromDate:date];
    NSUInteger weekday = [components weekday];
    NSString *weekString;
    switch (weekday) {
        case 1:
        {
            weekString = @"周日";
        }
            break;
        case 2:
        {
            weekString = @"周一";
        }
            break;
        case 3:
        {
            weekString = @"周二";
        }
            break;
        case 4:
        {
            weekString = @"周三";
        }
            break;
        case 5:
        {
            weekString = @"周四";
        }
            break;
        case 6:
        {
            weekString = @"周五";
        }
            break;
        case 7:
        {
            weekString = @"周六";
        }
            break;
        default:
            break;
    }
    return weekString;
}

- (void)daySelected:(UIButton *)sender
{
    int count = 1;
    switch (sender.tag) {
        case 0:
        {
            count = -1;
        }
            break;
            
        case 1:
        {
            count = 1;
        }
            break;
        case 2:
        {
            [self createDatePicker];
//            PMCalendarController *pmCalenderController = [[PMCalendarController alloc] init];
//            self.pmCalenderController = pmCalenderController;
//            pmCalenderController.delegate = self;
//            pmCalenderController.mondayFirstDayOfWeek = YES;
//            pmCalenderController.allowsPeriodSelection = NO;
//            pmCalenderController.allowsLongPressYearChange = NO;
//            [pmCalenderController presentCalendarFromView:sender
//                 permittedArrowDirections:PMCalendarArrowDirectionAny
//                                 animated:YES];

        }
            break;
        default:
            break;
    }
    
    if (sender.tag == 0 || sender.tag == 1) {
        NSDate *startDate = [dateFormatter dateFromString:dayLabel.text];
        NSDate *destDate =  [[NSDate date] initWithTimeInterval:24*60*60*count sinceDate:startDate];
        NSString *destDateString = [dateFormatter stringFromDate:destDate];
        dayLabel.text = destDateString;
        weekLabel.text = [self getWeekdayFromDate:destDate];
        self.remindArray = [[LocalNotificationCenter shareInstance] localNotificationListWithString:destDateString];
        self.remindArray = [self updateListTimeArray:self.remindArray];
        [m_tableView reloadData];
    }
    
}

#pragma mark PMCalendarControllerDelegate methods
- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    NSString *selectDateStr = [newPeriod.endDate dateStringWithFormat:@"yyyy-MM-dd"];
    NSDate *selectDate = [dateFormatter dateFromString:selectDateStr];
    dayLabel.text = selectDateStr;
    weekLabel.text = [self getWeekdayFromDate:selectDate];
    self.remindArray = [[LocalNotificationCenter shareInstance] localNotificationListWithString:selectDateStr];
    self.remindArray = [self updateListTimeArray:self.remindArray];
    [m_tableView reloadData];
    
//    [self.pmCalenderController dismissCalendarAnimated:YES];
}

- (void)createDatePicker
{
    if (datePickerView) {
        return;
    }
    
    NSDate *selectDate = [dateFormatter dateFromString:dayLabel.text];
    
    if (datePickerView == nil) {
        datePickerView = [[MudDatePickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-260, SCREEN_WIDTH, 260)];
        datePickerView.delegate = self;
        datePickerView.date = selectDate;
    }
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.4f];//设置时延
    [animation setType:kCATransitionMoveIn];//设置移动样式大类，推入，移入，淡入，暴露
    [animation setSubtype:kCATransitionFromTop];//移动样式子类,左，右，上，下
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];//设置动画开始、结束快慢。
    [[datePickerView layer] addAnimation:animation forKey:@"keyForAnimation"];//kCATransitionReveal keep the animation unique
    [self.view addSubview:datePickerView];
}

#pragma MudDatePickerViewDelegate -mark

- (void)certainButtonOnClickedWithDateString:(NSString *)dateString
{
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.4f];
    datePickerView.frame = CGRectMake(0, self.view.frame.size.height, datePickerView.frame.size.width, datePickerView.frame.size.height);
    [UIView commitAnimations];
    [self performSelector:@selector(animationFinishedrecharge) withObject:nil afterDelay:0.3];
    
    NSDate *selectDate = [dateFormatter dateFromString:dateString];
    
    dayLabel.text = dateString;
    weekLabel.text = [self getWeekdayFromDate:selectDate];
    self.remindArray = [[LocalNotificationCenter shareInstance] localNotificationListWithString:dateString];
    self.remindArray = [self updateListTimeArray:self.remindArray];
    [m_tableView reloadData];
}

- (void)cancelButtonOnClicked
{
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.4f];
    datePickerView.frame = CGRectMake(0, self.view.frame.size.height, datePickerView.frame.size.width, datePickerView.frame.size.height);
    [UIView commitAnimations];
    [self performSelector:@selector(animationFinishedrecharge) withObject:nil afterDelay:0.3];
}

-(void)animationFinishedrecharge
{
    [datePickerView removeFromSuperview];
    datePickerView = nil;
}

#pragma mark - Notificaiton
- (void)addNotificationObserver {
    [self addObserveNotificationWithName:NotificationCreated];
    [self addObserveNotificationWithName:NOtificationUpdated];
    [self addObserveNotificationWithName:@"tongbu"];
}

- (void)removeNotificationObserver {
    [self removeObserverNotificationWithName:NotificationCreated];
    [self removeObserverNotificationWithName:NOtificationUpdated];
    [self removeObserverNotificationWithName:@"tongbu"];
}

- (void)handNotification:(NSNotification *)notifacation {
    if ([notifacation.name isEqualToString:NotificationCreated] || [notifacation.name isEqualToString:NOtificationUpdated]) {
        NSDate *startDate = [dateFormatter dateFromString:dayLabel.text];
        NSString *destDateString = [dateFormatter stringFromDate:startDate];
        self.remindArray = [[LocalNotificationCenter shareInstance] localNotificationListWithString:destDateString];
        self.remindArray = [self updateListTimeArray:self.remindArray];
        [m_tableView reloadData];
    }

    if ([notifacation.name isEqualToString:@"tongbu"]) {
        
        //同步之后，重新请求本地数据进行显示
        NSString *dateString = dayLabel.text;
        self.remindArray = [[LocalNotificationCenter shareInstance] localNotificationListWithString:dateString];
        self.remindArray = [self updateListTimeArray:self.remindArray];
        
        [m_tableView reloadData];
    }
}

#pragma tableView delegate&dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.remindArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TimAlertView *alertView = [[TimAlertView alloc]initWithTitle:@"确认删除？" message:nil  cancelHandler:^{
            [tableView reloadData];
        } comfirmButtonHandlder:^{
            LocalNotification *notifi = [self.remindArray objectAtIndex:indexPath.row];
            BOOL ret = [[LocalNotificationCenter shareInstance] removeLocalNotification:notifi];
            if (ret) {
                self.remindArray = [[LocalNotificationCenter shareInstance] localNotificationListWithString:dayLabel.text];
                self.remindArray = [self updateListTimeArray:self.remindArray];
                [m_tableView reloadData];
            }
        }];
        [alertView show];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        cell = [[ScheduleReminderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    LocalNotification *notifi = [self.remindArray objectAtIndex:indexPath.row];
    Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:notifi.patient_id];
    
    cell.personLabel.text = [notifi.reserve_time substringFromIndex:11];
    cell.statusLabel.text = patient.patient_name;
    cell.timeLabel.text = notifi.reserve_type;
    cell.medical_chairLabel.text = notifi.tooth_position;
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
        switch (menuView.type) {
            case SchedulePopMenuType1:
                //预约详情
                [weakSelf junpToAppointDetailWithNotification:notifi];
                break;
            case SchedulePopMenuType2:
                //患者详情
                [weakSelf junpToPatientDetailWithNotification:notifi];
                break;
            case SchedulePopMenuType3:
                //打电话
                [weakSelf junpToPhoneWithNotification:notifi];
                break;
            case SchedulePopMenuType4:
                //发短信
                [weakSelf junpToMessageWithNotification:notifi];
                break;
            default:
                break;
        }
    }];
}
//预约详情
- (void)junpToAppointDetailWithNotification:(LocalNotification *)notifi{
    //跳转到详情页面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    AppointDetailViewController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"AppointDetailViewController"];
    detailVc.hidesBottomBarWhenPushed = YES;
    detailVc.isHomeTo = YES;
    detailVc.localNoti = notifi;
    [self.navigationController pushViewController:detailVc animated:YES];
}

//患者详情
- (void)junpToPatientDetailWithNotification:(LocalNotification *)notifi{
    PatientsCellMode *cellMode = [[PatientsCellMode alloc] init];
    cellMode.patientId = notifi.patient_id;
    //跳转到新的患者详情页面
    PatientDetailViewController *detailVc = [[PatientDetailViewController alloc] init];
    detailVc.patientsCellMode = cellMode;
    detailVc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:detailVc animated:YES];
}

//打电话
- (void)junpToPhoneWithNotification:(LocalNotification *)notifi{
    
    if(![NSString isEmptyString:self.selectPatient.patient_phone]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"拨打电话%@",self.selectPatient.patient_phone] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 101;
        [alertView show];
    }else{
        [SVProgressHUD showImage:nil status:@"患者未留电话"];
    }
}
//发短信
- (void)junpToMessageWithNotification:(LocalNotification *)notifi{
    if(![NSString isEmptyString:self.selectPatient.patient_phone]){
        if( [MFMessageComposeViewController canSendText] ){
            MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init]; //autorelease];
            controller.recipients = @[self.selectPatient.patient_phone];
            controller.body = notifi.reserve_type;
            controller.messageComposeDelegate = self;
            //跳转到发送短信的页面
            [self presentViewController:controller animated:YES completion:nil];
            [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"发送短信页面"];//修改短信界面标题
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"设备没有短信功能"];
        }
    }else{
        [SVProgressHUD showImage:nil status:@"患者未留电话"];
    }
}
//短信是否发送成功
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:NO completion:nil];//关键的一句   不能为YES
    switch ( result ) {
        case MessageComposeResultCancelled:
            [SVProgressHUD showImage:nil status:@"取消发送信息"];
            break;
        case MessageComposeResultFailed:
            [SVProgressHUD showImage:nil status:@"发送信息失败"];
            break;
        case MessageComposeResultSent:
            [SVProgressHUD showImage:nil status:@"发送信息成功"];
            break;
        default:
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 101){
        if(buttonIndex == 0){
        }else{
            NSString *number = self.selectPatient.patient_phone;
            NSString *num = [[NSString alloc]initWithFormat:@"tel://%@",number];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }
    }
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    UIView *view1 =[ [UIView alloc]initWithFrame:CGRectZero];
    view1.backgroundColor = [UIColor clearColor];
    [tableView setTableHeaderView:view1];
}

- (void)dealloc {
    [self removeNotificationObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
