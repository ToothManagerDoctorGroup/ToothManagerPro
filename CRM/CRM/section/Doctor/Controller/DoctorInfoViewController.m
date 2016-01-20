//
//  DoctorInfoViewController.m
//  CRM
//
//  Created by TimTiger on 5/10/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "DoctorInfoViewController.h"
#import "RepairDocHeaderTableViewController.h"
#import "RepairDocDetailTableViewCell.h"
#import "DBTableMode.h"
#import "DBManager+RepairDoctor.h"
#import "DBManager+Patients.h"
#import "DBManager+Materials.h"
#import "CRMMacro.h"
#import "PatientInfoViewController.h"
#import "DBManager+Doctor.h"
#import "DBManager+Patients.h"
#import "UIImageView+WebCache.h"
#import "PatientDetailViewController.h"

@interface DoctorInfoViewController ()
@property (nonatomic,retain) RepairDocHeaderTableViewController *tbheaderView;
@property (nonatomic,retain) Doctor *doctor;
@property (nonatomic,retain) NSArray *patientsArray;
@property (nonatomic,retain) NSMutableArray *patientCellModeArray;
@end

@implementation DoctorInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"医生详情";
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
    [self loadTableView];
}

- (void)initData {
    [super initData];
    _doctor = [[DBManager shareInstance] getDoctorWithCkeyId:_repairDoctorID];
    _patientsArray = [[DBManager shareInstance] getAllPatientWithID:_repairDoctorID];
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
}

- (void)refreshView {
    [super refreshView];
    _tbheaderView.phoneTextField.text = _doctor.doctor_phone;
    _tbheaderView.nameTextField.text = _doctor.doctor_name;
    [_tbheaderView.iconImageView sd_setImageWithURL:[NSURL URLWithString:_doctor.doctor_image] placeholderImage:[UIImage imageNamed:@"user_icon"]];
    [myTableView reloadData];
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
    self.view.backgroundColor = [UIColor whiteColor];
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
//    [_tbheaderView.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/avatar/%@.jpg",DomainName,Method_His_Crm,_doctor.ckeyid]]];
    _tbheaderView.phoneTextField.enabled = NO;
    _tbheaderView.nameTextField.enabled = NO;
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
    return self.patientsArray.count;
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
    detailVc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:detailVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
