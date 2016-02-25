//
//  IntroPeopleDetailViewController.m
//  CRM
//
//  Created by fankejun on 14-5-13.
//  Copyright (c) 2014年 mifeo. All rights reserved.
//

#import "IntroPeopleDetailViewController.h"
#import "PeopleInfoCell.h"
#import "CRMMacro.h"
#import "CreateIntroducerViewController.h"
#import "DBManager+Introducer.h"
#import "DBManager+Patients.h"
#import "PatientsCellMode.h"
#import "PatientsTableViewCell.h"
#import "DBManager+Materials.h"
#import "IntroDetailHeaderTableViewController.h"
#import "TimStarTextField.h"
#import "SVProgressHUD.h"
#import "PatientInfoViewController.h"
#import "DBManager+Doctor.h"
#import "PatientDetailViewController.h"
#import "XLStarView.h"

#import "MJExtension.h"
#import "JSONKit.h"
#import "DBManager+AutoSync.h"
#import "XLStarSelectViewController.h"

@interface IntroPeopleDetailViewController ()<IntroDetailHeaderTableViewControllerDelegate,XLStarSelectViewControllerDelegate>

@property (nonatomic,retain) NSMutableArray *patientCellModeArray;
@property (nonatomic,retain) IntroDetailHeaderTableViewController *tbheaderView;

@end

@implementation IntroPeopleDetailViewController
@synthesize infoArray,introducer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNotificationObserver];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGer)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}
-(void)tapGer{
    [_tbheaderView.nameTextField resignFirstResponder];
//    [_tbheaderView.levelTextField resignFirstResponder];
    [_tbheaderView.phoneTextField resignFirstResponder];
}
- (void)initView {
    [super initView];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self loadTableView];
}

- (void)refreshView {
    [super refreshView];
    _tbheaderView.nameTextField.text = introducer.intr_name;
//    _tbheaderView.levelTextField.starLevel = introducer.intr_level;
    _tbheaderView.levelView.level = introducer.intr_level;
    _tbheaderView.phoneTextField.text = introducer.intr_phone;
    _tbheaderView.ckeyId = introducer.ckeyid;
    [myTableView reloadData];
}

- (void)initData
{
    [super initData];
    
  //  patientArray = [[DBManager shareInstance] getPatientByIntroducerId:self.introducer.ckeyid];
    
   
    patientArray = [[DBManager shareInstance] getPatientByIntroducerId:self.introducer.ckeyid];
    
    
    _patientCellModeArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < patientArray.count; i++) {
        Patient *patientTmp = [patientArray objectAtIndex:i];
        PatientsCellMode *cellMode = [[PatientsCellMode alloc]init];
        cellMode.patientId = patientTmp.ckeyid;
        cellMode.introducerId = patientTmp.introducer_id;
        cellMode.name = patientTmp.patient_name;
        cellMode.phone = patientTmp.patient_phone;
        cellMode.introducerName = [[DBManager shareInstance] getIntroducerByIntroducerID:patientTmp.introducer_id].intr_name;
        cellMode.statusStr = [Patient statusStrWithIntegerStatus:patientTmp.patient_status];
        cellMode.countMaterial = [[DBManager shareInstance] numberMaterialsExpenseWithPatientId:patientTmp.ckeyid];
        [_patientCellModeArray addObject:cellMode];
    }
}

- (void)refreshData {
    [super refreshData];
    introducer = [[DBManager shareInstance] getIntroducerByIntroducerID:introducer.ckeyid];
    patientArray = [[DBManager shareInstance] getPatientByIntroducerId:self.introducer.ckeyid];
    [_patientCellModeArray removeAllObjects];
    for (NSInteger i = 0; i < patientArray.count; i++) {
        Patient *patientTmp = [patientArray objectAtIndex:i];
        PatientsCellMode *cellMode = [[PatientsCellMode alloc]init];
        cellMode.patientId = patientTmp.ckeyid;
        cellMode.introducerId = patientTmp.introducer_id;
        cellMode.name = patientTmp.patient_name;
        cellMode.phone = patientTmp.patient_phone;
        cellMode.introducerName = [[DBManager shareInstance] getIntroducerByIntroducerID:patientTmp.introducer_id].intr_name;
        cellMode.statusStr = [Patient statusStrWithIntegerStatus:patientTmp.patient_status];
        cellMode.countMaterial = [[DBManager shareInstance] numberMaterialsExpenseWithPatientId:patientTmp.ckeyid];
        [_patientCellModeArray addObject:cellMode];
    }
}

- (void)dealloc {
    [self removeNotificationObserver];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.isEdit) {
        [self.tbheaderView.nameTextField becomeFirstResponder];
    }
}

#pragma mark - Private API
- (void)loadTableView
{
    myTableView = [[UITableView alloc]init];
    [myTableView setFrame:CGRectMake(0,90,kScreenWidth,kScreenHeight - 64 - 90)];
    myTableView.backgroundColor = [UIColor whiteColor];
    [myTableView setDelegate:self];
    [myTableView setDataSource:self];
    //去掉多余的cell
    myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:myTableView];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Introducer" bundle:nil];
    _tbheaderView = [storyboard instantiateViewControllerWithIdentifier:@"IntroDetailHeaderTableViewController"];
    _tbheaderView.delegate = self;
    _tbheaderView.view.frame = CGRectMake(0, 0, kScreenWidth,90);
    [self.view addSubview:_tbheaderView.view];
    
    if (self.isEdit) {
        //编辑模式
//        [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_complet"]];
        [self setRightBarButtonWithTitle:@"保存"];
        myTableView.hidden = YES;
         self.title = @"编辑介绍人";
    }else{
        _tbheaderView.nameTextField.enabled = NO;
        _tbheaderView.levelView.enabled = NO;
        _tbheaderView.phoneTextField.enabled = NO;
        [self setRightBarButtonWithImage:[UIImage imageNamed:@"material_bianji_white"]];
         self.title = @"介绍人详情";
    }
    
    [self refreshView];
}

#pragma mark - Button Action
- (void)onRightButtonAction:(id)sender {
    
    if (!self.isEdit) {
        //编辑状态
        IntroPeopleDetailViewController * detailCtl = [[IntroPeopleDetailViewController alloc]init];
        [detailCtl setIntroducer:introducer];
        detailCtl.hidesBottomBarWhenPushed = YES;
        detailCtl.isEdit = YES;
        [self pushViewController:detailCtl animated:YES];
        return;
    }
    [self.tbheaderView.nameTextField resignFirstResponder];
    [self.tbheaderView.phoneTextField resignFirstResponder];
    self.introducer.intr_name = self.tbheaderView.nameTextField.text;
    self.introducer.intr_level = self.tbheaderView.levelView.level;
    self.introducer.intr_phone = self.tbheaderView.phoneTextField.text;
    BOOL ret = [[DBManager shareInstance] insertIntroducer:self.introducer];
    if (ret) {
        [SVProgressHUD showImage:nil status:@"修改成功"];
        //自动同步信息
        InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Introducer postType:Update dataEntity:[self.introducer.keyValues JSONString] syncStatus:@"0"];
        [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
        
        [self postNotificationName:IntroducerEditedNotification object:nil];
        
        [self popViewControllerAnimated:YES];
    } else {
        [SVProgressHUD showImage:nil status:@"修改失败"];
    }
}

- (void)callIntroducer:(UIButton *)sender
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",introducer.intr_phone]];
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

#pragma mark - Notification
- (void)addNotificationObserver {
    [super addNotificationObserver];
    [self addObserveNotificationWithName:IntroducerEditedNotification];
    [self addObserveNotificationWithName:PatientCreatedNotification];
    [self addObserveNotificationWithName:PatientEditedNotification];
    [self addObserveNotificationWithName:MedicalCaseCreatedNotification];
    [self addObserveNotificationWithName:MedicalCaseEditedNotification];
}

- (void)removeNotificationObserver {
    [super addNotificationObserver];
    [self removeObserverNotificationWithName:IntroducerEditedNotification];
    [self removeObserverNotificationWithName:PatientCreatedNotification];
    [self removeObserverNotificationWithName:PatientEditedNotification];
    [self removeObserverNotificationWithName:MedicalCaseCreatedNotification];
    [self removeObserverNotificationWithName:MedicalCaseEditedNotification];
}

- (void)handNotification:(NSNotification *)notifacation {
    [super handNotification:notifacation];
    if ([notifacation.name isEqualToString:IntroducerEditedNotification] ||
        [notifacation.name isEqualToString:PatientCreatedNotification]
        || [notifacation.name isEqualToString:PatientEditedNotification]
        || [notifacation.name isEqualToString:MedicalCaseCreatedNotification]
        || [notifacation.name isEqualToString:MedicalCaseEditedNotification]) {
        [self refreshData];
        [self refreshView];
    }
}

#pragma mark - UITableView Delegate
-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [patientArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat commonW = kScreenWidth / 4;
    CGFloat commonH = 40;
    
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 0, kScreenWidth, commonH);
    bgView.backgroundColor = [UIColor colorWithHex:VIEWCONTROLLER_BACKGROUNDCOLOR];
    
    UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nameButton setTitle:@"患者" forState:UIControlStateNormal];
    [nameButton setFrame:CGRectMake(0, 0, commonW, commonH)];
    [nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nameButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:nameButton];
    
    
    UIButton *statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [statusButton setTitle:@"状态" forState:UIControlStateNormal];
    [statusButton setFrame:CGRectMake(nameButton.right, 0, commonW, commonH)];
    [statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    statusButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:statusButton];
    
    UIButton *introducerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [introducerButton setTitle:@"介绍人" forState:UIControlStateNormal];
    [introducerButton setFrame:CGRectMake(statusButton.right, 0, commonW,commonH)];
    [introducerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    introducerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:introducerButton];
    
    UIButton *numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [numberButton setTitle:@"数量" forState:UIControlStateNormal];
    [numberButton setFrame:CGRectMake(introducerButton.right, 0, commonW, commonH)];
    [numberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    numberButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:numberButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHex:0xCCCCCC];
    [bgView addSubview:lineView];
    
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"PatientcellIdentifier";
    PatientsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PatientsTableViewCell" owner:nil options:nil] objectAtIndex:0];
        [tableView registerNib:[UINib nibWithNibName:@"PatientsTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    }
    
    //赋值,获取患者信息
    NSInteger row = [indexPath row];
    PatientsCellMode *cellMode = [_patientCellModeArray objectAtIndex:row];
    [cell configCellWithCellMode:cellMode];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PatientsCellMode *cellMode = [_patientCellModeArray objectAtIndex:indexPath.row];
    //跳转到新的患者详情页面
    PatientDetailViewController *detailVc = [[PatientDetailViewController alloc] init];
    detailVc.patientsCellMode = cellMode;
    [self pushViewController:detailVc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IntroDetailHeaderTableViewControllerDelegate
- (void)didClickStarView{
    XLStarSelectViewController *selectVc = [[XLStarSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
    selectVc.delegate = self;
    [self.navigationController pushViewController:selectVc animated:YES];
}

#pragma mark - XLStarSelectViewControllerDelegate
- (void)starSelectViewController:(XLStarSelectViewController *)starSelectVc didSelectLevel:(NSInteger)level{
    self.tbheaderView.levelView.level = level;
}

@end
