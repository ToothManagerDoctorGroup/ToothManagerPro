//
//  XLFilterStateView.m
//  CRM
//
//  Created by Argo Zhang on 16/4/6.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLFilterStateView.h"
#import "UIColor+Extension.h"
#import "NSString+TTMAddtion.h"
#import "UIImage+TTMAddtion.h"


#define Normal_Height 50
#define CommonWidth 50
#define LINE_HEIGHT .5
#define BUTTON_WIDTH 70
#define BUTTON_HEIGHT 30
#define BUTTON_TITLE_COLOR_NORMAL [UIColor colorWithHex:0x333333]
#define BUTTON_TITLE_COLOR_SELECT [UIColor colorWithHex:0xffffff]

@interface XLFilterStateView (){
    UIView *_dividerView;
}

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)NSArray *sourceArray;

@property (nonatomic, weak)UIButton *selectBtn;

@end

@implementation XLFilterStateView

- (instancetype)initWithSourceArray:(NSArray *)sourceArray{
    if (self = [super init]) {
        self.sourceArray = sourceArray;
        self.backgroundColor = [UIColor whiteColor];
        //初始化
        [self setUp];
    }
    return self;
}

#pragma mark - 初始化子视图
- (void)setUp{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CommonWidth, Normal_Height)];
    _titleLabel.text = @"治疗：";
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor colorWithHex:0x888888];
    [self addSubview:_titleLabel];
    
    //分割线
    _dividerView = [[UIView alloc] init];
    _dividerView.backgroundColor = [UIColor colorWithHex:0xcccccc];
    [self addSubview:_dividerView];
    
    //设置按钮
    for (int i = 0; i < self.sourceArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100 + i;
        [btn setTitle:self.sourceArray[i] forState:UIControlStateNormal];
        //初始化
        [btn setTitleColor:BUTTON_TITLE_COLOR_NORMAL forState:UIControlStateNormal];
        [btn setTitleColor:BUTTON_TITLE_COLOR_SELECT forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithFileName:@"filter_btn_bg_grey"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithFileName:@"filter_btn_bg_blue"] forState:UIControlStateSelected];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    //设置子控件frame
    [self setUpSubviewFrame];
}

#pragma mark - 设置子控件frame
- (void)setUpSubviewFrame{
    
    _titleLabel.frame = CGRectMake(10, 0, CommonWidth, Normal_Height);
    
    CGFloat margin = 10;
    CGFloat btnSuperWidth = kScreenWidth - margin - CommonWidth;
    //判断当前一行可以显示几个按钮
    int maxCols = (int)btnSuperWidth / (int)(BUTTON_WIDTH + margin);//一行最多显示几列
    //设置子控件
    for (int i = 0; i < self.sourceArray.count; i++) {
        UIButton *btn = [self viewWithTag:100 + i];
        CGFloat marginX = 15;
        //计算总共显示几行
        if (self.sourceArray.count <= maxCols) {
            btn.frame = CGRectMake(i * (BUTTON_WIDTH + marginX) + self.titleLabel.right, margin, BUTTON_WIDTH, BUTTON_HEIGHT);
        }else{
            NSInteger row = i / maxCols;
            NSInteger col = i % maxCols;
            
            CGFloat btnX = (BUTTON_WIDTH + marginX) * col + self.titleLabel.right;
            CGFloat btnY = margin + (margin + BUTTON_HEIGHT) * row;
            
            btn.frame = CGRectMake(btnX, btnY, BUTTON_WIDTH, BUTTON_HEIGHT);
        }
    }
    
    _dividerView.frame = CGRectMake(0, [self mesureHeightWithSourceArray:self.sourceArray] - LINE_HEIGHT, kScreenWidth, LINE_HEIGHT);
}

#pragma mark - 计算当前控件的高度
- (CGFloat)mesureHeightWithSourceArray:(NSArray *)sourceArray{
    CGFloat margin = 10;
    CGFloat btnSuperWidth = kScreenWidth - margin - CommonWidth;
    //判断当前一行可以显示几个按钮
    int maxCols = (int)btnSuperWidth / (int)(BUTTON_WIDTH + margin);//一行最多显示几列
    //计算总共显示几行
    if (sourceArray.count <= maxCols) {
        return Normal_Height;
    }else{
        int rows = (int)sourceArray.count % maxCols == 0 ? (int)sourceArray.count / maxCols : (int)sourceArray.count / maxCols + 1;
        return rows * (BUTTON_HEIGHT + margin) + margin;
    }
}

- (CGFloat)fixHeight{
    return [self mesureHeightWithSourceArray:self.sourceArray];
}

- (void)buttonAction:(UIButton *)button{
    
    if (self.selectBtn == button) {
        button.selected = NO;
        self.selectBtn = nil;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(filterStateView:didChooseState:)]) {
            [self.delegate filterStateView:self didChooseState:-1];
        }
    }else{
        self.selectBtn.selected = NO;
        button.selected = YES;
        self.selectBtn = button;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(filterStateView:didChooseState:)]) {
            [self.delegate filterStateView:self didChooseState:button.tag - 100];
        }
    }
}

#pragma mark - 重置
- (void)reset{
    self.selectBtn.selected = NO;
}

@end
