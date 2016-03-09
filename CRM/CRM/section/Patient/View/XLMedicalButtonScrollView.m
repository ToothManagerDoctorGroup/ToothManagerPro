//
//  XLMedicalButtonScrollView.m
//  CRM
//
//  Created by Argo Zhang on 16/3/1.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLMedicalButtonScrollView.h"
#import "DBManager+Patients.h"
#import "UIColor+Extension.h"

#define TitleSelectColor [UIColor colorWithHex:0x00a0ea]
#define TitleNormalColor [UIColor colorWithHex:0x888888]
#define TitleFont [UIFont systemFontOfSize:15]

@interface XLMedicalButtonScrollView ()

@property (nonatomic, strong)UILabel *selectButton; //当前选中的button

@end

@implementation XLMedicalButtonScrollView
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
    //设置基本属性
    self.showsHorizontalScrollIndicator = NO;
    self.userInteractionEnabled = YES;
}

#pragma mark -添加按钮
- (void)setMedicalCases:(NSArray *)medicalCases{
    _medicalCases = medicalCases;
    
    //先移除所有的子视图
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat buttonH = 40;
    //设置scrollView的偏移量
    CGFloat offset = 0;
    //添加子视图
    for (int i = 0; i < self.medicalCases.count; i++) {
        //获取模型
        MedicalCase *medicalCase = self.medicalCases[i];
        //创建button
        UILabel *buttonLabel = [[UILabel alloc] init];
        buttonLabel.userInteractionEnabled = YES;
        NSString *title = medicalCase.case_name;
        CGSize titleSize = [title sizeWithFont:TitleFont];
        CGFloat buttonW = titleSize.width + 30;
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
            UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(offset, 10, 1, 20)];
            divider.backgroundColor = TitleNormalColor;
            [self addSubview:divider];
        }
        if (i == 0) {
            self.selectButton = buttonLabel;
            buttonLabel.textColor = TitleSelectColor;
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
    NSInteger index = tapButton.tag;
     //调用代理方法
    if ([self.medicalDelegate respondsToSelector:@selector(medicalButtonScrollView:didSelectButtonWithIndex:)]) {
        [self.medicalDelegate medicalButtonScrollView:self didSelectButtonWithIndex:index];
    }
}

@end
