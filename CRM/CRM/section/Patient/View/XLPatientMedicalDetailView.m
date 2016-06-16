//
//  XLPatientMedicalDetailView.m
//  CRM
//
//  Created by Argo Zhang on 16/3/1.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLPatientMedicalDetailView.h"
#import "UIColor+Extension.h"
#import "XLMedicalImageView.h"
#import "XLServerTeamButton.h"
#import "XLTeamButton.h"
#import "DBManager+Patients.h"
#import "UIView+WXViewController.h"
#import "XLTreatPlanViewController.h"
#import "XLDiseaseRecordViewController.h"
#import "XLMaterialExpendViewController.h"
#import "ChatViewController.h"
#import "XLPatientAppointViewController.h"

#define CommonTextColor [UIColor colorWithHex:0x333333]
#define CommonTextFont [UIFont systemFontOfSize:15]

@interface XLPatientMedicalDetailView ()

@property (nonatomic, weak)UILabel *implantTimeLabel;//种植时间

@property (nonatomic, weak)XLMedicalImageView *medicalImageView;//病历图片详情视图
@property (nonatomic, weak)XLServerTeamButton *serverTeamButton;//服务团队按钮

@property (nonatomic, strong)NSArray *buttonDatas;

@end

@implementation XLPatientMedicalDetailView

- (NSArray *)buttonDatas{
    if (!_buttonDatas) {
        _buttonDatas = @[@{@"title" : @"治疗方案",@"image" : @"team_fangan"},
                         @{@"title" : @"预约记录",@"image" : @"team_yuyue"},
                         @{@"title" : @"病程记录",@"image" : @"team_bingcheng"},
                         @{@"title" : @"所用耗材",@"image" : @"team_haocai"}];
    }
    
    return _buttonDatas;
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

#pragma mark -初始化
- (void)setUp{
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    //种植时间
    UILabel *implantTimeLabel = [[UILabel alloc] init];
    implantTimeLabel.textColor = CommonTextColor;
    implantTimeLabel.font = CommonTextFont;
    self.implantTimeLabel = implantTimeLabel;
    [self addSubview:implantTimeLabel];
    
    //病历图片视图
    XLMedicalImageView *medicalImageView = [[XLMedicalImageView alloc] init];
    self.medicalImageView = medicalImageView;
    [self addSubview:medicalImageView];
    
    //服务团队按钮
    XLServerTeamButton *serverTeamButton = [[XLServerTeamButton alloc] init];
    self.serverTeamButton = serverTeamButton;
    [serverTeamButton addTarget:self action:@selector(serverTeamButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:serverTeamButton];
    
    //团队按钮
    for (int i = 0; i < self.buttonDatas.count; i++) {
        NSDictionary *dic = self.buttonDatas[i];
        XLTeamButton *teamBtn = [[XLTeamButton alloc] init];
        teamBtn.image = [UIImage imageNamed:dic[@"image"]];
        teamBtn.tag = 100 + i;
        teamBtn.title = dic[@"title"];
        
        [teamBtn addTarget:self action:@selector(teamBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:teamBtn];
        
        if (i > 0) {
            UIView *divider = [[UIView alloc] init];
            divider.tag = 200 + i;
            divider.backgroundColor = [UIColor colorWithHex:0xCCCCCC];
            [self addSubview:divider];
        }
    }
}

- (void)setMedicalCase:(MedicalCase *)medicalCase{
    _medicalCase = medicalCase;
    
    CGFloat margin = 5;
    
    CGFloat timeX = margin * 2;
    CGFloat timeY = 0;
    CGFloat timeW = self.width - margin * 4;
    CGFloat timeH = 40;
    self.implantTimeLabel.frame = CGRectMake(timeX, timeY, timeW, timeH);
    
    CGFloat medicalImageX = margin;
    CGFloat medicalImageY = self.implantTimeLabel.bottom;
    CGFloat medicalImageW = self.width - margin * 2;
    CGFloat medicalImageH = 180;
    self.medicalImageView.frame = CGRectMake(medicalImageX, medicalImageY, medicalImageW, medicalImageH);
    
    CGFloat serverX = 0;
    CGFloat serverY = self.medicalImageView.bottom + margin * 2;
    CGFloat serverW = self.width;
    CGFloat serverH = 50;
    self.serverTeamButton.frame = CGRectMake(serverX, serverY, serverW, serverH);
    
    //创建4个按钮
    CGFloat buttonW = self.width / self.buttonDatas.count;
    CGFloat buttonH = 90;
    CGFloat buttonY = self.serverTeamButton.bottom;
    CGFloat buttonX = 0;
    CGFloat dividerX = 0;
    CGFloat dividerY = buttonY;
    CGFloat dividerW = 1;
    CGFloat dividerH = buttonH;
    for (int i = 0; i < self.buttonDatas.count; i++) {
        XLTeamButton *button = [self viewWithTag:100 + i];
        buttonX = i * buttonW;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        
        UIView *divider = [self viewWithTag:200 + i];
        dividerX = i * buttonW;
        divider.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
    }
    
    //设置种植时间
    if ([medicalCase.implant_time isNotEmpty]) {
        self.implantTimeLabel.text = [NSString stringWithFormat:@"种植时间：%@",medicalCase.implant_time];
    }else{
        self.implantTimeLabel.text = @"种植时间：";
    }
    
    //设置ct图显示
    self.medicalImageView.medicalCase = medicalCase;
}

- (void)setMemberNum:(NSInteger)memberNum{
    _memberNum = memberNum;
    
    self.serverTeamButton.memberNum = memberNum;
}

#pragma mark - 菜单按钮点击事件
- (void)teamBtnAction:(XLTeamButton *)button{
    if (button.tag == 100) {
        //治疗方案
        XLTreatPlanViewController *treatVc = [[XLTreatPlanViewController alloc] initWithStyle:UITableViewStylePlain];
        treatVc.mCase = self.medicalCase;
        [self.viewController.navigationController pushViewController:treatVc animated:YES];
        NSLog(@"治疗方案");
    }else if (button.tag == 101){
        //预约记录
        NSLog(@"预约记录");
        XLPatientAppointViewController *appointVc = [[XLPatientAppointViewController alloc] initWithStyle:UITableViewStylePlain];
        appointVc.patient_id = self.medicalCase.patient_id;
        [self.viewController.navigationController pushViewController:appointVc animated:YES];
    }else if (button.tag == 102){
        //病程记录
        XLDiseaseRecordViewController *diseaseVc = [[XLDiseaseRecordViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.viewController.navigationController pushViewController:diseaseVc animated:YES];
        NSLog(@"病程记录");
    }else if (button.tag == 103){
        //所用耗材
        NSLog(@"所用耗材");
        XLMaterialExpendViewController *expendVc = [[XLMaterialExpendViewController alloc] init];
        expendVc.medicalCase_id = self.medicalCase.ckeyid;
        [self.viewController.navigationController pushViewController:expendVc animated:YES];
    }
}

- (void)serverTeamButtonAction{
    NSLog(@"服务团队");
    ChatViewController *chatVc = [[ChatViewController alloc] initWithConversationChatter:self.medicalCase.hxGroupId conversationType:eConversationTypeGroupChat];
    chatVc.title = self.medicalCase.case_name;
    chatVc.mCase = self.medicalCase;
    [self.viewController.navigationController pushViewController:chatVc animated:YES];
}


@end
