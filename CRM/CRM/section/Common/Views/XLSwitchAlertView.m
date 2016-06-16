//
//  XLSwitchAlertView.m
//  CRM
//
//  Created by Argo Zhang on 16/3/17.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLSwitchAlertView.h"
#import "XLSwitchView.h"

@interface XLSwitchAlertView ()

@property (nonatomic, weak)XLSwitchView *switchView;

@property (nonatomic, strong)NSArray *titles;


@end

@implementation XLSwitchAlertView

- (NSArray *)titles{
    if (!_titles) {
        _titles = @[@"微信通知",@"短信通知"];
    }
    return _titles;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    for (int i = 0; i < 2; i++) {
        XLSwitchView *switchView = [[XLSwitchView alloc] initWithFrame:CGRectZero];
        switchView.on = YES;
        switchView.tag = i + 100;
        switchView.title = self.titles[i];
        switchView.hidden = YES;
        [self addSubview:switchView];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.showSwitch) {
        self.contentTextView.frame = CGRectMake(0, self.titleLabel.bottom, self.width, self.height - self.titleLabel.height - 60);
        
        CGFloat switchW = self.width / 2;
        CGFloat switchH = 60;
        for (int i = 0; i < 2; i++) {
            XLSwitchView *switchView = [self viewWithTag:100 + i];
            switchView.hidden = NO;
            switchView.frame = CGRectMake(i * switchW, self.contentTextView.bottom, switchW, switchH);
        }
    }
}

- (void)setShowSwitch:(BOOL)showSwitch{
    _showSwitch = showSwitch;
    
    [self setNeedsLayout];
}

- (void)setWeiXinEnable:(BOOL)weiXinEnable{
    _weiXinEnable = weiXinEnable;
    
    XLSwitchView *switchView = [self viewWithTag:100];
    switchView.enable = weiXinEnable;
}

- (BOOL)weixinIsOn{
    XLSwitchView *switchView = [self viewWithTag:100];
    return switchView.isOn;
}

- (BOOL)messageIsOn{
    XLSwitchView *switchView = [self viewWithTag:101];
    return switchView.isOn;
}


@end
