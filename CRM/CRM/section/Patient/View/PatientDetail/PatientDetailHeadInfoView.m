//
//  PatientDetailHeadInfoView.m
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "PatientDetailHeadInfoView.h"
#import "QrCodeViewController.h"
#import "UIView+WXViewController.h"

#define Margin 8
#define CommenTitleFont [UIFont systemFontOfSize:16]
#define CommenTitleColor MyColor(142, 143, 144)
#define CommenTextColor MyColor(47, 47, 48)
#define LineViewH 1

@interface PatientDetailHeadInfoView ()

@property (nonatomic, weak)UILabel *patientNameTitle; //患者姓名标题
@property (nonatomic, weak)UILabel *patientNameLabel; //患者姓名
@property (nonatomic, weak)UILabel *patientPhoneTitle; //联系电话标题
@property (nonatomic, weak)UILabel *patientPhoneLabel; //联系电话
@property (nonatomic, weak)UIButton *phoneButton; //联系电话按钮
@property (nonatomic, weak)UIButton *weixinButton; //微信的按钮
@property (nonatomic, weak)UILabel *introducerNameTitle; //介绍人姓名标题
@property (nonatomic, weak)UILabel *introducerNameLabel; //介绍人姓名
@property (nonatomic, weak)UILabel *transferToTitle; //转诊到标题å
@property (nonatomic, weak)UILabel *transferToLabel; //转诊到

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
    //患者姓名标题
    NSString *patientName = @"患者姓名:";
    CGSize pNameTitleSize = [patientName sizeWithFont:CommenTitleFont];
    CGFloat commentW = pNameTitleSize.width; //公共宽
    CGFloat commentH = pNameTitleSize.height; //公共高
    
    UILabel *patientNameTitle = [[UILabel alloc] initWithFrame:CGRectMake(Margin * 2, Margin, pNameTitleSize.width, pNameTitleSize.height)];
    patientNameTitle.textColor = CommenTitleColor;
    patientNameTitle.font = CommenTitleFont;
    patientNameTitle.text = patientName;
    self.patientNameTitle = patientNameTitle;
    [self addSubview:patientNameTitle];
    
    //患者姓名内容视图
    UILabel *patientNameLabel = [[UILabel alloc] init];
    patientNameLabel.textColor = CommenTextColor;
    patientNameLabel.font = CommenTitleFont;
    [self addSubview:patientNameLabel];
    self.patientNameLabel = patientNameLabel;
    
    //联系电话标题
    UILabel *patientPhoneTitle = [[UILabel alloc] initWithFrame:CGRectMake(Margin * 2, Margin * 3 + commentH + LineViewH, commentW, commentH)];
    patientPhoneTitle.textColor = CommenTitleColor;
    patientPhoneTitle.font = CommenTitleFont;
    patientPhoneTitle.text = @"联系电话:";
    self.patientPhoneTitle = patientPhoneTitle;
    [self addSubview:patientPhoneTitle];
    
    //联系电话内容视图
    UILabel *patientPhoneLabel = [[UILabel alloc] init];
    patientPhoneLabel.textColor = CommenTextColor;
    patientPhoneLabel.font = CommenTitleFont;
    [self addSubview:patientPhoneLabel];
    self.patientPhoneLabel = patientPhoneLabel;
    
    //联系电话按钮
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneButton setImage:[UIImage imageNamed:@"phone_blue"] forState:UIControlStateNormal];
    [phoneButton setImage:[UIImage imageNamed:@"phone_gray"] forState:UIControlStateHighlighted];
    [phoneButton addTarget:self action:@selector(phoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.phoneButton = phoneButton;
    [self addSubview:phoneButton];
    
    //微信按钮
    UIButton *weixinButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [weixinButton setImage:[UIImage imageNamed:@"weixin_gray"] forState:UIControlStateNormal];
    self.weixinButton = weixinButton;
    [self addSubview:weixinButton];
    
    //介绍人标题
    UILabel *introducerNameTitle = [[UILabel alloc] initWithFrame:CGRectMake(Margin * 2, Margin * 5 + commentH * 2 + LineViewH * 2, commentW, commentH)];
    introducerNameTitle.textColor = CommenTitleColor;
    introducerNameTitle.font = CommenTitleFont;
    introducerNameTitle.text = @"介绍人:";
    self.introducerNameTitle = introducerNameTitle;
    [self addSubview:introducerNameTitle];
    
    //介绍人内容视图
    UILabel *introducerNameLabel = [[UILabel alloc] init];
    introducerNameLabel.textColor = CommenTextColor;
    introducerNameLabel.font = CommenTitleFont;
    [self addSubview:introducerNameLabel];
    self.introducerNameLabel = introducerNameLabel;
    
    //转诊到标题
    UILabel *transferToTitle = [[UILabel alloc] initWithFrame:CGRectMake(Margin * 2, Margin * 7 + commentH * 3 + LineViewH * 3, commentW, commentH)];
    transferToTitle.textColor = CommenTitleColor;
    transferToTitle.font = CommenTitleFont;
    transferToTitle.text = @"转诊到:";
    self.transferToTitle = transferToTitle;
    [self addSubview:transferToTitle];
    
    //转诊到内容视图
    UILabel *transferToLabel = [[UILabel alloc] init];
    transferToLabel.textColor = CommenTextColor;
    transferToLabel.font = CommenTitleFont;
    [self addSubview:transferToLabel];
    self.transferToLabel = transferToLabel;
    
    //创建分割线
    for (int i = 0; i < 5; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i * (Margin * 2 + commentH), kScreenWidth, LineViewH)];
        lineView.backgroundColor = MyColor(232, 234, 235);
        [self addSubview:lineView];
    }
}

- (void)setDetailPatient:(Patient *)detailPatient{
    _detailPatient = detailPatient;
    
    //患者姓名
    if (self.detailPatient.patient_name) {
        NSString *name = self.detailPatient.patient_name;
        CGSize nameSize = [name sizeWithFont:CommenTitleFont];
        self.patientNameLabel.frame = CGRectMake(self.patientNameTitle.right + Margin * 4, self.patientNameTitle.top, nameSize.width, nameSize.height);
        self.patientNameLabel.text = name;
    }
    
    //联系方式
    if (self.detailPatient.patient_phone) {
        NSString *phone = self.detailPatient.patient_phone;
        CGSize phoneSize = [phone sizeWithFont:CommenTitleFont];
        self.patientPhoneLabel.frame = CGRectMake(self.patientPhoneTitle.right + Margin * 4, self.patientPhoneTitle.top, phoneSize.width, phoneSize.height);
        self.patientPhoneLabel.text= phone;
        
        //电话按钮
        CGFloat commentH = phoneSize.height + Margin * 2;
        self.phoneButton.frame = CGRectMake(self.patientPhoneLabel.right + Margin * 2, commentH + 2, commentH - 4, commentH - 4);
        
    }
    
    //介绍人
    if (self.introducerName) {
        NSString *introducer = self.introducerName;
        CGSize introducerSize = [introducer sizeWithFont:CommenTitleFont];
        self.introducerNameLabel.frame = CGRectMake(self.introducerNameTitle.right + Margin * 2, self.introducerNameTitle.top, introducerSize.width, introducerSize.height);
        self.introducerNameLabel.text = introducer;
    }
    
    
    //转诊到
    if (self.transferStr) {
        NSString *transfer = self.transferStr;
        CGSize transferSize = [transfer sizeWithFont:CommenTitleFont];
        self.transferToLabel.frame = CGRectMake(self.transferToTitle.right + Margin * 2, self.transferToTitle.top, transferSize.width, transferSize.height);
        self.transferToLabel.text = transfer;
    }
}

- (void)setIsWeixin:(BOOL)isWeixin{
    _isWeixin = isWeixin;
    
    CGFloat commentH = self.phoneButton.height + 4;
    self.weixinButton.frame = CGRectMake(self.phoneButton.right, commentH + 2, commentH - 4, commentH - 4);
    
    if (self.isWeixin) {
        [self.weixinButton setImage:[UIImage imageNamed:@"weixin_green"] forState:UIControlStateNormal];
    }else{
        [self.weixinButton addTarget:self action:@selector(weixinButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.weixinButton setImage:[UIImage imageNamed:@"weixin_gray"] forState:UIControlStateNormal];
    }
}

- (void)setIntroducerName:(NSString *)introducerName{
    _introducerName = introducerName;
    
    //重新计算frame
    [self setDetailPatient:self.detailPatient];
}

- (void)setTransferStr:(NSString *)transferStr{
    _transferStr = transferStr;
    
    //重新计算frame
    [self setDetailPatient:self.detailPatient];
}

- (CGFloat)getTotalHeight{
    return self.patientNameTitle.height * 4 + Margin * 8 + LineViewH * 4;
}

#pragma mark -打电话
- (void)phoneButtonClick{
    if(![NSString isEmptyString:self.patientPhoneLabel.text]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"是否拨打该电话" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 101;
        [alertView show];
    }else{
        [SVProgressHUD showImage:nil status:@"患者未留电话"];
    }
}

#pragma mark -微信扫描
- (void)weixinButtonClick{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    QrCodeViewController *qrVC = [storyBoard instantiateViewControllerWithIdentifier:@"QrCodeViewController"];
    [self.viewController.navigationController pushViewController:qrVC animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 101){
        if(buttonIndex == 0){
        }else{
            NSString *number = self.patientPhoneLabel.text;
            NSString *num = [[NSString alloc]initWithFormat:@"tel://%@",number];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }
    }
}
@end
