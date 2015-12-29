//
//  XLAddReminderViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/21.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLAddReminderViewController.h"
#import "AccountManager.h"
#import "PatientsDisplayViewController.h"
#import "LocalNotificationCenter.h"
#import "HengYaViewController.h"
#import "RuYaViewController.h"
#import "XLReserveTypesViewController.h"
#import "TimNavigationViewController.h"
#import "DoctorManager.h"
#import "CRMUserDefalut.h"
#import "CustomAlertView.h"
#import "DoctorTool.h"
#import "CRMHttpRespondModel.h"
#import "DBManager+Patients.h"

@interface XLAddReminderViewController ()<HengYaDeleate,RuYaDelegate,XLReserveTypesViewControllerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;//患者名称
@property (weak, nonatomic) IBOutlet UILabel *yaweiNameLabel;//牙位
@property (weak, nonatomic) IBOutlet UILabel *reserveTypeLabel;//预约类型
@property (weak, nonatomic) IBOutlet UILabel *visitTimeLabel;//就诊时间
@property (weak, nonatomic) IBOutlet UILabel *visitAddressLabel;//就诊地点
@property (weak, nonatomic) IBOutlet UILabel *visitDurationLabel;//就诊时长
@property (weak, nonatomic) IBOutlet UISwitch *weixinSendSwitch;//是否发送微信


@property (nonatomic,retain) HengYaViewController *hengYaVC;//恒牙
@property (nonatomic,retain) RuYaViewController *ruYaVC;//乳牙

@property (nonatomic, strong)LocalNotification *currentNoti;//当前需要添加的预约信息
@end

@implementation XLAddReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"back"]];
    [self setRightBarButtonWithTitle:@"保存"];
    self.title = @"添加预约";
    
    //显示数据
    [self initView];
    
}
- (void)dealloc{
    [LocalNotificationCenter shareInstance].selectPatient = nil;
}
#pragma mark - 保存按钮点击
- (void)onRightButtonAction:(id)sender{
    
    if(self.patientNameLabel.text.length == 0){
        [SVProgressHUD showImage:nil status:@"预约患者不能为空"];
        return;
    }
//    if(self.yaweiNameLabel.text.length == 0){
//        [SVProgressHUD showImage:nil status:@"患者牙位不能为空"];
//        return;
//    }
    if (self.reserveTypeLabel.text.length == 0) {
        [SVProgressHUD showImage:nil status:@"治疗项目不能为空"];
        return;
    }
    
    LocalNotification *notification = [[LocalNotification alloc] init];
    notification.reserve_time = self.visitTimeLabel.text;
    notification.reserve_type = self.reserveTypeLabel.text;
    notification.medical_place = self.visitAddressLabel.text;
    notification.medical_chair = @"";
    notification.update_date = [NSString defaultDateString];
    
    notification.selected = YES;
    notification.tooth_position = self.yaweiNameLabel.text;
    notification.clinic_reserve_id = @"0";
    notification.duration = [NSString stringWithFormat:@"%.1f",[self.infoDic[@"durationFloat"] floatValue]];
    
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
    
    //微信消息推送打开
    if([self.weixinSendSwitch isOn]){
        //获取偏好设置中保存的提醒设置
        NSString *userId = [AccountManager currentUserid];
        NSString *isOpen = [CRMUserDefalut objectForKey:[NSString stringWithFormat:@"%@RemindOpening",userId]];
        if (isOpen == nil) {
            isOpen = @"open";
            [CRMUserDefalut setObject:isOpen forKey:[NSString stringWithFormat:@"%@RemindOpening",userId]];
        }
        //开启提示框功能
        if ([isOpen isEqualToString:@"open"]) {
            [SVProgressHUD showWithStatus:@"正在加载..."];
            [DoctorTool yuYueMessagePatient:patient_id fromDoctor:[AccountManager currentUserid] withMessageType:self.reserveTypeLabel.text withSendType:@"0" withSendTime:self.visitTimeLabel.text success:^(CRMHttpRespondModel *result) {
                [SVProgressHUD dismiss];
                //显示提示框
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒内容" message:result.result delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
                [alertView show];
                
            } failure:^(NSError *error) {
                [SVProgressHUD dismiss];
                if (error) {
                    NSLog(@"error:%@",error);
                }
            }];
        }else{
            [self saveNotificationWithNoti:notification];
        }
    }else{
        BOOL ret = [[LocalNotificationCenter shareInstance] addLocalNotification:notification];
        if (ret) {
            [SVProgressHUD showSuccessWithStatus:@"本地预约保存成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"本地预约保存失败"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.isNextReserve) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(addReminderViewController:didSelectDateTime:)]) {
                    [self.delegate addReminderViewController:self didSelectDateTime:self.visitTimeLabel.text];
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}
#pragma mark - 保存本地预约
- (void)saveNotificationWithNoti:(LocalNotification *)noti{
    BOOL ret = [[LocalNotificationCenter shareInstance] addLocalNotification:noti];
    //关闭
    if (ret) {
        [SVProgressHUD showSuccessWithStatus:@"本地预约保存成功"];
        [[DoctorManager shareInstance] weiXinMessagePatient:noti.patient_id fromDoctor:[AccountManager shareInstance].currentUser.userid withMessageType:self.reserveTypeLabel.text withSendType:@"0" withSendTime:self.visitTimeLabel.text successBlock:^{
            
        } failedBlock:^(NSError *error){
            [SVProgressHUD showImage:nil status:error.localizedDescription];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"本地预约保存失败"];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isNextReserve) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(addReminderViewController:didSelectDateTime:)]) {
                [self.delegate addReminderViewController:self didSelectDateTime:self.visitTimeLabel.text];
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else{
        //点击了发送按钮
        [self saveNotificationWithNoti:self.currentNoti];
    }
}

#pragma mark - 加载视图数据
- (void)initView{
    [super initView];
    
    self.visitTimeLabel.text = self.infoDic[@"time"];
    self.visitDurationLabel.text = self.infoDic[@"duration"];
    self.visitAddressLabel.text = [[AccountManager shareInstance] currentUser].hospitalName;
    
    //如果是下次预约，设置患者的姓名
    if (self.isNextReserve) {
        //查询数据库
        Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.medicalCase.patient_id];
        if (patient) {
            //设置当前文本框内的值
            self.patientNameLabel.text = patient.patient_name;
        }
        self.yaweiNameLabel.text = self.medicalCase.case_name;
    }else if (self.isAddLocationToPatient){
        if (self.patient) {
            self.patientNameLabel.text = self.patient.patient_name;
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!self.isNextReserve && !self.isAddLocationToPatient) {
        self.patientNameLabel.text = [LocalNotificationCenter shareInstance].selectPatient.patient_name;
    }
}

#pragma mark - UITableView  Delegate/DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headerView.backgroundColor = MyColor(237, 237, 237);
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 40)];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.backgroundColor = MyColor(237, 237, 237);
    headerLabel.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:headerLabel];
    
    switch (section) {
        case 0:
            headerLabel.text = @"";
            break;
        case 1:
            headerLabel.text = @"";
            break;
        case 2:
            headerLabel.text = @"提醒方式";
            break;
        case 3:
            headerLabel.text = @"提醒时间";
            break;
            
        default:
            break;
    }
    
    if (section == 0) {
        return nil;
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //选择患者
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            PatientsDisplayViewController *patientVC = [storyboard instantiateViewControllerWithIdentifier:@"PatientsDisplayViewController"];
            patientVC.patientStatus = PatientStatuspeAll;
            patientVC.isYuYuePush = YES;
            patientVC.hidesBottomBarWhenPushed = YES;
            [self pushViewController:patientVC animated:YES];
        }else if (indexPath.row == 1){
            //选择牙位
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
            self.hengYaVC = [storyboard instantiateViewControllerWithIdentifier:@"HengYaViewController"];
            self.hengYaVC.delegate = self;
            self.hengYaVC.hengYaString = self.yaweiNameLabel.text;
            [self.navigationController addChildViewController:self.hengYaVC];
            [self.navigationController.view addSubview:self.hengYaVC.view];
        }else{
            //选择治疗项目
            XLReserveTypesViewController *reserceVC = [[XLReserveTypesViewController alloc] initWithStyle:UITableViewStylePlain];
            reserceVC.reserve_type = self.reserveTypeLabel.text;
            reserceVC.delegate = self;
            TimNavigationViewController *nav = [[TimNavigationViewController alloc]initWithRootViewController:reserceVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}

#pragma mark -HengYaDeleate
-(void)removeHengYaVC{
    [self.hengYaVC willMoveToParentViewController:nil];
    [self.hengYaVC.view removeFromSuperview];
    [self.hengYaVC removeFromParentViewController];
}

- (void)queDingHengYa:(NSMutableArray *)hengYaArray toothStr:(NSString *)toothStr{
    
    if ([toothStr isEqualToString:@"未连续"]) {
        self.yaweiNameLabel.text = [hengYaArray componentsJoinedByString:@","];
    }else{
        self.yaweiNameLabel.text = toothStr;
    }
    
    [self removeHengYaVC];
}

- (void)queDingRuYa:(NSMutableArray *)ruYaArray toothStr:(NSString *)toothStr{
    if ([toothStr isEqualToString:@"未连续"]) {
        self.yaweiNameLabel.text = [ruYaArray componentsJoinedByString:@","];
    }else{
        self.yaweiNameLabel.text = toothStr;
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
    self.ruYaVC.ruYaString = self.yaweiNameLabel.text;
    [self.navigationController addChildViewController:self.ruYaVC];
    [self.navigationController.view addSubview:self.ruYaVC.view];
}
-(void)changeToHengYaVC{
    [self removeRuYaVC];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
    self.hengYaVC = [storyboard instantiateViewControllerWithIdentifier:@"HengYaViewController"];
    self.hengYaVC.delegate = self;
    self.hengYaVC.hengYaString = self.yaweiNameLabel.text;
    [self.navigationController addChildViewController:self.hengYaVC];
    [self.navigationController.view addSubview:self.hengYaVC.view];
}

#pragma mark - XLReserveTypesViewControllerDelegate
- (void)reserveTypesViewController:(XLReserveTypesViewController *)vc didSelectReserveType:(NSString *)type{
    self.reserveTypeLabel.text = type;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
