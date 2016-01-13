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
#import "XLAddressMapViewController.h"
#import "MyDateTool.h"
#import "XLDataSelectViewController.h"

#define CommenBgColor MyColor(245, 246, 247)

@interface EditPatientDetailViewController ()<UITextFieldDelegate,EditAllergyViewControllerDelegate,XLDataSelectViewControllerDelegate>

@property (nonatomic, strong)NSArray *dataList;
@property (nonatomic, strong)NSArray *contentList;

@end

@implementation EditPatientDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataList = @[@[@"姓名",@"电话",@"性别",@"年龄",@"身份证号",@"家庭住址"],@[@"过敏史",@"既往病史",@"备注"]];
    
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
    self.patientAgeField.text = patient.patient_age;
    self.patientGenderLabel.text = genderStr;
    self.patientAddressField.text = patient.patient_address;
    self.patientIdCardField.text = patient.idCardNum;
    self.patientPhoneField.text = patient.patient_phone;
    self.patientRemarkLabel.text = patient.patient_remark;
    self.allergyLabel.text = patient.patient_allergy;
    self.anamnesisLabel.text = patient.anamnesis;
}

- (void)initNavBar{
    [super initView];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.title = @"患者信息";
    self.view.backgroundColor = CommenBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (self.isGroup) {
        self.patientNameField.enabled = NO;
        self.patientAgeField.enabled = NO;
        self.patientGenderLabel.enabled = NO;
        self.patientAddressField.enabled = NO;
        self.patientIdCardField.enabled = NO;
        self.patientPhoneField.enabled = NO;
    }else{
        [self setRightBarButtonWithTitle:@"保存"];
    }
}

- (void)onRightButtonAction:(id)sender{
    
    if (self.patientPhoneField.text.length != 11) {
        [SVProgressHUD showImage:nil status:@"电话号码无效，请重新输入"];
        return;
    }
    
    Patient *currentPatient = self.patient;
    currentPatient.patient_name = self.patientNameField.text;
    currentPatient.patient_age = self.patientAgeField.text;
    currentPatient.patient_gender = [self.patientGenderLabel.text isEqualToString: @"女"] ? @"0" : @"1";
    currentPatient.patient_address = self.patientAddressField.text;
    currentPatient.idCardNum = self.patientIdCardField.text;
    currentPatient.patient_phone = self.patientPhoneField.text;
    
    BOOL res = [[DBManager shareInstance] updatePatient:currentPatient];
    if (res) {
        [[DBManager shareInstance] updateUpdateDate:currentPatient.ckeyid];
        [SVProgressHUD showSuccessWithStatus:@"更新成功"];
        
        //将修改过的患者信息保存到数据库
        NSArray *array = [[DBManager shareInstance] getAllEditNeedSyncPatient];
        for (Patient *patient in array) {
            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Patient postType:Update dataEntity:[patient.keyValues JSONString] syncStatus:@"0"];
            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
        }
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"更新失败"];
    }
    [self popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 20;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.patientNameField isFirstResponder] || [self.patientPhoneField isFirstResponder] || [self.patientAgeField isFirstResponder] || [self.patientIdCardField isFirstResponder] || [self.patientAddressField isFirstResponder]) {
        [self.patientNameField resignFirstResponder];
        [self.patientPhoneField resignFirstResponder];
        [self.patientAgeField resignFirstResponder];
        [self.patientIdCardField resignFirstResponder];
        [self.patientAddressField resignFirstResponder];
    }else{
        if (indexPath.section == 0) {
            
            if (indexPath.row == 2) {
                XLDataSelectViewController *selectVc = [[XLDataSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
                selectVc.type = XLDataSelectViewControllerSex;
                selectVc.currentContent = self.patientGenderLabel.text;
                selectVc.delegate = self;
                [self pushViewController:selectVc animated:YES];
            }
            
        }else if (indexPath.section == 1) {
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
            }else{
                EditAllergyViewController *allergyVc = [[EditAllergyViewController alloc] init];
                allergyVc.title = @"备注";
                allergyVc.content = self.patientRemarkLabel.text;
                allergyVc.type = EditAllergyViewControllerRemark;
                allergyVc.patient = self.patient;
                allergyVc.delegate = self;
                [self pushViewController:allergyVc animated:YES];
            }
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

#pragma mark - EditAllergyViewControllerDelegate
- (void)editViewController:(EditAllergyViewController *)editVc didEditWithContent:(NSString *)content type:(EditAllergyViewControllerType)type{
    if (type == EditAllergyViewControllerAllergy) {
        self.allergyLabel.text = content;
    }else if (type == EditAllergyViewControllerAnamnesis){
        self.anamnesisLabel.text = content;
    }else if (type == EditAllergyViewControllerRemark){
        self.patientRemarkLabel.text = content;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)mapAction:(id)sender {
    if (self.isGroup) return;
    XLAddressMapViewController *addressVC = [[XLAddressMapViewController alloc] init];
    [self pushViewController:addressVC animated:YES];
}

#pragma mark - XLDataSelectViewControllerDelegate
- (void)dataSelectViewController:(XLDataSelectViewController *)dataVc didSelectContent:(NSString *)content type:(XLDataSelectViewControllerType)type{
    if (type == XLDataSelectViewControllerSex) {
        self.patientGenderLabel.text = content;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
