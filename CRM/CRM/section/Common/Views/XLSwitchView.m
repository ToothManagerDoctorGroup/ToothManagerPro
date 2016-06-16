//
//  XLSwitchView.m
//  CRM
//
//  Created by Argo Zhang on 16/3/16.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLSwitchView.h"
#import "UIColor+Extension.h"

@interface XLSwitchView (){
    UISwitch *_switchView;
    UILabel *_titleLabel;
}

@end

@implementation XLSwitchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    _switchView = [[UISwitch alloc] init];
    _switchView.on = YES;
    [_switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_switchView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor colorWithHex:0x888888];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _switchView.frame = CGRectMake((self.width - _switchView.width) / 2, 3, _switchView.width, 27);
    _titleLabel.frame = CGRectMake(0, _switchView.bottom, self.width, 30);
}

- (void)setOn:(BOOL)on{
    _on = on;
    
    _switchView.on = on;
}


- (void)setTitle:(NSString *)title{
    _title = title;
    
    _titleLabel.text = title;
}

- (void)setEnable:(BOOL)enable{
    _enable = enable;

    _switchView.on = enable;
    _switchView.enabled = enable;
}

- (void)switchAction:(UISwitch *)switchView{
    self.on = switchView.isOn;
}

@end
