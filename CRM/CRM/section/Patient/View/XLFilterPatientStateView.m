//
//  XLFilterPatientStateView.m
//  CRM
//
//  Created by Argo Zhang on 16/4/1.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLFilterPatientStateView.h"
#import "UIColor+Extension.h"


#define BUTTON_TITLE_COLOR [UIColor colorWithHex:0x333333]
#define BUTTON_TITLE_FONT [UIFont systemFontOfSize:14]
#define BUTTON_BACKGROUNDCOLOR [UIColor colorWithHex:0xeeeeee]
#define ROWCOUNT 2

@interface XLFilterPatientStateView ()

@property (nonatomic, strong)NSArray *buttonTitles;

@end

@implementation XLFilterPatientStateView

- (NSArray *)buttonTitles{
    if (!_buttonTitles) {
        _buttonTitles = @[@"未就诊",@"未种植",@"已种未修",@"已修复"];
    }
    return _buttonTitles;
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
    for (int i = 0; i < self.buttonTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100 + i;
        [button setTitle:self.buttonTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:BUTTON_TITLE_COLOR forState:UIControlStateNormal];
        button.titleLabel.font = BUTTON_TITLE_FONT;
        button.backgroundColor = BUTTON_BACKGROUNDCOLOR;
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat buttonW = 100;
    CGFloat buttonH = 35;
    CGFloat marginY = 20;
    CGFloat marginX = (self.width - ROWCOUNT * buttonW) / 3;
    
    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    
    for (int i = 0; i < self.buttonTitles.count; i++) {
        UIButton *button = [self viewWithTag:100 + i];
        
        NSInteger index_x = i / ROWCOUNT;
        NSInteger index_y = i % ROWCOUNT;
        
        buttonX = marginX + index_y * (buttonW + marginX);
        buttonY = marginY + index_x * (buttonH + marginY);
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }
}

#pragma mark - 按钮点击事件
- (void)buttonAction:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterPatientStateView:didSelectItem:)]) {
        [self.delegate filterPatientStateView:self didSelectItem:button.tag - 100];
    }
}


@end
