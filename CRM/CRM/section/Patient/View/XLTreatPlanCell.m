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

#define CommonFont [UIFont systemFontOfSize:15]
#define CommonColor [UIColor colorWithHex:0x333333]
#define CommonButtonColor [UIColor colorWithHex:0x00a0ea]
#define FinishLabelFont [UIFont systemFontOfSize:10]

@interface XLTreatPlanCell ()

@property (nonatomic, weak)UIImageView *functionSuperView;//功能视图父视图
@property (nonatomic, weak)UILabel *treatType;//治疗事项
@property (nonatomic, weak)UILabel *toothLabel;//牙位
@property (nonatomic, weak)UILabel *finishLabel;//是否完成
@property (nonatomic, weak)UIImageView *icowView;//头像
@property (nonatomic, weak)UILabel *doctorNameLabel;//医生姓名
@property (nonatomic, weak)UIView *lineView;//分割线

@property (nonatomic, weak)UIImageView *stepImageView;//步骤视图
@property (nonatomic, weak)UIView *stepLine;//步骤分割线

@property (nonatomic, strong)NSArray *buttonNames;

@end

@implementation XLTreatPlanCell

- (NSArray *)buttonNames{
    if (!_buttonNames) {
        _buttonNames = @[@"付款",@"病程记录",@"预约记录"];
    }
    return _buttonNames;
}

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
    UIImageView *functionSuperView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"team_bg"]];
    functionSuperView.userInteractionEnabled = YES;
    self.functionSuperView = functionSuperView;
    [self.contentView addSubview:functionSuperView];
    
    //治疗事项
    UILabel *treatType = [[UILabel alloc] init];
    treatType.textColor = CommonColor;
    treatType.font = CommonFont;
    self.treatType = treatType;
    [functionSuperView addSubview:treatType];
    
    //牙位
    UILabel *toothLabel = [[UILabel alloc] init];
    toothLabel.textColor = CommonColor;
    toothLabel.font = CommonFont;
    toothLabel.textAlignment = NSTextAlignmentCenter;
    self.toothLabel = toothLabel;
    [functionSuperView addSubview:toothLabel];
    
    //是否完成
    UILabel *finishLabel = [[UILabel alloc] init];
    finishLabel.textColor = [UIColor whiteColor];
    finishLabel.font = FinishLabelFont;
    finishLabel.layer.cornerRadius = 3;
    finishLabel.layer.masksToBounds = YES;
    finishLabel.backgroundColor = [UIColor colorWithHex:0x3dbd57];
    finishLabel.textAlignment = NSTextAlignmentCenter;
    self.finishLabel = finishLabel;
    [functionSuperView addSubview:finishLabel];
    
    //头像
    UIImageView *icowView = [[UIImageView alloc] init];
    icowView.layer.borderWidth = 1;
    icowView.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
    icowView.layer.cornerRadius = 14;
    icowView.layer.masksToBounds = YES;
    self.icowView = icowView;
    [functionSuperView addSubview:icowView];
    
    //医生姓名
    UILabel *doctorNameLabel = [[UILabel alloc] init];
    doctorNameLabel.textColor = CommonColor;
    doctorNameLabel.font = CommonFont;
    self.doctorNameLabel = doctorNameLabel;
    [functionSuperView addSubview:doctorNameLabel];
    
    //分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xCCCCCC];
    self.lineView = lineView;
    [functionSuperView addSubview:lineView];
    
    //三个按钮
    for (int i = 0; i < self.buttonNames.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.buttonNames[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
        [button setTitleColor:[UIColor colorWithHex:0x00a0ea] forState:UIControlStateNormal];
        button.titleLabel.font = CommonFont;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithHex:0x00a0ea].CGColor;
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        [functionSuperView addSubview:button];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 10;
    
    CGFloat stepW = 25;
    CGFloat stepH = 25;
    CGFloat stepX = 5;
    CGFloat stepY = margin;
    self.stepImageView.frame = CGRectMake(stepX, stepY, stepW, stepH);
    self.stepImageView.image = [UIImage drowRoundImageWithContent:2];
    
    self.stepLine.frame = CGRectMake(stepX + stepW / 2, 0, 1, self.height);
    
    self.functionSuperView.frame = CGRectMake(30, margin, kScreenWidth - 30 - margin, 125);
    
    NSString *type = @"修复";
    NSString *tooth = @"23,24,25";
    NSString *finish = @"已完成";
    
    CGFloat finishW = 40;
    CGFloat finishH = 18;
    CGFloat finishX = self.functionSuperView.width - margin - finishW;
    CGFloat finishY = margin;
    self.finishLabel.frame = CGRectMake(finishX, finishY, finishW, finishH);
    self.finishLabel.text = finish;
  
    CGSize typeSize = [type measureFrameWithFont:CommonFont size:CGSizeMake(MAXFLOAT, MAXFLOAT)].size;
    CGFloat typeX = margin * 2;
    CGFloat typeY = margin;
    CGFloat typeW = typeSize.width;
    CGFloat typeH = typeSize.height;
    self.treatType.frame = CGRectMake(typeX, typeY, typeW, typeH);
    self.treatType.text = type;
    
    CGSize toothSize = [tooth measureFrameWithFont:CommonFont size:CGSizeMake(self.width - margin * 7 - finishW - typeW, MAXFLOAT)].size;
    CGFloat toothX = self.treatType.right + margin * 2;
    CGFloat toothY = margin;
    CGFloat toothW = self.functionSuperView.width - self.treatType.right - margin - self.finishLabel.width - margin * 2;
    CGFloat toothH = toothSize.height;
    self.toothLabel.frame = CGRectMake(toothX, toothY, toothW, toothH);
    self.toothLabel.text = tooth;
    
    NSString *name = @"陈云";
    CGSize nameSize = [name measureFrameWithFont:CommonFont size:CGSizeMake(MAXFLOAT, MAXFLOAT)].size;
    CGFloat nameW = nameSize.width;
    CGFloat nameH = 28;
    CGFloat nameX = self.functionSuperView.width - margin - nameW;
    CGFloat nameY = self.finishLabel.bottom + margin;
    self.doctorNameLabel.frame = CGRectMake(nameX, nameY, nameW, nameH);
    self.doctorNameLabel.text = name;
    
    CGFloat iconW = 28;
    CGFloat iconH = iconW;
    CGFloat iconX = nameX - margin - iconW;
    CGFloat iconY = nameY;
    self.icowView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    self.icowView.image = [UIImage imageNamed:@"user_icon"];
    
    CGFloat dividerX = 5;
    CGFloat dividerY = 75;
    CGFloat dividerW = self.functionSuperView.width - dividerX;
    CGFloat dividerH = .5;
    self.lineView.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
    
    //按钮frame
    CGFloat buttonW = 75;
    CGFloat buttonH = 30;
    for (int i = 0; i < self.buttonNames.count; i++) {
        UIButton *button = [self.functionSuperView viewWithTag:100 + i];
        CGFloat buttonY = self.lineView.bottom + margin;
        CGFloat buttonX = self.functionSuperView.width - (margin + buttonW) * (i + 1);
        button.frame = CGRectMake(buttonX ,buttonY, buttonW, buttonH);
    }
}

- (void)buttonAction:(UIButton *)button{
    if (button.tag == 100) {
        NSLog(@"付款");
    }else if (button.tag == 101){
        NSLog(@"病程记录");
    }else{
        NSLog(@"预约记录");
    }
}

@end
