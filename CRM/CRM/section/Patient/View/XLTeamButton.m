//
//  XLTeamButton.m
//  CRM
//
//  Created by Argo Zhang on 16/3/2.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLTeamButton.h"
#import "UIColor+Extension.h"

#define TitleFont [UIFont systemFontOfSize:15]
#define TitleColor [UIColor colorWithHex:0x333333]

@interface XLTeamButton ()

@property (nonatomic, weak)UIImageView *iconView;
@property (nonatomic, weak)UILabel *titleLabel;

@end

@implementation XLTeamButton

- (instancetype)initWithImage:(UIImage *)image{
    if (self = [super init]) {
        [self setUp];
        
        self.iconView.image = image;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark -初始化
- (void)setUp{
    self.userInteractionEnabled = YES;
    
    UIImageView *iconView = [[UIImageView alloc] init];
    self.iconView = iconView;
    [self addSubview:iconView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = TitleFont;
    titleLabel.textColor = TitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = titleLabel;
    [self addSubview:titleLabel];
}

- (void)setImage:(UIImage *)image{
    _image = image;
    self.iconView.image = image;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat iconW = 33;
    CGFloat iconH = 33;
    CGFloat iconX = (self.width - iconW) / 2;
    CGFloat iconY = 15;
    self.iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGFloat titleX = 0;
    CGFloat titleY = self.iconView.bottom + 10;
    CGFloat titleW = self.width;
    CGFloat titleH = 20;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
}



@end
