//
//  MedicalButtonScrollView.m
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "MedicalButtonScrollView.h"
#import "TTMMedicalCaseModel.h"


#define TitleSelectColor RGBColor(19, 152, 234)
#define TitleNormalColor RGBColor(221, 223, 223)
#define TitleFont [UIFont systemFontOfSize:16]

@interface MedicalButtonScrollView ()

@property (nonatomic, weak)UIView *lineView;//下划线

@property (nonatomic, strong)UILabel *selectButton; //当前选中的button

@end

@implementation MedicalButtonScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        [self setUp];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}
#pragma mark -初始化
- (void)setUp{
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TitleSelectColor;
    [self addSubview:lineView];
    self.lineView = lineView;
    
    //设置基本属性
    self.showsHorizontalScrollIndicator = NO;
    self.userInteractionEnabled = YES;
}

#pragma mark -添加按钮
- (void)setMedicalCases:(NSArray *)medicalCases{
    _medicalCases = medicalCases;
    
    //先移除所有的子视图
    for (UILabel *btn in self.subviews) {
        [btn removeFromSuperview];
    }
    
    CGFloat buttonH = 33;
    
    //设置scrollView的偏移量
    CGFloat offset = 0;
    //添加子视图
    for (int i = 0; i < self.medicalCases.count; i++) {
        //获取模型
        TTMMedicalCaseModel *medicalCase = self.medicalCases[i];
        //创建button
        UILabel *buttonLabel = [[UILabel alloc] init];
        buttonLabel.userInteractionEnabled = YES;
        NSString *title = medicalCase.case_name;
        CGSize titleSize = [title sizeWithFont:TitleFont];
        CGFloat buttonW = titleSize.width + 20;
        buttonLabel.text = title;
        buttonLabel.tag = i;
        buttonLabel.textColor = TitleNormalColor;
        buttonLabel.font = TitleFont;
        buttonLabel.textAlignment = NSTextAlignmentCenter;
        buttonLabel.frame = CGRectMake(offset, 0, buttonW, buttonH);
        offset = offset + buttonW;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [buttonLabel addGestureRecognizer:tap];
        [self addSubview:buttonLabel];
        
        //创建button之间的分割线
        if (i != self.medicalCases.count - 1) {
            UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(offset, 12, 1, 11)];
            divider.backgroundColor = TitleNormalColor;
            [self addSubview:divider];
        }
        
        if (i == 0) {
            self.selectButton = buttonLabel;
            buttonLabel.textColor = TitleSelectColor;
            self.lineView.frame = CGRectMake(0, 33, 40, 2);
        }
    }
    
    self.contentSize = CGSizeMake(offset + 1 * (self.medicalCases.count - 1), self.height);
    
}


#pragma mark -按钮单击事件
- (void)tapAction:(UITapGestureRecognizer *)tap{
    UILabel *tapButton = (UILabel *)tap.view;
    self.selectButton.textColor = TitleNormalColor;
    tapButton.textColor = TitleSelectColor;
    self.selectButton = tapButton;
    //设置lineView的偏移量
    CGFloat offset = 0;
    for (int i = 0; i < tapButton.tag; i++) {
        //获取模型
        TTMMedicalCaseModel *medicalCase = self.medicalCases[i];
        CGSize titleSize = [medicalCase.case_name sizeWithFont:TitleFont];
        CGFloat buttonW = titleSize.width + 20;
        offset = offset + buttonW;
    }
    
    //设置下划线的frame
    self.lineView.frame = CGRectMake(offset, 33, tapButton.width, 2);
    
    //调用代理方法
    if ([self.medicalDelegate respondsToSelector:@selector(medicalButtonScrollView:didSelectButtonWithIndex:)]) {
        [self.medicalDelegate medicalButtonScrollView:self didSelectButtonWithIndex:tapButton.tag];
    }
}

@end
