//
//  XLNoIntroducerTintView.m
//  CRM
//
//  Created by Argo Zhang on 16/4/5.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLNoIntroducerTintView.h"
#import "UIColor+Extension.h"
#import "UIImage+TTMAddtion.h"
#import "CreateIntroducerViewController.h"
#import "UIView+WXViewController.h"

@interface XLNoIntroducerTintView (){
    UIImageView *_tintImageView;
    UILabel *_messageLabel1;
    UILabel *_messageLabel2;
    UIButton *_settingButton;//设置按钮
}

@end

@implementation XLNoIntroducerTintView

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
    
    UIImage *targetImage = [[UIImage imageNamed:@"nointroducer_img"] imageCompressForWidth:[UIImage imageNamed:@"nointroducer_img"] targetWidth:kScreenWidth];
    _tintImageView = [[UIImageView alloc] initWithImage:targetImage];

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
    [_settingButton setTitle:@"添加我的第一个介绍人" forState:UIControlStateNormal];
    _settingButton.backgroundColor = [UIColor colorWithHex:0x00a0ea];
    _settingButton.layer.cornerRadius = 5;
    _settingButton.layer.masksToBounds = YES;
    _settingButton.titleLabel.textColor = [UIColor whiteColor];
    [_settingButton addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_settingButton];
}

- (void)settingAction:(UIButton *)btn{
    //设置按钮
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    CreateIntroducerViewController *newIntoducerVC = [storyboard instantiateViewControllerWithIdentifier:@"CreateIntroducerViewController"];
    newIntoducerVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:newIntoducerVC animated:YES];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _tintImageView.frame = CGRectMake(0, 0, _tintImageView.width, _tintImageView.height);
    
    _messageLabel1.frame = CGRectMake(0, _tintImageView.bottom + 20, kScreenWidth, 25);
    _messageLabel1.text = @"基于熟人医患，建立客户链条";
    _messageLabel2.frame = CGRectMake(0, _messageLabel1.bottom, kScreenWidth, 25);
    _messageLabel2.text = @"营造优质的品牌口碑";
    
    CGFloat btnW = 270;
    CGFloat btnH = 40;
    _settingButton.frame = CGRectMake((kScreenWidth - btnW) / 2, _messageLabel2.bottom + 10, btnW, btnH);
    
}


@end
