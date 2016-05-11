//
//  XLFilterView.m
//  CRM
//
//  Created by Argo Zhang on 16/4/6.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLFilterView.h"
#import "XLFilterStateView.h"
#import "XLFilterTimeView.h"
#import "XLFilterDoctorView.h"
#import "UIColor+Extension.h"
#import "XLFilterDismissButton.h"
#import "MyDateTool.h"
#import "TimPickerTextField.h"

static const NSTimeInterval kXLFilterViewAnimatedDuration = .35;

@interface XLFilterView ()<XLFilterDoctorViewDelegate,XLFilterStateViewDelegate,XLFilterTimeViewDelegate>{
    
    UIView *_cover;//遮罩
    
    UIScrollView *_scrollView;
    XLFilterStateView *_stateView;
    XLFilterTimeView *_timeView;
    XLFilterDoctorView *_doctorView;
    
    UIView *_btnSuperView;
    UIButton *_resetButton;
    UIButton *_searchButton;
    
    XLFilterDismissButton *_dismissBtn;
}

@property (nonatomic, strong)NSArray *selectDoctors;
@property (nonatomic, assign)PatientStatus patientStatus;
@property (nonatomic, assign)FilterTimeState timeState;
@property (nonatomic, copy)NSString *startTime;
@property (nonatomic, copy)NSString *endTime;

@end

@implementation XLFilterView

- (void)dealloc{
    [_timeView removeObserver:self forKeyPath:@"isCustomTime"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.timeState = FilterTimeStateUnSelect;
        self.patientStatus = PatientStatuspeAll;
        [self setUp];
    }
    return self;
}

- (void)setUp{
    
    _cover = [[UIView alloc] init];
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipAction:)];
    swip.direction = UISwipeGestureRecognizerDirectionUp;
    [_cover addGestureRecognizer:swip];
    [self addSubview:_cover];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_cover addSubview:_scrollView];
    
    NSArray *states = @[@"种植",@"修复"];
    _stateView = [[XLFilterStateView alloc] initWithSourceArray:states];
    _stateView.delegate = self;
    [_scrollView addSubview:_stateView];
    
    NSArray *times = @[@"今日",@"本周",@"本月",@"自定义"];
    _timeView = [[XLFilterTimeView alloc] initWithSourceArray:times];
    [_timeView addObserver:self forKeyPath:@"isCustomTime" options:NSKeyValueObservingOptionNew context:nil];
    _timeView.delegate = self;
    [_scrollView addSubview:_timeView];

    _doctorView = [[XLFilterDoctorView alloc] init];
    _doctorView.delegate = self;
    [_scrollView addSubview:_doctorView];
    
    
    _btnSuperView = [[UIView alloc] init];
    _btnSuperView.backgroundColor = [UIColor whiteColor];
    [_cover  addSubview:_btnSuperView];
    
    _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_resetButton setTitle:@"重置" forState:UIControlStateNormal];
    _resetButton.layer.cornerRadius = 5;
    _resetButton.layer.masksToBounds = YES;
    _resetButton.layer.borderWidth = 1;
    _resetButton.layer.borderColor = [UIColor colorWithHex:0x888888].CGColor;
    [_resetButton setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    _resetButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_btnSuperView addSubview:_resetButton];
    [_resetButton addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchButton setTitle:@"查询" forState:UIControlStateNormal];
    _searchButton.layer.cornerRadius = 5;
    _searchButton.layer.masksToBounds = YES;
    [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _searchButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _searchButton.backgroundColor = [UIColor colorWithHex:0x00a0ea];
    [_btnSuperView addSubview:_searchButton];
    [_searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    _dismissBtn = [[XLFilterDismissButton alloc] init];
    [_cover addSubview:_dismissBtn];
    
    //设置子控件的frame
    [self setViewFrame];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"isCustomTime"]) {
        [self setViewFrame];
    }
}

- (void)setViewFrame{
    
    CGFloat margin = 10;
    CGFloat btnSuperH = 60;
    CGFloat resetW = (kScreenWidth - margin * 3) / 5 * 2;
    CGFloat resetH = 40;
    CGFloat searchW = (kScreenWidth - margin * 3) / 5 * 3;
    CGFloat searchH = resetH;
    
    CGFloat stateH = [_stateView fixHeight];
    CGFloat timeH = [_timeView fixHeight];
    CGFloat doctorH = [_doctorView fixHeight];
    CGFloat scrollH = stateH + timeH + doctorH;
    
    _scrollView.frame = CGRectMake(0, 0, kScreenWidth, scrollH);
    _stateView.frame = CGRectMake(0, 0, kScreenWidth, [_stateView fixHeight]);
    _timeView.frame = CGRectMake(0, _stateView.bottom, kScreenWidth, [_timeView fixHeight]);
    
    _doctorView.frame = CGRectMake(0, _timeView.bottom, kScreenWidth, [_doctorView fixHeight]);
    
    _btnSuperView.frame = CGRectMake(0, _scrollView.bottom, kScreenWidth, btnSuperH);
    _resetButton.frame = CGRectMake(margin, margin, resetW, resetH);
    _searchButton.frame = CGRectMake(_resetButton.right + margin, margin, searchW, searchH);
    
    _dismissBtn.frame = CGRectMake(0, _btnSuperView.bottom, kScreenWidth, [_dismissBtn fixHeight]);
    
    //设置scrollView的偏移量
    CGFloat scrollMaxH = self.bottom - 160;
    CGFloat contentH = _doctorView.bottom > scrollMaxH ? scrollMaxH : _doctorView.bottom;
    _scrollView.contentSize = CGSizeMake(kScreenWidth, contentH);
}

- (CGFloat)fixHeight{
    return _timeView.bottom;
}

#pragma mark - XLFilterDoctorViewDelegate
- (void)filterDoctorView:(XLFilterDoctorView *)doctorView didSelectDoctors:(NSArray *)doctors{
    [self setViewFrame];
    self.selectDoctors = doctors;
}

#pragma mark - XLFilterStateViewDelegate
- (void)filterStateView:(XLFilterStateView *)stateView didChooseState:(NSInteger)state{
    switch (state) {
        case 0:
            self.patientStatus = PatientStatusUnrepaired;
            break;
        case 1:
            self.patientStatus = PatientStatusRepaired;
            break;
        default:
            self.patientStatus = PatientStatuspeAll;
            break;
    }
}

#pragma mark - XLFilterTimeViewDelegate
- (void)filterTimeView:(XLFilterTimeView *)timeVc timeState:(FilterTimeState)timeState{
    self.timeState = timeState;
}

#pragma mark - resetAction
- (void)resetAction{
    [_doctorView reset];
    [_stateView reset];
    [_timeView reset];
    //重新设置frame
    [self setViewFrame];
    self.selectDoctors = nil;
    self.patientStatus = PatientStatuspeAll;
    self.timeState = FilterTimeStateUnSelect;
    self.startTime = nil;
    self.endTime = nil;
}
#pragma mark - searchAction
- (void)searchAction{
    
    //判断是否选择了时间
    if (self.timeState == FilterTimeStateUnSelect) {
        self.startTime = nil;
        self.endTime = nil;
    }else{
        NSString *startTime;
        NSString *endTime;
        //判断是否选择自定义时间
        if (self.timeState == FilterTimeStateDay) {
            //今日
            NSString *common = [[MyDateTool stringWithDateWithSec:[NSDate date]] componentsSeparatedByString:@" "][0];
            startTime = [NSString stringWithFormat:@"%@ 00:00:00",common];
            endTime = [NSString stringWithFormat:@"%@ 23:59:59",common];
        }else if (self.timeState == FilterTimeStateWeek){
            //本周
            startTime = [MyDateTool stringWithDateWithSec:[MyDateTool getMondayDateWithCurrentDate:[NSDate date]]];
            endTime = [MyDateTool stringWithDateWithSec:[MyDateTool getSundayDateWithCurrentDate:[NSDate date]]];
        }else if (self.timeState == FilterTimeStateMonth){
            //本月
            startTime = [MyDateTool getMonthBeginWith:[NSDate date]];
            endTime = [MyDateTool getMonthEndWith:startTime];
        }else {
            //判断自定义的时间是否符合要求
            if ([_timeView.startTimeField.text isEmpty]) {
                [SVProgressHUD showImage:nil status:@"请输入开始时间"];
                return;
            }
            if ([_timeView.endTimeField.text isEmpty]) {
                [SVProgressHUD showImage:nil status:@"请输入结束时间"];
                return;
            }
            //比较两个日期的大小
            NSComparisonResult result = [MyDateTool compareStartDateStr:_timeView.startTimeField.text endDateStr:_timeView.endTimeField.text];
            if (result == NSOrderedDescending) {
                [SVProgressHUD showImage:nil status:@"开始时间不能大于结束时间"];
                return;
            }
            startTime = [NSString stringWithFormat:@"%@ 00:00:00",_timeView.startTimeField.text];
            endTime = [NSString stringWithFormat:@"%@ 00:00:00",_timeView.endTimeField.text];
        }
        
        self.startTime = startTime;
        self.endTime = endTime;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterView:patientStatus:startTime:endTime:cureDoctors:)]) {
        [self.delegate filterView:self patientStatus:self.patientStatus startTime:self.startTime endTime:self.endTime cureDoctors:self.selectDoctors];
    }
    //隐藏当前视图
    [self dismissAction];
}

#pragma mark - dismissAction
- (void)dismissAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismiss)]) {
        [self.delegate dismiss];
    }
}

#pragma mark - 显示
- (void)showInView:(UIView *)view animated:(BOOL)animated{
    WS(weakSelf);
    if (animated) {
        weakSelf.hidden = NO;
        //带动画
        _cover.frame = CGRectMake(0, -view.height, view.width, view.height);
        
        [UIView animateWithDuration:kXLFilterViewAnimatedDuration animations:^{
            _cover.transform = CGAffineTransformMakeTranslation(0, view.height);
            weakSelf.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7];
        } completion:^(BOOL finished) {
            
        }];
    }else{
        //不带动画
        _cover.frame = self.bounds;
        self.hidden = NO;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7];
    }
}

- (void)dismissAnimated:(BOOL)animated{
    WS(weakSelf);
    if (animated) {
        [UIView animateWithDuration:kXLFilterViewAnimatedDuration animations:^{
            _cover.transform = CGAffineTransformIdentity;
            weakSelf.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        } completion:^(BOOL finished) {
            weakSelf.hidden = YES;
        }];
    }else{
        self.hidden = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }
}
#pragma mark - 轻扫手势
- (void)swipAction:(UISwipeGestureRecognizer *)swip{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismiss)]) {
        [self.delegate dismiss];
    }
}

@end
