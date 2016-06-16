//
//  XLCalendarSelectViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/5/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLCalendarSelectViewController.h"
#import "FSCalendar.h"
#import "MyDateTool.h"
#import "XLQueryModel.h"
#import "XLChatRecordQueryModel.h"
#import "DoctorTool.h"
#import "XLChatModel.h"
#import "DBTableMode.h"
#import "AccountManager.h"

static const NSInteger kCalendarSelectViewControllerCalendarHeight = 350;

@interface XLCalendarSelectViewController ()<FSCalendarDelegate,FSCalendarDataSource>

@property (nonatomic, strong)FSCalendar *calendar;

@property (nonatomic, strong)NSMutableArray *currentMothDataArray;

@end

@implementation XLCalendarSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    [self setUpSubViews];
    //查询数据
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - ********************* Private Method ***********************
#pragma mark 初始化
- (void)setUpSubViews{
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.title = @"按日期查找";
    [self calendar];
}

#pragma mark 首次查询数据
- (void)requestData{
    //获取当月第一天的时间
    NSString *start = [MyDateTool getMonthBeginWith:[NSDate date]];
    NSString *end = [MyDateTool getMonthEndWith:start];
    NSString *startStr = [NSString stringWithFormat:@"%@ 00:00:00",start];
    NSString *endStr = [NSString stringWithFormat:@"%@ 00:00:00",end];
    
    NSString *endStrTmp = [self getOneSecondBeforeDateStr:endStr];
    //请求数据
    [self queryChatRecordByBeginTime:startStr endTime:endStrTmp];
}

#pragma mark 模糊查询聊天记录,根据时间来查询
- (void)queryChatRecordByBeginTime:(NSString *)beginTime endTime:(NSString *)endTime{
    NSString *ids = [NSString stringWithFormat:@"%@,%@",[AccountManager currentUserid],self.patient.ckeyid];
    XLChatRecordQueryModel *queryModel = [[XLChatRecordQueryModel alloc] initWithSenderId:ids receiverId:ids beginTime:beginTime endTime:endTime keyWord:@"" sortField:@"" isAsc:YES];
    WS(weakSelf);
    [DoctorTool getAllChatRecordWithChatQueryModel:queryModel success:^(NSArray *result) {
        
        [weakSelf.currentMothDataArray removeAllObjects];
        for (XLChatModel *model in result) {
            [weakSelf.currentMothDataArray addObject:[MyDateTool stringWithDateNoTime:[MyDateTool dateWithStringWithSec:model.send_time]]];
        }
        //刷新日历
        [weakSelf.calendar reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}
#pragma mark 获取给定日期1s之前的日期
- (NSString *)getOneSecondBeforeDateStr:(NSString *)dateStr{
    NSDate *curDate = [MyDateTool dateWithStringWithSec:dateStr];
    NSDate *beforeDate = [NSDate dateWithTimeInterval:-1 sinceDate:curDate];
    NSString *beforeDateStr = [MyDateTool stringWithDateWithSec:beforeDate];
    return beforeDateStr;
}


#pragma mark - ****************** Delegate / DataSourcec ****************
#pragma mark FSCalendarDelegate/DataSource
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    if (_delegate && [_delegate respondsToSelector:@selector(calendarSelectVC:didSelectDate:)]) {
        [_delegate calendarSelectVC:self didSelectDate:date];
    }
    [self popViewControllerAnimated:YES];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSString *startDateStr = [calendar stringFromDate:calendar.currentPage format:@"yyyy-MM-dd"];
    NSString *endDateStr = [MyDateTool getMonthEndWith:[calendar stringFromDate:calendar.currentPage format:@"yyyy-MM-dd"]];
    
    NSString *startStr = [NSString stringWithFormat:@"%@ 00:00:00",startDateStr];
    NSString *endStr = [self getOneSecondBeforeDateStr:[NSString stringWithFormat:@"%@ 00:00:00",endDateStr]];
    //获取当前月的所有数据
    [self queryChatRecordByBeginTime:startStr endTime:endStr];
}

- (BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate *)date
{
    NSString *currentDateStr = [MyDateTool stringWithDateNoTime:date];
    BOOL exist = NO;
    for (NSString *time in self.currentMothDataArray) {
        if ([time isEqualToString:currentDateStr]) {
            exist = YES;
            break;
        }
    }
    return exist;
}


#pragma mark - ********************* Lazy Method ***********************
- (FSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCalendarSelectViewControllerCalendarHeight)];
        _calendar.dataSource = self;
        _calendar.delegate = self;
        _calendar.maximumDate = [NSDate dateWithTimeInterval:-24 * 60 * 60 sinceDate:[NSDate date]];
        [self.view addSubview:_calendar];
    }
    return _calendar;
}

- (NSMutableArray *)currentMothDataArray{
    if (!_currentMothDataArray) {
        _currentMothDataArray = [NSMutableArray array];
    }
    return _currentMothDataArray;
}

@end
