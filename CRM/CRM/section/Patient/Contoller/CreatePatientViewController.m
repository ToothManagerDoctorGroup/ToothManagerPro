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
#import "IntroducerViewController.h"
#import "PickerTextTableViewCell.h"
#import "CRMMacro.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "CRMHttpRequest+Sync.h"
#import "CreateCaseViewController.h"
#import "PatientsDisplayViewController.h"
#import "CRMHttpRequest+Introducer.h"


@interface CreatePatientViewController () <UITextFieldDelegate,IntroducePersonViewControllerDelegate,RequestIntroducerDelegate>
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createMedicalCaseSuccessAction:) name:@"CreateMedicalCaseSuccessNotification" object:nil];
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
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_complet"]];
    [self.tableView setAllowsSelection:NO];
    if (self.edit) {
        self.title = @"编辑患者";
    } else {
        self.title = @"新建患者";
    }
    
    self.nameTextField.mode = TextFieldInputModeKeyBoard;
    self.introducerTextField.mode = TextFieldInputModeExternal;
    self.introducerTextField.delegate = self;
    self.phoneTextField.mode = TextFieldInputModeKeyBoard;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    if (self.patientId > 0) {
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
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Action
- (void)onRightButtonAction:(id)sender {
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
    
    if (![patient.patient_name isEmpty] && ![patient.patient_phone isEmpty]){
        NSString * message = nil;
        if ([[DBManager shareInstance] insertPatient:patient]) {
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
                
                [self insertPatientIntroducerMap];
                
                [NSThread sleepForTimeInterval: 0.5];
                
                [[CRMHttpRequest shareInstance] postAllNeedSyncPatient:[NSArray arrayWithObjects:patient, nil]];
                
                
                UIAlertView * alertview;
                alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"返回列表" otherButtonTitles:@"新建病例", nil];
                [alertview show];
                [alertview setDelegate:self];
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
        //返回列表
        [self popViewControllerAnimated:YES];
    }else if(buttonIndex == 1){
        //新建病例
        //由于patient的keyID是在数据库自增，所以，创建完之后必须要去数据库取最后一行数据的keyID作为当前新建患者的KeyID,【不能查数据库的count作为keyid，因为有可能不连续】
        //    [[NSNotificationCenter defaultCenter] postNotificationName:MedicalCaseNeedCreateNotification object:patient];
    
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
        CreateCaseViewController *caseVC = [storyboard instantiateViewControllerWithIdentifier:@"CreateCaseViewController"];
        caseVC.title = @"新建病历";
        caseVC.patiendId = patient.ckeyid;
        [self pushViewController:caseVC animated:YES];
        
    }
}

#pragma mark - FirstRespnder Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [_nameTextField resignFirstResponder];
    [_introducerTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    IntroducerViewController *introducerVC = [storyboard instantiateViewControllerWithIdentifier:@"IntroducerViewController"];
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
        
        [[CRMHttpRequest shareInstance]postPatientIntroducerMap:patient.ckeyid withDoctorId:[AccountManager shareInstance].currentUser.userid withIntrId:selectIntroducer.ckeyid];
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
}
-(void)postPatientIntroducerMapFailed:(NSError *)error{
        [SVProgressHUD showImage:nil status:error.localizedDescription];
}

@end
