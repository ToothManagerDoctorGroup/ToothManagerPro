//
//  XLMaterialDetailViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/18.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLMaterialDetailViewController.h"
#import "DBTableMode.h"
#import "DBManager+Materials.h"
#import "UIColor+Extension.h"
#import "DBManager+Doctor.h"
#import "PatientDetailViewController.h"
#import "NewMaterialsViewController.h"

@interface XLMaterialDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *patientCellModeArray;

@property (nonatomic, strong)Material *material;

@end

@implementation XLMaterialDetailViewController
@synthesize patientCellModeArray;

- (void)dealloc{
    [self removeNotificationObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加通知
    [self addNotificationObserver];
}

#pragma mark - 添加通知
- (void)addNotificationObserver{
    [self addObserveNotificationWithName:MaterialEditedNotification];
    [self addObserveNotificationWithName:UIKeyboardWillShowNotification];
}

#pragma mark - 移除通知
- (void)removeNotificationObserver{
    [self removeObserverNotificationWithName:MaterialEditedNotification];
    [self removeObserverNotificationWithName:UIKeyboardWillShowNotification];
}

#pragma mark - 处理通知
- (void)handNotification:(NSNotification *)notifacation{
    if ([notifacation.name isEqualToString:MaterialEditedNotification]) {
        //刷新数据
        _material = [[DBManager shareInstance] getMaterialWithId:self.materialId];
        self.nameLabel.text = _material.mat_name;
        self.priceLabel.text = [NSString stringWithFormat:@"%d",(int)_material.mat_price];
    }
}

- (void)onRightButtonAction:(id)sender{
    //跳转到编辑页面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    NewMaterialsViewController *meterialDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"NewMaterialsViewController"];
    meterialDetailVC.edit = YES;
    meterialDetailVC.showPatients = NO;
    meterialDetailVC.materialId = self.materialId;
    [self pushViewController:meterialDetailVC animated:YES];
}

- (void)initData{
    [super initData];
    
    _material = [[DBManager shareInstance] getMaterialWithId:self.materialId];
    
    NSArray *patientArray = [[DBManager shareInstance] getPatientByMaterialId:self.materialId];
    patientCellModeArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < patientArray.count; i++) {
        Patient *patientTmp = [patientArray objectAtIndex:i];
        PatientsCellMode *cellMode = [[PatientsCellMode alloc]init];
        cellMode.patientId = patientTmp.ckeyid;
        cellMode.introducerId = patientTmp.introducer_id;
        cellMode.name = patientTmp.patient_name;
//        if (patientTmp.nickName != nil && [patientTmp.nickName isNotEmpty]) {
//            cellMode.name = patientTmp.nickName;
//        }else{
//            cellMode.name = patientTmp.patient_name;
//        }
        cellMode.phone = patientTmp.patient_phone;
        cellMode.introducerName = patientTmp.intr_name;
        cellMode.statusStr = [Patient statusStrWithIntegerStatus:patientTmp.patient_status];
        cellMode.status = patientTmp.patient_status;
        cellMode.countMaterial = patientTmp.expense_num;
        Doctor *doc = [[DBManager shareInstance]getDoctorNameByPatientIntroducerMapWithPatientId:patientTmp.ckeyid withIntrId:[AccountManager currentUserid]];
        if ([doc.doctor_name isNotEmpty]) {
            cellMode.isTransfer = YES;
        }else{
            cellMode.isTransfer = NO;
        }
        [patientCellModeArray addObject:cellMode];
    }
}

- (void)initView{
    self.view.backgroundColor = [UIColor colorWithHex:VIEWCONTROLLER_BACKGROUNDCOLOR];
    self.title = @"种植体详情";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"material_bianji_white@3x"]];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    
    //设置显示的数据
    self.nameLabel.text = _material.mat_name;
    self.priceLabel.text = [NSString stringWithFormat:@"%d",(int)_material.mat_price];
}

#pragma mark - UITableViewDataSource/Delegate
#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//增加的表头
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat commonW = kScreenWidth / 4;
    CGFloat commonH = 40;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, commonH)];
    bgView.backgroundColor = MyColor(238, 238, 238);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 39.5, kScreenWidth, .5)];
    label.backgroundColor = [UIColor colorWithHex:0xCCCCCC];
    [bgView addSubview:label];
    
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
    [introducerButton setFrame:CGRectMake(statusButton.right, 0, commonW, commonH)];
    [introducerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    introducerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:introducerButton];
    
    UIButton *numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [numberButton setTitle:@"数量" forState:UIControlStateNormal];
    [numberButton setFrame:CGRectMake(introducerButton.right, 0, commonW, commonH)];
    [numberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    numberButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:numberButton];
    
    return bgView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return patientCellModeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellIdentifier";
    PatientsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PatientsTableViewCell" owner:nil options:nil] objectAtIndex:0];
        [tableView registerNib:[UINib nibWithNibName:@"PatientsTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    }
    
    //赋值,获取患者信息
    NSInteger row = [indexPath row];
    PatientsCellMode *cellMode;
    cellMode = [patientCellModeArray objectAtIndex:row];
    
    [cell configCellWithCellMode:cellMode];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PatientsCellMode *cellMode = [patientCellModeArray objectAtIndex:indexPath.row];
    //跳转到新的患者详情页面
    PatientDetailViewController *detailVc = [[PatientDetailViewController alloc] init];
    detailVc.patientsCellMode = cellMode;
    [self pushViewController:detailVc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
