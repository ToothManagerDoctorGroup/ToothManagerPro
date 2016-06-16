//
//  XLTimeView.m
//  CRM
//
//  Created by Argo Zhang on 16/1/20.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLTimeView.h"
#import "JKCountDownButton.h"

@interface XLTimeView ()

@property (nonatomic, weak)UILabel *timeLabel;
@property (nonatomic, weak)UILabel *jumpLabel;
@property (nonatomic, strong)NSTimer *timer;

@property (nonatomic, assign)int timeCount;

@end

@implementation XLTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        [self setUp];
    }
    return self;
}
#pragma mark - 初始化
- (void)setUp{
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:timeLabel];
    timeLabel.text = @"3s";
    self.timeLabel = timeLabel;
    
    UILabel *jumpLabel = [[UILabel alloc] init];
    jumpLabel.textColor = [UIColor whiteColor];
    jumpLabel.text = @"跳过";
    jumpLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:jumpLabel];
    self.jumpLabel = jumpLabel;
    
    //添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpOutAction:)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.timeLabel.frame = CGRectMake(10, 0, 20, self.height);
    self.jumpLabel.frame = CGRectMake(self.timeLabel.right + 10, 0, 30, self.height);
}

- (void)start{
    self.timeCount = 3;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeEndAction) userInfo:nil repeats:YES];
}
- (void)timeEndAction{
    self.timeCount--;
    NSString *timeStr = [NSString stringWithFormat:@"%ds",self.timeCount];
    self.timeLabel.text = timeStr;
    
    if (self.timeCount == 1) {
        //移除定时器
        [self.timer invalidate];
        self.timer = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickJumpButton)]) {
                [self.delegate didClickJumpButton];
            }
        });
    }
}

#pragma mark - 直接跳出的方法
- (void)jumpOutAction:(UITapGestureRecognizer *)tap{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickJumpButton)]) {
        [self.delegate didClickJumpButton];
    }
    NSLog(@"直接跳过");
}


@end
