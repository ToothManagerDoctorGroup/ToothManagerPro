//
//  DoctorInfoViewController.m
//  CRM
//
//  Created by TimTiger on 5/10/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "DoctorInfoViewController.h"
#import "DBTableMode.h"
#import "DBManager+RepairDoctor.h"
#import "DBManager+Patients.h"
#import "DBManager+Materials.h"
#import "CRMMacro.h"
#import "DBManager+Doctor.h"
#import "DBManager+Patients.h"
#import "UIImageView+WebCache.h"
#import "PatientDetailViewController.h"
#import "XLSliderView.h"
#import "XLUserInfoViewController.h"
#import "RepairDocHeaderTableViewController.h"

#define TYPE_FROM @"from"
#define TYPE_TO @"to"
#define TYPE_REPAIR @"repair"

@interface DoctorInfoViewController ()<XLSliderViewDelegate>
@property (nonatomic,retain) RepairDocHeaderTableViewController *tbheaderView;
@property (nonatomic,retain) Doctor *doctor;
@property (nonatomic,retain) NSMutableArray *patientCellModeArray;

@property (nonatomic, strong)XLSliderView *sliderView;
@end

@implementation DoctorInfoViewController

- (NSMutableArray *)patientCellModeArray{
    if (!_patientCellModeArray) {
        _patientCellModeArray = [NSMutableArray array];
    }
    return _patientCellModeArray;
}

- (void)dealloc{
    self.doctor = nil;
    [self.patientCellModeArray removeAllObjects];
    self.patientCellModeArray = nil;
    self.sliderView = nil;
    self.tbheaderView = nil;
}

- (XLSliderView *)sliderView{
    if (!_sliderView) {
        _sliderView = [[XLSliderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
        _sliderView.backgroundColor = MyColor(238, 238, 238);
        NSInteger fromCount = [[DBManager shareInstance] getPatientCountWithID:self.repairDoctorID type:TYPE_FROM];
        NSInteger toCount = [[DBManager shareInstance] getPatientCountWithID:self.repairDoctorID type:TYPE_TO];
        NSInteger repairCount = [[DBManager shareInstance] getPatientCountWithID:self.repairDoctorID type:TYPE_REPAIR];
        NSString *fromStr = [NSString stringWithFormat:@"我转给他%ld人",(long)fromCount];
        NSString *toStr = [NSString stringWithFormat:@"他转给我%ld人",(long)toCount];
        NSString *repairStr = [NSString stringWithFormat:@"修复%ld人",(long)repairCount];
        _sliderView.sourceList = @[toStr,fromStr,repairStr];
        _sliderView.delegate = self;
    }
    return _sliderView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"医生详情";
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    //初始化子视图
    [self initSubViews];
    //请求数据
    [self requestLocalDataWithType:TYPE_TO];
    //请求头视图数据
    [self initHeaderViewData];
}
-(void)viewTapped{
    [_tbheaderView.phoneTextField resignFirstResponder];
    [_tbheaderView.nameTextField resignFirstResponder];
}
- (void)initSubViews {
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"详情"];
    [self loadTableView];
}

- (void)onRightButtonAction:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    XLUserInfoViewController *userInfoVc = [storyboard instantiateViewControllerWithIdentifier:@"XLUserInfoViewController"];
    userInfoVc.doctor = self.doctor;
    [self pushViewController:userInfoVc animated:YES];
}

- (void)requestLocalDataWithType:(NSString *)type{
    [self.patientCellModeArray removeAllObjects];
    NSArray *patientsArray;
    if ([type isEqualToString:TYPE_FROM]) {
        //表示我转出去的
        patientsArray = [[DBManager shareInstance] getAllPatientWIthID:self.repairDoctorID type:TYPE_FROM];
    }else if ([type isEqualToString:TYPE_TO]){
        //表示别人转给我的
        patientsArray = [[DBManager shareInstance] getAllPatientWIthID:self.repairDoctorID type:TYPE_TO];
    }else{
        //表示我修复的患者
        patientsArray = [[DBManager shareInstance] getAllPatientWIthID:self.repairDoctorID type:TYPE_REPAIR];
    }
    for (NSInteger i = 0; i < patientsArray.count; i++) {
        Patient *patientTmp = [patientsArray objectAtIndex:i];
        PatientsCellMode *cellMode = [[PatientsCellMode alloc]init];
        cellMode.patientId = patientTmp.ckeyid;
        cellMode.introducerId = patientTmp.introducer_id;
        cellMode.name = patientTmp.patient_name;
        cellMode.phone = patientTmp.patient_phone;
        cellMode.introducerName = patientTmp.intr_name;
        cellMode.statusStr = [Patient statusStrWithIntegerStatus:patientTmp.patient_status];
        cellMode.status = patientTmp.patient_status;
        //            cellMode.countMaterial = [[DBManager shareInstance] numberMaterialsExpenseWithPatientId:patientTmp.ckeyid];
        cellMode.countMaterial = patientTmp.expense_num;
        Doctor *doc = [[DBManager shareInstance]getDoctorNameByPatientIntroducerMapWithPatientId:patientTmp.ckeyid withIntrId:[AccountManager currentUserid]];
        if ([doc.doctor_name isNotEmpty]) {
            cellMode.isTransfer = YES;
        }else{
            cellMode.isTransfer = NO;
        }

        [self.patientCellModeArray addObject:cellMode];
    }
}

- (void)initHeaderViewData{

    _doctor = [[DBManager shareInstance] getDoctorWithCkeyId:self.repairDoctorID];
    _tbheaderView.phoneTextField.text = _doctor.doctor_phone;
    _tbheaderView.nameTextField.text = _doctor.doctor_name;
    [_tbheaderView.iconImageView sd_setImageWithURL:[NSURL URLWithString:_doctor.doctor_image] placeholderImage:[UIImage imageNamed:@"user_icon"]];
}

#pragma mark - Private API
- (void)loadTableView
{
    myTableView = [[UITableView alloc]init];
    [myTableView setFrame:CGRectMake(0,
                                     detailInfoView.frame.origin.y + detailInfoView.frame.size.height,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height - detailInfoView.frame.size.height)];
    myTableView.backgroundColor = [UIColor whiteColor];
    [myTableView setDelegate:self];
    [myTableView setDataSource:self];
    //去掉多余的cell
    myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RepairDoctor" bundle:nil];
    _tbheaderView = [storyboard instantiateViewControllerWithIdentifier:@"RepairDocHeaderTableViewController"];
    _tbheaderView.view.frame = CGRectMake(0, 0, self.view.bounds.size.width,88);
    _tbheaderView.phoneTextField.text = _doctor.doctor_phone;
    _tbheaderView.nameTextField.text = _doctor.doctor_name;
    [_tbheaderView.iconImageView sd_setImageWithURL:[NSURL URLWithString:_doctor.doctor_image] placeholderImage:[UIImage imageNamed:@"user_icon"]];
    _tbheaderView.phoneTextField.enabled = NO;
    _tbheaderView.nameTextField.enabled = NO;
    myTableView.tableHeaderView = _tbheaderView.view;
    [self.view addSubview:myTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self refreshView];
}

#pragma mark - UITableView Delegate
-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.patientCellModeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 52;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sliderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellIdentifier";
    PatientsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PatientsTableViewCell" owner:nil options:nil] objectAtIndex:0];
        [tableView registerNib:[UINib nibWithNibName:@"PatientsTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    }
    //赋值,获取患者信息
    NSInteger row = [indexPath row];
    PatientsCellMode *cellMode = [self.patientCellModeArray objectAtIndex:row];
    [cell configCellWithCellMode:cellMode];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PatientsCellMode *cellMode = [self.patientCellModeArray objectAtIndex:indexPath.row];
    //跳转到新的患者详情页面
    PatientDetailViewController *detailVc = [[PatientDetailViewController alloc] init];
    detailVc.patientsCellMode = cellMode;
    detailVc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:detailVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - XLSliderViewDelegate
- (void)sliderView:(XLSliderView *)sliderView didClickBtnFrom:(NSInteger)from to:(NSInteger)to{
    if (to == 0) {
        [self requestLocalDataWithType:TYPE_TO];
    }else if (to == 1){
        [self requestLocalDataWithType:TYPE_FROM];
    }else{
        [self requestLocalDataWithType:TYPE_REPAIR];
    }
    //重新请求数据进行显示
    [myTableView reloadData];
}


@end
