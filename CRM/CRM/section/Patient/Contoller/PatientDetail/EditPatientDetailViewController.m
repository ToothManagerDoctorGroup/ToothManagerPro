//
//  EditPatientDetailViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/14.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "EditPatientDetailViewController.h"
#import "DBManager+Patients.h"
#import "DBManager+sync.h"
#import "DBManager+AutoSync.h"
#import "DBTableMode.h"
#import "EditAllergyViewController.h"
#import "MJExtension.h"
#import "JSONKit.h"
#import "MyDateTool.h"
#import "XLDataSelectViewController.h"
#import "CRMMacro.h"
#import "XLCommonEditViewController.h"
#import "UIColor+Extension.h"


#define CommenBgColor MyColor(245, 246, 247)

@interface EditPatientDetailViewController ()<UITextFieldDelegate,EditAllergyViewControllerDelegate,XLDataSelectViewControllerDelegate,XLCommonEditViewControllerDelegate>

@property (nonatomic, strong)NSArray *contentList;//内容数组

@property (nonatomic, strong)NSMutableArray *orginExistGroups;//初始存在的分组
@property (nonatomic, strong)NSArray *curExistGroups;//编辑过后，选中的分组
@property (nonatomic, strong)NSArray *curDeleteGroups;//编辑过后，删除的分组

@end

@implementation EditPatientDetailViewController

- (NSMutableArray *)orginExistGroups{
    if (!_orginExistGroups) {
        _orginExistGroups = [NSMutableArray array];
    }
    return _orginExistGroups;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self initNavBar];
    
    //添加键盘监听事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];

}

- (void)keyBoardShow:(NSNotification *)noti{
    if ([self.patientAgeField isFirstResponder]) {
        self.patientAgeField.text = @"";
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.contentList = nil;
    [self.orginExistGroups removeAllObjects];
    self.orginExistGroups = nil;
    self.curExistGroups = nil;
}

- (void)initData{
    [super initData];
}

- (void)initView{
    [super initView];
    
    Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.patient.ckeyid];
    self.patient = patient;
    NSString *genderStr;
    if (![patient.patient_gender isEqualToString:@"2"]) {
        genderStr = [patient.patient_gender isEqualToString:@"0"]?@"女" : @"男";
    }else{
        genderStr = @"未知";
    }
    
    self.patientNameField.text = patient.patient_name;
    self.patientAgeField.text = [patient.patient_age intValue] == 0 ? @"" : patient.patient_age;
    self.patientGenderLabel.text = genderStr;
    self.patientAddressLabel.text = patient.patient_address;
    self.patientIdCardField.text = patient.idCardNum;
    self.patientPhoneField.text = patient.patient_phone;
    self.remarkNameLabel.text = patient.nickName;
    self.allergyLabel.text = patient.patient_allergy;
    self.anamnesisLabel.text = patient.anamnesis;
}

- (void)initNavBar{
    [super initView];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.title = @"修改患者信息";
    
    if (self.isGroup) {
        self.patientNameField.enabled = NO;
        self.patientAgeField.enabled = NO;
        self.patientGenderLabel.enabled = NO;
        self.patientAddressLabel.enabled = NO;
        self.patientIdCardField.enabled = NO;
        self.patientPhoneField.enabled = NO;
    }else{
        [self setRightBarButtonWithTitle:@"保存"];
    }
}
- (void)onBackButtonAction:(id)sender{
    __weak typeof(self) weakSelf = self;
    TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"提示" message:@"是否放弃此次编辑?" cancelHandler:^{} comfirmButtonHandlder:^{
        [weakSelf popViewControllerAnimated:YES];
    }];
    [alertView show];
}

- (void)onRightButtonAction:(id)sender{
    
    Patient *currentPatient = self.patient;
    currentPatient.patient_name = self.patientNameField.text;
    currentPatient.patient_age = [self.patientAgeField.text isEmpty] ? @"0" : self.patientAgeField.text;
    currentPatient.patient_gender = [self.patientGenderLabel.text isEqualToString: @"女"] ? @"0" : @"1";
    currentPatient.patient_address = self.patientAddressLabel.text;
    currentPatient.idCardNum = self.patientIdCardField.text;
    currentPatient.patient_phone = self.patientPhoneField.text;
    currentPatient.nickName = self.remarkNameLabel.text;
    currentPatient.patient_allergy = self.allergyLabel.text;
    currentPatient.anamnesis = self.anamnesisLabel.text;
    
    BOOL res = [[DBManager shareInstance] updatePatient:currentPatient];
    if (res) {
        [[DBManager shareInstance] updateUpdateDate:currentPatient.ckeyid];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PatientEditedNotification object:nil];
        [SVProgressHUD showSuccessWithStatus:@"更新成功"];
        
        //上传更新的患者信息
        InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Patient postType:Update dataEntity:[currentPatient.keyValues JSONString] syncStatus:@"0"];
        [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"更新失败"];
    }
    
    [self popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            [self jumpToEditPageWithTitle:@"姓名" placeHolder:@"请填写姓名" content:self.patientNameField.text showBtn:NO keyboardType:UIKeyboardTypeDefault];
        }else if (indexPath.row == 1){
            [self jumpToEditPageWithTitle:@"电话" placeHolder:@"请填写电话" content:self.patientPhoneField.text showBtn:NO keyboardType:UIKeyboardTypeNumberPad];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self jumpToEditPageWithTitle:@"备注名" placeHolder:@"请填写备注名" content:self.remarkNameLabel.text showBtn:NO keyboardType:UIKeyboardTypeDefault];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            XLDataSelectViewController *selectVc = [[XLDataSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
            selectVc.type = XLDataSelectViewControllerSex;
            selectVc.currentContent = self.patientGenderLabel.text;
            selectVc.delegate = self;
            [self pushViewController:selectVc animated:YES];
        }else if (indexPath.row == 1) {
            [self jumpToEditPageWithTitle:@"年龄" placeHolder:@"请填写年龄" content:self.patientAgeField.text showBtn:NO keyboardType:UIKeyboardTypeNumberPad];
        }
        else if (indexPath.row == 2){
            [self jumpToEditPageWithTitle:@"家庭住址" placeHolder:@"请填写详细地址" content:self.patientAddressLabel.text showBtn:YES keyboardType:UIKeyboardTypeDefault];
        }else if (indexPath.row == 3){
            [self jumpToEditPageWithTitle:@"身份证号" placeHolder:@"请填写身份证号" content:self.patientIdCardField.text showBtn:NO keyboardType:UIKeyboardTypeDefault];
        }
        
    }else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            EditAllergyViewController *allergyVc = [[EditAllergyViewController alloc] init];
            allergyVc.title = @"过敏史";
            allergyVc.content = self.allergyLabel.text;
            allergyVc.type = EditAllergyViewControllerAllergy;
            allergyVc.patient = self.patient;
            allergyVc.delegate = self;
            [self pushViewController:allergyVc animated:YES];
        }else if(indexPath.row == 1){
            EditAllergyViewController *allergyVc = [[EditAllergyViewController alloc] init];
            allergyVc.title = @"既往病史";
            allergyVc.content = self.anamnesisLabel.text;
            allergyVc.type = EditAllergyViewControllerAnamnesis;
            allergyVc.patient = self.patient;
            allergyVc.delegate = self;
            [self pushViewController:allergyVc animated:YES];
        }
    }
}
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (self.isGroup)
    {
        return nil;
    }
    return path;
}

#pragma mark - 跳转到编辑页面
- (void)jumpToEditPageWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder content:(NSString *)content showBtn:(BOOL)showBtn keyboardType:(UIKeyboardType)type{
    XLCommonEditViewController *editVc = [[XLCommonEditViewController alloc] init];
    editVc.title = title;
    editVc.placeHolder = placeHolder;
    editVc.delegate = self;
    editVc.content = content;
    editVc.rightButtonTitle = @"完成";
    editVc.showBtn = showBtn;
    editVc.keyboardType = type;
    [self pushViewController:editVc animated:YES];
}

#pragma mark - EditAllergyViewControllerDelegate
- (void)editViewController:(EditAllergyViewController *)editVc didEditWithContent:(NSString *)content type:(EditAllergyViewControllerType)type{
    if (type == EditAllergyViewControllerAllergy) {
        self.allergyLabel.text = content;
    }else if (type == EditAllergyViewControllerAnamnesis){
        self.anamnesisLabel.text = content;
    }else if (type == EditAllergyViewControllerNickName){
        self.remarkNameLabel.text = content;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - XLDataSelectViewControllerDelegate
- (void)dataSelectViewController:(XLDataSelectViewController *)dataVc didSelectContent:(NSString *)content type:(XLDataSelectViewControllerType)type{
    if (type == XLDataSelectViewControllerSex) {
        self.patientGenderLabel.text = content;
    }
}

#pragma mark - XLCommonEditViewControllerDelegate
- (void)commonEditViewController:(XLCommonEditViewController *)editVc content:(NSString *)content title:(NSString *)title{
    if ([title isEqualToString:@"姓名"]) {
        if ([title isEmpty]) {
            [SVProgressHUD showImage:nil status:@"姓名不能为空"];
            return;
        }
        ValidationResult result = [NSString isValidLength:content length:32];
        if (result == ValidationResultInValid) {
            [SVProgressHUD showImage:nil status:@"姓名过长，请重新输入"];
            return;
        }
        self.patientNameField.text = content;
    }else if ([title isEqualToString:@"电话"]){
        if (![NSString checkAllPhoneNumber:content]) {
            [SVProgressHUD showImage:nil status:@"电话号码无效，请重新输入"];
            return;
        }
        self.patientPhoneField.text = content;
    }else if ([title isEqualToString:@"备注名"]){
        ValidationResult result = [NSString isValidLength:content length:32];
        if (result == ValidationResultInValid) {
            [SVProgressHUD showImage:nil status:@"备注名过长，请重新输入"];
            return;
        }
        self.remarkNameLabel.text = content;
    }else if ([title isEqualToString:@"年龄"]){
        if (content.length > 0) {
            NSString *initial = [content substringToIndex:1];
            if ([content intValue] > 150 || [initial integerValue] == 0) {
                [SVProgressHUD showImage:nil status:@"年龄无效，请重新输入"];
                return;
            }
        }
        self.patientAgeField.text = content;
    }else if ([title isEqualToString:@"家庭住址"]){
        ValidationResult result = [NSString isValidLength:content length:100];
        if (result == ValidationResultInValid) {
            [SVProgressHUD showImage:nil status:@"家庭住址过长，请重新输入"];
            return;
        }
        self.patientAddressLabel.text = content;
    }else if ([title isEqualToString:@"身份证号"]){
        ValidationResult result = [NSString checkIDCard:content];
        if (result != ValidationResultValid) {
            [SVProgressHUD showImage:nil status:@"身份证号无效，请重新输入"];
        }
        self.patientIdCardField.text = content;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
