//
//  XLAdvertisementView.m
//  CRM
//
//  Created by Argo Zhang on 16/1/20.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAdvertisementView.h"
#import "XLTimeView.h"

@interface XLAdvertisementView ()<XLTimeViewDelegate>

@property (nonatomic, weak)XLTimeView *timeBtn;

@end

@implementation XLAdvertisementView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        [self setUp];
    }
    return self;
}

- (void)setUp{
    XLTimeView *timeBtn = [[XLTimeView alloc] init];
    timeBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7];
    timeBtn.delegate = self;
    self.timeBtn = timeBtn;
    [self addSubview:timeBtn];
    self.userInteractionEnabled = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.timeBtn.frame = CGRectMake(kScreenWidth - 80 - 25, 25, 80, 40);
    
}

#pragma mark - XLTimeViewDelegate
- (void)didClickJumpButton{
    if (self.completeBlock) {
        [self dismiss:self.completeBlock];
    }
}

- (void)dismiss:(AdvertisementViewDismissBlock)dismissblock{
    
    [UIView animateWithDuration:.8 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (dismissblock) {
            dismissblock();
        }
    }];
}

- (void)start{
    [self.timeBtn start];
}



@end
