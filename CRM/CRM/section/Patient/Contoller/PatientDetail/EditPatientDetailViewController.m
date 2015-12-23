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

#define CommenBgColor MyColor(245, 246, 247)

@interface EditPatientDetailViewController ()<UITextFieldDelegate>

@property (nonatomic, strong)NSArray *dataList;
@property (nonatomic, strong)NSArray *contentList;

@end

@implementation EditPatientDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataList = @[@[@"姓名",@"电话",@"性别",@"年龄",@"身份证号",@"家庭住址"],@[@"过敏史",@"既往病史",@"备注"]];
    
    //设置导航栏
    [self initNavBar];
    
    //设置性别选择
    NSMutableArray *selectSexArray = [NSMutableArray arrayWithObjects:@"男",@"女" ,nil];
    self.patientGenderField.mode = TextFieldInputModePicker;
    self.patientGenderField.pickerDataSource = selectSexArray;
    self.patientGenderField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initView];
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
    self.patientGenderField.text = genderStr;
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
    self.title = @"患者详情";
    [self setRightBarButtonWithTitle:@"保存"];
    self.view.backgroundColor = CommenBgColor;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)onRightButtonAction:(id)sender{
    Patient *currentPatient = self.patient;
    currentPatient.patient_name = self.patientNameField.text;
    currentPatient.patient_age = self.patientAgeField.text;
    currentPatient.patient_gender = [self.patientGenderField.text isEqualToString: @"女"] ? @"0" : @"1";
    currentPatient.patient_address = self.patientAddressField.text;
    currentPatient.idCardNum = self.patientIdCardField.text;
    currentPatient.patient_phone = self.patientPhoneField.text;
    
    BOOL res = [[DBManager shareInstance] updatePatient:currentPatient];
    if (res) {
        [[DBManager shareInstance] updateUpdateDate:currentPatient.ckeyid];
        [SVProgressHUD showSuccessWithStatus:@"更新成功"];
        
        //将修改过的患者信息保存到数据库
//        NSArray *array = [[DBManager shareInstance] getAllEditNeedSyncPatient];
//        for (Patient *patient in array) {
//            InfoAutoSync *info = [[InfoAutoSync alloc] init];
//            info.data_type = AutoSync_Patient;
//            info.post_type = Update;
//            info.dataEntity = [patient.keyValues JSONString];
//            info.sync_status = @"0";
//            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
//        }
        
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
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    static NSString *ID = @"cell_id";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
//        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 43, kScreenWidth, 1)];
//        divider.backgroundColor = MyColor(206, 206, 206);
//        [cell.contentView addSubview:divider];
//        
//        cell.textLabel.font = [UIFont systemFontOfSize:13];
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
//        
//        if (indexPath.section == 0) {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            cell.textLabel.textColor = [UIColor grayColor];
//        }else{
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            cell.textLabel.textColor = [UIColor blackColor];
//        }
//    }
//    cell.textLabel.text = self.dataList[indexPath.section][indexPath.row];
//    cell.detailTextLabel.text = self.contentList[indexPath.section][indexPath.row];
//    
//    return cell;
//    
//}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            EditAllergyViewController *allergyVc = [[EditAllergyViewController alloc] init];
            allergyVc.title = @"过敏史";
            allergyVc.content = self.allergyLabel.text;
            allergyVc.type = EditAllergyViewControllerAllergy;
            allergyVc.patient = self.patient;
            [self pushViewController:allergyVc animated:YES];
        }else if(indexPath.row == 1){
            EditAllergyViewController *allergyVc = [[EditAllergyViewController alloc] init];
            allergyVc.title = @"既往病史";
            allergyVc.content = self.anamnesisLabel.text;
            allergyVc.type = EditAllergyViewControllerAnamnesis;
            allergyVc.patient = self.patient;
            [self pushViewController:allergyVc animated:YES];
        }else{
            EditAllergyViewController *allergyVc = [[EditAllergyViewController alloc] init];
            allergyVc.title = @"备注";
            allergyVc.content = self.patientRemarkLabel.text;
            allergyVc.type = EditAllergyViewControllerRemark;
            allergyVc.patient = self.patient;
            [self pushViewController:allergyVc animated:YES];
        }
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
