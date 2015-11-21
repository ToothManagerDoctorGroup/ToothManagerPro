//
//  THCTimeButton.m
//  THCFramework
//

#import "TTMTimeButton.h"

// 默认的起始时间为30秒
#define kDefaultStartTime 30

// NSTimer每一秒执行一次
#define kStepTime 1

// 重新获取验证码的字符串
#define kDefaultAgainTitle @"请重新获取验证码"

// 还剩多少秒的字符串
#define kLeftSecondTitle   @"还剩%ld秒"

@interface TTMTimeButton ()

/*!
 @property
 @abstract 计时器
 */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TTMTimeButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.layer.cornerRadius = 8.f;
    [self addTarget:self action:@selector(timeButtonAction:) forControlEvents:UIControlEventTouchDown];
}

- (NSString *)againTitle {
    if (!_againTitle || _againTitle.length == 0) {
        _againTitle = kDefaultAgainTitle;
    }
    return _againTitle;
}

- (void)countTimeSelector:(NSTimer *)timer {
    self.startTime--;
    if (self.startTime > 0) {
        NSString *title = [NSString stringWithFormat:kLeftSecondTitle, (long)self.startTime];
        [self setTitle:title forState:UIControlStateNormal];
    } else {
        [self setTitle:self.againTitle forState:UIControlStateNormal];
        self.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)timeButtonAction:(TTMTimeButton *)timeButton {
    if ([self.delegate respondsToSelector:@selector(timeButtonDidClick:)]) {

        // 开启计时器
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:kStepTime target:self
                                                        selector:@selector(countTimeSelector:)
                                                        userInfo:nil repeats:YES];
            if (!self.startTime) {
                self.startTime = kDefaultStartTime;
            }
        }
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

        // 点击按钮后，按钮的状态设置为不可用
        timeButton.enabled = NO;
        [self.delegate timeButtonDidClick:timeButton];
    }
}

- (void)openTimer {
    if (self.timer) {
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

- (void)closeTimer {
    if (self.timer) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)resetButtonWithTitle:(NSString *)title {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        self.enabled = YES;
        [self setTitle:title forState:UIControlStateNormal];
    }
}

@end
