//
//  PatientDetailHeadInfoView.m
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "PatientDetailHeadInfoView.h"
#import "UIView+WXViewController.h"
#import "EditPatientDetailViewController.h"
#import "DBManager+Patients.h"
#import "DBTableMode.h"
#import "XLSelectYuyueViewController.h"
#import "NSString+MyString.h"
#import "UIColor+Extension.h"
#import "ChatViewController.h"
#import "NSString+TTMAddtion.h"
#import "DoctorGroupModel.h"
#import "XLEditGroupViewController.h"
#import "MJExtension.h"
#import "JSONKit.h"
#import "DBManager+AutoSync.h"
#import "GroupMemberEntity.h"
#import "DoctorGroupTool.h"
#import <MessageUI/MessageUI.h>
#import "XLAppointmentBaseViewController.h"
#import "XLTransferRecordViewController.h"

#define Margin 10
#define CommenTitleFont [UIFont systemFontOfSize:14]
#define CommenTitleColor MyColor(142, 143, 144)
#define CommenTextColor MyColor(47, 47, 48)
#define LineViewH 1
#define RowHeight 50
#define AllergyW 16
#define DividerH 16
#define arrowW 13
#define arrowH 18

@interface PatientDetailHeadInfoView ()<UITextFieldDelegate,UIAlertViewDelegate,XLEditGroupViewControllerDelegate>{
    Introducer *selectIntroducer;
}

@property (nonatomic, weak)UIView *nameAndPhoneSuperView;//姓名和电话父视图
@property (nonatomic, weak)UILabel *patientNameLabel; //患者姓名
@property (nonatomic, weak)UILabel *introducerNameLabel; //介绍人姓名
@property (nonatomic, weak)UIImageView *introducerImage;//介绍人编辑图片

@property (nonatomic, weak)UILabel *transferToLabel; //转诊到
@property (nonatomic, weak)UIImageView *transferArrow;//箭头

@property (nonatomic, weak)UIButton *phoneButton; //联系电话按钮
@property (nonatomic, weak)UIButton *messageButton;//消息
@property (nonatomic, weak)UIButton *addReserveButton;//添加预约
@property (nonatomic, weak)UIImageView *allergyView;//是否过敏

@property (nonatomic, strong)UIView *groupSuperView;//分组父视图
@property (nonatomic, weak)UILabel *groupTitle;//标题
@property (nonatomic, weak)UITextField *groupName;//分组名称
@property (nonatomic, weak)UIImageView *arrowView;//箭头

@property (nonatomic, strong)NSArray *curExistGroups;

@end

@implementation PatientDetailHeadInfoView

- (UIView *)groupSuperView{
    if (!_groupSuperView) {
        _groupSuperView = [[UIView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTouchesRequired = 1;
        [_groupSuperView addGestureRecognizer:tap];
        [self addSubview:_groupSuperView];
        //标题
        UILabel *groupTitle = [[UILabel alloc] init];
        groupTitle.textColor = MyColor(136, 136, 136);
        groupTitle.font = CommenTitleFont;
        groupTitle.text = @"分组：   ";
        [_groupSuperView addSubview:groupTitle];
        self.groupTitle = groupTitle;
        
        //分组名称
        UITextField *groupName = [[UITextField alloc] init];
        groupName.font = CommenTitleFont;
        groupName.textColor = [UIColor colorWithHex:0x333333];
        groupName.placeholder = @"将患者添加到分组";
        groupName.enabled = NO;
        self.groupName = groupName;
        [_groupSuperView addSubview:groupName];
        
        //箭头
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_crm"]];
        self.arrowView = arrowView;
        [_groupSuperView addSubview:arrowView];
    }
    return _groupSuperView;
}

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
    transferToLabel.textColor = [UIColor colorWithHex:0x333333];
    transferToLabel.font = CommenTitleFont;
    transferToLabel.userInteractionEnabled = YES;
    [self addSubview:transferToLabel];
    UITapGestureRecognizer *transferTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transferAction:)];
    [transferToLabel addGestureRecognizer:transferTap];
    transferToLabel.text = @"转诊记录";
    self.transferToLabel = transferToLabel;
    //转诊按钮
    UIImageView *transferArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_crm"]];
    self.transferArrow = transferArrow;
    [transferToLabel addSubview:transferArrow];
    
    //联系电话按钮
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneButton setImage:[UIImage imageNamed:@"phone_blue"] forState:UIControlStateNormal];
    [phoneButton setImage:[UIImage imageNamed:@"phone_gray"] forState:UIControlStateHighlighted];
    [phoneButton addTarget:self action:@selector(phoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.phoneButton = phoneButton;
    [self addSubview:phoneButton];
    
    //添加预约
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageButton setTitle:@"消息" forState:UIControlStateNormal];
    messageButton.titleLabel.font = CommenTitleFont;
    [messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    messageButton.backgroundColor = [UIColor colorWithHex:0x42c112];
    messageButton.layer.cornerRadius = 2;
    messageButton.layer.masksToBounds = YES;
    [messageButton sizeToFit];
    [messageButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [messageButton addTarget:self action:@selector(messageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.messageButton = messageButton;
    [self addSubview:messageButton];
    
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
    
    //初始化分组视图
    [self groupSuperView];
}

- (void)setDetailPatient:(Patient *)detailPatient{
    _detailPatient = detailPatient;
    
    self.nameAndPhoneSuperView.frame = CGRectMake(0, 0, kScreenWidth, RowHeight);
    
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
    
    //介绍人
    self.introducerNameLabel.frame = CGRectMake(Margin, self.patientNameLabel.bottom, kScreenWidth / 2 - Margin, RowHeight);
    self.introducerNameLabel.attributedText = [@"介绍人：无" changeStrColorWithIndex:4];
    
    //介绍人编辑图片
    self.introducerImage.frame = CGRectMake(self.introducerNameLabel.width - 14 - 5, (RowHeight - 14) / 2, 14, 14);
    
    //分割线
    [self dividerViewWithFrame:CGRectMake((kScreenWidth - 1) *.5, (RowHeight - DividerH) * .5 + self.patientNameLabel.bottom, 1, DividerH)];
    
    //转诊到
    self.transferToLabel.frame = CGRectMake(self.introducerNameLabel.right + Margin, self.patientNameLabel.bottom, kScreenWidth / 2 - Margin, RowHeight);
    self.transferArrow.frame = CGRectMake(self.transferToLabel.width - arrowW - Margin, (self.transferToLabel.height - arrowH) / 2, arrowW, arrowH);
    
    //4个按钮
    CGFloat buttonW = 40;
    CGFloat buttonH = 25;
    self.addReserveButton.frame = CGRectMake(kScreenWidth - buttonW - Margin, (RowHeight - buttonH) / 2, buttonW, buttonH);
    self.messageButton.frame = CGRectMake(self.addReserveButton.left - buttonW - Margin, (RowHeight - buttonH) / 2, buttonW, buttonH);
    self.phoneButton.frame = CGRectMake(self.messageButton.left - buttonW, (RowHeight - buttonH) / 2, buttonW, buttonH);
    
    //添加各行之间的分割线
    for (int i = 0; i < 3; i++) {
        [self dividerViewWithFrame:CGRectMake(0, (i + 1) * RowHeight, kScreenWidth, 1)];
    }
    
    //分组
    self.groupSuperView.frame = CGRectMake(0, self.introducerNameLabel.bottom, kScreenWidth, RowHeight);
    CGSize groupTitleSize = [self.groupTitle.text measureFrameWithFont:CommenTitleFont size:CGSizeMake(MAXFLOAT, MAXFLOAT)].size;
    self.groupTitle.frame = CGRectMake(Margin, 0, groupTitleSize.width, RowHeight);
    self.arrowView.frame = CGRectMake(kScreenWidth - arrowW - Margin, (RowHeight - arrowH) / 2, arrowW, arrowH);
    self.groupName.frame = CGRectMake(self.groupTitle.right, 0, kScreenWidth - self.groupTitle.right - arrowW - Margin * 2, RowHeight);
}
//添加分割线
- (void)dividerViewWithFrame:(CGRect)frame{
    UIView *divider = [[UIView alloc] initWithFrame:frame];
    divider.backgroundColor = MyColor(235, 235, 235);
    [self addSubview:divider];
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
- (void)messageButtonClick{
    //跳转到即时通讯页面
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.detailPatient.ckeyid conversationType:eConversationTypeChat];
    chatController.title = self.detailPatient.patient_name;
    [self.viewController.navigationController pushViewController:chatController animated:YES];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 101){
        if(buttonIndex == 0){
        }else{
            NSString *number = self.detailPatient.patient_phone;
            NSString *num = [[NSString alloc]initWithFormat:@"tel://%@",number];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }
    }
}

#pragma mark - 转诊按钮点击
- (void)transferAction:(UITapGestureRecognizer *)tap{
    XLTransferRecordViewController *transferVc = [[XLTransferRecordViewController alloc] init];
    transferVc.patientId = self.detailPatient.ckeyid;
    [self.viewController.navigationController pushViewController:transferVc animated:YES];
}

#pragma mark - 添加预约
- (void)addReserveButtonClick{
    
    XLAppointmentBaseViewController *baseVC = [[XLAppointmentBaseViewController alloc] init];
    baseVC.patient = self.detailPatient;
    [self.viewController.navigationController pushViewController:baseVC animated:YES];
}
#pragma mark - 选择介绍人
- (void)introduceAction:(UITapGestureRecognizer *)tap{
    if (self.introduceCanEdit) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectIntroducer)]) {
            [self.delegate didSelectIntroducer];
        }
    }
}
#pragma mark - 设置分组
- (void)tapAction:(UITapGestureRecognizer *)tap{
    XLEditGroupViewController *editGroupVc = [[XLEditGroupViewController alloc] initWithStyle:UITableViewStyleGrouped];
    editGroupVc.delegate = self;
    editGroupVc.isEdit = YES;
    editGroupVc.currentGroups = self.curExistGroups == nil ? self.currentGroups : self.curExistGroups;
    editGroupVc.orginExistGroups = self.currentGroups;
    [self.viewController.navigationController pushViewController:editGroupVc animated:YES];
}

- (void)setCurrentGroups:(NSArray *)currentGroups{
    _currentGroups = currentGroups;
    
    NSMutableString *mStr = [NSMutableString string];
    for (DoctorGroupModel *groupM in currentGroups) {
        [mStr appendFormat:@"%@、",groupM.group_name];
    }
    NSString *groupName = mStr.length > 0 ? [mStr substringToIndex:mStr.length - 1] : @"";
    
    self.groupName.text = groupName;
}

#pragma mark - XLEditGroupViewControllerDelegate
- (void)editGroupViewController:(XLEditGroupViewController *)editGroupVc didAddGroups:(NSArray *)addGroups delectGroups:(NSArray *)deleteGroups groupName:(NSString *)groupName{
    self.curExistGroups = addGroups;
    //上传新增的分组信息
    if (addGroups.count > 0) {
        NSMutableArray *selectMemberArr = [NSMutableArray array];
        for (DoctorGroupModel *model in addGroups) {
            BOOL exist = NO;
            for (DoctorGroupModel *orginModel in self.currentGroups) {
                if ([model.ckeyid isEqualToString:orginModel.ckeyid]) {
                    exist = YES;
                    break;
                }
            }
            if (!exist) {
                GroupMemberEntity *member = [[GroupMemberEntity alloc] initWithGroupName:model.group_name groupId:model.ckeyid doctorId:model.doctor_id patientId:self.detailPatient.ckeyid patientName:self.detailPatient.patient_name ckeyId:@""];
                [selectMemberArr addObject:member.keyValues];
            }
        }
        if (selectMemberArr.count > 0) {
            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_AddPatientToGroups postType:Insert dataEntity:[selectMemberArr JSONString] syncStatus:@"0"];
            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
        } 
    }
    
    //上传删除的分组信息
    if (deleteGroups.count > 0) {
        NSMutableString *mStr = [NSMutableString string];
        for (DoctorGroupModel *model in deleteGroups) {
            [mStr appendFormat:@"%@,",model.ckeyid];
        }
        NSString *groupIds = [mStr substringToIndex:mStr.length - 1];
        GroupAndPatientParam *param = [[GroupAndPatientParam alloc] init];
        param.patientIds = self.detailPatient.ckeyid;
        param.groupIds = groupIds;
        
        InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_AddPatientToGroups postType:Delete dataEntity:[param.keyValues JSONString] syncStatus:@"0"];
        [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
    }
    [self setCurrentGroups:addGroups];
}


@end
