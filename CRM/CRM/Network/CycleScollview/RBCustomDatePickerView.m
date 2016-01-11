//
//  RBCustomDatePickerView.m
//  RBCustomDateTimePicker
//  e-mail:rbyyy924805@163.com
//  Created by renbing on 3/17/14.
//  Copyright (c) 2014 renbing. All rights reserved.
//

#import "RBCustomDatePickerView.h"
#import "MyDateTool.h"

@interface RBCustomDatePickerView()
{
    UIView                      *timeBroadcastView;//定时播放显示视图
    MXSCycleScrollView          *yearScrollView;//年份滚动视图
    MXSCycleScrollView          *monthScrollView;//月份滚动视图
    MXSCycleScrollView          *dayScrollView;//日滚动视图
    MXSCycleScrollView          *hourScrollView;//时滚动视图
    MXSCycleScrollView          *minuteScrollView;//分滚动视图
//    MXSCycleScrollView          *secondScrollView;//秒滚动视图
    UILabel                     *nowPickerShowTimeLabel;//当前picker显示的时间
//    UILabel                     *selectTimeIsNotLegalLabel;//所选时间是否合法
    UIButton                    *okBtn;//自定义picker上的确认按钮
    UIButton                    *cancleButton;//取消按钮
}
@property (nonatomic, copy)NSString *selectDateStr;

@end

@implementation RBCustomDatePickerView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0;
    }
    return self;
}

- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = .8;
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
#pragma mark -custompicker
//设置自定义datepicker界面
- (void)setTimeBroadcastView
{
    nowPickerShowTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(17.0, 117.0 + 40, 278.5, 18)];
    [nowPickerShowTimeLabel setBackgroundColor:[UIColor clearColor]];
    [nowPickerShowTimeLabel setFont:[UIFont systemFontOfSize:18.0]];
    [nowPickerShowTimeLabel setTextColor:[UIColor whiteColor]];
    [nowPickerShowTimeLabel setTextAlignment:NSTextAlignmentCenter];
    NSDate *now = nil;
    if (self.currentDateStr && [self.currentDateStr isNotEmpty]) {
        now = [MyDateTool dateWithStringNoSec:self.currentDateStr];
    }else {
        now = [NSDate date];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
    
    self.selectDateStr = [MyDateTool stringWithDateNoSec:now];
    
    NSString *dateString = [dateFormatter stringFromDate:now];
    NSString *weekString = [self fromDateToWeek:dateString];
    NSInteger monthInt = [dateString substringWithRange:NSMakeRange(4, 2)].integerValue;
    NSInteger dayInt = [dateString substringWithRange:NSMakeRange(6, 2)].integerValue;
    nowPickerShowTimeLabel.text = [NSString stringWithFormat:@"%@年%ld月%ld日 %@ %@:%@",[dateString substringWithRange:NSMakeRange(0, 4)],(long)monthInt,(long)dayInt,weekString,[dateString substringWithRange:NSMakeRange(8, 2)],[dateString substringWithRange:NSMakeRange(10, 2)]];
    [self addSubview:nowPickerShowTimeLabel];
    
    timeBroadcastView = [[UIView alloc] initWithFrame:CGRectMake(20, 140 + 50, 278.5, 190.0)];
    timeBroadcastView.layer.cornerRadius = 8;//设置视图圆角
    timeBroadcastView.layer.masksToBounds = YES;
    CGColorRef cgColor = MyColor(44, 188, 255).CGColor;
    timeBroadcastView.layer.borderColor = cgColor;
    timeBroadcastView.layer.borderWidth = 2.0;
    timeBroadcastView.backgroundColor = [UIColor whiteColor];
    [self addSubview:timeBroadcastView];
    UIView *beforeSepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 39, 278.5, 1.5)];
    [beforeSepLine setBackgroundColor:MyColor(44, 188, 255)];
    [timeBroadcastView addSubview:beforeSepLine];
    UIView *middleSepView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, 278.5, 38)];
    [middleSepView setBackgroundColor:MyColor(44, 188, 255)];
    [timeBroadcastView addSubview:middleSepView];
    UIView *bottomSepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 150.5, 278.5, 1.5)];
    [bottomSepLine setBackgroundColor:MyColor(44, 188, 255)];
    [timeBroadcastView addSubview:bottomSepLine];
    [self setYearScrollView];
    [self setMonthScrollView];
    [self setDayScrollView];
    [self setHourScrollView];
    [self setMinuteScrollView];
//    [self setSecondScrollView];
    
    
    okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    okBtn.frame = CGRectMake(20 + 283.5 / 2, 339.5 + 50, 273.5 / 2, 40);
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okBtn.backgroundColor = MyColor(0, 160, 234);
    okBtn.layer.cornerRadius = 5;
    okBtn.layer.masksToBounds = YES;
    [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:okBtn];
    
    cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.frame = CGRectMake(20, 339.5 + 50, 273.5 / 2, 40);
    [cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancleButton.backgroundColor = [UIColor lightGrayColor];
    cancleButton.layer.cornerRadius = 5;
    cancleButton.layer.masksToBounds = YES;
    [cancleButton addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancleButton];
}

- (void)setCurrentDateStr:(NSString *)currentDateStr{
    _currentDateStr = currentDateStr;
    
    [self setTimeBroadcastView];
}

- (void)okBtnClick{
    //确定按钮
    if ([self.delegate respondsToSelector:@selector(custonDatePickerView:didSelectDateStr:)]) {
        [self.delegate custonDatePickerView:self didSelectDateStr:self.selectDateStr];
    }
    
    NSLog(@"选中的时间:%@",self.selectDateStr);
    [self dismiss];
}

- (void)cancleButtonClick{
    //取消按钮
    [self dismiss];
}

//设置年月日时分的滚动视图
- (void)setYearScrollView
{
    yearScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 81.5, 190.0)];
    NSInteger yearint = [self setNowTimeShow:0 date:[NSDate date]];
    [yearScrollView setCurrentSelectPage:(yearint-2002)];
    yearScrollView.delegate = self;
    yearScrollView.datasource = self;
    [self setAfterScrollShowView:yearScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:yearScrollView];
}
//设置年月日时分的滚动视图
- (void)setMonthScrollView
{
    monthScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(81.5, 0, 49, 190.0)];
    NSInteger monthint = [self setNowTimeShow:1 date:[NSDate date]];
    [monthScrollView setCurrentSelectPage:(monthint-3)];
    monthScrollView.delegate = self;
    monthScrollView.datasource = self;
    [self setAfterScrollShowView:monthScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:monthScrollView];
}
//设置年月日时分的滚动视图
- (void)setDayScrollView
{
    dayScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(130.5, 0, 54.5, 190.0)];
    NSInteger dayint = [self setNowTimeShow:2 date:[NSDate date]];
    [dayScrollView setCurrentSelectPage:(dayint-3)];
    dayScrollView.delegate = self;
    dayScrollView.datasource = self;
    [self setAfterScrollShowView:dayScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:dayScrollView];
}
//设置年月日时分的滚动视图
- (void)setHourScrollView
{
    hourScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(185, 0, 47.5, 190.0)];
    NSInteger hourint = [self setNowTimeShow:3 date:[NSDate date]];
    [hourScrollView setCurrentSelectPage:(hourint-2)];
    hourScrollView.delegate = self;
    hourScrollView.datasource = self;
    [self setAfterScrollShowView:hourScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:hourScrollView];
}
//设置年月日时分的滚动视图
- (void)setMinuteScrollView
{
    minuteScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(232.5, 0, 47.5, 190.0)];
    NSInteger minuteint = [self setNowTimeShow:4 date:[NSDate date]];
    [minuteScrollView setCurrentSelectPage:(minuteint-2)];
    minuteScrollView.delegate = self;
    minuteScrollView.datasource = self;
    [self setAfterScrollShowView:minuteScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:minuteScrollView];
}
//设置年月日时分的滚动视图
//- (void)setSecondScrollView
//{
//    secondScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(235.5, 0, 43.0, 190.0)];
//    NSInteger secondint = [self setNowTimeShow:5];
//    [secondScrollView setCurrentSelectPage:(secondint-2)];
//    secondScrollView.delegate = self;
//    secondScrollView.datasource = self;
//    [self setAfterScrollShowView:secondScrollView andCurrentPage:1];
//    [timeBroadcastView addSubview:secondScrollView];
//}
- (void)setAfterScrollShowView:(MXSCycleScrollView*)scrollview  andCurrentPage:(NSInteger)pageNumber
{
    UILabel *oneLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber];
    [oneLabel setFont:[UIFont systemFontOfSize:14]];
    [oneLabel setTextColor:MyColor(144, 144, 144)];
    UILabel *twoLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+1];
    [twoLabel setFont:[UIFont systemFontOfSize:16]];
    [twoLabel setTextColor:MyColor(90, 90, 90)];
    
    UILabel *currentLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+2];
    [currentLabel setFont:[UIFont systemFontOfSize:18]];
    [currentLabel setTextColor:[UIColor whiteColor]];
    
    UILabel *threeLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+3];
    [threeLabel setFont:[UIFont systemFontOfSize:16]];
    [threeLabel setTextColor:MyColor(90, 90, 90)];
    UILabel *fourLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+4];
    [fourLabel setFont:[UIFont systemFontOfSize:14]];
    [fourLabel setTextColor:MyColor(144, 144, 144)];
}
#pragma mark mxccyclescrollview delegate
#pragma mark mxccyclescrollview databasesource
- (NSInteger)numberOfPages:(MXSCycleScrollView*)scrollView
{
    if (scrollView == yearScrollView) {
        return 99;
    }
    else if (scrollView == monthScrollView)
    {
        return 12;
    }
    else if (scrollView == dayScrollView)
    {
        return 28;
    }
    else if (scrollView == hourScrollView)
    {
        return 24;
    }
    else if (scrollView == minuteScrollView)
    {
        return 60;
    }
    return 60;
}

- (UIView *)pageAtIndex:(NSInteger)index andScrollView:(MXSCycleScrollView *)scrollView
{
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrollView.bounds.size.width, scrollView.bounds.size.height/5)];
    l.tag = index+1;
    if (scrollView == yearScrollView) {
        l.text = [NSString stringWithFormat:@"%ld年",2000+(long)index];
    }
    else if (scrollView == monthScrollView)
    {
        l.text = [NSString stringWithFormat:@"%ld月",1+index];
    }
    else if (scrollView == dayScrollView)
    {
        l.text = [NSString stringWithFormat:@"%ld日",1+index];
    }
    else if (scrollView == hourScrollView)
    {
        if (index < 10) {
            l.text = [NSString stringWithFormat:@"0%ld时",(long)index];
        }
        else
            l.text = [NSString stringWithFormat:@"%ld时",(long)index];
    }
    else if (scrollView == minuteScrollView)
    {
        if (index < 10) {
            l.text = [NSString stringWithFormat:@"0%ld分",(long)index];
        }
        else
            l.text = [NSString stringWithFormat:@"%ld分",(long)index];
    }
//    else
//        if (index < 10) {
//            l.text = [NSString stringWithFormat:@"0%ld",(long)index];
//        }
//        else
//            l.text = [NSString stringWithFormat:@"%ld",(long)index];
    
    l.font = [UIFont systemFontOfSize:12];
    l.textAlignment = NSTextAlignmentCenter;
    l.backgroundColor = [UIColor clearColor];
    return l;
}
//设置现在时间
- (NSInteger)setNowTimeShow:(NSInteger)timeType date:(NSDate *)date
{
    NSDate *now = nil;
    if (self.currentDateStr && [self.currentDateStr isNotEmpty]) {
        now = [MyDateTool dateWithStringNoSec:self.currentDateStr];
    }else {
        now = [NSDate date];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
    NSString *dateString = [dateFormatter stringFromDate:now];
    switch (timeType) {
        case 0:
        {
            NSRange range = NSMakeRange(0, 4);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 1:
        {
            NSRange range = NSMakeRange(4, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 2:
        {
            NSRange range = NSMakeRange(6, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 3:
        {
            NSRange range = NSMakeRange(8, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 4:
        {
            NSRange range = NSMakeRange(10, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
//        case 5:
//        {
//            NSRange range = NSMakeRange(12, 2);
//            NSString *yearString = [dateString substringWithRange:range];
//            return yearString.integerValue;
//        }
            break;
        default:
            break;
    }
    return 0;
}

//选择设置的播报时间
- (void)selectSetBroadcastTime
{
    UILabel *yearLabel = [[(UILabel*)[[yearScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *monthLabel = [[(UILabel*)[[monthScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *dayLabel = [[(UILabel*)[[dayScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *hourLabel = [[(UILabel*)[[hourScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *minuteLabel = [[(UILabel*)[[minuteScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
//    UILabel *secondLabel = [[(UILabel*)[[secondScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    
    NSInteger yearInt = yearLabel.tag + 1999;
    NSInteger monthInt = monthLabel.tag;
    NSInteger dayInt = dayLabel.tag;
    NSInteger hourInt = hourLabel.tag - 1;
    NSInteger minuteInt = minuteLabel.tag - 1;
//    NSInteger secondInt = secondLabel.tag - 1;
    NSString *taskDateString = [NSString stringWithFormat:@"%ld%02ld%02ld%02ld%02ld",(long)yearInt,(long)monthInt,(long)dayInt,(long)hourInt,(long)minuteInt];
    NSLog(@"Now----%@",taskDateString);
}
//滚动时上下标签显示(当前时间和是否为有效时间)
- (void)scrollviewDidChangeNumber:(MXSCycleScrollView *)csView
{
    UILabel *yearLabel = [[(UILabel*)[[yearScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *monthLabel = [[(UILabel*)[[monthScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *dayLabel = [[(UILabel*)[[dayScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *hourLabel = [[(UILabel*)[[hourScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *minuteLabel = [[(UILabel*)[[minuteScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
//    UILabel *secondLabel = [[(UILabel*)[[secondScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    
    NSInteger yearInt = yearLabel.tag + 1999;
    NSInteger monthInt = monthLabel.tag;
    NSInteger dayInt = dayLabel.tag;
    NSInteger hourInt = hourLabel.tag - 1;
    NSInteger minuteInt = minuteLabel.tag - 1;
//    NSInteger secondInt = secondLabel.tag - 1;
    NSString *dateString = [NSString stringWithFormat:@"%ld%02ld%02ld%02ld%02ld",(long)yearInt,(long)monthInt,(long)dayInt,(long)hourInt,(long)minuteInt];
    NSString *weekString = [self fromDateToWeek:dateString];
    nowPickerShowTimeLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日 %@ %02ld:%02ld",(long)yearInt,(long)monthInt,(long)dayInt,(long)weekString,(long)hourInt,(long)minuteInt];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *selectTimeString = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",(long)yearInt,(long)monthInt,(long)dayInt,(long)hourInt,(long)minuteInt];
    NSDate *selectDate = [dateFormatter dateFromString:selectTimeString];
    NSDate *nowDate = [NSDate date];
    NSString *nowString = [dateFormatter stringFromDate:nowDate];
    NSDate *nowStrDate = [dateFormatter dateFromString:nowString];
    
    self.selectDateStr = [MyDateTool stringWithDateNoSec:selectDate];
    
    
//    if (csView == monthScrollView) {
//        //获取当前选择的时间
//        NSUInteger monthCount = [MyDateTool getMonthDayCountWithDate:self.selectDateStr];
//        dayScrollView.allPages = monthCount;
//    }
    
}
//通过日期求星期
- (NSString*)fromDateToWeek:(NSString*)selectDate
{
    NSInteger yearInt = [selectDate substringWithRange:NSMakeRange(0, 4)].integerValue;
    NSInteger monthInt = [selectDate substringWithRange:NSMakeRange(4, 2)].integerValue;
    NSInteger dayInt = [selectDate substringWithRange:NSMakeRange(6, 2)].integerValue;
    int c = 20;//世纪
    int y = yearInt -1;//年
    int d = dayInt;
    int m = monthInt;
    int w =(y+(y/4)+(c/4)-2*c+(26*(m+1)/10)+d-1)%7;
    NSString *weekDay = @"";
    switch (w) {
        case 0:
            weekDay = @"周日";
            break;
        case 1:
            weekDay = @"周一";
            break;
        case 2:
            weekDay = @"周二";
            break;
        case 3:
            weekDay = @"周三";
            break;
        case 4:
            weekDay = @"周四";
            break;
        case 5:
            weekDay = @"周五";
            break;
        case 6:
            weekDay = @"周六";
            break;
        default:
            break;
    }
    return weekDay;
}

@end
