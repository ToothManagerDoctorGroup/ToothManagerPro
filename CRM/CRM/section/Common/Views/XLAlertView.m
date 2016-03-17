//
//  XLAlertView.m
//  CRM
//
//  Created by Argo Zhang on 16/3/15.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAlertView.h"
#import "UIColor+Extension.h"
#import "XLSwitchView.h"

#define TitleFont [UIFont boldSystemFontOfSize:20]
#define TextColor [UIColor colorWithHex:0x333333]

#define ContentFont [UIFont systemFontOfSize:15]
@interface XLAlertView ()<UITextViewDelegate>

@property (nonatomic, weak)XLSwitchView *switchView;

@property (nonatomic, strong)NSArray *titles;

@end
@implementation XLAlertView

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
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = TitleFont;
    titleLabel.textColor = TextColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    UITextView *contentTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    contentTextView.textColor = TextColor;
    contentTextView.font = ContentFont;
    contentTextView.backgroundColor = [UIColor clearColor];
    [contentTextView sizeToFit];
    contentTextView.returnKeyType = UIReturnKeyDone;
    contentTextView.delegate =self;
    contentTextView.textAlignment = NSTextAlignmentCenter;
    self.contentTextView = contentTextView;
    [self addSubview:contentTextView];
    
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
    
    _titleLabel.frame = CGRectMake(0, 0, self.width, 30);
    _contentTextView.frame = CGRectMake(0, _titleLabel.bottom, self.width, self.height - _titleLabel.height);
    if (self.showSwitch) {
        
        _contentTextView.frame = CGRectMake(0, _titleLabel.bottom, self.width, self.height - _titleLabel.height - 60);
        
        CGFloat switchW = self.width / 2;
        CGFloat switchH = 60;
        for (int i = 0; i < 2; i++) {
            XLSwitchView *switchView = [self viewWithTag:100 + i];
            switchView.hidden = NO;
            switchView.frame = CGRectMake(i * switchW, _contentTextView.bottom, switchW, switchH);
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

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.contentTextView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

@end
