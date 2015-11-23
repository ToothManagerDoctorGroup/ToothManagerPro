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


@interface AddReminderViewController ()<HengYaDeleate,RuYaDelegate>{
    
    __weak IBOutlet UISwitch *weiXinSwitch;
    __weak IBOutlet UISwitch *duanXinSwitch;
}
@property (nonatomic,retain) HengYaViewController *hengYaVC;
@property (nonatomic,retain) RuYaViewController *ruYaVC;
@property (nonatomic,retain) NSMutableArray *clinicArray;
@property (nonatomic,retain) NSMutableArray *clinicIdArray;
@end

@implementation AddReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"保存"];
    self.title = @"添加新提醒";
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
    
    self.timeTextField.text = self.selectDateString;
    
    
    self.clinicArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.clinicIdArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    //这个主要来获取医院信息
    UserObject *userobj = [[AccountManager shareInstance] currentUser];
    [self refreshView];
    [[DoctorManager shareInstance] getDoctorListWithUserId:userobj.userid successBlock:^{

    } failedBlock:^(NSError *error) {
        
    }];
    


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
            
            [[DoctorManager shareInstance]clinicSeat:clinicId successBlock:^{
                
            } failedBlock:^(NSError *error){
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
        }
    }
}
- (void)doctorClinicFailedWithError:(NSError *)error{
    
}
-(void)clinicSeatSuccessWithResult:(NSDictionary *)result{
}
- (void)clinicSeatFailedWithError:(NSError *)error{
    
}
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    self.huanzheTextField.text = [LocalNotificationCenter shareInstance].yuyuePatient.patient_name;
}
- (void)onBackButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [LocalNotificationCenter shareInstance].yuyuePatient = nil;
}
//获取用户的医生列表
- (void)getDoctorListSuccessWithResult:(NSDictionary *)result {
    [SVProgressHUD dismiss];
    NSArray *dicArray = [result objectForKey:@"Result"];
    if (dicArray && dicArray.count > 0) {
        for (NSDictionary *dic in dicArray) {
            Doctor *tmpDoctor = [Doctor DoctorFromDoctorResult:dic];
            self.medicalPlaceTextField.text = tmpDoctor.doctor_hospital;
            
            [self.clinicArray addObject:tmpDoctor.doctor_hospital];
            
            [[DoctorManager shareInstance]doctorClinic:[AccountManager shareInstance].currentUser.userid successBlock:^{
                
            } failedBlock:^(NSError *error){
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
            
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
    LocalNotification *notification = [[LocalNotification alloc] init];
  //  notification.reserve_content = self.selectMatterTextField.text;
    notification.reserve_time = self.timeTextField.text;//[NSDate dateWithString:self.timeLabel.text];
  //  notification.reserve_type = self.repeatTimeTextField.text;
    
   // notification.reserve_content = self.repeatTimeTextField.text;
    notification.reserve_type = self.selectMatterTextField.text;
    notification.medical_place = self.medicalPlaceTextField.text;
    notification.medical_chair = self.medicalChairTextField.text;
    
    notification.patient_id = [LocalNotificationCenter shareInstance].selectPatient.ckeyid;
    
    if(self.ifNextReserve == YES){
        notification.patient_id = self.reservedPatiendId;
        
        BOOL ret = [[LocalNotificationCenter shareInstance] addLocalNotification:notification];
        if (ret) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [[DoctorManager shareInstance]weiXinMessagePatient:notification.patient_id fromDoctor:[AccountManager shareInstance].currentUser.userid withMessageType:self.selectMatterTextField.text withSendType:@"0" withSendTime:self.timeTextField.text successBlock:^{
            
        } failedBlock:^(NSError *error){
            [SVProgressHUD showImage:nil status:error.localizedDescription];
        }];
        return;
    }
    
    //微信消息推送打开
    if([weiXinSwitch isOn]){
        
    }
    //短信消息推送打开
    if([duanXinSwitch isOn]){
        [[DoctorManager shareInstance] yuYueMessagePatient:[LocalNotificationCenter shareInstance].yuyuePatient.ckeyid fromDoctor:[AccountManager shareInstance].currentUser.userid withMessageType:self.selectMatterTextField.text withSendType:@"1" withSendTime:self.timeTextField.text successBlock:^{
            
        } failedBlock:^(NSError *error){
            [SVProgressHUD showImage:nil status:error.localizedDescription];
        }];
    }
    
    BOOL ret = [[LocalNotificationCenter shareInstance] addLocalNotification:notification];
    if (ret) {
         [self.navigationController popViewControllerAnimated:YES];
    }

    [[DoctorManager shareInstance]weiXinMessagePatient:[LocalNotificationCenter shareInstance].selectPatient.ckeyid fromDoctor:[AccountManager shareInstance].currentUser.userid withMessageType:self.selectMatterTextField.text withSendType:@"0" withSendTime:self.timeTextField.text successBlock:^{
        
    } failedBlock:^(NSError *error){
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}

- (void)weiXinMessageSuccessWithResult:(NSDictionary *)result{
    
    NSString *str = [result objectForKey:@"Result"];
    NSRange range = [str rangeOfString:@"电话"];
    
    NSString *phoneStr = [str substringWithRange:NSMakeRange(range.location+2, 11)];
    
    
    
    if( [MFMessageComposeViewController canSendText] ){
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init]; //autorelease];
        
        
            controller.recipients = [NSArray arrayWithObject:phoneStr];
            controller.body = str;
            controller.messageComposeDelegate = self;
            
            [self presentModalViewController:controller animated:YES];
            
            [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"发送短信页面"];//修改短信界面标题
        }
    else{
        [self alertWithTitle:@"提示信息" msg:@"设备没有短信功能"];
    }
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
- (void)weiXinMessageFailedWithError:(NSError *)error{
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}
- (void)yuYueMessageSuccessWithResult:(NSDictionary *)result{
    
}
- (void)yuYueMessageFailedWithError:(NSError *)error{
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}
#pragma cellLineHidden - mark

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

#pragma tableView delegate - mark

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

-(void)removeHengYaVC{
    [self.hengYaVC willMoveToParentViewController:nil];
    [self.hengYaVC.view removeFromSuperview];
    [self.hengYaVC removeFromParentViewController];
}
-(void)queDingHengYa:(NSMutableArray *)hengYaArray{
    self.yaWeiTextField.text = [hengYaArray componentsJoinedByString:@","];
    [self removeHengYaVC];
}
-(void)queDingRuYa:(NSMutableArray *)ruYaArray{
    self.yaWeiTextField.text = [ruYaArray componentsJoinedByString:@","];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
