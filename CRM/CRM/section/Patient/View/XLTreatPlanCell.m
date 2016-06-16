//
//  XLTreatPlanCell.m
//  CRM
//
//  Created by Argo Zhang on 16/3/2.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLTreatPlanCell.h"
#import "UIImage+Resize.h"
#import "UIColor+Extension.h"
#import "NSString+TTMAddtion.h"
#import "UIImage+TTMAddtion.h"
#import "CommonMacro.h"
#import "XLTreatePlanDetailView.h"
#import "XLCureProjectModel.h"

@interface XLTreatPlanCell ()

#define CellHeight 135

@property (nonatomic, weak)XLTreatePlanDetailView *detailView;//功能视图父视图

@property (nonatomic, weak)UIImageView *stepImageView;//步骤视图
@property (nonatomic, weak)UIView *stepLine;//步骤分割线

@end

@implementation XLTreatPlanCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"teamPlan_cell";
    XLTreatPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

#pragma mark - 初始化
- (void)setUp{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithHex:VIEWCONTROLLER_BACKGROUNDCOLOR];
    
    UIView *stepLine = [[UIView alloc] init];
    stepLine.backgroundColor = [UIColor colorWithHex:0x59c0f2];
    self.stepLine = stepLine;
    [self.contentView addSubview:stepLine];
    
    UIImageView *stepImageView = [[UIImageView alloc] init];
    self.stepImageView = stepImageView;
    [self.contentView addSubview:stepImageView];
    
    //功能视图父视图
    XLTreatePlanDetailView *detailView = [[XLTreatePlanDetailView alloc] init];
    self.detailView = detailView;
    [self.contentView addSubview:detailView];
    
}

- (void)setModel:(XLCureProjectModel *)model{
    _model = model;
    
    CGFloat margin = 10;
    
    CGFloat stepW = 25;
    CGFloat stepH = 25;
    CGFloat stepX = 5;
    CGFloat stepY = margin;
    self.stepImageView.frame = CGRectMake(stepX, stepY, stepW, stepH);
    self.stepImageView.image = [UIImage drowRoundImageWithContent:model.step];
    
    self.stepLine.frame = CGRectMake(stepX + stepW / 2, 0, 1, CellHeight);
    
    self.detailView.frame = CGRectMake(30, margin, kScreenWidth - 30 - margin, 125);
    self.detailView.model = model;
}
@end
