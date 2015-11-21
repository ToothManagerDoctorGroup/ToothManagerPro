
#import "TTMCalendarController.h"
#import "FSCalendar.h"
#import "NSDate+FSExtension.h"
#import "TTMScheduleCellModel.h"
#import "TTMScheduleRequestModel.h"
#import "TTMChairModel.h"
#import "NSString+TTMAddtion.h"

// 日历头
#define kCalendarHeaderHeight 44
#define kCalendarHeaderBackgroundColor RGBColor(60, 69, 80)
#define kCalendarHeaderFontSize 16
#define kCalendarHeaderTitleColor MainColor
// 日历
#define kCalendarHeight (ScreenHeight - NavigationHeight - kCalendarHeaderHeight)
#define kCalendarTitleFontSize 16
#define kCalendarTitleDefaultColor [UIColor blackColor]
#define kCalendarWeekdayFontSize 15
#define kCalendarWeekdayColor RGBColor(97, 101, 110)

@interface TTMCalendarController ()<
    FSCalendarDelegate,
    FSCalendarDataSource>

@property (nonatomic, weak)   FSCalendarHeader *calendarHeader; //日历头
@property (nonatomic, weak)   FSCalendar       *calendar; //日历
@property (nonatomic, strong) NSArray        *dataArray; // 数据
@end

@implementation TTMCalendarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"日程表";
    
    [self setupCalendarHeader];
    [self setupCalender];
    [self queryScheduleData];
}

- (void)setupCalendarHeader {
    FSCalendarHeader *calendarHeader = [[FSCalendarHeader alloc] init];
    calendarHeader.frame = CGRectMake(0, NavigationHeight, ScreenWidth, kCalendarHeaderHeight);
    [self.view addSubview:calendarHeader];
    self.calendarHeader = calendarHeader;
}

/**
 *  日历控件
 */
- (void)setupCalender {
    FSCalendar *calendar = [[FSCalendar alloc] init];
    calendar.frame = CGRectMake(0, self.calendarHeader.bottom, ScreenWidth, kCalendarHeight);
    calendar.delegate = self;
    calendar.dataSource = self;
    calendar.header = self.calendarHeader;
    calendar.autoAdjustTitleSize = NO;
    calendar.flow = FSCalendarFlowVertical;
    
    // header样式
    [calendar setHeaderTitleFont:[UIFont systemFontOfSize:kCalendarHeaderFontSize]];
    [calendar setHeaderTitleColor:kCalendarHeaderTitleColor];
    calendar.headerDateFormat = @"yyyy 年 MM 月";
    
    // 日历样式
    [calendar setTitleFont:[UIFont systemFontOfSize:kCalendarTitleFontSize]];
    [calendar setTitleDefaultColor:kCalendarTitleDefaultColor];
    
    [calendar setWeekdayFont:[UIFont systemFontOfSize:kCalendarWeekdayFontSize]];
    [calendar setWeekdayTextColor:kCalendarWeekdayColor];
    
    [calendar setEventColor:MainColor];
    self.calendar = calendar;
    
    [self.view addSubview:calendar];
}

#pragma mark - FSCalendarDataSource
- (BOOL)calendar:(FSCalendar *)calendarView hasEventForDate:(NSDate *)date
{
    return [self hasDate:date];
}

#pragma mark - FSCalendarDelegate
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    if ([self.delegate respondsToSelector:@selector(calendarController:selectedDate:)]) {
        [self.delegate calendarController:self selectedDate:date];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 *  刷新日程数据
 */
- (void)queryScheduleData {
    __weak __typeof(&*self) weakSelf = self;
    TTMScheduleRequestModel *request = [[TTMScheduleRequestModel alloc] init];
    request.controlType = TTMScheduleRequestModelControlTypeSchedule;
    // 查询全部
    TTMChairModel *chair = [[TTMChairModel alloc] init];
    chair.seat_name = @"全部";
    request.chair = chair;
    
    [TTMScheduleCellModel querySchedulesWithRequest:request
                                           complete:^(id result) {
                                               if ([result isKindOfClass:[NSString class]]) {
                                                   [MBProgressHUD showToastWithText:result];
                                               } else {
                                                   weakSelf.dataArray = result;
                                                   [weakSelf.calendar reloadData];
                                               }
                                           }];
}

/**
 *  数据中是否含有该日期
 *
 *  @param date 日期
 *
 *  @return BOOL
 */
- (BOOL)hasDate:(NSDate *)date {
    BOOL hasDate = NO;
    for (TTMScheduleCellModel *model in self.dataArray) {
        NSDate *modelDate = [model.appoint_time dateValue];
        if ([date fs_isEqualToDateForDay:modelDate]) {
            hasDate = YES;
        }
    }
    return hasDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
