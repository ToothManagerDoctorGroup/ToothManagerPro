//
//  XLFilterDoctorListView.m
//  CRM
//
//  Created by Argo Zhang on 16/4/6.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLFilterDoctorListView.h"
#import "UIColor+Extension.h"
#import "UIImage+TTMAddtion.h"
#import "DBTableMode.h"

#define Normal_Height 50
#define CommonWidth 50
#define BUTTON_WIDTH 70
#define BUTTON_HEIGHT 30
#define BUTTON_TITLE_COLOR_NORMAL [UIColor colorWithHex:0xffffff]

@implementation XLFilterDoctorListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - 初始化
- (void)setSourceArray:(NSMutableArray *)sourceArray{
    _sourceArray = sourceArray;
    
    //移除之前的所有视图
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //设置按钮
    for (int i = 0; i < self.sourceArray.count; i++) {
        Doctor *doc = self.sourceArray[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 200 + i;
        [btn setTitle:doc.doctor_name forState:UIControlStateNormal];
        //初始化
        [btn setTitleColor:BUTTON_TITLE_COLOR_NORMAL forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithFileName:@"filter_btn_bg_blue"] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)setSubViewFrame{
    CGFloat margin = 10;
    //判断当前一行可以显示几个按钮
    int maxCols = (int)self.width / (int)(BUTTON_WIDTH + margin);//一行最多显示几列
    //设置子控件
    for (int i = 0; i < self.sourceArray.count; i++) {
        UIButton *btn = [self viewWithTag:200 + i];
        CGFloat marginX = 15;
        //计算总共显示几行
        if (self.sourceArray.count <= maxCols) {
            btn.frame = CGRectMake(i * (BUTTON_WIDTH + marginX), margin, BUTTON_WIDTH, BUTTON_HEIGHT);
        }else{
            NSInteger row = i / maxCols;
            NSInteger col = i % maxCols;
            
            CGFloat btnX = (BUTTON_WIDTH + marginX) * col;
            CGFloat btnY = margin + (margin + BUTTON_HEIGHT) * row;
            
            btn.frame = CGRectMake(btnX, btnY, BUTTON_WIDTH, BUTTON_HEIGHT);
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self setSubViewFrame];
}

#pragma mark - 计算当前控件的高度
- (CGFloat)mesureHeightWithSourceArray:(NSArray *)sourceArray width:(CGFloat)width{
    CGFloat margin = 10;
    //判断当前一行可以显示几个按钮
    int maxCols = (int)width / (int)(BUTTON_WIDTH + margin);//一行最多显示几列
    //计算总共显示几行
    if (sourceArray.count <= maxCols) {
        return Normal_Height;
    }else{
        int rows = (int)sourceArray.count % maxCols == 0 ? (int)sourceArray.count / maxCols : (int)sourceArray.count / maxCols + 1;
        return rows * (BUTTON_HEIGHT + margin);
    }
}

#pragma mark - 计算控件的高度
- (CGFloat)fixHeigthWithWidth:(CGFloat)width{
    if (self.sourceArray.count == 0) {
        return 0;
    }
    return [self mesureHeightWithSourceArray:self.sourceArray width:width] + 10;;
}

#pragma mark - 按钮点击事件
- (void)buttonAction:(UIButton *)btn{
    //移除数组中的元素
    [self.sourceArray removeObjectAtIndex:btn.tag - 200];
    //移除视图
    [btn removeFromSuperview];
    //重新设置frame
    [self setSourceArray:_sourceArray];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterDoctorListView:didChooseDoctors:)]) {
        [self.delegate filterDoctorListView:self didChooseDoctors:_sourceArray];
    }
}

@end
