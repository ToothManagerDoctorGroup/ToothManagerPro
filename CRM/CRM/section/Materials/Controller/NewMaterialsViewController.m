//
//  NewMaterialsViewController.m
//  CRM
//
//  Created by mac on 14-5-12.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "NewMaterialsViewController.h"
#import "DBManager+Materials.h"
#import "PickerTextTableViewCell.h"
#import "CRMMacro.h"
#import "DBManager+Introducer.h"
#import "DBManager+Patients.h"
#import "PatientInfoViewController.h"
#import "JSONKit.h"
#import "MJExtension.h"
#import "DBManager+AutoSync.h"
#import "PatientDetailViewController.h"
#import "XLDataSelectViewController.h"


//TIMUIKIT_EXTERN NSString * const ITI;
//TIMUIKIT_EXTERN NSString * const DENTIS;
//TIMUIKIT_EXTERN NSString * const NuoBeiEr;
//TIMUIKIT_EXTERN NSString * const AoChiTai;
//TIMUIKIT_EXTERN NSString * const FeiYaDan;
//TIMUIKIT_EXTERN NSString * const MaterialStr;
//TIMUIKIT_EXTERN NSString * const OtherStr;

@interface NewMaterialsViewController () <TimPickerTextFieldDataSource,UITableViewDelegate,UITableViewDataSource,XLDataSelectViewControllerDelegate>
{
    NSMutableArray *patientCellModeArray;
}

@property (nonatomic,readonly) NSArray *materialTypeArray;
@property (nonatomic,readonly) Material *material;

@end

@implementation NewMaterialsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc{
    [self removeNotificationObserver];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //添加通知
    [self addNotificationObserver];
}

#pragma mark - 添加通知
- (void)addNotificationObserver{
    [self addObserveNotificationWithName:MaterialEditedNotification];
}

#pragma mark - 移除通知
- (void)removeNotificationObserver{
    [self removeObserverNotificationWithName:MaterialEditedNotification];
}

#pragma mark - 处理通知
- (void)handNotification:(NSNotification *)notifacation{
    if ([notifacation.name isEqualToString:MaterialEditedNotification]) {
        //刷新数据
        _material = [[DBManager shareInstance] getMaterialWithId:self.materialId];
        self.nameTextField.text = _material.mat_name;
        self.priceTextField.text = [NSString stringWithFormat:@"%d",(int)_material.mat_price];
        self.typeTextField.text = [Material typeStringWith:_material.mat_type];
    }
}

- (void)initView
{
    [super initView];
    
    self.view.backgroundColor = [UIColor colorWithHex:VIEWCONTROLLER_BACKGROUNDCOLOR];
    
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];

    self.nameTextField.mode = TextFieldInputModeKeyBoard;
    [self.nameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.nameTextField.clearButtonMode = UITextFieldViewModeNever;
    self.priceTextField.mode = TextFieldInputModeKeyBoard;
    [self.priceTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.priceTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.priceTextField.clearButtonMode = UITextFieldViewModeNever;
    self.typeTextField.mode = TextFieldInputModeExternal;
    self.typeTextField.clearButtonMode = UITextFieldViewModeNever;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
  //  patientCellModeArray = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
}

- (void)initData {
    [super initData];
    if (self.edit) {
        _material = [[DBManager shareInstance] getMaterialWithId:self.materialId];
        self.nameTextField.text = _material.mat_name;
        self.priceTextField.text = [NSString stringWithFormat:@"%d",(int)_material.mat_price];
        self.typeTextField.text = [Material typeStringWith:_material.mat_type];
        if (self.showPatients) {
            self.title = @"种植体详情";
            [self setRightBarButtonWithImage:[UIImage imageNamed:@"material_bianji_white"]];
            self.nameTextField.enabled = NO;
            self.priceTextField.enabled = NO;
            self.typeTextField.enabled = NO;
        }else{
            self.title = @"编辑种植体";
            self.tableView.hidden = YES;
            [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_complet"]];
        }
        
    } else {
        _material = [[Material alloc] init];
        self.tableView.hidden = YES;
        self.title = @"新建种植体";
        [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_complet"]];
    }
    
    
   NSArray *patientArray = [[DBManager shareInstance]getPatientByMaterialId:self.materialId];
    patientCellModeArray = [NSMutableArray arrayWithCapacity:0];
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
        [patientCellModeArray addObject:cellMode];
    }
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}
-(void)viewTapped{
    [self.nameTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.typeTextField resignFirstResponder];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //第一行进入编辑状态
   // [self.nameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action
- (void)onRightButtonAction:(id)sender {
    //判断是否是编辑状态
    if (self.showPatients) {
        //跳转到编辑页面
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        NewMaterialsViewController *meterialDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"NewMaterialsViewController"];
        meterialDetailVC.edit = YES;
        meterialDetailVC.showPatients = NO;
        meterialDetailVC.materialId = self.materialId;
        [self pushViewController:meterialDetailVC animated:YES];
    }else{
        //获取名称
        if ([self.nameTextField.text isNotEmpty]) {
            _material.mat_name = self.nameTextField.text;
        }
        //获取类型
        if ([self.priceTextField.text isNotEmpty]) {
            _material.mat_price = [self.priceTextField.text floatValue];
        }
        if ([self.typeTextField.text isNotEmpty]) {
            _material.mat_type = [Material typeIntegerWith:self.typeTextField.text];
        }
        if ([_material.mat_name isEmpty]) {
            //名称为空toast提示
            [self.view makeToast:@"材料名称不能为空！"];
        } else {
            if ([[DBManager shareInstance] insertMaterial:_material]) {
                if (self.edit) {
                    //自动同步信息
                    Material *tempMaterial = [[DBManager shareInstance] getMaterialWithId:_material.ckeyid];
                    InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Material postType:Update dataEntity:[tempMaterial.keyValues JSONString] syncStatus:@"0"];
                    [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                    
                    [self postNotificationName:MaterialEditedNotification object:nil];
                } else {
                    //获取材料信息
                    Material *tempMaterial = [[DBManager shareInstance] getMaterialWithId:_material.ckeyid];
                    if (tempMaterial != nil) {
                        //自动同步信息
                        InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Material postType:Insert dataEntity:[tempMaterial.keyValues JSONString] syncStatus:@"0"];
                        [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                        [self postNotificationName:MaterialCreatedNotification object:nil];
                    }
                    
                }
                [self popViewControllerAnimated:YES];
            } else {
                [self.view makeToast:@"创建失败"];
            }
        }
    }
}

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
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, kScreenWidth, 1)];
    label.backgroundColor = [UIColor colorWithHex:0xCCCCCC];
    [bgView addSubview:label];
    
    UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nameButton setTitle:@"姓名" forState:UIControlStateNormal];
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

#pragma mark - Notification
- (void)keyboardWillShow:(CGFloat)keyboardHeight{
    if ([self.typeTextField isFirstResponder]) {
        [self.typeTextField resignFirstResponder];
        
        XLDataSelectViewController *dataSelectVc = [[XLDataSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
        dataSelectVc.type = XLDataSelectViewControllerMaterialType;
        dataSelectVc.currentContent = self.typeTextField.text;
        dataSelectVc.delegate = self;
        [self pushViewController:dataSelectVc animated:YES];
    }
}

#pragma mark - XLDataSelectViewControllerDelegate
- (void)dataSelectViewController:(XLDataSelectViewController *)dataVc didSelectContent:(NSString *)content type:(XLDataSelectViewControllerType)type{
    self.typeTextField.text = content;
}

@end
