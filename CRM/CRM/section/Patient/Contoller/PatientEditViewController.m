//
//  PatientEditViewController.m
//  CRM
//
//  Created by lsz on 15/7/8.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "PatientEditViewController.h"
#import "PatientInfoHeaderViewController.h"
#import "DBTableMode.h"
#import "DBManager+Patients.h"
#import "DBManager+Introducer.h"
#import "PatientsCellMode.h"
#import "TimPickerTextField.h"
#import "XLIntroducerViewController.h"
#import "TimNavigationViewController.h"
#import "CreateCaseViewController.h"
#import "PatientCaseTableViewCell.h"
#import "TimAlertView.h"
#import "SVProgressHUD.h"
#import "SDImageCache.h"
#import "NSString+Conversion.h"
#import "CRMMacro.h"
#import "LocalNotificationCenter.h"
#import "IntroducerCellMode.h"
#import "DBManager+Doctor.h"
#import "PatientEditViewController.h"
#import "CRMHttpRequest+Introducer.h"

@interface PatientEditViewController ()<UITextFieldDelegate,XLIntroducerViewControllerDelegate>

@property (nonatomic,retain) Patient *detailPatient;
@property (nonatomic,retain) Introducer *detailIntroducer;
@property (nonatomic,retain) Introducer *changeIntroducer;
@property (nonatomic) NSString *originalIntroducerText;

@end

@implementation PatientEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"编辑患者";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
//    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_complet.png"]];
    [self setRightBarButtonWithTitle:@"保存"];
    
    self.patientNameTextField.mode = TextFieldInputModeKeyBoard;
    self.patientNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.patientNameTextField setBorderStyle:UITextBorderStyleNone];
    self.patientPhoneTextField.mode = TextFieldInputModeKeyBoard;
    [self.patientPhoneTextField setBorderStyle:UITextBorderStyleNone];
    self.patientPhoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.patientPhoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.introducerNameTextField.mode = TextFieldInputModeExternal;
    self.introducerNameTextField.delegate = self;
    self.introducerNameTextField.borderStyle = UITextBorderStyleNone;
    
    [self addNotificationObserver];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    PatientIntroducerMap *map = [[DBManager shareInstance]getPatientIntroducerMapByPatientId:self.detailPatient.ckeyid];
    
    if([map.intr_source rangeOfString:@"B"].location != NSNotFound){
        Introducer *introducer = [[DBManager shareInstance]getIntroducerByCkeyId:map.intr_id];
        self.introducerNameTextField.text = introducer.intr_name;
    }else{
        Introducer *introducer = [[DBManager shareInstance]getIntroducerByIntrid:map.intr_id];
        self.introducerNameTextField.text = introducer.intr_name;
    }
    /*
    if([map.intr_source containsString:@"B"]){
        Introducer *introducer = [[DBManager shareInstance]getIntroducerByCkeyId:map.intr_id];
        self.introducerNameTextField.text = introducer.intr_name;
    }else{
        Introducer *introducer = [[DBManager shareInstance]getIntroducerByIntrid:map.intr_id];
        self.introducerNameTextField.text = introducer.intr_name;
    }*/
    self.originalIntroducerText = self.introducerNameTextField.text;
    
}
-(void)viewTapped{
    [self.patientNameTextField resignFirstResponder];
    [self.patientPhoneTextField resignFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self refreshView];
}
- (void)updateIntroducerNameTextFieldState{
    //“介绍人”若在本地介绍人库里，则可修改。若为网络介绍人则不可修改。
    NSArray *introducerInfoArray = [[NSArray alloc]init];
    introducerInfoArray = [[DBManager shareInstance] getAllIntroducerWithPage:0];
    NSMutableArray *allIntroducerArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < introducerInfoArray.count; i++) {
        Introducer *introducerInfo = [introducerInfoArray objectAtIndex:i];
        [allIntroducerArray addObject:introducerInfo.intr_name];
    }
    if(![allIntroducerArray containsObject:_detailIntroducer.intr_name] && self.introducerNameTextField.text.length > 0){
        self.introducerNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.introducerNameTextField.enabled = NO;
    }
}
- (void)refreshView {
    [super refreshView];
    self.detailPatient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.patientsCellMode.patientId];
    self.patientNameTextField.text = self.detailPatient.patient_name;
    self.patientPhoneTextField.text = self.detailPatient.patient_phone;
    
    if(self.changeIntroducer != nil){
        self.detailIntroducer = self.changeIntroducer;
    }else{
        self.detailIntroducer = [[DBManager shareInstance] getIntroducerByIntroducerID:self.detailPatient.introducer_id];
    }
    /*
    if(_detailIntroducer.intr_name != nil){
        self.introducerNameTextField.text = _detailIntroducer.intr_name;
    }else{
        Doctor *doctor2 = [[DBManager shareInstance] getDoctorWithCkeyId:self.detailPatient.introducer_id];
        self.introducerNameTextField.text = doctor2.doctor_name;
    }*/
    
    

    
    [self updateIntroducerNameTextFieldState];
}
- (void)initData {
    [super initData];
    _detailPatient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.patientsCellMode.patientId];
    if (_detailPatient == nil) {
        [SVProgressHUD showImage:nil status:@"患者不存在"];
        return;
    }
    _detailIntroducer = [[DBManager shareInstance] getIntroducerByIntroducerID:_detailPatient.introducer_id];
    if (_detailIntroducer == nil && [_detailPatient.introducer_id isEqualToString:[AccountManager currentUserid]]) {
        _detailIntroducer = [[Introducer alloc] init];
        _detailIntroducer.intr_name = [AccountManager shareInstance].currentUser.name;
        _detailIntroducer.ckeyid = [AccountManager currentUserid];
    }
}
- (BOOL)getData {
    if ([NSString isEmptyString:self.patientNameTextField.text]) {
        [SVProgressHUD showImage:nil status:@"患者姓名不能为空"];
        return NO;
    }else{
        self.detailPatient.patient_name = self.patientNameTextField.text;
    }
    if ([NSString isEmptyString:self.introducerNameTextField.text]) {
        self.detailPatient.introducer_id = @"";
    } else if (self.detailIntroducer != nil && [NSString isNotEmptyString:self.detailIntroducer.ckeyid]) {
        self.detailPatient.introducer_id = self.detailIntroducer.ckeyid;
    }
    if ([NSString isEmptyString:self.patientPhoneTextField.text]) {
        self.detailPatient.patient_phone = @"";
    } else {
        if ([self.patientPhoneTextField.text hasPrefix:@"1"] && self.patientPhoneTextField.text.length == 11) {
            self.detailPatient.patient_phone = self.patientPhoneTextField.text;
        } else {
            [SVProgressHUD showImage:nil status:@"手机号码格式错误"];
            return NO;
        }
    }
    self.detailPatient.creation_date = [NSString currentDateString];
    return YES;
}
- (void)dealloc {
    [self removeNotificationObserver];
}
-(void)onRightButtonAction:(id)sender{
    BOOL ret =[self getData];
    if (ret == NO) {
        return;
    }
    ret = [[DBManager shareInstance] insertPatient:self.detailPatient];
    if (ret) {
        [SVProgressHUD showImage:nil status:@"保存成功"];
        [self postNotificationName:PatientEditedNotification object:nil];
        
        //如果改变了介绍人那一栏
        if(![self.originalIntroducerText isEqualToString:self.introducerNameTextField.text]){
            [[CRMHttpRequest shareInstance]postPatientIntroducerMap:self.detailPatient.ckeyid withDoctorId:[AccountManager shareInstance].currentUser.userid withIntrId:self.changeIntroducer.ckeyid];
        }
        
    } else{
        [SVProgressHUD showImage:nil status:@"保存失败"];
    }
}

-(void)postPatientIntroducerMapSuccess:(NSDictionary *)result{
    
    PatientIntroducerMap *map = [[PatientIntroducerMap alloc]init];
    map.intr_id = self.changeIntroducer.ckeyid;
    map.intr_source = @"B";
    map.patient_id = self.detailPatient.ckeyid;
    map.doctor_id = [AccountManager shareInstance].currentUser.userid;
    map.intr_time = [NSString currentDateString];
    //如果介绍人那一栏从空变成有介绍人了，则插入
    if(![self.originalIntroducerText isNotEmpty]){
         [[DBManager shareInstance]insertPatientIntroducerMap:map];
    }else{
        [[DBManager shareInstance]updatePatientIntroducerMap:map];
    }
     [self popViewControllerAnimated:YES];
}
-(void)postPatientIntroducerMapFailed:(NSError *)error{
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}

#pragma mark - Notifications
- (void)keyboardWillShow:(CGFloat)keyboardHeight {
    if ([self.introducerNameTextField isFirstResponder]) {
        [self.introducerNameTextField resignFirstResponder];
        XLIntroducerViewController *introducerVC = [[XLIntroducerViewController alloc] init];
        introducerVC.Mode = IntroducePersonViewSelect;
        introducerVC.delegate = self;
        TimNavigationViewController *nav = [[TimNavigationViewController alloc]initWithRootViewController:introducerVC];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    } else {
        
    }
}
- (void)didSelectedIntroducer:(Introducer *)intro {
  //  self.detailIntroducer = [[DBManager shareInstance] getIntroducerByIntroducerID:intro.ckeyid];
 //   [self refreshView];
    
    self.changeIntroducer = intro;
    self.introducerNameTextField.text = intro.intr_name;
}
#pragma mark - NOtification
- (void)addNotificationObserver {
    [super addNotificationObserver];
  //  [self addObserveNotificationWithName:PatientTransferNotification];
}

- (void)removeNotificationObserver {
    [super removeNotificationObserver];
  //  [self removeObserverNotificationWithName:PatientTransferNotification];
}

- (void)handNotification:(NSNotification *)notifacation {
    [super handNotification:notifacation];
    if ([notifacation.name isEqualToString:MedicalCaseEditedNotification]
        || [notifacation.name isEqualToString:MedicalCaseEditedNotification]) {
        [self refreshData];
        [self refreshView];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.introducerNameTextField) {
        [self.patientPhoneTextField resignFirstResponder];
        [self.patientNameTextField resignFirstResponder];
    }
    return YES;
}
- (IBAction)tel:(id)sender {
    if(![NSString isEmptyString:self.patientPhoneTextField.text]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"是否拨打该电话" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 101;
        [alertView show];
    }else{
        [SVProgressHUD showImage:nil status:@"患者未留电话"];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 101){
        if(buttonIndex == 0){
            
        }else{
            NSString *number = self.patientPhoneTextField.text;
            NSString *num = [[NSString alloc]initWithFormat:@"tel://%@",number];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
