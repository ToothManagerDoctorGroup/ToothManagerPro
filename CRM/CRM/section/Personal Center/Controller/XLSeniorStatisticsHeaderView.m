//
//  XLSeniorStatisticsHeaderView.m
//  CRM
//
//  Created by Argo Zhang on 16/1/22.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLSeniorStatisticsHeaderView.h"

@interface XLSeniorStatisticsHeaderView ()

@property (nonatomic, weak)UILabel *repairTimeTitle;//修复时间标题
@property (nonatomic, weak)UITextField *startTime;//开始时间
@property (nonatomic, weak)UITextField *endTime;//结束时间
@property (nonatomic, weak)UIView *divider;//分割线


@property (nonatomic, weak)UIView *repairDoctorSuperView;//修复医生父视图
//@property (nonatomic, weak)UILabel *<#view#>;

@end

@implementation XLSeniorStatisticsHeaderView

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
    
}

@end
