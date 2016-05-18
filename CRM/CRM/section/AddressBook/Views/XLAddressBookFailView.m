//
//  XLAddressBookFailView.m
//  CRM
//
//  Created by Argo Zhang on 16/3/30.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAddressBookFailView.h"
#import "UIColor+Extension.h"

@interface XLAddressBookFailView (){
    UIImageView *_tintImageView;
    UILabel *_messageLabel1;
    UILabel *_messageLabel2;
    UIButton *_settingButton;//设置按钮
}

@end

@implementation XLAddressBookFailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    _tintImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addressbook_fail"]];
    [self addSubview:_tintImageView];
    
    _messageLabel1 = [[UILabel alloc] init];
    _messageLabel1.textColor = [UIColor colorWithHex:0x333333];
    _messageLabel1.font = [UIFont systemFontOfSize:15];
    _messageLabel1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_messageLabel1];
    
    _messageLabel2 = [[UILabel alloc] init];
    _messageLabel2.textColor = [UIColor colorWithHex:0x888888];
    _messageLabel2.font = [UIFont systemFontOfSize:15];
    _messageLabel2.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_messageLabel2];
    
    _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_settingButton setTitle:@"马上设置" forState:UIControlStateNormal];
    _settingButton.backgroundColor = [UIColor colorWithHex:0x00a0ea];
    _settingButton.layer.cornerRadius = 5;
    _settingButton.layer.masksToBounds = YES;
    _settingButton.titleLabel.textColor = [UIColor whiteColor];
    [_settingButton addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_settingButton];
}

- (void)settingAction:(UIButton *)btn{
    //设置按钮
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat imgW = 186;
    CGFloat imgH = 152;
    _tintImageView.frame = CGRectMake((kScreenWidth - imgW) / 2, 30, imgW, imgH);
    
    _messageLabel1.frame = CGRectMake(0, _tintImageView.bottom + 50, kScreenWidth, 25);
    _messageLabel1.text = @"通过通讯录，您可以快速添加患者、介绍人";
    _messageLabel2.frame = CGRectMake(0, _messageLabel1.bottom, kScreenWidth, 25);
    _messageLabel2.text = @"请允许种牙管家读取您的通讯录";
    
    CGFloat btnW = 270;
    CGFloat btnH = 50;
    _settingButton.frame = CGRectMake((kScreenWidth - btnW) / 2, _messageLabel2.bottom + 10, btnW, btnH);
    
}

@end
