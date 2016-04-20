//
//  XLSeniorStatisticsHeaderView.m
//  CRM
//
//  Created by Argo Zhang on 16/1/22.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLSeniorStatisticsHeaderView.h"
#import "UIColor+Extension.h"
#import "TimPickerTextField.h"
#import "TimNavigationViewController.h"
#import "UIView+WXViewController.h"
#import "MyDateTool.h"
#import "DBTableMode.h"
#import "XLDoctorLibraryViewController.h"

#define CommonTextColor [UIColor colorWithHex:0x333333]
#define CommonTextFont [UIFont systemFontOfSize:15]

#define PlantType @"plant"
#define RepairType @"repair"

@interface XLSeniorStatisticsHeaderView ()<TimPickerTextFieldDelegate,XLDoctorLibraryViewControllerDelegate>

@property (nonatomic, weak)UILabel *repairTimeTitle;//修复时间标题
@property (nonatomic, weak)TimPickerTextField *startTime;//开始时间
@property (nonatomic, weak)TimPickerTextField *endTime;//结束时间
@property (nonatomic, weak)UIView *divider;//分割线

@property (nonatomic, weak)UIView *repairDoctorSuperView;//修复医生父视图
@property (nonatomic, weak)UILabel *repairDoctor;//修复医生

@property (nonatomic, weak)UIButton *searchBtn;//查询按钮

@property (nonatomic, strong)Doctor *selectDoc;//当前选中的修复医生

@end

@implementation XLSeniorStatisticsHeaderView
- (UIView *)repairDoctorSuperView{
    if (!_repairDoctorSuperView) {
        
        CGFloat margin = 10;
        CGFloat superH = 50;
        //修复医生父视图
        UIView *repairDoctorSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kScreenWidth, superH)];
        _repairDoctorSuperView = repairDoctorSuperView;
        [self addSubview:repairDoctorSuperView];
        //添加修复医生
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [repairDoctorSuperView addGestureRecognizer:tap];
        
        //修复医生标题
        NSString *title = @"修复医生:";
        CGSize titleSize = [title sizeWithFont:CommonTextFont];
        UILabel *repairDoctorTitle = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, titleSize.width, superH)];
        repairDoctorTitle.textColor = CommonTextColor;
        repairDoctorTitle.font = CommonTextFont;
        repairDoctorTitle.text = title;
        [repairDoctorSuperView addSubview:repairDoctorTitle];
        
        //箭头
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_crm"]];
        arrowView.frame = CGRectMake(kScreenWidth - 13 - margin, (superH - 18) / 2, 13, 18);
        [repairDoctorSuperView addSubview:arrowView];
        
        //修复医生
        CGFloat repairDocW = kScreenWidth - margin * 4 - repairDoctorTitle.width - arrowView.width;
        CGFloat repairDocH = superH;
        CGFloat repairDocX = CGRectGetMaxX(repairDoctorTitle.frame) + margin;
        CGFloat repairDocY = 0;
        UILabel *repairDoctor = [[UILabel alloc] initWithFrame:CGRectMake(repairDocX, repairDocY, repairDocW, repairDocH)];
        repairDoctor.textColor = CommonTextColor;
        repairDoctor.font = CommonTextFont;
        repairDoctor.textAlignment = NSTextAlignmentRight;
        self.repairDoctor = repairDoctor;
        [repairDoctorSuperView addSubview:repairDoctor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, superH - 1, kScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHex:0xdddddd];
        [repairDoctorSuperView addSubview:line];
        
    }
    
    return _repairDoctorSuperView;
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
#pragma mark - 初始化
- (void)setUp{
    self.backgroundColor = [UIColor whiteColor];
    
    //修复时间标题
    UILabel *repairTimeTitle = [[UILabel alloc] init];
    repairTimeTitle.textColor = CommonTextColor;
    repairTimeTitle.font = CommonTextFont;
    [repairTimeTitle sizeToFit];
    self.repairTimeTitle = repairTimeTitle;
    [self addSubview:repairTimeTitle];
    //开始时间
    TimPickerTextField *startTime = [[TimPickerTextField alloc] init];
    startTime.placeholder = @"起始时间";
    startTime.text = [MyDateTool getMonthBeginWith:[NSDate date]];
    startTime.textAlignment = NSTextAlignmentCenter;
    startTime.textColor = CommonTextColor;
    startTime.font = [UIFont systemFontOfSize:15];
    startTime.layer.cornerRadius = 5;
    startTime.layer.masksToBounds = YES;
    startTime.layer.borderWidth = 1;
    startTime.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
    startTime.mode = TextFieldInputModeDatePicker;
    startTime.dateMode = TextFieldDateModeDate;
    startTime.isBirthDay = YES;
    startTime.clearButtonMode = UITextFieldViewModeNever;
    startTime.actiondelegate = self;
    self.startTime = startTime;
    [self addSubview:startTime];
    

    //结束时间
    TimPickerTextField *endTime = [[TimPickerTextField alloc] init];
    endTime.placeholder = @"终止时间";
    endTime.text = [MyDateTool stringWithDateNoTime:[NSDate date]];
    endTime.textColor = CommonTextColor;
    endTime.font = [UIFont systemFontOfSize:15];
    endTime.textAlignment = NSTextAlignmentCenter;
    endTime.layer.cornerRadius = 5;
    endTime.layer.masksToBounds = YES;
    endTime.layer.borderWidth = 1;
    endTime.mode = TextFieldInputModeDatePicker;
    endTime.dateMode = TextFieldDateModeDate;
    endTime.clearButtonMode = UITextFieldViewModeNever;
    endTime.isBirthDay = YES;
    endTime.actiondelegate = self;
    endTime.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
    self.endTime = endTime;
    [self addSubview:endTime];
    
    //分割线
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = [UIColor colorWithHex:0x333333];
    self.divider = divider;
    [self addSubview:divider];
    
    //查询按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"查询" forState:UIControlStateNormal];
    searchBtn.backgroundColor = [UIColor colorWithHex:0x00a0ea];
//    searchBtn.backgroundColor = [UIColor colorWithHex:0xdddddd];
    searchBtn.layer.cornerRadius = 5;
    searchBtn.layer.masksToBounds = YES;
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = CommonTextFont;
    self.searchBtn = searchBtn;
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:searchBtn];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat margin = 10;
    CGFloat commonH = 80;
    CGFloat dividerW = 10;
    CGFloat dividerH = 2;
    
    NSString *timeTitle;
    if ([self.type isEqualToString:PlantType]) {
        timeTitle = @"种植时间：";
    }else{
        timeTitle = @"修复时间：";
    }
    
    CGSize timeTitleSize = [timeTitle sizeWithFont:CommonTextFont];
    self.repairTimeTitle.frame = CGRectMake(margin, (commonH - timeTitleSize.height) / 2, timeTitleSize.width, timeTitleSize.height);
    self.repairTimeTitle.text = timeTitle;
    
    CGFloat filedW = (kScreenWidth - 3 * margin - timeTitleSize.width - dividerW) / 2;
    CGFloat fieldH = 40;
    
    self.startTime.frame = CGRectMake(self.repairTimeTitle.right, (commonH - fieldH) / 2, filedW, fieldH);
    
    self.divider.frame = CGRectMake(self.startTime.right + margin * .5, (commonH - dividerH) / 2, dividerW, dividerH);
    
    self.endTime.frame = CGRectMake(self.divider.right + margin * .5, (commonH - fieldH) / 2, filedW, fieldH);
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, commonH - 1, kScreenWidth, 1)];
    line1.backgroundColor = [UIColor colorWithHex:0xdddddd];
    [self addSubview:line1];
    
    CGFloat btnH = 40;
    CGFloat btnW = 200;
    CGFloat btnX = (kScreenWidth - btnW) / 2;
    CGFloat btnY;
    if ([self.type isEqualToString:RepairType]) {
        [self repairDoctorSuperView];
        btnY = _repairDoctorSuperView.bottom + (commonH - btnH) / 2;
    }else{
        btnY = line1.bottom + (commonH - btnH) / 2;
    }
    self.searchBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.searchBtn.bottom + (commonH - btnH) / 2 - 1, kScreenWidth, 1)];
    line2.backgroundColor = [UIColor colorWithHex:0xdddddd];
    [self addSubview:line2];
    
}

#pragma mark - 搜索按钮点击
- (void)searchBtnClick{
    if ([self.type isEqualToString:RepairType]) {
        //修复统计
        if ([self.repairDoctor.text isNotEmpty]) {
            if ([self.startTime.text isNotEmpty] && ![self.endTime.text isNotEmpty]) {
                [SVProgressHUD showImage:nil status:@"请选择终止时间"];
                return;
            }else if (![self.startTime.text isNotEmpty] && [self.endTime.text isNotEmpty]){
                [SVProgressHUD showImage:nil status:@"请选择起始时间"];
                return;
            }
        }else{
            if (![self.startTime.text isNotEmpty]) {
                [SVProgressHUD showImage:nil status:@"请输入起始时间"];
                return;
            }
            if (![self.endTime.text isNotEmpty]){
                [SVProgressHUD showImage:nil status:@"请输入终止时间"];
                return;
            }
        }
    }else{
        if (![self.startTime.text isNotEmpty]) {
            [SVProgressHUD showImage:nil status:@"请输入起始时间"];
            return;
        }
        if (![self.endTime.text isNotEmpty]){
            [SVProgressHUD showImage:nil status:@"请输入终止时间"];
            return;
        }
    }
    
    if ([self.startTime.text isNotEmpty] && [self.endTime.text isNotEmpty]) {
        //比较两个日期的大小
        NSComparisonResult result = [MyDateTool compareStartDateStr:self.startTime.text endDateStr:self.endTime.text];
        if (result == NSOrderedDescending) {
            [SVProgressHUD showImage:nil status:@"起始时间不能大于终止时间"];
            return;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(seniorStatisticsHeaderView:didSearchWithStartTime:endTime:repairDoctor:)]) {
        [self.delegate seniorStatisticsHeaderView:self didSearchWithStartTime:self.startTime.text endTime:self.endTime.text repairDoctor:self.selectDoc];
    }
    NSLog(@"查询");
}

#pragma mark - 选择修复医生
- (void)tapAction:(UITapGestureRecognizer *)tap{
    //跳转界面
//    XLRepairDoctorViewController *repairdoctorVC = [[XLRepairDoctorViewController alloc] init];
//    repairdoctorVC.delegate = self;
//    [self.viewController.navigationController pushViewController:repairdoctorVC animated:YES];
    
    //选择治疗医生
    XLDoctorLibraryViewController *docLibrary = [[XLDoctorLibraryViewController alloc] init];
    docLibrary.isTherapyDoctor = YES;
    docLibrary.delegate = self;
    [self.viewController.navigationController pushViewController:docLibrary animated:YES];
}

#pragma mark - XLDoctorLibraryViewControllerDelegate
- (void)doctorLibraryVc:(XLDoctorLibraryViewController *)doctorLibraryVc didSelectDoctor:(Doctor *)doctor{
    self.selectDoc = doctor;
    self.repairDoctor.text = doctor.doctor_name;
}

@end
