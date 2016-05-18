//
//  XLSliderView.m
//  CRM
//
//  Created by Argo Zhang on 16/1/26.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLSliderView.h"
#import "UIColor+Extension.h"

@interface XLSliderView ()

@property (nonatomic, weak)UIView *lineView;

@property (nonatomic, weak)UIButton *selectBtn;//当前选中的button

@end

@implementation XLSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
#pragma mark - 初始化
- (void)setUp{
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0x00a0ea];
    self.lineView = lineView;
    [self addSubview:lineView];
    
    //设置初始的位置
    self.selectIndex = 0;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat btnW = kScreenWidth / self.sourceList.count;
    CGFloat btnH = 50;
    
    for (int i = 0; i < self.sourceList.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * btnW, 0, btnW, btnH);
        btn.tag = 100 + i;
        [btn setTitle:self.sourceList[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHex:0x00a0ea] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        if (i == self.selectIndex) {
            self.selectBtn = btn;
            btn.selected = YES;
            self.lineView.frame = CGRectMake(i * btnW, 50, btnW, 2);
        }
    }
}


- (void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
}

#pragma mark - 按钮点击事件
- (void)btnClick:(UIButton *)btn{
    NSInteger from = self.selectBtn.tag - 100;
    NSInteger to = btn.tag - 100;
    
    self.selectIndex = to;
    
    self.selectBtn.selected = NO;
    btn.selected = YES;
    self.selectBtn = btn;
    
    [UIView animateWithDuration:.35 animations:^{
        self.lineView.left = btn.left;
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:didClickBtnFrom:to:)]) {
        [self.delegate sliderView:self didClickBtnFrom:from to:to];
    }
}

@end
