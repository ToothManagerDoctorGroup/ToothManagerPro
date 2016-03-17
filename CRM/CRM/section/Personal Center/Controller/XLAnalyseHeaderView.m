//
//  XLAnalyseHeaderView.m
//  CRM
//
//  Created by Argo Zhang on 16/1/21.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAnalyseHeaderView.h"
#import "XLPieChartView.h"
#import "XLPieChartParam.h"
#import "UIColor+Extension.h"
#import "XLAnalyseButton.h"
#import "XLPatientSelectViewController.h"
#import "UIView+WXViewController.h"


@interface XLAnalyseHeaderView ()<XLPieChartViewDataSource,XLPieChartViewDelegate>

@property (nonatomic, weak)XLPieChartView *pieChartView;//饼状图
@property (nonatomic, weak)UIView *patientCountView;//背景视图
@property (nonatomic, weak)UILabel *patientCountNameLabel;//患者人数标题
@property (nonatomic, weak)UILabel *patientCountLabel;//患者人数
@property (nonatomic, weak)UIView *divider;//分割线

@end

@implementation XLAnalyseHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        [self setUp];
    }
    return self;
}

#pragma mark - 初始化
- (void)setUp{
    XLPieChartView *pieChartView = [[XLPieChartView alloc] init];
    pieChartView.delegate = self;
    pieChartView.datasource = self;
    self.pieChartView = pieChartView;
    [self addSubview:pieChartView];
    
    UIView *patientCountView = [[UIView alloc] init];
    patientCountView.backgroundColor = [UIColor whiteColor];
    patientCountView.layer.cornerRadius = 60;
    patientCountView.layer.masksToBounds = YES;
    self.patientCountView = patientCountView;
    [self addSubview:patientCountView];
    
    UILabel *patientCountNameLabel = [[UILabel alloc] init];
    patientCountNameLabel.textColor = [UIColor colorWithHex:0x888888];
    patientCountNameLabel.text = @"患者人数";
    patientCountNameLabel.font = [UIFont systemFontOfSize:12];
    [patientCountNameLabel sizeToFit];
    [patientCountView addSubview:patientCountNameLabel];
    self.patientCountNameLabel = patientCountNameLabel;
    
    UILabel *patientCountLabel = [[UILabel alloc] init];
    patientCountLabel.textColor = [UIColor colorWithHex:0x333333];
    patientCountLabel.font = [UIFont systemFontOfSize:24];
    patientCountLabel.textAlignment = NSTextAlignmentCenter;
    [patientCountView addSubview:patientCountLabel];
    self.patientCountLabel = patientCountLabel;
    
//    UIView *divider = [[UIView alloc] init];
//    divider.backgroundColor = [UIColor colorWithHex:0xCCCCCC];
//    self.divider = divider;
//    [self addSubview:divider];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat pieH = 160;
    CGFloat pieW = pieH;
    CGFloat pieX = (kScreenWidth - pieW) / 2;
    CGFloat pieY = 40;
    self.pieChartView.frame = CGRectMake(pieX, pieY, pieW, pieH);
    
    CGFloat countViewX = 0;
    CGFloat countViewY = 0;
    CGFloat countViewW = 120;
    CGFloat countViewH = 120;
    self.patientCountView.frame = CGRectMake(countViewX, countViewY, countViewW, countViewH);
    self.patientCountView.center = self.pieChartView.center;
    
    CGFloat countNameX = (countViewW - self.patientCountNameLabel.width) / 2;
    CGFloat countNameY = 20;
    CGFloat countNameW = self.patientCountNameLabel.width;
    CGFloat countNameH = self.patientCountNameLabel.height;
    self.patientCountNameLabel.frame = CGRectMake(countNameX, countNameY, countNameW,countNameH);
    
    
    int total = 0;
    for (XLPieChartParam *param in self.scaleList) {
        total += param.count;
    }
    self.patientCountLabel.text = [NSString stringWithFormat:@"%d",total];
    CGFloat countW = countViewW;
    CGFloat countH = 40;
    CGFloat countX = 0;
    CGFloat countY = 50;
    self.patientCountLabel.frame = CGRectMake(countX,countY,countW,countH);
    
    //动态创建按钮
    for (int i = 0; i < 4; i++) {
        XLAnalyseButton *btn = [[XLAnalyseButton alloc] init];
        btn.tag = 100 + i;
        CGFloat btnW = 180;
        CGFloat btnH = 40;
        CGFloat btnX = (kScreenWidth - btnW) / 2;
        CGFloat btnY = self.pieChartView.bottom + 10 + btnH * i;
        btn.param = self.scaleList[i];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [self addSubview:btn];
        //添加点击事件
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
//    CGFloat dividerW = kScreenWidth;
//    CGFloat dividerH = .5;
//    CGFloat dividerX = 0;
//    CGFloat dividerY = self.height - dividerH;
//    self.divider.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
}

#pragma mark - 按钮点击事件
- (void)btnAction:(UIButton *)btn{
    
    XLPatientSelectViewController *patientVC = [[XLPatientSelectViewController alloc] init];
    if (btn.tag == 100) {
        NSLog(@"未就诊");
        patientVC.patientStatus = PatientStatusUntreatment;
    }else if (btn.tag == 101){
        NSLog(@"未种植");
        patientVC.patientStatus = PatientStatusUnplanted;
    }else if (btn.tag == 102){
        NSLog(@"已种未修");
        patientVC.patientStatus = PatientStatusUnrepaired;
    }else{
        NSLog(@"已修复");
        patientVC.patientStatus = PatientStatusRepaired;
    }
    
    [self.viewController.navigationController pushViewController:patientVC animated:YES];
}

- (void)setScaleList:(NSArray *)scaleList{
    _scaleList = scaleList;
    
    [self.pieChartView reloadData];
}

#pragma mark - XLPieChartViewDelegate
-(CGFloat)centerCircleRadius
{
    return 60;
}
#pragma mark - PieChartViewDataSource
-(int)numberOfSlicesInPieChartView:(XLPieChartView *)pieChartView
{
    return (int)self.scaleList.count;
}
-(UIColor *)pieChartView:(XLPieChartView *)pieChartView colorForSliceAtIndex:(NSUInteger)index
{
    XLPieChartParam *param = self.scaleList[index];
    return param.color;
}
-(double)pieChartView:(XLPieChartView *)pieChartView valueForSliceAtIndex:(NSUInteger)index
{
    XLPieChartParam *param = self.scaleList[index];
    return param.scale;
}




@end
