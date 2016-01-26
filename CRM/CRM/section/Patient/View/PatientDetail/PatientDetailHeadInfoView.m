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
#import "AddReminderViewController.h"
#import "EditPatientDetailViewController.h"
#import "DBManager+Patients.h"
#import "DBTableMode.h"
#import "EditAllergyViewController.h"
#import "IntroducerViewController.h"
#import "UserInfoViewController.h"
#import "XLSelectYuyueViewController.h"
#import "NSString+MyString.h"
#import "UIColor+Extension.h"
#import "ChatViewController.h"

#define Margin 10
#define CommenTitleFont [UIFont systemFontOfSize:14]
#define CommenTitleColor MyColor(142, 143, 144)
#define CommenTextColor MyColor(47, 47, 48)
#define LineViewH 1
#define RowHeight 36
#define AllergyW 16
#define DividerH 16
#define arrowW 13
#define arrowH 18

@interface PatientDetailHeadInfoView ()<MFMessageComposeViewControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate>{
    Introducer *selectIntroducer;
}

@property (nonatomic, weak)UIView *nameAndPhoneSuperView;//姓名和电话父视图
@property (nonatomic, weak)UILabel *patientNameLabel; //患者姓名
@property (nonatomic, weak)UILabel *patientPhoneLabel; //联系电话
//@property (nonatomic, weak)UILabel *remarkLabel;//备注
@property (nonatomic, weak)UILabel *introducerNameLabel; //介绍人姓名
@property (nonatomic, weak)UIImageView *introducerImage;//介绍人编辑图片

@property (nonatomic, weak)UILabel *transferToLabel; //转诊到
@property (nonatomic, weak)UIButton *phoneButton; //联系电话按钮
@property (nonatomic, weak)UIButton *weixinButton; //微信的按钮
@property (nonatomic, weak)UIButton *addReserveButton;//添加预约
@property (nonatomic, weak)UIImageView *allergyView;//是否过敏

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
    
    UIView *nameAndPhoneSuperView = [[UIView alloc] init];
    self.nameAndPhoneSuperView = nameAndPhoneSuperView;
    
    [self addSubview:nameAndPhoneSuperView];
    //患者姓名内容视图
    UILabel *patientNameLabel = [[UILabel alloc] init];
    patientNameLabel.textColor = CommenTextColor;
    patientNameLabel.font = CommenTitleFont;
    [nameAndPhoneSuperView addSubview:patientNameLabel];
    self.patientNameLabel = patientNameLabel;
    
    //联系电话内容视图
    UILabel *patientPhoneLabel = [[UILabel alloc] init];
    patientPhoneLabel.textColor = CommenTextColor;
    patientPhoneLabel.font = CommenTitleFont;
    [nameAndPhoneSuperView addSubview:patientPhoneLabel];
    self.patientPhoneLabel = patientPhoneLabel;
    
    //介绍人内容视图
    UILabel *introducerNameLabel = [[UILabel alloc] init];
    introducerNameLabel.textColor = CommenTextColor;
    introducerNameLabel.font = CommenTitleFont;
    [self addSubview:introducerNameLabel];
    introducerNameLabel.userInteractionEnabled = YES;
    self.introducerNameLabel = introducerNameLabel;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(introduceAction:)];
    [introducerNameLabel addGestureRecognizer:tap];
    
    //介绍人编辑按钮
    UIImageView *introducerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"patient_bianji"]];
    self.introducerImage = introducerImage;
    introducerImage.hidden = YES;
    [introducerNameLabel addSubview:introducerImage];
    
    //转诊到内容视图
    UILabel *transferToLabel = [[UILabel alloc] init];
    transferToLabel.textColor = CommenTextColor;
    transferToLabel.font = CommenTitleFont;
    [self addSubview:transferToLabel];
    transferToLabel.text = @"转诊到：无";
    self.transferToLabel = transferToLabel;
    
    //联系电话按钮
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneButton setImage:[UIImage imageNamed:@"phone_blue"] forState:UIControlStateNormal];
    [phoneButton setImage:[UIImage imageNamed:@"phone_gray"] forState:UIControlStateHighlighted];
    [phoneButton addTarget:self action:@selector(phoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.phoneButton = phoneButton;
    [self addSubview:phoneButton];
    
    //微信按钮
    UIButton *weixinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [weixinButton setImage:[UIImage imageNamed:@"weixin_gray"] forState:UIControlStateNormal];
    self.weixinButton = weixinButton;
    [weixinButton addTarget:self action:@selector(weixinButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:weixinButton];
    
    //添加预约
    UIButton *addReserveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addReserveButton setTitle:@"预约" forState:UIControlStateNormal];
    addReserveButton.titleLabel.font = CommenTitleFont;
    [addReserveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addReserveButton.backgroundColor = [UIColor colorWithHex:0x00a0ea];
    addReserveButton.layer.cornerRadius = 2;
    addReserveButton.layer.masksToBounds = YES;
    [addReserveButton sizeToFit];
    [addReserveButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [addReserveButton addTarget:self action:@selector(addReserveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.addReserveButton = addReserveButton;
    [self addSubview:addReserveButton];
    
    //过敏
    UIImageView *allergyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"patient_min"]];
    self.allergyView = allergyView;
    [self.nameAndPhoneSuperView addSubview:allergyView];
}

- (void)setDetailPatient:(Patient *)detailPatient{
    _detailPatient = detailPatient;
    
    self.nameAndPhoneSuperView.frame = CGRectMake(0, 0, kScreenWidth, RowHeight * 2);
    
    //患者姓名
    NSString *name;
    if (self.detailPatient.patient_name && [self.detailPatient.patient_name isNotEmpty]) {
        name = [NSString stringWithFormat:@"姓名：   %@",self.detailPatient.patient_name];
    }else{
        name = @"姓名：   ";
    }
    CGSize nameSize = [name sizeWithFont:CommenTitleFont];
    self.patientNameLabel.frame = CGRectMake(Margin, 0, nameSize.width, RowHeight);
    self.patientNameLabel.attributedText = [name changeStrColorWithIndex:3];
    
    
    //过敏史
    if (self.detailPatient.patient_allergy && [self.detailPatient.patient_allergy isNotEmpty]) {
        self.allergyView.hidden = NO;
        self.allergyView.frame = CGRectMake(self.patientNameLabel.right + Margin, (RowHeight - AllergyW) * .5, AllergyW, AllergyW);
    }else{
        self.allergyView.hidden = YES;
    }
    
    //联系方式
    NSString *phone;
    if (self.detailPatient.patient_phone && [self.detailPatient.patient_phone isNotEmpty]) {
        phone = [NSString stringWithFormat:@"电话：   %@",self.detailPatient.patient_phone];
    }else{
        phone = @"电话：   无";
    }
    CGSize phoneSize = [phone sizeWithFont:CommenTitleFont];
    self.patientPhoneLabel.frame = CGRectMake(Margin, self.patientNameLabel.bottom, phoneSize.width, RowHeight);
    self.patientPhoneLabel.attributedText = [phone changeStrColorWithIndex:3];
    

    //介绍人
    self.introducerNameLabel.frame = CGRectMake(Margin, self.patientPhoneLabel.bottom, kScreenWidth / 2 - Margin, RowHeight);
    self.introducerNameLabel.text = @"介绍人：无";
    
    //介绍人编辑图片
    self.introducerImage.frame = CGRectMake(self.introducerNameLabel.width - 14 - 5, (RowHeight - 14) / 2, 14, 14);
    
    
    //分割线
    [self dividerViewWithFrame:CGRectMake((kScreenWidth - 1) *.5, (RowHeight - DividerH) * .5 + self.patientPhoneLabel.bottom, 1, DividerH)];
    
    //转诊到
    self.transferToLabel.frame = CGRectMake(self.introducerNameLabel.right + Margin, self.patientPhoneLabel.bottom, kScreenWidth / 2 - Margin, RowHeight);
    
    //4个按钮
    CGFloat buttonW = 40;
    CGFloat buttonH = 25;
    self.addReserveButton.frame = CGRectMake(kScreenWidth - buttonW - Margin, (RowHeight * 2 - buttonH) / 2, buttonW, buttonH);
    self.weixinButton.frame = CGRectMake(self.addReserveButton.left - buttonW - Margin, (RowHeight * 2 - buttonH) / 2, buttonW, buttonH);
    self.phoneButton.frame = CGRectMake(self.weixinButton.left - buttonW, (RowHeight * 2 - buttonH) / 2, buttonW, buttonH);
    
    //添加各行之间的分割线
    for (int i = 0; i < 3; i++) {
        [self dividerViewWithFrame:CGRectMake(0, (i + 2) * RowHeight, kScreenWidth, 1)];
    }
}
//添加分割线
- (void)dividerViewWithFrame:(CGRect)frame{
    UIView *divider = [[UIView alloc] initWithFrame:frame];
    divider.backgroundColor = MyColor(235, 235, 235);
    [self addSubview:divider];
}

- (void)setIsWeixin:(BOOL)isWeixin{
    _isWeixin = isWeixin;
    
    if (self.isWeixin) {
        [self.weixinButton setImage:[UIImage imageNamed:@"weixin_green"] forState:UIControlStateNormal];
    }else{
        [self.weixinButton setImage:[UIImage imageNamed:@"weixin_gray"] forState:UIControlStateNormal];
    }
}

- (void)setIntroducerName:(NSString *)introducerName{
    _introducerName = introducerName;
    
    //重新计算frame
    NSString *introducer;
    if (self.introducerName && [self.introducerName isNotEmpty]) {
        introducer = [NSString stringWithFormat:@"介绍人：%@",introducerName];
    }else{
        introducer = @"介绍人：无";
    }
   
    self.introducerNameLabel.attributedText = [introducer changeStrColorWithIndex:4];
}

- (void)setTransferStr:(NSString *)transferStr{
    _transferStr = transferStr;
    
    //重新计算frame
    NSString *transfer;
    if (self.transferStr) {
        transfer = [NSString stringWithFormat:@"转诊到：%@",self.transferStr];
    }else{
        transfer = @"转诊到：无";
    }
    self.transferToLabel.attributedText = [transfer changeStrColorWithIndex:4];
}

- (void)setIntroduceCanEdit:(BOOL)introduceCanEdit{
    _introduceCanEdit = introduceCanEdit;
    
    if (introduceCanEdit) {
        self.introducerImage.hidden = NO;
    }else{
        self.introducerImage.hidden = YES;
    }
    
}

- (CGFloat)getTotalHeight{
    return RowHeight * 3;
}

#pragma mark -打电话
- (void)phoneButtonClick{
    if(![NSString isEmptyString:self.detailPatient.patient_phone]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"是否拨打电话%@",self.detailPatient.patient_phone] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 101;
        [alertView show];
    }else{
        [SVProgressHUD showImage:nil status:@"患者未留电话"];
    }
}

#pragma mark -微信扫描
- (void)weixinButtonClick{
    if (self.isWeixin) {
        //跳转到即时通讯页面
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.detailPatient.ckeyid conversationType:eConversationTypeChat];
        chatController.title = self.detailPatient.patient_name;
        [self.viewController.navigationController pushViewController:chatController animated:YES];
    }else{
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        QrCodeViewController *qrVC = [storyBoard instantiateViewControllerWithIdentifier:@"QrCodeViewController"];
        qrVC.patient = self.detailPatient;
        [self.viewController.navigationController pushViewController:qrVC animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 101){
        if(buttonIndex == 0){
        }else{
            NSString *number = self.detailPatient.patient_phone;
            NSString *num = [[NSString alloc]initWithFormat:@"tel://%@",number];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }
    }else if (alertView.tag == 200){
        if (buttonIndex == 0) {
            //取消
        }else{
            //编辑个人信息
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            UserInfoViewController *userInfoVC = [storyBoard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
            userInfoVC.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:userInfoVC animated:YES];
        }
    }
    
}

#pragma mark -发信息
- (void)messageButtonClick{
    if (self.detailPatient.patient_phone) {
        if( [MFMessageComposeViewController canSendText] ){
            MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init]; //autorelease];
            controller.recipients = @[self.detailPatient.patient_phone];
            controller.body = @"";
            controller.messageComposeDelegate = self;
            //跳转到发送短信的页面
            [self.viewController presentViewController:controller animated:YES completion:nil];
            [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"发送短信页面"];//修改短信界面标题
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"设备没有短信功能"];
        }
    }else{
        [SVProgressHUD showImage:nil status:@"患者未留电话"];
    }
}
//短信是否发送成功
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:NO completion:nil];//关键的一句   不能为YES
    switch ( result ) {
        case MessageComposeResultCancelled:
            [SVProgressHUD showImage:nil status:@"取消发送信息"];
            break;
        case MessageComposeResultFailed:
            [SVProgressHUD showImage:nil status:@"发送信息失败"];
            break;
        case MessageComposeResultSent:
            [SVProgressHUD showImage:nil status:@"发送信息成功"];
            break;
        default:
            break;
    }
}

#pragma mark - 添加预约
- (void)addReserveButtonClick{
    
    if ([[AccountManager shareInstance] currentUser].hospitalName == NULL || ![[[AccountManager shareInstance] currentUser].hospitalName isNotEmpty]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你没有设置所在医院，是否前往设置？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往", nil];
        alertView.tag = 200;
        [alertView show];
        return;
    }
    
    XLSelectYuyueViewController *selectYuyeVc = [[XLSelectYuyueViewController alloc] init];
    selectYuyeVc.hidesBottomBarWhenPushed = YES;
    selectYuyeVc.isAddLocationToPatient = YES;
    selectYuyeVc.patient = self.detailPatient;
    [self.viewController.navigationController pushViewController:selectYuyeVc animated:YES];
}
#pragma mark - 选择介绍人
- (void)introduceAction:(UITapGestureRecognizer *)tap{
    if (self.introduceCanEdit) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectIntroducer)]) {
            [self.delegate didSelectIntroducer];
        }
    }
}



@end
