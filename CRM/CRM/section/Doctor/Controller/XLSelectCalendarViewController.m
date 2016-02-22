//
//  XLSelectCalendarViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/24.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLSelectCalendarViewController.h"
#import "FSCalendar.h"
#import "MyDateTool.h"

@interface XLSelectCalendarViewController ()<FSCalendarDelegate,FSCalendarDataSource>
@property (nonatomic, weak)FSCalendar *calendar;//日历
@end

@implementation XLSelectCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.title = @"选择时间";
    [self setRightBarButtonWithTitle:@"今天"];
    
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 350)];
    calendar.dataSource = self;
    calendar.delegate = self;
    
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
}

- (void)onBackButtonAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onRightButtonAction:(id)sender{
    [self.calendar setCurrentPage:[NSDate date]];
}

#pragma mark - FSCalendar Delegate/DataSource
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectCalendarViewController:didSelectDateStr:type:)]) {
        [self.delegate selectCalendarViewController:self didSelectDateStr:[MyDateTool stringWithDateWithSec:date] type:self.type];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"did change to page %@",[calendar stringFromDate:calendar.currentPage format:@"MMMM YYYY"]);
}

- (BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate *)date
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
