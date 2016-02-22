//
//  RepairDoctorDetailViewController.m
//  CRM
//
//  Created by doctor on 15/4/24.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "RepairDoctorDetailViewController.h"
#import "RepairDocHeaderTableViewController.h"
#import "RepairDocDetailTableViewCell.h"
#import "DBTableMode.h"
#import "DBManager+RepairDoctor.h"
#import "DBManager+Patients.h"
#import "DBManager+Materials.h"
#import "CRMMacro.h"
#import "PatientInfoViewController.h"

#import "MJExtension.h"
#import "JSONKit.h"
#import "DBManager+AutoSync.h"
#import "PatientDetailViewController.h"

@interface RepairDoctorDetailViewController ()

@property (nonatomic,retain) RepairDocHeaderTableViewController *tbheaderView;
@property (nonatomic,retain) RepairDoctor *doctor;
@property (nonatomic,retain) NSArray *patientsArray;
@property (nonatomic,retain) NSMutableArray *patientCellModeArray;

@property (nonatomic, strong)NSMutableArray *repairArray;//已修复数量
@property (nonatomic, strong)NSMutableArray *unrepairArray;//未修复数量

@end

@implementation RepairDoctorDetailViewController

- (NSMutableArray *)repairArray{
    if (!_repairArray) {
        _repairArray = [NSMutableArray array];
    }
    return _repairArray;
}

- (NSMutableArray *)unrepairArray{
    if (!_unrepairArray) {
        _unrepairArray = [NSMutableArray array];
    }
    return _unrepairArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修复医生详情";
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}
-(void)viewTapped{
    [_tbheaderView.phoneTextField resignFirstResponder];
    [_tbheaderView.nameTextField resignFirstResponder];
}
- (void)initView {
    [super initView];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_complet"]];
    [self loadTableView];
}

- (void)initData {
    [super initData];
    _doctor = [[DBManager shareInstance] getRepairDoctorWithCkeyId:_repairDoctorID];
    _patientsArray = [[DBManager shareInstance] getPatientByRepairDoctorId:_repairDoctorID];
    _patientCellModeArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < _patientsArray.count; i++) {
        Patient *patientTmp = [_patientsArray objectAtIndex:i];
        PatientsCellMode *cellMode = [[PatientsCellMode alloc]init];
        cellMode.patientId = patientTmp.ckeyid;
        cellMode.introducerId = patientTmp.introducer_id;
        cellMode.name = patientTmp.patient_name;
        cellMode.phone = patientTmp.patient_phone;
        cellMode.introducerName = [[DBManager shareInstance] getIntroducerByIntroducerID:patientTmp.introducer_id].intr_name;
        cellMode.statusStr = [Patient statusStrWithIntegerStatus:patientTmp.patient_status];
        cellMode.status = patientTmp.patient_status;
        cellMode.countMaterial = [[DBManager shareInstance] numberMaterialsExpenseWithPatientId:patientTmp.ckeyid];
        [_patientCellModeArray addObject:cellMode];
    }
    
    //计算已修复和未修复的数量
    [self.repairArray removeAllObjects];
    [self.unrepairArray removeAllObjects];
    for (PatientsCellMode *model in self.patientCellModeArray) {
        if (model.status == PatientStatusRepaired) {
            [self.repairArray addObject:model];
        }else{
            [self.unrepairArray addObject:model];
        }
    }

}

- (void)refreshView {
    [super refreshView];
    _tbheaderView.phoneTextField.text = _doctor.doctor_phone;
    _tbheaderView.nameTextField.text = _doctor.doctor_name;
    [myTableView reloadData];
}

- (void)onRightButtonAction:(id)sender {
    if ([NSString isEmptyString:_tbheaderView.nameTextField.text]) {
        [SVProgressHUD showImage:nil status:@"昵称不能为空"];
        return;
    }
    if ([NSString isEmptyString:_tbheaderView.phoneTextField.text]) {
        [SVProgressHUD showImage:nil status:@"电话不能为空"];
        return;
    }
    _doctor.doctor_name = _tbheaderView.nameTextField.text;
    _doctor.doctor_phone = _tbheaderView.phoneTextField.text;
    BOOL ret = [[DBManager shareInstance] updateRepairDoctor:_doctor];
    if (ret) {
        [SVProgressHUD showImage:nil status:@"保存成功"];
        //保存自动同步信息
        InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_RepairDoctor postType:Update dataEntity:[_doctor.keyValues JSONString] syncStatus:@"0"];
        [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
        
        [self postNotificationName:RepairDoctorEditedNotification object:nil];
    } else {
        [SVProgressHUD showImage:nil status:@"保存失败"];
    }
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
    myTableView.tableHeaderView = _tbheaderView.view;
    [self.view addSubview:myTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshView];
}

#pragma mark - UITableView Delegate
-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.patientCellModeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    superView.backgroundColor = MyColor(234, 234, 234);
    
    UIButton *repairedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    repairedButton.frame = CGRectMake(0, 0, kScreenWidth / 2, 40);
    repairedButton.titleLabel.font = [UIFont systemFontOfSize:15];
    NSString *repairStr;
    if (self.repairArray.count == 0) {
        repairStr = [NSString stringWithFormat:@"已修复患者（0）"];
    }else{
        repairStr = [NSString stringWithFormat:@"已修复患者（%lu）",(unsigned long)self.repairArray.count];
    }
    [repairedButton setTitle:repairStr forState:UIControlStateNormal];
    [repairedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [repairedButton addTarget:self action:@selector(repairBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:repairedButton];
    
    UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 10, 1, 20)];
    dividerView.backgroundColor = MyColor(188, 188, 188);
    [superView addSubview:dividerView];
    
    UIButton *unRepairedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    unRepairedButton.frame = CGRectMake(kScreenWidth / 2, 0, kScreenWidth / 2, 40);
    unRepairedButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [unRepairedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSString *unrepairStr;
    if (self.unrepairArray.count == 0) {
        unrepairStr = [NSString stringWithFormat:@"未修复患者（0）"];
    }else{
        unrepairStr = [NSString stringWithFormat:@"未修复患者（%lu）",(unsigned long)self.unrepairArray.count];
    }
    [unRepairedButton setTitle:unrepairStr forState:UIControlStateNormal];
    [unRepairedButton addTarget:self action:@selector(unrepairBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:unRepairedButton];
    
    return superView;
}

#pragma mark - 修复统计按钮点击
- (void)repairBtnClick{
    //清除当前数组中的所有数据
    [self.patientCellModeArray removeAllObjects];
    
    [self.patientCellModeArray addObjectsFromArray:self.repairArray];
    
    [myTableView reloadData];
}
#pragma mark - 未修复统计按钮点击
- (void)unrepairBtnClick{
    //清除当前数组中的所有数据
    [self.patientCellModeArray removeAllObjects];
    
    [self.patientCellModeArray addObjectsFromArray:self.unrepairArray];
    
    [myTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellIdentifier";
    PatientsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PatientsTableViewCell" owner:nil options:nil] objectAtIndex:0];//[[PatientsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
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
    [self pushViewController:detailVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
