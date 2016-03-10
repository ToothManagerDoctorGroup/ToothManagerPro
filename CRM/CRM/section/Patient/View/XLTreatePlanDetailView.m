//
//  XLTreatePlanDetailView.m
//  CRM
//
//  Created by Argo Zhang on 16/3/5.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLTreatePlanDetailView.h"
#import "UIColor+Extension.h"
#import "NSString+TTMAddtion.h"
#import "XLCureProjectModel.h"
#import "MyDateTool.h"
#import "UIImageView+WebCache.h"

#define CommonFont [UIFont systemFontOfSize:15]
#define CommonColor [UIColor colorWithHex:0x333333]
#define CommonButtonColor [UIColor colorWithHex:0x00a0ea]
#define FinishLabelFont [UIFont systemFontOfSize:10]
#define FinishedColor [UIColor colorWithHex:0x3dbd57]
#define UnFinishColor [UIColor colorWithHex:0xff4e4a]

@interface XLTreatePlanDetailView ()
@property (nonatomic, strong)UILabel *treatType;//治疗事项
@property (nonatomic, strong)UILabel *toothLabel;//牙位
@property (nonatomic, strong)UILabel *finishLabel;//是否完成
@property (nonatomic, strong)UIImageView *icowView;//头像
@property (nonatomic, strong)UILabel *doctorNameLabel;//医生姓名
@property (nonatomic, strong)UIView *lineView;//分割线

@property (nonatomic, strong)NSArray *buttonNames;

@end
@implementation XLTreatePlanDetailView

- (NSArray *)buttonNames{
    if (!_buttonNames) {
        _buttonNames = @[@"付款",@"病程记录"];
    }
    return _buttonNames;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

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
    self.userInteractionEnabled = YES;
    self.image = [UIImage imageNamed:@"team_bg"];
    
    //治疗事项
    _treatType = [[UILabel alloc] init];
    _treatType.textColor = CommonColor;
    _treatType.font = CommonFont;
    [self addSubview:_treatType];
    
    //牙位
    _toothLabel = [[UILabel alloc] init];
    _toothLabel.textColor = CommonColor;
    _toothLabel.font = CommonFont;
    _toothLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_toothLabel];
    
    //是否完成
    _finishLabel = [[UILabel alloc] init];
    _finishLabel.textColor = [UIColor whiteColor];
    _finishLabel.font = FinishLabelFont;
    _finishLabel.layer.cornerRadius = 3;
    _finishLabel.layer.masksToBounds = YES;
    _finishLabel.backgroundColor = [UIColor colorWithHex:0x3dbd57];
    _finishLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_finishLabel];
    
    //头像
    _icowView = [[UIImageView alloc] init];
    _icowView.layer.borderWidth = 1;
    _icowView.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
    _icowView.layer.cornerRadius = 14;
    _icowView.layer.masksToBounds = YES;
    [self addSubview:_icowView];
    
    //医生姓名
    _doctorNameLabel = [[UILabel alloc] init];
    _doctorNameLabel.textColor = CommonColor;
    _doctorNameLabel.font = CommonFont;
    [self addSubview:_doctorNameLabel];
    
    //分割线
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithHex:0xCCCCCC];
    [self addSubview:_lineView];
    
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
        [self addSubview:button];
    }
    
}

- (void)setModel:(XLCureProjectModel *)model{
    _model = model;
    
    CGFloat margin = 10;
    NSString *type = model.medical_item;
    NSString *tooth = model.tooth_position;
    NSString *finish = nil;
    UIColor *finishColor = nil;
    if ([model.status integerValue] == CureProjectWaitHandle) {
        //判断是否逾期
        if ([MyDateTool lateThanToday:model.end_date]) {
            self.finishLabel.hidden = NO;
            //逾期
            finish = @"已过期";
            finishColor = UnFinishColor;
        }else{
            //未逾期
            self.finishLabel.hidden = YES;
            finishColor = [UIColor whiteColor];
        }
    }else{
        finish = @"已完成";
        self.finishLabel.hidden = NO;
        finishColor = FinishedColor;
    }
    
    CGFloat finishW = 40;
    CGFloat finishH = 18;
    CGFloat finishX = self.width - margin - finishW;
    CGFloat finishY = margin;
    self.finishLabel.frame = CGRectMake(finishX, finishY, finishW, finishH);
    self.finishLabel.text = finish;
    self.finishLabel.textColor = finishColor;
    
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
    CGFloat toothW = self.width - self.treatType.right - margin - finishW - margin * 2;
    CGFloat toothH = toothSize.height;
    self.toothLabel.frame = CGRectMake(toothX, toothY, toothW, toothH);
    self.toothLabel.text = tooth;
    
    NSString *name = model.therapist_name;
    CGSize nameSize = [name measureFrameWithFont:CommonFont size:CGSizeMake(MAXFLOAT, MAXFLOAT)].size;
    CGFloat nameW = nameSize.width;
    CGFloat nameH = 28;
    CGFloat nameX = self.width - margin - nameW;
    CGFloat nameY = self.finishLabel.bottom + margin;
    self.doctorNameLabel.frame = CGRectMake(nameX, nameY, nameW, nameH);
    self.doctorNameLabel.text = name;
    
    CGFloat iconW = 28;
    CGFloat iconH = iconW;
    CGFloat iconX = nameX - margin - iconW;
    CGFloat iconY = nameY;
    self.icowView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    [self.icowView sd_setImageWithURL:[NSURL URLWithString:model.doctor_image] placeholderImage:[UIImage imageNamed:@"user_icon"] options:SDWebImageRefreshCached];
    
    CGFloat dividerX = 5;
    CGFloat dividerY = 75;
    CGFloat dividerW = self.width - dividerX;
    CGFloat dividerH = .5;
    self.lineView.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
    
    //按钮frame
    CGFloat buttonW = 75;
    CGFloat buttonH = 30;
    for (int i = 0; i < self.buttonNames.count; i++) {
        UIButton *button = [self viewWithTag:100 + i];
        CGFloat buttonY = self.lineView.bottom + margin;
        CGFloat buttonX = self.width - (margin + buttonW) * (i + 1);
        button.frame = CGRectMake(buttonX ,buttonY, buttonW, buttonH);
    }
}

- (void)buttonAction:(UIButton *)button{
    if (button.tag == 100) {
        NSLog(@"付款");
        
    }else if (button.tag == 101){
        NSLog(@"病程记录");
        
    }
}

@end
