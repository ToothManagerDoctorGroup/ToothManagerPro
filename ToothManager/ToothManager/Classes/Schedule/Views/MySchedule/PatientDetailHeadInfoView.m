//
//  PatientDetailHeadInfoView.m
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "PatientDetailHeadInfoView.h"

#define Margin 10
#define CommenTitleFont [UIFont systemFontOfSize:16]
#define CommenTextColor RGBColor(47, 47, 48)
#define LineViewH 1

#define commenH 35


@interface PatientDetailHeadInfoView ()

@property (nonatomic, weak)UILabel *patientNameLabel; //患者姓名
@property (nonatomic, weak)UILabel *sexLabel; //患者性别内容
@property (nonatomic, weak)UILabel *ageLabel; //患者年龄内容
@property (nonatomic, weak)UILabel *patientPhoneLabel; //联系电话
@property (nonatomic, weak)UIButton *phoneButton; //联系电话按钮
@property (nonatomic, weak)UILabel *addressLabel; //患者地址内容
@property (nonatomic, weak)UILabel *allergyLabel; //过敏史内容
@property (nonatomic, weak)UILabel *historyLabel; //既往病史内容

@end

@implementation PatientDetailHeadInfoView

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
        //初始化
        [self setUp];
    }
    return self;
}
#pragma mark -初始化子视图
- (void)setUp{
    //患者姓名
    UILabel *patientNameLabel = [[UILabel alloc] init];
    patientNameLabel.textColor = CommenTextColor;
    patientNameLabel.font = CommenTitleFont;
    self.patientNameLabel = patientNameLabel;
    [self addSubview:patientNameLabel];
    
    //患者性别内容
    UILabel *sexLabel = [[UILabel alloc] init];
    sexLabel.textColor = CommenTextColor;
    sexLabel.font = CommenTitleFont;
    self.sexLabel = sexLabel;
    [self addSubview:sexLabel];
    
    //患者年龄内容
    UILabel *ageLabel = [[UILabel alloc] init];
    ageLabel.textColor = CommenTextColor;
    ageLabel.font = CommenTitleFont;
    self.ageLabel = ageLabel;
    [self addSubview:ageLabel];
    
    //联系电话
    UILabel *patientPhoneLabel = [[UILabel alloc] init];
    patientPhoneLabel.textColor = CommenTextColor;
    patientPhoneLabel.font = CommenTitleFont;
    self.patientPhoneLabel = patientPhoneLabel;
    [self addSubview:patientPhoneLabel];
    
    
    //联系电话按钮
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneButton setImage:[UIImage imageNamed:@"phone_blue"] forState:UIControlStateNormal];
    [phoneButton setImage:[UIImage imageNamed:@"phone_gray"] forState:UIControlStateHighlighted];
    [phoneButton addTarget:self action:@selector(phoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.phoneButton = phoneButton;
    [self addSubview:phoneButton];
    
    //患者地址内容
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.textColor = CommenTextColor;
    addressLabel.font = CommenTitleFont;
    self.addressLabel = addressLabel;
    [self addSubview:addressLabel];
    
    //过敏史内容
    UILabel *allergyLabel = [[UILabel alloc] init];
    allergyLabel.textColor = CommenTextColor;
    allergyLabel.font = CommenTitleFont;
    self.allergyLabel = allergyLabel;
    [self addSubview:allergyLabel];
    
    //既往病史内容
    UILabel *historyLabel = [[UILabel alloc] init];
    historyLabel.textColor = CommenTextColor;
    historyLabel.font = CommenTitleFont;
    self.historyLabel = historyLabel;
    [self addSubview:historyLabel];
    
    
    //创建分割线
    for (int i = 0; i < 8; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i * commenH, ScreenWidth, LineViewH)];
        lineView.backgroundColor = RGBColor(232, 234, 235);
        [self addSubview:lineView];
    }
}

- (void)setModel:(TTMPatientModel *)model{
    _model = model;
    
    //患者姓名
    self.patientNameLabel.frame = CGRectMake(Margin, 0, ScreenWidth - Margin * 2, commenH);
    self.patientNameLabel.text = [NSString stringWithFormat:@"姓名:  %@",model.patient_name];
    
    //性别
    NSString *sex;
    if (model.patient_gender == 0) {
        sex = @"男";
    }else{
        sex = @"女";
    }
    self.sexLabel.frame = CGRectMake(Margin, self.patientNameLabel.bottom, ScreenWidth - Margin * 2, commenH);
    self.sexLabel.text = [NSString stringWithFormat:@"性别:  %@",sex];
   
    //年龄
    self.ageLabel.frame = CGRectMake(Margin, self.sexLabel.bottom, ScreenWidth - Margin * 2, commenH);
    self.ageLabel.text = [NSString stringWithFormat:@"年龄:  %ld",(long)model.patient_age];
    
    //联系电话
    NSString *phone = [NSString stringWithFormat:@"联系电话:  %@",model.patient_phone];
    CGSize phoneSize = [phone sizeWithFont:CommenTitleFont];
    self.patientPhoneLabel.frame = CGRectMake(Margin, self.ageLabel.bottom, phoneSize.width, commenH);
    self.patientPhoneLabel.text = phone;
    
    //电话按钮
    self.phoneButton.frame = CGRectMake(self.patientPhoneLabel.right + Margin * 2, self.ageLabel.bottom + 2 , commenH - 4, commenH - 4);
    
    
    //患者地址
    self.addressLabel.frame = CGRectMake(Margin, self.patientPhoneLabel.bottom, ScreenWidth - Margin * 2, commenH);
    self.addressLabel.text = [NSString stringWithFormat:@"家庭住址:  %@",model.patient_address];
    
    //过敏史
    self.allergyLabel.frame = CGRectMake(Margin, self.addressLabel.bottom, ScreenWidth - Margin * 2, commenH);
    self.allergyLabel.text = [NSString stringWithFormat:@"过敏史:  %@",model.patient_allergy];
    
    //既往病史
    self.historyLabel.frame = CGRectMake(Margin, self.allergyLabel.bottom, ScreenWidth - Margin * 2, commenH);
    self.historyLabel.text = [NSString stringWithFormat:@"既往病史:  %@",model.anamnesis];
    
}

#pragma mark -打电话
- (void)phoneButtonClick{
    if(self.model.patient_phone){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"是否拨打电话%@",self.model.patient_phone] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 101;
        [alertView show];
    }else{
        [MBProgressHUD showToastWithText:@"患者未留电话"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 101){
        if(buttonIndex == 0){
        }else{
            NSString *number = self.model.patient_phone;
            NSString *num = [[NSString alloc]initWithFormat:@"tel://%@",number];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }
    }
}
@end
