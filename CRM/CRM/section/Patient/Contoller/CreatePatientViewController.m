//
//  CreatePatientViewController.m
//  CRM
//
//  Created by mac on 14-5-16.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "CreatePatientViewController.h"
#import "DBManager+Introducer.h"
#import "DBManager+Patients.h"
#import "XLIntroducerViewController.h"
#import "PickerTextTableViewCell.h"
#import "CRMMacro.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "CRMHttpRequest+Sync.h"
#import "CreateCaseViewController.h"
#import "PatientsDisplayViewController.h"
#import "CRMHttpRequest+Introducer.h"
#import "DBManager+AutoSync.h"
#import "JSONKit.h"
#import "MJExtension.h"
#import "CRMUserDefalut.h"
#import "NSString+Conversion.h"
#import "PatientDetailViewController.h"
#import "PatientsCellMode.h"

@interface CreatePatientViewController () <UITextFieldDelegate,RequestIntroducerDelegate,XLIntroducerViewControllerDelegate,CreateCaseViewControllerDelegate>
{
    Introducer *selectIntroducer;
    Patient * patient;
}

@property (nonatomic,retain) NSArray *headerArray;

@end

@implementation CreatePatientViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -创建病历成功
- (void)createMedicalCaseSuccessAction:(NSNotification *)noti{
    //创建成功后，返回此界面时，直接返回添加病历界面
    [self popViewControllerAnimated:YES];
}

- (void)initView
{
    [super initView];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
//    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_complet"]];
    [self setRightBarButtonWithTitle:@"保存"];
    [self.tableView setAllowsSelection:NO];
    if (self.edit) {
        self.title = @"编辑患者";
    } else {
        self.title = @"手工录入患者";
    }
    
    self.nameTextField.mode = TextFieldInputModeKeyBoard;
    self.nameTextField.clearButtonMode = UITextFieldViewModeNever;
    self.introducerTextField.mode = TextFieldInputModeExternal;
    self.introducerTextField.delegate = self;
    self.introducerTextField.clearButtonMode = UITextFieldViewModeNever;
    self.phoneTextField.mode = TextFieldInputModeKeyBoard;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeNever;
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}
-(void)viewTapped{
    [self.nameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
}
- (void)initData
{
    [super initData];
    //创建患者
    if (self.patientId) {
        patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.patientId];
        selectIntroducer = [[DBManager shareInstance] getIntroducerByIntroducerID:patient.introducer_id];
        
        self.nameTextField.text = patient.patient_name;
        self.phoneTextField.text = patient.patient_phone;
        if (selectIntroducer != nil) {
            self.introducerTextField.text = selectIntroducer.intr_name;
        } else {
            
        }
    } else {
        patient = [[Patient alloc]init];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Button Action
- (void)onRightButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if(self.nameTextField.text.length == 0){
        [SVProgressHUD showImage:nil status:@"请输入患者姓名"];
        return;
    }
    if ([self.nameTextField.text charaterCount] > 32) {
        [SVProgressHUD showImage:nil status:@"患者姓名过长"];
        return;
    }
    
    if(self.phoneTextField.text.length == 0 || ![NSString checkAllPhoneNumber:self.phoneTextField.text]){
        [SVProgressHUD showImage:nil status:@"手机号无效，请重新输入"];
        return;
    }
    
    [_nameTextField resignFirstResponder];
    [_introducerTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
    
    patient.patient_name = self.nameTextField.text;
    patient.patient_phone = self.phoneTextField.text;
    patient.patient_age = @"0";
    patient.patient_gender = @"2";
    
    if (selectIntroducer && selectIntroducer.ckeyid) {
        patient.introducer_id = selectIntroducer.ckeyid;
    }
    
    if([[DBManager shareInstance] patientIsExist:patient]){
        [SVProgressHUD showImage:nil status:@"手机号已存在，请重新输入"];
        return;
    }
    
    if (![patient.patient_name isEmpty] && ![patient.patient_phone isEmpty]){
        NSString * message = nil;
        if ([[DBManager shareInstance] insertPatient:patient]) {
            
            Patient *tempPatient = [[DBManager shareInstance] getPatientCkeyid:patient.ckeyid];
            if (tempPatient != nil) {
                //添加自动同步信息
                InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Patient postType:Insert dataEntity:[tempPatient.keyValues JSONString] syncStatus:@"0"];
                [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
            }
            
            if (self.edit) {  //如果是编辑患者界面
                message = @"修改成功!";
                //通知患者信息被修改
                [self.view makeToast:message duration:1.0f position:@"Center"];
                [self postNotificationName:PatientEditedNotification object:nil];
                [self popViewControllerAnimated:YES];
            } else {
                //如果是创建患者界面
                message = @"新建患者成功";
                //周知各vc 创建了新患者
               [self postNotificationName:PatientCreatedNotification object:nil];
                
                if (selectIntroducer!= nil && self.introducerTextField.text.length > 0) {
                    //新建介绍人，添加到本地数据库同时保存自动同步信息
                    PatientIntroducerMap *map = [[PatientIntroducerMap alloc]init];
                    map.intr_id = selectIntroducer.ckeyid;
                    map.intr_source = @"B";
                    map.patient_id = patient.ckeyid;
                    map.doctor_id = [AccountManager shareInstance].currentUser.userid;
                    map.intr_time = [NSString currentDateString];
                    if([[DBManager shareInstance]insertPatientIntroducerMap:map]){
                        //获取患者介绍人信息
                        PatientIntroducerMap *tempMap = [[DBManager shareInstance] getPatientIntroducerMapByPatientId:map.patient_id doctorId:map.doctor_id intrId:map.intr_id];
                        if (tempMap != nil) {
                            //添加自动同步信息
                            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_PatientIntroducerMap postType:Insert dataEntity:[tempMap.keyValues JSONString] syncStatus:@"0"];
                            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                        }
                    }
                }
                
//                UIAlertView * alertview;
//                alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"再录一个" otherButtonTitles:@"返回",@"新建病历", nil];
//                [alertview show];
                //将患者插入手机通讯录
                [self savePatientPhontToAddressBook];
                
                //跳转到患者详细信息页面
                PatientDetailViewController *detailVc = [[PatientDetailViewController alloc] init];
                PatientsCellMode *model = [[PatientsCellMode alloc] init];
                model.patientId = patient.ckeyid;
                detailVc.patientsCellMode = model;
                detailVc.isNewPatient = YES;
                [self pushViewController:detailVc animated:YES];
            }
        } else {
            if (self.edit) {  //如果是编辑患者界面
                message = @"修改失败!";
            } else {
                //如果是创建患者界面
                message = @"新建患者失败";
            }
            [self.view makeToast:message duration:1.0f position:@"Center"];
        }
    } else {
        [self.view makeToast:@"请填入患者完整信息" duration:1.0f position:@"Center"];
    }
}

#pragma mark - Private API

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        //再建一个，清空当前文本框中的信息
        self.nameTextField.text = @"";
        self.introducerTextField.text = @"";
        self.phoneTextField.text = @"";
        patient = [[Patient alloc]init];
        
    }else if(buttonIndex == 1){
        //返回列表
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        //新建病例
        //由于patient的keyID是在数据库自增，所以，创建完之后必须要去数据库取最后一行数据的keyID作为当前新建患者的KeyID,【不能查数据库的count作为keyid，因为有可能不连续】
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
        CreateCaseViewController *caseVC = [storyboard instantiateViewControllerWithIdentifier:@"CreateCaseViewController"];
        caseVC.title = @"新建病历";
        caseVC.patiendId = patient.ckeyid;
        caseVC.delegate = self;
        caseVC.isNewPatient = YES;
        [self pushViewController:caseVC animated:YES];
    }
}

#pragma mark - CreateCaseViewControllerDelegate
- (void)didCancelCreateAction{
    [self popViewControllerAnimated:YES];
}

#pragma mark - FirstRespnder Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [_nameTextField resignFirstResponder];
    [_introducerTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
    
    XLIntroducerViewController *introducerVC = [[XLIntroducerViewController alloc] init];
    introducerVC.delegate = self;
    introducerVC.Mode = IntroducePersonViewSelect;
    
    [self pushViewController:introducerVC animated:YES];
    
    return false;
}

#pragma mark - IntroducePersonViewController Delegate
- (void)didSelectedIntroducer:(Introducer *)intro {
    selectIntroducer = nil;
    selectIntroducer = [Introducer intoducerFromIntro:intro];
    self.introducerTextField.text = selectIntroducer.intr_name;
}


- (void)insertPatientIntroducerMap{
    if(selectIntroducer!= nil && self.introducerTextField.text.length > 0){
        
        [[CRMHttpRequest shareInstance] postPatientIntroducerMap:patient.ckeyid withDoctorId:[AccountManager shareInstance].currentUser.userid withIntrId:selectIntroducer.ckeyid];
    }
}

-(void)postPatientIntroducerMapSuccess:(NSDictionary *)result{
    
    PatientIntroducerMap *map = [[PatientIntroducerMap alloc]init];
    map.intr_id = selectIntroducer.ckeyid;
    map.intr_source = @"B";
    map.patient_id = patient.ckeyid;
    map.doctor_id = [AccountManager shareInstance].currentUser.userid;
    map.intr_time = [NSString currentDateString];
    [[DBManager shareInstance]insertPatientIntroducerMap:map];
    //添加自动同步信息
    InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_PatientIntroducerMap postType:Insert dataEntity:[map.keyValues JSONString] syncStatus:@"0"];
    [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
    
}
-(void)postPatientIntroducerMapFailed:(NSError *)error{
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}


#pragma mark - 将新建的患者保存到通讯录
- (void)savePatientPhontToAddressBook{
    //判断设置里面的开关是否打开
    NSString *open = [CRMUserDefalut objectForKey:PatientToAddressBookKey];
    if (open == nil) {
        //默认开启
        open = Auto_Action_Open;
        [CRMUserDefalut setObject:open forKey:PatientToAddressBookKey];
    }
    
    if ([open isEqualToString:Auto_Action_Open]) {
        //把新建的患者倒入手机本地联系人
        // 初始化一个ABAddressBookRef对象，使用完之后需要进行释放，
        // 这里使用CFRelease进行释放
        // 相当于通讯录的一个引用
        ABAddressBookRef addressBook = ABAddressBookCreate();
        // 新建一个联系人
        // ABRecordRef是一个属性的集合，相当于通讯录中联系人的对象
        // 联系人对象的属性分为两种：
        // 只拥有唯一值的属性和多值的属性。
        // 唯一值的属性包括：姓氏、名字、生日等。
        // 多值的属性包括:电话号码、邮箱等。
        ABRecordRef person = ABPersonCreate();
        // 保存到联系人对象中，每个属性都对应一个宏，例如：kABPersonFirstNameProperty
        // 设置firstName属性
        NSString *nameStr = self.nameTextField.text;
        CFStringRef nameRef = (__bridge CFStringRef)nameStr;
        NSString *phoneStr = self.phoneTextField.text;
        CFStringRef phoneRef = (__bridge CFStringRef)phoneStr;
        
        
        ABRecordSetValue(person, kABPersonFirstNameProperty,nameRef, NULL);
        // ABMultiValueRef类似是Objective-C中的NSMutableDictionary
        // 添加电话号码与其对应的名称内容
        ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiPhone, phoneRef, kABPersonPhoneMainLabel, NULL);
        // 设置phone属性
        ABRecordSetValue(person, kABPersonPhoneProperty, multiPhone, NULL);
        // 释放该数组
        CFRelease(multiPhone);
        // 将新建的联系人添加到通讯录中
        ABAddressBookAddRecord(addressBook, person, NULL);
        // 保存通讯录数据
        ABAddressBookSave(addressBook, NULL);
        // 释放通讯录对象的引用
        if (addressBook) {
            CFRelease(addressBook);
        }
    }

}

@end
