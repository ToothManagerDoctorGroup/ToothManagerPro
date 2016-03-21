//
//  XLCheckAlertView.m
//  CRM
//
//  Created by Argo Zhang on 16/3/17.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLCheckAlertView.h"
#import "UIColor+Extension.h"

@interface XLCheckAlertView ()

@property (nonatomic, strong)NSArray *titles;

@property (nonatomic, weak)UIButton *weixinBtn;
@property (nonatomic, weak)UIButton *messageBtn;

@end

@implementation XLCheckAlertView

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
    UIButton *weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [weixinBtn setImage:[UIImage imageNamed:@"message_send_gou"] forState:UIControlStateSelected];
    [weixinBtn setImage:[UIImage imageNamed:@"message_send_kuang"] forState:UIControlStateNormal];
    [weixinBtn setImage:[UIImage imageNamed:@"message_send_kuang_grey"] forState:UIControlStateDisabled];
    [weixinBtn setTitle:self.titles[0] forState:UIControlStateNormal];
    [weixinBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [weixinBtn setTitleColor:[UIColor colorWithHex:0x888888] forState:UIControlStateDisabled];
    [weixinBtn setImage:[UIImage imageNamed:@"message_send_weiguanzhu"] forState:UIControlStateDisabled];
    weixinBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [weixinBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5, 0.0, 0.0)];
    [weixinBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5, 0.0, 0.0)];
    self.weixinBtn = weixinBtn;
    [weixinBtn addTarget:self action:@selector(weixinAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:weixinBtn];
    
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageBtn setImage:[UIImage imageNamed:@"message_send_gou"] forState:UIControlStateSelected];
    [messageBtn setImage:[UIImage imageNamed:@"message_send_kuang"] forState:UIControlStateNormal];
    [messageBtn setImage:[UIImage imageNamed:@"message_send_kuang_grey"] forState:UIControlStateDisabled];
    [messageBtn setTitle:self.titles[1] forState:UIControlStateNormal];
    [messageBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    messageBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [messageBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5, 0.0, 0.0)];
    [messageBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5, 0.0, 0.0)];
    [messageBtn addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    messageBtn.selected = YES;
    self.messageBtn = messageBtn;
    [self addSubview:messageBtn];
    
    
    [weixinBtn addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    [messageBtn addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc{
    [self.weixinBtn removeObserver:self forKeyPath:@"selected"];
    [self.messageBtn removeObserver:self forKeyPath:@"selected"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if (!self.weixinBtn.isSelected && !self.messageBtn.isSelected) {
        //都选中
        if (self.delegate && [self.delegate respondsToSelector:@selector(checkAlertView:didSelect:)]) {
            [self.delegate checkAlertView:self didSelect:NO];
        }
    }else{
        //都不选中
        if (self.delegate && [self.delegate respondsToSelector:@selector(checkAlertView:didSelect:)]) {
            [self.delegate checkAlertView:self didSelect:YES];
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.showCheck) {
        CGFloat checkW = self.width / 2;
        CGFloat checkH = 30;
        
        self.contentTextView.frame = CGRectMake(0, self.titleLabel.bottom, self.width, self.height - self.titleLabel.height - checkH);
        
        self.weixinBtn.frame = CGRectMake(0, self.contentTextView.bottom, checkW, checkH);
        self.messageBtn.frame = CGRectMake(self.weixinBtn.right, self.contentTextView.bottom, checkW, checkH);
    }
}

- (void)setWeiXinCheckEnable:(BOOL)weiXinCheckEnable{
    _weiXinCheckEnable = weiXinCheckEnable;
    
    self.weixinBtn.selected = weiXinCheckEnable;
    self.weixinBtn.enabled = weiXinCheckEnable;
    
}

- (void)setShowCheck:(BOOL)showCheck{
    _showCheck = showCheck;
    
    [self setNeedsLayout];
}

- (BOOL)weixinIsCheck{
    return self.weixinBtn.isSelected;
}

- (BOOL)messageIsCheck{
    return self.messageBtn.isSelected;
}

#pragma mark - button action
- (void)weixinAction{
    self.weixinBtn.selected = !self.weixinBtn.isSelected;
}

- (void)messageAction{
    self.messageBtn.selected = !self.messageBtn.isSelected;
}

@end
