//
//  XLSelectYuyueViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/21.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLSelectYuyueViewController.h"
#import "SelectDateCell.h"
#import "AddReminderViewController.h"
#import "LocalNotificationCenter.h"
#import "DBManager+Patients.h"
#import "DBTableMode.h"
#import "MLKMenuPopover.h"
#import "MyYuyueTitleView.h"
#import "ClinicPopMenu.h"
#import "ClinicCover.h"
#import "MenuTitleViewController.h"
#import "MyDateTool.h"
#import "NSDate+Helpers.h"
#import "XLSelectYuyueCell.h"
#import "FSCalendar.h"
#import "XLAddReminderViewController.h"

@interface XLSelectYuyueViewController ()<ClinicCoverDelegate,MenuTitleViewControllerDelegate,FSCalendarDelegate,FSCalendarDataSource,XLAddReminderViewControllerDelegate>
@property (nonatomic,retain) NSArray *remindArray; //被预约的时间数组
@property (nonatomic,retain) NSMutableArray *remindTwoArray; //被占用的时间数组

@property (nonatomic, strong)NSMutableArray *dataSuperArray;//混合数组

@property (nonatomic,assign) NSInteger actionSheetInt;
@property (nonatomic,copy) NSString *actionSheetTime;

@property (nonatomic, weak)FSCalendar *calendar;//日历

@end

@implementation XLSelectYuyueViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startDateString = [dateFormatter stringFromDate:[NSDate date]];
    dateString = startDateString;
    self.remindArray = [[LocalNotificationCenter shareInstance] localNotificationListWithString:startDateString];
    
    for (NSString *time in timeArray) {
        NSMutableArray *subArr = [NSMutableArray array];
        //拼接时间
        NSString *targetDateStr = [NSString stringWithFormat:@"%@ %@",startDateString,time];
        for (LocalNotification *noti in self.remindArray) {
            if ([targetDateStr isEqualToString:noti.reserve_time] || [MyDateTool timeInStartTime:noti.reserve_time endTime:noti.reserve_time_end targetTime:targetDateStr]) {
                //表名当前时间在时间跨度内
                [subArr addObject:noti];
            }
        }
        [self.dataSuperArray addObject:subArr];
    }
    
    [m_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isHome) {
        //去除多余的视图
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UIView *view = keyWindow.subviews[1];
        [view removeFromSuperview];
    }
    
    self.dataSuperArray = [NSMutableArray array];
    
    
    self.title = @"选择时间";
    self.view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back.png"]];
    [self setRightBarButtonWithTitle:@"今天"];
    
    timeArray = [[NSMutableArray alloc]initWithCapacity:0];
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
    
    CGFloat height = 250;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    calendar.dataSource = self;
    calendar.delegate = self;
    [self.view addSubview:calendar];
    self.calendar = calendar;
    m_tableView.tableHeaderView = calendar;
    
    [self.view addSubview:m_tableView];
    
}
//今天按钮点击
- (void)onRightButtonAction:(id)sender{
//    [self.calendar selectDate:[NSDate date] scrollToDate:NO];
//    [self.calendar setCurrentPage:[NSDate date]];
    [self.calendar selectDate:[NSDate date]];
    
    [self requestDataWithDate:[NSDate date]];
}

#pragma mark - FSCalendar Delegate/DataSource
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    [self requestDataWithDate:date];
}

- (void)requestDataWithDate:(NSDate *)date{
    NSString *dateStr = [date dateStringWithFormat:@"yyyy-MM-dd"];
    self.remindArray = [[LocalNotificationCenter shareInstance] localNotificationListWithString:dateStr];
    dateString = dateStr;
    
    [self.dataSuperArray removeAllObjects];
    for (NSString *time in timeArray) {
        NSMutableArray *subArr = [NSMutableArray array];
        //拼接时间
        NSString *targetDateStr = [NSString stringWithFormat:@"%@ %@",dateStr,time];
        for (LocalNotification *noti in self.remindArray) {
            if ([targetDateStr isEqualToString:noti.reserve_time]) {
                //表名当前时间在时间跨度内
                [subArr addObject:noti];
            }else if(![targetDateStr isEqualToString:noti.reserve_time_end]){
                if ([MyDateTool timeInStartTime:noti.reserve_time endTime:noti.reserve_time_end targetTime:targetDateStr]) {
                    [subArr addObject:noti];
                }
            }
        }
        [self.dataSuperArray addObject:subArr];
    }
    
    [m_tableView reloadData];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"did change to page %@",[calendar stringFromDate:calendar.currentPage format:@"MMMM YYYY"]);
}

- (BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate *)date
{
    NSString *selectDateStr = [date dateStringWithFormat:@"yyyy-MM-dd"];
    NSArray *array = [[LocalNotificationCenter shareInstance] localNotificationListWithString:selectDateStr];
    if (array.count > 0) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - tableView delegate&dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return timeArray.count;
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
#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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
    
    if (self.remindTwoArray.count > 0) {
        for (NSString *targetStr in self.remindTwoArray) {
            NSString *changeStr = [MyDateTool stringWithDateNoSec:[MyDateTool dateWithStringWithSec:targetStr]];
            BOOL result = [MyDateTool timeInStartTime:startStr endTime:endStr targetTime:changeStr];
            if (result) {
                compareResult = YES;
            }
        }
    }
    return compareResult;
}

#pragma mark - XLAddReminderViewControllerDelegate
- (void)addReminderViewController:(XLAddReminderViewController *)vc didSelectDateTime:(NSString *)dateStr{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectYuyueViewController:didSelectDateTime:)]) {
        [self.delegate selectYuyueViewController:self didSelectDateTime:dateStr];
    }
    //关闭当前视图
    [self popViewControllerAnimated:YES];
}

@end
