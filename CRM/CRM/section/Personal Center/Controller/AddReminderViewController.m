//
//  AddReminderViewController.m
//  CRM
//
//  Created by doctor on 15/3/4.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "AddReminderViewController.h"
#import "LocalNotificationCenter.h"
#import "NSDate+Conversion.h"
#import "ScheduleReminderViewController.h"
#import "PatientInfoViewController.h"
#import "DoctorManager.h"
#import "AccountManager.h"
#import "CRMHttpRequest+Doctor.h"
#import "DBManager+Doctor.h"
#import "CreateCaseViewController.h"
#import <EventKit/EventKit.h>
#import "HengYaViewController.h"
#import "RuYaViewController.h"
#import "PatientsDisplayViewController.h"
#import "SelectYuYueDetailViewController.h"
#import "ChooseAssistViewController.h"
#import "ChooseMaterialViewController.h"

#import "MaterialCountModel.h"
#import "AssistCountModel.h"
#import "AssistModel.h"
#import "MaterialModel.h"
#import "MyBillTool.h"
#import "DBManager+Patients.h"
#import "CRMUserDefalut.h"
#import "MyPatientTool.h"
#import "CRMHttpRespondModel.h"
#import "NSDate+Conversion.h"

@interface AddReminderViewController ()<HengYaDeleate,RuYaDelegate,ChooseMaterialViewControllerDelegate,ChooseAssistViewControllerDelegate>{
    
    __weak IBOutlet UISwitch *weiXinSwitch;
    __weak IBOutlet UISwitch *duanXinSwitch;
}
@property (nonatomic,retain) HengYaViewController *hengYaVC;
@property (nonatomic,retain) RuYaViewController *ruYaVC;
@property (nonatomic,retain) NSMutableArray *clinicArray;
@property (nonatomic,retain) NSMutableArray *clinicIdArray;
@property (nonatomic,copy) NSString *originalClinic;
@property (nonatomic,assign) float durationFloat;
@property (nonatomic,copy) NSString *seatId;
@property (nonatomic,copy) NSString *seatPrice;

@property (nonatomic, copy)NSString *selectClinicId;//选中的诊所id

@property (nonatomic, strong)NSArray *chooseMaterials; //选中的耗材数组

@property (nonatomic, strong)NSArray *chooseAssists; //选中的助手数组

@property (nonatomic, strong)LocalNotification *currentNoti;//当前需要保存的预约对象

@end

@implementation AddReminderViewController

- (NSArray *)chooseAssists{
    if (!_chooseAssists) {
        _chooseAssists = [NSArray array];
    }
    return _chooseAssists;
}

- (NSArray *)chooseMaterials{
    if (!_chooseMaterials) {
        _chooseMaterials = [NSArray array];
    }
    return _chooseMaterials;
}

- (void)dealloc
{
    self.hengYaVC = nil;
    self.ruYaVC = nil;
    [self.clinicArray removeAllObjects];
    self.clinicArray = nil;
    [self.clinicIdArray removeAllObjects];
    self.clinicIdArray = nil;
    self.huanzheTextField.text = @"";
    NSLog(@"我被销毁了*********************");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"保存"];
    self.title = @"新增预约";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setExtraCellLineHidden:self.tableView];

    selectMatterArray = [NSArray arrayWithObjects:@"预约定方案",@"预约种植",@"预约拆线",@"预约取模",@"预约戴牙",@"根充",@"扩根",@"洗牙",@"补牙",@"拔牙",@"刮治",@"预约复查",@"预约修复",@"开会", nil];

    
    self.selectMatterTextField.text = [selectMatterArray objectAtIndex:0];
    self.selectMatterTextField.mode = TextFieldInputModePicker;
    self.selectMatterTextField.pickerDataSource = selectMatterArray;
    
  //  self.repeatTimeTextField.text = [selectRepeatArray objectAtIndex:0];
    self.yaWeiTextField.borderStyle = UITextBorderStyleNone;
  //  self.repeatTimeTextField.mode = TextFieldInputModePicker;
   // self.repeatTimeTextField.pickerDataSource = selectRepeatArray;
    self.yaWeiTextField.mode = TextFieldInputModeKeyBoard;
    [self.yaWeiTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    self.timeTextField.borderStyle = UITextBorderStyleNone;
    self.timeTextField.mode = TextFieldInputModeKeyBoard;
    [self.timeTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    self.huanzheTextField.borderStyle = UITextBorderStyleNone;
    self.huanzheTextField.mode = TextFieldInputModeKeyBoard;
    [self.huanzheTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    self.medicalChairTextField.mode = TextFieldInputModeKeyBoard;
    self.medicalChairTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.medicalChairTextField setBorderStyle:UITextBorderStyleNone];
    
    self.medicalPlaceTextField.mode = TextFieldInputModeKeyBoard;
    self.medicalPlaceTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.medicalPlaceTextField setBorderStyle:UITextBorderStyleNone];
    
    //如果是下次预约，设置患者的姓名
    if (self.isNextReserve) {
        self.patientArrowImageView.hidden = YES;
        self.huanzheTextField.enabled = NO;
        //查询数据库
        Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.medicalCase.patient_id];
        if (patient) {
            //设置当前文本框内的值
            self.huanzheTextField.text = patient.patient_name;
        }
        self.yaWeiTextField.text = self.medicalCase.case_name;
    }else if (self.isAddLocationToPatient){
        self.patientArrowImageView.hidden = YES;
        self.huanzheTextField.enabled = NO;
        if (self.patient) {
            self.huanzheTextField.text = self.patient.patient_name;
        }
    }
    
    self.clinicArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.clinicIdArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    //这个主要来获取医院信息
    UserObject *userobj = [[AccountManager shareInstance] currentUser];
    [[DoctorManager shareInstance] getDoctorListWithUserId:userobj.userid successBlock:^{
    } failedBlock:^(NSError *error) {
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yuYueTime:) name:@"YuYueTime" object:nil];
    
}
- (void)doctorClinicSuccessWithResult:(NSDictionary *)result{
    NSArray *dicArray = [result objectForKey:@"Result"];
    if (dicArray && dicArray.count > 0) {
        for(NSInteger i =0;i<[dicArray count];i++){
            NSDictionary *dic = dicArray[i];
            NSString *string = [dic objectForKey:@"clinic_name"];
            [self.clinicArray addObject:string];

            NSString *clinicId = [dic objectForKey:@"clinic_id"];
            [self.clinicIdArray addObject:clinicId];
        }
    }
}
- (void)doctorClinicFailedWithError:(NSError *)error{
    [SVProgressHUD showImage:nil status:@"预约诊所获取失败"];
}


-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    if (!self.isNextReserve && !self.isAddLocationToPatient) {
        self.huanzheTextField.text = [LocalNotificationCenter shareInstance].selectPatient.patient_name;
    }
    
}
-(void)yuYueTime:(NSNotification*)aNotification {
    NSDictionary *dic = [aNotification object];
    
    self.durationFloat = [[dic objectForKey:@"durationFloat"] floatValue];
    self.seatId = [dic objectForKey:@"seatId"];
    self.medicalPlaceTextField.text = [dic objectForKey:@"clinicName"];
    self.medicalChairTextField.text = [dic objectForKey:@"seatName"];
    self.seatPrice = [dic objectForKey:@"seatPrice"];
    self.timeTextField.text = [dic objectForKey:@"time"];
    self.timeDurationLabel.text = [dic objectForKey:@"duration"];
    
    if (dic[@"seatName"] == nil || [dic[@"seatName"] isEqualToString:@""]) {
        [SVProgressHUD showImage:nil status:@"当前医院没有椅位信息"];
    }
}
- (void)onBackButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [LocalNotificationCenter shareInstance].selectPatient = nil;
}
//获取用户的医生列表
- (void)getDoctorListSuccessWithResult:(NSDictionary *)result {
    [SVProgressHUD dismiss];
    NSArray *dicArray = [result objectForKey:@"Result"];
    if (dicArray && dicArray.count > 0) {
        for (NSDictionary *dic in dicArray) {
            Doctor *tmpDoctor = [Doctor DoctorFromDoctorResult:dic];
            self.medicalPlaceTextField.text = tmpDoctor.doctor_hospital;
            self.originalClinic = tmpDoctor.doctor_hospital;
            
            [self.clinicArray addObject:tmpDoctor.doctor_hospital];
            
            
            NSString *signKey = [NSString stringWithFormat:@"%@isSign",[[AccountManager shareInstance] currentUser].userid];
            if ([[CRMUserDefalut objectForKey:signKey] isEqualToString:@"1"]) {
                [[DoctorManager shareInstance] doctorClinic:[AccountManager shareInstance].currentUser.userid successBlock:^{
                    
                } failedBlock:^(NSError *error){
                    [SVProgressHUD showImage:nil status:error.localizedDescription];
                }];
            }
            return;
        }
    }
}
- (void)getDoctorListFailedWithError:(NSError *)error {
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}

- (void)onRightButtonAction:(id)sender {
    if(self.huanzheTextField.text.length == 0){
        [SVProgressHUD showImage:nil status:@"预约患者不能为空"];
        return;
    }
    if(self.timeTextField.text.length == 0){
        [SVProgressHUD showImage:nil status:@"预约时间不能为空"];
        return;
    }
    if (self.medicalPlaceTextField.text.length == 0) {
        [SVProgressHUD showImage:nil status:@"医院不能为空"];
        return;
    }
    
    NSString *clinicId = nil;
    for(NSInteger i =1;i<self.clinicArray.count;i++){
        if([self.medicalPlaceTextField.text isEqualToString:self.clinicArray[i]]){
            clinicId = [self.clinicIdArray objectAtIndex:i-1];
        }
    }
    
    LocalNotification *notification = [[LocalNotification alloc] init];
    notification.reserve_time = self.timeTextField.text;
    notification.reserve_type = self.selectMatterTextField.text;
    notification.medical_place = self.medicalPlaceTextField.text;
    notification.medical_chair = self.medicalChairTextField.text;
    notification.update_date = [NSString defaultDateString];
    
    notification.selected = YES;
    notification.tooth_position = self.yaWeiTextField.text;
    notification.clinic_reserve_id = @"1";
    notification.duration = [NSString stringWithFormat:@"%.1f",self.durationFloat];
    
    //判断是否是下一次预约
    NSString *patient_id;
    if (self.isNextReserve) {
        patient_id = self.medicalCase.patient_id;
    }else if(self.isAddLocationToPatient){
        patient_id = self.patient.ckeyid;
    }else{
        patient_id = [LocalNotificationCenter shareInstance].selectPatient.ckeyid;
    }
    notification.patient_id = patient_id;
    
    self.currentNoti = notification;
    
    BOOL ret = [[LocalNotificationCenter shareInstance] addLocalNotification:notification];
    
    //微信消息推送打开
    if([weiXinSwitch isOn]){
        [[DoctorManager shareInstance]weiXinMessagePatient:[LocalNotificationCenter shareInstance].selectPatient.ckeyid fromDoctor:[AccountManager shareInstance].currentUser.userid withMessageType:self.selectMatterTextField.text withSendType:@"0" withSendTime:self.timeTextField.text successBlock:^{
            
        } failedBlock:^(NSError *error){
            [SVProgressHUD showImage:nil status:error.localizedDescription];
        }];
    }
    //短信消息推送打开
    if([duanXinSwitch isOn]){
        [[DoctorManager shareInstance] yuYueMessagePatient:[LocalNotificationCenter shareInstance].yuyuePatient.ckeyid fromDoctor:[AccountManager shareInstance].currentUser.userid withMessageType:self.selectMatterTextField.text withSendType:@"1" withSendTime:self.timeTextField.text successBlock:^{
            
        } failedBlock:^(NSError *error){
            [SVProgressHUD showImage:nil status:error.localizedDescription];
        }];
    }
    
    //选择如果选择的不是自己的医院
    if(![self.medicalPlaceTextField.text isEqualToString:self.originalClinic]){
        if(patient_id == nil){
            [SVProgressHUD showErrorWithStatus:@"请先选择患者"];
            return;
        }
        if([AccountManager shareInstance].currentUser.userid == nil){
            [SVProgressHUD showErrorWithStatus:@"请登陆"];
            return;
        }
        //计算总的money
        float totalMoney = self.seatPrice.floatValue;
        //获取耗材的数组
        NSMutableArray *materialsArr = [NSMutableArray array];
        if (self.chooseMaterials.count > 0) {
            for (MaterialCountModel *countModel in self.chooseMaterials) {
                MaterialModel *material = [MaterialModel modelWithMaterialCountModel:countModel];
                
                [materialsArr addObject:material.keyValues];
                totalMoney = totalMoney + [material.actual_money floatValue];
            }
        }
        //获取助手的数组
        NSMutableArray *assistsArr = [NSMutableArray array];
        if (self.chooseAssists.count > 0) {
            for (AssistCountModel *countModel in self.chooseAssists) {
                AssistModel *assist = [AssistModel modelWithAssistCountModel:countModel];
                [assistsArr addObject:assist.keyValues];
                totalMoney = totalMoney + [assist.actual_money floatValue];
            }
        }
        [SVProgressHUD showWithStatus:@"正在预约"];
        //发送预约信息给服务器
        [MyPatientTool postAppointInfoTuiSongClinic:patient_id withClinicName:self.medicalPlaceTextField.text withCliniId:clinicId withDoctorId:[AccountManager shareInstance].currentUser.userid  withAppointTime:self.timeTextField.text withDuration:self.durationFloat withSeatPrice:self.seatPrice.floatValue withAppointMoney:totalMoney withAppointType:self.selectMatterTextField.text withSeatId:self.seatId withToothPosition:self.yaWeiTextField.text withAssist:assistsArr withMaterial:materialsArr success:^(CRMHttpRespondModel *respondModel) {
            [SVProgressHUD showSuccessWithStatus:@"预约成功"];
            //获取当前的返回结果
            NSNumber *clinic_reserve_id = respondModel.result;
            //修改clinic_reserve_id
            if (self.currentNoti) {
                self.currentNoti.clinic_reserve_id = [NSString stringWithFormat:@"%d",[clinic_reserve_id intValue]];
            }
            //更新当前保存的本地预约信息
            BOOL res = [[LocalNotificationCenter shareInstance] updateLocalNotification:self.currentNoti];
            if (res) {
                NSLog(@"预约更新成功");
            }else{
                NSLog(@"预约更新失败");
            }
            if (self.isNextReserve) {
                //调用代理方法
                if ([self.delegate respondsToSelector:@selector(addReminderViewController:didSelectDateTime:)]) {
                    [self.delegate addReminderViewController:self didSelectDateTime:self.timeTextField.text];
                }
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failure:^(NSError *error) {
            if (error) {
                //调用代理方法
                if (self.isNextReserve) {
                    //调用代理方法
                    if ([self.delegate respondsToSelector:@selector(addReminderViewController:didSelectDateTime:)]) {
                        [self.delegate addReminderViewController:self didSelectDateTime:self.timeTextField.text];
                    }
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                [SVProgressHUD showImage:nil status:@"预约失败"];
            }
        }];
    }else{
        //调用代理方法
        if (self.isNextReserve) {
            //调用代理方法
            if ([self.delegate respondsToSelector:@selector(addReminderViewController:didSelectDateTime:)]) {
                [self.delegate addReminderViewController:self didSelectDateTime:self.timeTextField.text];
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        if (ret) {
            [SVProgressHUD showSuccessWithStatus:@"本地预约保存成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"本地预约保存失败"];
        }
    }
}

- (void)weiXinMessageSuccessWithResult:(NSDictionary *)result{
    
}
- (void)weiXinMessageFailedWithError:(NSError *)error{
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}
- (void)yuYueMessageSuccessWithResult:(NSDictionary *)result{
    NSString *str = [result objectForKey:@"Result"];
    if( [MFMessageComposeViewController canSendText] ){
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init]; //autorelease];
        controller.recipients = [NSArray arrayWithObject:[LocalNotificationCenter shareInstance].selectPatient.patient_phone];
        controller.body = str;
        controller.messageComposeDelegate = self;
        
        [self presentModalViewController:controller animated:YES];
        
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"发送短信页面"];//修改短信界面标题
    }
    else{
        [self alertWithTitle:@"提示信息" msg:@"设备没有短信功能"];
    }
}
- (void)yuYueMessageFailedWithError:(NSError *)error{
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissModalViewControllerAnimated:NO];//关键的一句   不能为YES
    switch ( result ) {
        case MessageComposeResultCancelled:
            //  [self alertWithTitle:@"提示" msg:@"取消发送信息"];
            break;
        case MessageComposeResultFailed:// send failed
            //     [self alertWithTitle:@"提示" msg:@"发送信息成功"];
            break;
        case MessageComposeResultSent:
            //     [self alertWithTitle:@"提示" msg:@"发送信息失败"];
            break;
        default:
            break;
    }
}


- (void) alertWithTitle:(NSString *)title msg:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma cellLineHidden - mark

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

#pragma tableView delegate - mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 3;
            break;
            
        default:
            return 2;
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
        {
            break;
        }
            break;
        default:
        {
            NSLog(@"重复");
        }
            break;
    }
    
    UserObject *user = [[AccountManager shareInstance] currentUser];
        if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                if ([user.hospitalName isEqualToString:self.medicalPlaceTextField.text]) {
                    [SVProgressHUD showErrorWithStatus:@"您所在医院不能选择耗材！"];
                }else{
                    //获取当前选中的诊所id
                    for(NSInteger i = 1;i < self.clinicArray.count;i++){
                        if([self.medicalPlaceTextField.text isEqualToString:self.clinicArray[i]]){
                            self.selectClinicId = self.clinicIdArray[i - 1];
                        }
                    }
                    //选择耗材
                    ChooseMaterialViewController *materialVc = [[ChooseMaterialViewController alloc] init];
                    materialVc.hidesBottomBarWhenPushed = YES;
                    materialVc.clinicId = self.selectClinicId;
                    materialVc.delegate = self;
                    materialVc.chooseMaterials = self.chooseMaterials;
                    [self pushViewController:materialVc animated:YES];
                }
            }else{
                if ([user.hospitalName isEqualToString:self.medicalPlaceTextField.text]) {
                    [SVProgressHUD showErrorWithStatus:@"您所在医院不能选择助手！"];
                }else{
                    //获取当前选中的诊所id
                    for(NSInteger i = 1;i < self.clinicArray.count;i++){
                        if([self.medicalPlaceTextField.text isEqualToString:self.clinicArray[i]]){
                            self.selectClinicId = self.clinicIdArray[i - 1];
                        }
                    }
                    //选择助手
                    ChooseAssistViewController *assistVc = [[ChooseAssistViewController alloc] init];
                    assistVc.delegate = self;
                    assistVc.hidesBottomBarWhenPushed = YES;
                    assistVc.clinicId = self.selectClinicId;
                    assistVc.chooseAssists = self.chooseAssists;
                    [self pushViewController:assistVc animated:YES];
                }
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(CGFloat)keyboardHeight {
    static BOOL flag = NO;
    if (flag == YES || self.navigationController.topViewController != self) {
        return;
    }
    flag = YES;
    if ([self.yaWeiTextField isFirstResponder]){
        [self.yaWeiTextField resignFirstResponder];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
        self.hengYaVC = [storyboard instantiateViewControllerWithIdentifier:@"HengYaViewController"];
        self.hengYaVC.delegate = self;
        self.hengYaVC.hengYaString = self.yaWeiTextField.text;
        [self.navigationController addChildViewController:self.hengYaVC];
        [self.navigationController.view addSubview:self.hengYaVC.view];
    }else if ([self.huanzheTextField isFirstResponder]){
        [self.huanzheTextField resignFirstResponder];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        PatientsDisplayViewController *patientVC = [storyboard instantiateViewControllerWithIdentifier:@"PatientsDisplayViewController"];
        patientVC.patientStatus = PatientStatuspeAll;
        patientVC.isYuYuePush = YES;
        patientVC.hidesBottomBarWhenPushed = YES;
        [self pushViewController:patientVC animated:YES];
    }else if ([self.medicalChairTextField isFirstResponder] || [self.medicalPlaceTextField isFirstResponder] || [self.timeTextField isFirstResponder]){
        [self.medicalChairTextField resignFirstResponder];
        [self.medicalPlaceTextField resignFirstResponder];
        [self.timeTextField resignFirstResponder];
        SelectYuYueDetailViewController  *selectDateView = [[SelectYuYueDetailViewController alloc]init];
        selectDateView.clinicNameArray = self.clinicArray;
        selectDateView.clinicIdArray = self.clinicIdArray;
        [self pushViewController:selectDateView animated:YES];
    }
    flag = NO;
   
}

#pragma mark -HengYaDeleate

-(void)removeHengYaVC{
    [self.hengYaVC willMoveToParentViewController:nil];
    [self.hengYaVC.view removeFromSuperview];
    [self.hengYaVC removeFromParentViewController];
}

- (void)queDingHengYa:(NSMutableArray *)hengYaArray toothStr:(NSString *)toothStr{
    
    if ([toothStr isEqualToString:@"未连续"]) {
        self.yaWeiTextField.text = [hengYaArray componentsJoinedByString:@","];
    }else{
        self.yaWeiTextField.text = toothStr;
    }
    
    [self removeHengYaVC];
}

- (void)queDingRuYa:(NSMutableArray *)ruYaArray toothStr:(NSString *)toothStr{
    if ([toothStr isEqualToString:@"未连续"]) {
        self.yaWeiTextField.text = [ruYaArray componentsJoinedByString:@","];
    }else{
        self.yaWeiTextField.text = toothStr;
    }
    [self removeRuYaVC];
}

-(void)removeRuYaVC{
    [self.ruYaVC willMoveToParentViewController:nil];
    [self.ruYaVC.view removeFromSuperview];
    [self.ruYaVC removeFromParentViewController];
}
-(void)changeToRuYaVC{
    [self removeHengYaVC];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
    self.ruYaVC = [storyboard instantiateViewControllerWithIdentifier:@"RuYaViewController"];
    self.ruYaVC.delegate = self;
    self.ruYaVC.ruYaString = self.yaWeiTextField.text;
    [self.navigationController addChildViewController:self.ruYaVC];
    [self.navigationController.view addSubview:self.ruYaVC.view];
}
-(void)changeToHengYaVC{
    [self removeRuYaVC];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
    self.hengYaVC = [storyboard instantiateViewControllerWithIdentifier:@"HengYaViewController"];
    self.hengYaVC.delegate = self;
    self.hengYaVC.hengYaString = self.yaWeiTextField.text;
    [self.navigationController addChildViewController:self.hengYaVC];
    [self.navigationController.view addSubview:self.hengYaVC.view];
}
- (void)keyboardWillHidden:(CGFloat)keyboardHeight {

}


#pragma mark -ChooseMaterialViewControllerDelegate
- (void)chooseMaterialViewController:(ChooseMaterialViewController *)mController didSelectMaterials:(NSArray *)materials{
    self.chooseMaterials = materials;
    int total = 0;
    for (MaterialCountModel *model in materials) {
        total = total + (int)model.num;
    }
    if(total > 0){
        self.materialCountLabel.text = [NSString stringWithFormat:@"%d颗",total];
    }else{
        self.materialCountLabel.text = @"";
    }
    
}
#pragma mark -ChooseAssistViewControllerDelegate
- (void)chooseAssistViewController:(ChooseAssistViewController *)aController didSelectAssists:(NSArray *)assists{
    self.chooseAssists = assists;
    int total = 0;
    for (AssistCountModel *model in assists) {
        total = total + (int)model.num;
    }
    if (total > 0) {
        self.assistCountLabel.text = [NSString stringWithFormat:@"%d名",total];
    }else{
        self.assistCountLabel.text = @"";
    }
    
    
}
@end
