//
//  XLSelectYuyueViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/21.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLSelectYuyueViewController.h"
#import "LocalNotificationCenter.h"
#import "DBManager+Patients.h"
#import "DBTableMode.h"
#import "MLKMenuPopover.h"
#import "MyYuyueTitleView.h"
#import "ClinicPopMenu.h"
#import "ClinicCover.h"
#import "MenuTitleViewController.h"
#import "MyDateTool.h"
#import "XLSelectYuyueCell.h"
#import "FSCalendar.h"
#import "XLAddReminderViewController.h"
#import "DBManager+LocalNotification.h"

static const NSInteger kSelectYuyueViewControllerCalendarHeight = 250;

@interface XLSelectYuyueViewController ()<ClinicCoverDelegate,MenuTitleViewControllerDelegate,FSCalendarDelegate,FSCalendarDataSource,XLAddReminderViewControllerDelegate>
@property (nonatomic,retain) NSArray *remindArray; //被预约的时间数组
@property (nonatomic, strong)NSMutableArray *dataSuperArray;//混合数组
@property (nonatomic, weak)FSCalendar *calendar;//日历
@property (nonatomic, strong)NSDate *selectDate;//当前选中的日期
@property (nonatomic, strong)NSMutableArray *currentMothArray;//当前月所有的数据
@property (nonatomic, strong)NSMutableArray *currentDayArray;//当前天所有的数据

@property (nonatomic,assign) NSInteger actionSheetInt;//当前选中的索引
@property (nonatomic,copy) NSString *actionSheetTime;//选中的时间
@end

@implementation XLSelectYuyueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置导航栏
    [self setUpNav];
    
    //加载子视图
    [self setUpSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.isEditAppointment) {
        [self.calendar selectDate:[MyDateTool dateWithStringNoSec:self.reserveTime]];
        [self getAllDataWithDate:[MyDateTool dateWithStringNoSec:self.reserveTime]];
        [self requestDataWithDate:[MyDateTool dateWithStringNoSec:self.reserveTime]];
    }else{
        if (self.selectDate) {
            [self getAllDataWithDate:self.selectDate];
            [self requestDataWithDate:self.selectDate];
        }else{
            [self getAllDataWithDate:[NSDate date]];
            [self requestDataWithDate:[NSDate date]];
        }
    }
    
    [self.calendar reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - Private Method
#pragma mark 获取当月的所有数据
- (void)getAllDataWithDate:(NSDate *)date{
    [self.currentMothArray removeAllObjects];
    NSString *beginStr = [MyDateTool getMonthBeginWith:date];
    NSString *endStr = [MyDateTool getMonthEndWith:beginStr];
    NSArray *array = [[DBManager shareInstance] localNotificationListWithStartDate:beginStr endDate:endStr];
    [self.currentMothArray addObjectsFromArray:array];
}
#pragma mark 今天按钮点击
- (void)onRightButtonAction:(id)sender{
    [self.calendar selectDate:[NSDate date]];
    [self requestDataWithDate:[NSDate date]];
}
#pragma mark 设置导航栏
- (void)setUpNav{
    self.title = @"选择时间";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back.png"]];
    [self setRightBarButtonWithTitle:@"今天"];
}
#pragma mark 设置子视图
- (void)setUpSubViews{
    timeArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < 31; i++) {
        if (i%2 == 0) {
            if (8+i/2 < 10) {
                [timeArray addObject:[NSString stringWithFormat:@"0%d:00",8+i/2]];
            } else {
                [timeArray addObject:[NSString stringWithFormat:@"%d:00",8+i/2]];
            }
        }
        else {
            if (8+i/2 < 10) {
                [timeArray addObject:[NSString stringWithFormat:@"0%d:30",8+i/2]];
            } else {
                [timeArray addObject:[NSString stringWithFormat:@"%d:30",8+i/2]];
            }
        }
    }
    m_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.backgroundColor = [UIColor clearColor];
    m_tableView.backgroundView = nil;
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSelectYuyueViewControllerCalendarHeight)];
    calendar.dataSource = self;
    calendar.delegate = self;
    [self.view addSubview:calendar];
    self.calendar = calendar;
    m_tableView.tableHeaderView = calendar;
    
    [self.view addSubview:m_tableView];
}

#pragma mark - Delegate/DataSource
#pragma mark -FSCalendar Delegate/DataSource
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    self.selectDate = date;
    [self requestDataWithDate:date];
}

- (void)requestDataWithDate:(NSDate *)date{
    
    NSString *dateStr = [MyDateTool stringWithDateNoTime:date];
    self.remindArray = [[LocalNotificationCenter shareInstance] localNotificationListWithString:dateStr array:self.currentMothArray];
    dateString = dateStr;
    
    
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在加载"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [weakSelf.dataSuperArray removeAllObjects];
        for (NSString *time in timeArray) {
            NSMutableArray *subArr = [NSMutableArray array];
            //拼接时间
            NSString *targetDateStr = [NSString stringWithFormat:@"%@ %@",dateStr,time];
            for (LocalNotification *noti in weakSelf.remindArray) {
                if ([targetDateStr isEqualToString:noti.reserve_time]) {
                    //表名当前时间在时间跨度内
                    [subArr addObject:noti];
                }else if(![targetDateStr isEqualToString:noti.reserve_time_end]){
                    if ([MyDateTool timeInStartTime:noti.reserve_time endTime:noti.reserve_time_end targetTime:targetDateStr]) {
                        [subArr addObject:noti];
                    }
                }
            }
            [weakSelf.dataSuperArray addObject:subArr];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [m_tableView reloadData];
        });
    });
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSString *startDateStr = [calendar stringFromDate:calendar.currentPage format:@"yyyy-MM-dd"];
    [self.currentMothArray removeAllObjects];
    //获取当前月的所有数据
    NSString *endDateStr = [MyDateTool getMonthEndWith:[calendar stringFromDate:calendar.currentPage format:@"yyyy-MM-dd"]];
    //查询当月数据
    NSArray *array = [[DBManager shareInstance] localNotificationListWithStartDate:startDateStr endDate:endDateStr];
    
    [self.currentMothArray addObjectsFromArray:array];
    [self.calendar reloadData];
    
}

- (BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate *)date
{
    //获取当前
    NSString *selectDateStr = [MyDateTool stringWithDateNoTime:date];
    NSArray *array = [[LocalNotificationCenter shareInstance] localNotificationListWithString:selectDateStr array:self.currentMothArray];
    if (array.count > 0) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark -tableView delegate&dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSuperArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XLSelectYuyueCell *cell = [XLSelectYuyueCell cellWithTableView:tableView];
    NSString *string = [timeArray objectAtIndex:indexPath.row];
    cell.time = string;
    cell.models = self.dataSuperArray[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"设定时长"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"30分钟"
                                                   otherButtonTitles:@"1小时",@"90分钟",@"2小时", nil];
    self.actionSheetInt = indexPath.row;
    self.actionSheetTime = [NSString stringWithFormat:@"%@ %@",dateString,[timeArray objectAtIndex:indexPath.row]];
    [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
    [actionSheet showInView:self.view];
}
#pragma mark -ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    switch (buttonIndex) {
        case 0:
        {
            dicM[@"time"] = self.actionSheetTime;
            dicM[@"duration"] = @"30分钟";
            dicM[@"durationFloat"] = @"0.5";
        }
            break;
        case 1:
        {
            dicM[@"time"] = self.actionSheetTime;
            dicM[@"duration"] = @"1小时";
            dicM[@"durationFloat"] = @"1.0";
        }
            break;
        case 2:
        {
            dicM[@"time"] = self.actionSheetTime;
            dicM[@"duration"] = @"90分钟";
            dicM[@"durationFloat"] = @"1.5";
        }
            break;
        case 3:
        {
            dicM[@"time"] = self.actionSheetTime;
            dicM[@"duration"] = @"2小时";
            dicM[@"durationFloat"] = @"2.0";
        }
        default:
            
            break;
    }
    
    if ([dicM[@"time"] isNotEmpty]) {
        if (self.isEditAppointment) {
            //选择时间页面
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectYuyueViewController:didSelectData:)]) {
                [self.delegate selectYuyueViewController:self didSelectData:dicM];
            }
            [self popViewControllerAnimated:YES];
            
        }else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            XLAddReminderViewController *addreminderVc = [storyboard instantiateViewControllerWithIdentifier:@"XLAddReminderViewController"];
            addreminderVc.infoDic = dicM;
            if (self.isNextReserve) {
                addreminderVc.isNextReserve = self.isNextReserve;
                addreminderVc.medicalCase = self.medicalCase;
                addreminderVc.delegate = self;
            }else if (self.isAddLocationToPatient){
                addreminderVc.isAddLocationToPatient = self.isAddLocationToPatient;
                addreminderVc.patient = self.patient;
            }
            [self pushViewController:addreminderVc animated:YES];
        }
    }
}

- (BOOL)compareWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    NSString *startStr = [MyDateTool stringWithDateNoSec:startDate];
    NSString *endStr = [MyDateTool stringWithDateNoSec:endDate];
    BOOL compareResult = NO;
    if (self.remindArray.count > 0) {
        for (LocalNotification *note in self.remindArray) {
            BOOL result = [MyDateTool timeInStartTime:startStr endTime:endStr targetTime:note.reserve_time];
            if (result) {
                compareResult = YES;
            }
        }
    }
    return compareResult;
}

#pragma mark -XLAddReminderViewControllerDelegate
- (void)addReminderViewController:(XLAddReminderViewController *)vc didSelectDateTime:(NSString *)dateStr{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectYuyueViewController:didSelectDateTime:)]) {
        [self.delegate selectYuyueViewController:self didSelectDateTime:dateStr];
    }
    //关闭当前视图
    [self popViewControllerAnimated:YES];
}

#pragma mark - 初始化子控件（懒加载）
- (NSMutableArray *)currentDayArray{
    if (!_currentDayArray) {
        _currentDayArray = [NSMutableArray array];
    }
    return _currentDayArray;
}

- (NSMutableArray *)currentMothArray{
    if (!_currentMothArray) {
        _currentMothArray = [NSMutableArray array];
    }
    return _currentMothArray;
}

- (NSMutableArray *)dataSuperArray{
    if (!_dataSuperArray) {
        _dataSuperArray = [NSMutableArray array];
    }
    return _dataSuperArray;
}

@end
