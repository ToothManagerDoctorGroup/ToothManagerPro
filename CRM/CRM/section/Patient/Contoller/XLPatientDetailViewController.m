//
//  XLPatientDetailViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/1.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLPatientDetailViewController.h"
#import "XLPatientDetailHeaderView.h"
#import "UIColor+Extension.h"
#import "CommonMacro.h"
#import "DBManager+Patients.h"
#import "MyPatientTool.h"
#import "CRMHttpRespondModel.h"
#import "MLKMenuPopover.h"
#import "XLMedicalButtonScrollView.h"
#import "XLPatientMedicalDetailView.h"
#import "MBProgressHUD.h"
#import "CustomAlertView.h"
#import "EditPatientDetailViewController.h"
#import "XLPatientAppointViewController.h"
#import "DBManager+Introducer.h"
#import "IntroducerManager.h"
#import "XLDoctorLibraryViewController.h"
#import "XLPatientTotalInfoModel.h"
#import "CRMHttpRequest+Sync.h"
#import "PatientManager.h"
#import "DBManager+Materials.h"
#import "XLTeamTool.h"
#import "XLTeamMemberParam.h"
#import "DBManager+AutoSync.h"
#import "JSONKit.h"
#import "MyDateTool.h"

#define CommenBgColor MyColor(245, 246, 247)
#define Margin 5

@interface XLPatientDetailViewController ()<UITableViewDataSource,UITableViewDelegate,MLKMenuPopoverDelegate,XLMedicalButtonScrollViewDelegate,CustomAlertViewDelegate>{
    
    UIView *_headerView; //头视图的背景视图
    XLPatientDetailHeaderView *_headerInfoView;//患者基本信息
    XLMedicalButtonScrollView *_buttonScrollView;//病历切换按钮
    XLPatientMedicalDetailView *_medicalDetailView;//病历详情视图
    UIButton *_addMedicalCaseButton;//添加病历按钮
}
@property (nonatomic,retain) Patient *detailPatient;//患者模型
@property (nonatomic, strong)NSArray *menuList;//菜单选项
@property (nonatomic, strong)MLKMenuPopover *menuPopover;//菜单弹出视图

@property (nonatomic, strong)NSArray *medicalCases;//病历数组
@end

@implementation XLPatientDetailViewController

#pragma mark - 懒加载
- (MLKMenuPopover *)menuPopover{
    if (!_menuPopover) {
        MLKMenuPopover *menuPopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake(kScreenWidth - 120 - 8, 64, 120, self.menuList.count * 44) menuItems:self.menuList];
        menuPopover.menuPopoverDelegate = self;
        _menuPopover = menuPopover;
    }
    return _menuPopover;
}

- (NSArray *)menuList{
    if (_menuList == nil) {
        _menuList = [NSArray arrayWithObjects:@"编辑患者",@"转诊患者",@"升为介绍人",@"下载CT片", nil];
    }
    return _menuList;
}

#pragma mark - 初次加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotificationObserver];
    //初始化导航栏样式
    [self setUpNavStyle];
    //初始化视图
    [self setUpViews];
    //初始化数据
    [self setUpData];
}

- (void)dealloc{
    [self removeNotificationObserver];
}
#pragma mark - 初始化
#pragma mark --初始化导航栏样式
- (void)setUpNavStyle{
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.title = @"患者详情";
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"patient_detail_menu"]];
}
#pragma mark --初始化视图
- (void)setUpViews{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (_headerInfoView == nil) {
        _headerInfoView = [[XLPatientDetailHeaderView alloc] init];
        _headerInfoView.frame = CGRectMake(0, 0, kScreenWidth, [_headerInfoView getTotalHeight]);
        _headerInfoView.backgroundColor = [UIColor whiteColor];
    }
    
    if (_addMedicalCaseButton == nil) {
        _addMedicalCaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addMedicalCaseButton.frame = CGRectMake(kScreenWidth - 5 - 100, _headerInfoView.bottom + 5, 100, 30);
        [_addMedicalCaseButton setTitle:@"新建病历" forState:UIControlStateNormal];
        [_addMedicalCaseButton setImage:[UIImage imageNamed:@"team_add-blue"] forState:UIControlStateNormal];
        [_addMedicalCaseButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [_addMedicalCaseButton setTitleColor:[UIColor colorWithHex:0x00a0ea] forState:UIControlStateNormal];
        _addMedicalCaseButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_addMedicalCaseButton addTarget:self action:@selector(addMedicalButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (_buttonScrollView == nil) {
        _buttonScrollView = [[XLMedicalButtonScrollView alloc] initWithFrame:CGRectMake(5, _headerInfoView.bottom, kScreenWidth - 5 * 2 - _addMedicalCaseButton.width, 40)];
        _buttonScrollView.medicalDelegate = self;
    }
    
    if (_medicalDetailView == nil) {
        _medicalDetailView = [[XLPatientMedicalDetailView alloc] initWithFrame:CGRectMake(5, _buttonScrollView.bottom, kScreenWidth - 10, 370)];
        _medicalDetailView.hidden = YES;
    }
    
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(_medicalDetailView.frame))];
        [_headerView addSubview:_headerInfoView];
        [_headerView addSubview:_addMedicalCaseButton];
        [_headerView addSubview:_buttonScrollView];
        [_headerView addSubview:_medicalDetailView];
    }
    
    
    //设置表示图的头视图
    self.tableView.tableHeaderView = _headerView;
}
#pragma mark --初始化数据
- (void)setUpData{
    
    _detailPatient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.patientsCellMode.patientId];
    if (_detailPatient == nil) {
        [SVProgressHUD showImage:nil status:@"患者不存在"];
        return;
    }
    self.medicalCases = [[DBManager shareInstance] getMedicalCaseArrayWithPatientId:_detailPatient.ckeyid];
    _buttonScrollView.medicalCases = self.medicalCases;
    if (self.medicalCases.count > 0) {
        _medicalDetailView.hidden = NO;
        _medicalDetailView.medicalCase = self.medicalCases[0];
        
        //查询团队下成员
        MedicalCase *mCase = self.medicalCases[0];
        [self queryTeamMemberByCaseId:mCase.ckeyid];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreshView];
}

#pragma mark - 刷新数据
- (void)refreshView {
    [super refreshView];
    self.detailPatient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.patientsCellMode.patientId];
    //获取患者绑定微信的状态
    [MyPatientTool getWeixinStatusWithPatientId:self.detailPatient.ckeyid success:^(CRMHttpRespondModel *respondModel) {
        if ([respondModel.result isEqualToString:@"1"]) {
            //绑定
            _headerInfoView.isWeixin = YES;
        }else{
            //未绑定
            _headerInfoView.isWeixin = NO;
        }
        
    } failure:^(NSError *error) {
        //未绑定
        _headerInfoView.isWeixin = NO;
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
    _headerInfoView.detailPatient = self.detailPatient;
}

- (void)refreshData {
    [super refreshData];
    self.medicalCases = [[DBManager shareInstance] getMedicalCaseArrayWithPatientId:_detailPatient.ckeyid];
    _buttonScrollView.medicalCases = self.medicalCases;
    if (self.medicalCases.count > 0) {
        _medicalDetailView.hidden = NO;
        _medicalDetailView.medicalCase = self.medicalCases[0];
    }
}
#pragma mark -导航栏菜单按钮点击事件
- (void)onRightButtonAction:(id)sender{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self.menuPopover showInView:keyWindow];
}

#pragma mark - MLKMenuPopoverDelegate
- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [self.menuPopover dismissMenuPopover];
    
    if (selectedIndex == 0) {
        //编辑患者
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        EditPatientDetailViewController *editDetail = [storyboard instantiateViewControllerWithIdentifier:@"EditPatientDetailViewController"];
        editDetail.patient = self.detailPatient;
        [self pushViewController:editDetail animated:YES];
        
    }else if(selectedIndex == 1){
        //转诊患者
        [self referralAction:nil];
    }else if(selectedIndex == 2){
        TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"提醒" message:@"是否将患者升级为介绍人?" cancelHandler:^{
        } comfirmButtonHandlder:^{
            //判断当前介绍人是否存在
            if([[DBManager shareInstance] isInIntroducerTable:_detailPatient.patient_phone]){
                [SVProgressHUD showImage:nil status:@"介绍人已存在，不能重复转换"];
            }else{
                
                [[IntroducerManager shareInstance] patientToIntroducer:[AccountManager shareInstance].currentUser.userid withCkeyId:_detailPatient.ckeyid withName:_detailPatient.patient_name withPhone:_detailPatient.patient_phone successBlock:^{
                    [SVProgressHUD showWithStatus:@"正在转换..."];
                }failedBlock:^(NSError *error){
                    [SVProgressHUD showImage:nil status:error.localizedDescription];
                }];
            }
        }];
        [alertView show];
        
    }else if (selectedIndex == 3){
        //更新当前患者的所有数据
        [SVProgressHUD showWithStatus:@"正在下载CT片"];
        [MyPatientTool getPatientAllInfosWithPatientId:self.detailPatient.ckeyid doctorID:[AccountManager currentUserid] success:^(CRMHttpRespondModel *respond) {
            if ([respond.code integerValue] == 200) {
                NSMutableArray *arrayM = [NSMutableArray array];
                for (NSDictionary *dic in respond.result) {
                    XLPatientTotalInfoModel *model = [XLPatientTotalInfoModel objectWithKeyValues:dic];
                    [arrayM addObject:model];
                }
                //保存数据到数据库
                [self savePatientDataWithModel:[arrayM lastObject]];
            }else{
                [SVProgressHUD showErrorWithStatus:respond.result];
            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"患者CT片更新失败"];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
}
#pragma mark - 保存所有的患者数据到数据库
- (void)savePatientDataWithModel:(XLPatientTotalInfoModel *)model{
    
    NSInteger total = 1 + model.medicalCase.count + model.medicalCourse.count + model.cT.count + model.consultation.count + model.expense.count + model.introducerMap.count;
    NSInteger current = 0;
    //保存患者消息
    Patient *patient = [Patient PatientFromPatientResult:model.baseInfo];
    [[DBManager shareInstance] insertPatient:patient];
    //稍后条件判断是否成功的代码
    if([[DBManager shareInstance] insertPatientBySync:patient]){
        current++;
    };
    
    //判断medicalCase数据是否存在
    if (model.medicalCase.count > 0) {
        //保存病历数据
        for (NSDictionary *dic in model.medicalCase) {
            MedicalCase *medicalCase = [MedicalCase MedicalCaseFromPatientMedicalCase:dic];
            if([[DBManager shareInstance] insertMedicalCase:medicalCase]){
                current++;
            };
        }
        
    }
    //判断medicalCourse数据是否存在
    if (model.medicalCourse.count > 0) {
        for (NSDictionary *dic in model.medicalCourse) {
            MedicalRecord *medicalrecord = [MedicalRecord MRFromMRResult:dic];
            if([[DBManager shareInstance] insertMedicalRecord:medicalrecord]){
                current++;
            }
        }
    }
    
    //判断CT数据是否存在
    if (model.cT.count > 0) {
        for (NSDictionary *dic in model.cT) {
            CTLib *ctlib = [CTLib CTLibFromCTLibResult:dic];
            if([[DBManager shareInstance] insertCTLib:ctlib]){
                current++;
            }
            if ([ctlib.ct_image isNotEmpty]) {
                NSString *urlImage = [NSString stringWithFormat:@"%@%@_%@", ImageDown, ctlib.ckeyid, ctlib.ct_image];
                
                UIImage *image = [self getImageFromURL:urlImage];
                
                if (nil != image) {
                    [PatientManager pathImageSaveToDisk:image withKey:ctlib.ct_image];
                }
            }
        }
    }
    
    //判断consultation数据是否存在
    if (model.consultation.count > 0) {
        for (NSDictionary *dic in model.consultation) {
            PatientConsultation *patientC = [PatientConsultation PCFromPCResult:dic];
            if([[DBManager shareInstance] insertPatientConsultation:patientC]){
                current++;
            }
        }
    }
    
    //判断expense数据是否存在
    if (model.expense.count > 0) {
        for (NSDictionary *dic in model.expense) {
            MedicalExpense *medicalexpense = [MedicalExpense MEFromMEResult:dic];
            if([[DBManager shareInstance] insertMedicalExpenseWith:medicalexpense]){
                current++;
            }
        }
    }
    
    //判断introducerMap数据是否存在
    if (model.introducerMap.count > 0) {
        for (NSDictionary *dic in model.introducerMap) {
            PatientIntroducerMap *map = [PatientIntroducerMap PIFromMIResult:dic];
            if ([[DBManager shareInstance] insertPatientIntroducerMap:map]) {
                current++;
            }
        }
    }
    if (total == current) {
        [SVProgressHUD dismiss];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"患者CT片下载失败"];
    }
}
//获取图片
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}
//转诊患者
- (void)referralAction:(id)sender {
    XLDoctorLibraryViewController *doctorVC = [[XLDoctorLibraryViewController alloc] init];
    if (self.detailPatient != nil) {
        doctorVC.isTransfer = YES;
        doctorVC.userId = self.detailPatient.doctor_id;
        doctorVC.patientId = self.detailPatient.ckeyid;
        [self pushViewController:doctorVC animated:YES];
    }
}

#pragma mark - XLMedicalButtonScrollViewDelegate
- (void)medicalButtonScrollView:(XLMedicalButtonScrollView *)scrollView didSelectButtonWithIndex:(NSUInteger)index{
    MedicalCase *mCase = self.medicalCases[index];
    //切换病历
    _medicalDetailView.medicalCase = mCase;
    
    //查询团队成员
    [self queryTeamMemberByCaseId:mCase.ckeyid];
    
}

#pragma mark - 查询团队成员
- (void)queryTeamMemberByCaseId:(NSString *)caseId{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_medicalDetailView animated:YES];
    [XLTeamTool queryMedicalCaseMembersWithCaseId:caseId success:^(NSArray *result) {
        [hud hideAnimated:YES];
        if (result.count == 0) {
            _medicalDetailView.memberNum = 0;
        }else{
            _medicalDetailView.memberNum = result.count;
        }
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - 添加病历按钮点击
- (void)addMedicalButtonClick{
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithAlertTitle:@"新建病历" cancleTitle:@"取消" certainTitle:@"保存"];
    alertView.type = CustomAlertViewTextField;
    alertView.placeHolder = @"请输入病历名称";
    alertView.delegate = self;
    [alertView show];
}
#pragma mark - CustomAlertViewDelegate
- (void)alertView:(CustomAlertView *)alertView didClickCertainButtonWithContent:(NSString *)content{
    if (![content isNotEmpty]) {
        [SVProgressHUD showErrorWithStatus:@"病历名称不能为空"];
        return;
    }
    //创建病历
    MedicalCase *mCase = [[MedicalCase alloc] init];
    mCase.case_name = content;
    mCase.patient_id = self.detailPatient.ckeyid;
    mCase.case_status = 1;
    mCase.implant_time = @"";
    mCase.next_reserve_time = @"";
    mCase.repair_time = @"";
    mCase.creation_date = [MyDateTool stringWithDateWithSec:[NSDate date]];
    
    [SVProgressHUD showWithStatus:@"正在创建"];
    [XLTeamTool addMedicalCaseWithMCase:mCase success:^(MedicalCase *resultCase) {
        [SVProgressHUD showSuccessWithStatus:@"创建成功"];
        [[DBManager shareInstance] insertMedicalCase:resultCase];
        
        self.medicalCases = [[DBManager shareInstance] getMedicalCaseArrayWithPatientId:_detailPatient.ckeyid];
        //刷新当前数据
        _buttonScrollView.medicalCases = self.medicalCases;
        _medicalDetailView.hidden = NO;
        _medicalDetailView.medicalCase = [self.medicalCases firstObject];
        [self queryTeamMemberByCaseId:[[self.medicalCases firstObject] ckeyid]];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"创建失败"];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - 通知
- (void)addNotificationObserver{
    [self addObserveNotificationWithName:TeamMemberAddSuccessNotification];
    [self addObserveNotificationWithName:TeamMemberDeleteSuccessNotification];
}

- (void)removeNotificationObserver{
    [self removeObserverNotificationWithName:TeamMemberAddSuccessNotification];
    [self removeObserverNotificationWithName:TeamMemberDeleteSuccessNotification];
}

- (void)handNotification:(NSNotification *)notifacation{
    if ([notifacation.name isEqualToString:TeamMemberAddSuccessNotification] || [notifacation.name isEqualToString:TeamMemberDeleteSuccessNotification]) {
        //移除成员后
        NSString *case_id = notifacation.object;
        [self queryTeamMemberByCaseId:case_id];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
