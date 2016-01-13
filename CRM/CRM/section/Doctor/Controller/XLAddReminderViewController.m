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
#import "DBManager+AutoSync.h"
#import "MJExtension.h"
#import "JSONKit.h"
#import "DBManager+LocalNotification.h"
#import "RBCustomDatePickerView.h"
#import "DoctorLibraryViewController.h"
#import "XLSelectYuyueViewController.h"
#import "UIColor+Extension.h"
#import "CRMMacro.h"
#import "NSString+Conversion.h"
#import "DBManager+LocalNotification.h"
#import "XLAutoSyncTool.h"
#import "XLAutoSyncTool+XLDelete.h"
#import "XLAutoSyncTool+XLInsert.h"
#import "XLContentWriteViewController.h"
#import "SysMessageTool.h"
#import "DBManager+Doctor.h"
#import "NSDictionary+Extension.h"
#import "DoctorTool.h"
#import "XLPatientSelectViewController.h"


#define AddReserveType @"新增预约"
#define CancelReserveType @"取消预约"
#define UpdateReserveType @"修改预约"

@interface XLAddReminderViewController ()<HengYaDeleate,RuYaDelegate,XLReserveTypesViewControllerDelegate,UIAlertViewDelegate,DoctorLibraryViewControllerDelegate,XLSelectYuyueViewControllerDelegate,XLContentWriteViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;//患者名称
@property (weak, nonatomic) IBOutlet UILabel *yaweiNameLabel;//牙位
@property (weak, nonatomic) IBOutlet UILabel *reserveTypeLabel;//预约类型
@property (weak, nonatomic) IBOutlet UILabel *visitTimeLabel;//就诊时间
@property (weak, nonatomic) IBOutlet UILabel *visitAddressLabel;//就诊地点
@property (weak, nonatomic) IBOutlet UILabel *visitDurationLabel;//就诊时长
@property (weak, nonatomic) IBOutlet UISwitch *weixinSendSwitch;//是否发送微信
@property (weak, nonatomic) IBOutlet UILabel *yuyueRemarkLabel;

@property (weak, nonatomic) IBOutlet UILabel *therapyDoctor;

@property (nonatomic,retain) HengYaViewController *hengYaVC;//恒牙
@property (nonatomic,retain) RuYaViewController *ruYaVC;//乳牙
@property (nonatomic, strong)LocalNotification *currentNoti;//当前需要添加的预约信息
@property (nonatomic, strong)Doctor *currentSelectDoctor;//当前选择的治疗医生
@property (nonatomic, strong)NSDictionary *currentSelectDic;//当前选中的时间字典
@property (weak, nonatomic) IBOutlet UIImageView *patientArrow;
@property (weak, nonatomic) IBOutlet UIImageView *yaweiArrow;
@property (weak, nonatomic) IBOutlet UIImageView *reserveTypeArrow;
@property (weak, nonatomic) IBOutlet UIImageView *reserveTimeArrow;
@property (weak, nonatomic) IBOutlet UIImageView *treatDoctorArrow;

@end

@implementation XLAddReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"保存"];
    if (self.isEditAppointment) {
        self.title = @"修改预约";
    }else{
        self.title = @"添加预约";
    }
    
    //显示数据
//    [self initView];
}

- (void)dealloc{
    [LocalNotificationCenter shareInstance].selectPatient = nil;
}
#pragma mark - 保存按钮点击
- (void)onRightButtonAction:(id)sender{
    
    if (self.isEditAppointment) {
        //判断当前的预约时间和原来的预约时间是否相同,当前的治疗医生和之前的治疗医生是否相同
        if ([self.localNoti.reserve_time isEqualToString:self.visitTimeLabel.text] && self.currentSelectDoctor == nil) {
            //没有修改时间，只是修改备注
            self.localNoti.reserve_content = self.yuyueRemarkLabel.text;
            //更新预约信息表
            [SVProgressHUD showWithStatus:@"正在修改预约，请稍候..."];
            [[XLAutoSyncTool shareInstance] editAllNeedSyncReserve_record:self.localNoti success:^(CRMHttpRespondModel *respond) {
                if ([respond.code integerValue] == 200) {
                    if([[DBManager shareInstance] updateLocalNotificaiton:self.localNoti]){
                        [SVProgressHUD showSuccessWithStatus:@"修改预约成功"];
                        //发送通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOtificationUpdated object:nil];
                        //发送微信给治疗医生
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }
                }else{
                    [SVProgressHUD showErrorWithStatus:@"预约修改失败"];
                }
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"预约修改失败"];
                if (error) {
                    NSLog(@"error:%@",error);
                }
            }];
        }else{
            //首先更新之前的预约
            self.localNoti.reserve_status = @"1";//表示已经改约
            [SVProgressHUD showWithStatus:@"正在修改预约，请稍候..."];
            [SysMessageTool updateReserveRecordStatusWithReserveId:self.localNoti.ckeyid success:^(CRMHttpRespondModel *respond) {
                if ([respond.code integerValue] == 200) {
                    //移除本地的通知
                    [[LocalNotificationCenter shareInstance] removeLocalNotification:self.localNoti];
                    //重新为治疗医生创建一个预约
                    LocalNotification *otherNoti = [LocalNotification notificationWithNoti:self.localNoti];
                    otherNoti.sync_time = [NSString defaultDateString];
                    otherNoti.update_date = [NSString currentDateString];
                    otherNoti.creation_date = [NSString currentDateString];
                    otherNoti.reserve_time = [NSString stringWithFormat:@"%@:00",self.visitTimeLabel.text];
                    otherNoti.reserve_content = self.yuyueRemarkLabel.text;
                    otherNoti.reserve_status = @"0";
                    otherNoti.ckeyid = [self createCkeyIdWithDoctorId:otherNoti.therapy_doctor_id];
                    otherNoti.doctor_id = [AccountManager currentUserid];
                    self.currentNoti = otherNoti;
                    
                    //添加一个新的预约
                    [[XLAutoSyncTool shareInstance] postAllNeedSyncReserve_record:otherNoti success:^(CRMHttpRespondModel *respond) {
                        if ([respond.code integerValue] == 200) {
                            
                            //修改预约成功后，如果修改了治疗医生，要进行转诊操作
                            if (![self.localNoti.therapy_doctor_id isEqualToString:otherNoti.therapy_doctor_id]) {
                                //进行转诊操作
                                [DoctorTool transferPatientWithPatientId:otherNoti.patient_id doctorId:[AccountManager currentUserid] receiverId:otherNoti.therapy_doctor_id success:^(CRMHttpRespondModel *result) {
                                    //转诊成功
                                    [self transferPatientSuccessWithResult:result];
                                } failure:^(NSError *error) {
                                    if (self.isEditAppointment) {
                                        [SVProgressHUD showErrorWithStatus:@"修改预约失败,转诊失败"];
                                    }else {
                                        [SVProgressHUD showErrorWithStatus:@"添加预约失败,转诊失败"];
                                    }
                                    if (error) {
                                        NSLog(@"error:%@",error);
                                    }
                                }];
                                
                            }else{
                                //修改预约成功，只是修改治疗时间，无转诊操作
                                [self updateReserveRecordSuccess];
                            }
                            
                            
                        }else{
                            [SVProgressHUD showErrorWithStatus:@"预约修改失败"];
                        }
                    } failure:^(NSError *error) {
                        [SVProgressHUD showErrorWithStatus:@"预约修改失败"];
                        if (error) {
                            NSLog(@"error:%@",error);
                        }
                    }];
                    
                }else{
                    [SVProgressHUD showErrorWithStatus:@"预约修改失败"];
                }
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"预约修改失败"];
                if (error) {
                    NSLog(@"error:%@",error);
                }
            }];
        }
    }else{
        //添加预约
        if(self.patientNameLabel.text.length == 0){
            [SVProgressHUD showImage:nil status:@"预约患者不能为空"];
            return;
        }
        if (self.reserveTypeLabel.text.length == 0) {
            [SVProgressHUD showImage:nil status:@"治疗项目不能为空"];
            return;
        }
        
        LocalNotification *notification = [[LocalNotification alloc] init];
        notification.reserve_time = [NSString stringWithFormat:@"%@:00",self.visitTimeLabel.text];
        notification.reserve_type = self.reserveTypeLabel.text;
        notification.medical_place = self.visitAddressLabel.text;
        notification.medical_chair = @"";
        notification.update_date = [NSString defaultDateString];
        notification.reserve_content = self.yuyueRemarkLabel.text;
        
        notification.selected = YES;
        notification.tooth_position = self.yaweiNameLabel.text;
        notification.clinic_reserve_id = @"0";
        notification.duration = [NSString stringWithFormat:@"%.1f",[self.infoDic[@"durationFloat"] floatValue]];
        notification.reserve_status = @"0";
        //设置治疗医生
        if (self.currentSelectDoctor == nil) {
            notification.therapy_doctor_id = [AccountManager currentUserid];
            notification.therapy_doctor_name = [[AccountManager shareInstance] currentUser].name;
        }else{
            notification.therapy_doctor_id = self.currentSelectDoctor.ckeyid;
            notification.therapy_doctor_name = self.currentSelectDoctor.doctor_name;
        }
        
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
            NSString *isOpen = [CRMUserDefalut objectForKey:AutoAlertKey];
            if (isOpen == nil) {
                isOpen = Auto_Action_Open;
                [CRMUserDefalut setObject:isOpen forKey:AutoAlertKey];
            }
            //开启提示框功能
            if ([isOpen isEqualToString:Auto_Action_Open]) {
                [SVProgressHUD showWithStatus:@"正在加载..."];
                [DoctorTool yuYueMessagePatient:patient_id fromDoctor:[AccountManager currentUserid] withMessageType:self.reserveTypeLabel.text withSendType:@"0" withSendTime:self.visitTimeLabel.text success:^(CRMHttpRespondModel *result) {
                    [SVProgressHUD dismiss];
                    //显示提示框
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒内容" message:result.result delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
                    [alertView show];
                    
                } failure:^(NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"提醒内容获取失败，请检查网络设置"];
                    if (error) {
                        NSLog(@"error:%@",error);
                    }
                }];
            }else{
                [self saveNotificationWithNoti:notification sendWeiXin:YES];
            }
        }else{
            //不给患者发送微信时，添加预约信息
            [self saveNotificationWithNoti:notification sendWeiXin:NO];
        }
    }
}
#pragma mark - 修改预约方法
- (void)updateReserveRecordSuccess{
    [SysMessageTool sendWeiXinReserveNotificationWithNewReserveId:self.currentNoti.ckeyid oldReserveId:self.localNoti.ckeyid isCancel:NO notification:nil type:UpdateReserveType success:nil failure:nil];
    
    [SVProgressHUD showSuccessWithStatus:@"预约修改成功"];
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCreated object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOtificationUpdated object:nil];
    //向本地保存一条预约信息
    if([[LocalNotificationCenter shareInstance] addLocalNotification:self.currentNoti]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(addReminderViewController:didUpdateReserveRecord:)]) {
            [self.delegate addReminderViewController:self didUpdateReserveRecord:self.currentNoti];
        }
        //发送微信给治疗医生
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

#pragma mark - 保存本地预约,给患者发送预约信息
- (void)saveNotificationWithNoti:(LocalNotification *)noti sendWeiXin:(BOOL)isSend{
    [SVProgressHUD showWithStatus:@"正在添加预约，请稍候..."];
    [[XLAutoSyncTool shareInstance] postAllNeedSyncReserve_record:noti success:^(CRMHttpRespondModel *respond) {
        if ([respond.code integerValue] == 200) {
            //判断当前治疗医生是否是当前登录人
            if (![noti.therapy_doctor_id isEqualToString:[AccountManager currentUserid]]) {
                //进行转诊操作
                [DoctorTool transferPatientWithPatientId:noti.patient_id doctorId:[AccountManager currentUserid] receiverId:noti.therapy_doctor_id success:^(CRMHttpRespondModel *result) {
                    //转诊成功回调
                    [self transferPatientSuccessWithResult:result];
                } failure:^(NSError *error) {
                    if (self.isEditAppointment) {
                        [SVProgressHUD showErrorWithStatus:@"添加预约失败,转诊失败"];
                    }else {
                        [SVProgressHUD showErrorWithStatus:@"添加预约失败,转诊失败"];
                    }
                    if (error) {
                        NSLog(@"error:%@",error);
                    }
                }];
            }else{
                //添加一条本地预约数据
                BOOL ret = [[LocalNotificationCenter shareInstance] addLocalNotification:noti];
                if (ret) {
                    [SVProgressHUD showSuccessWithStatus:@"预约添加成功"];
                    //判断微信发送是否打开
                    if (self.weixinSendSwitch.isOn) {
                        //发送微信给治疗医生和患者
                        [SysMessageTool sendWeiXinReserveNotificationWithNewReserveId:noti.ckeyid oldReserveId:noti.ckeyid isCancel:NO notification:nil type:AddReserveType success:nil failure:nil];
                    }
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"预约添加失败"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"预约添加失败"];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
    }else{
        //点击了发送按钮
        [self saveNotificationWithNoti:self.currentNoti sendWeiXin:YES];
    }
}

#pragma mark - 转诊患者成功
- (void)transferPatientSuccessWithResult:(CRMHttpRespondModel *)resultModel
{
    if ([resultModel.code integerValue] == 200) {
        //转诊成功
        if (self.isEditAppointment) {
            [SVProgressHUD showSuccessWithStatus:@"修改预约成功"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"添加预约成功"];
        }
        //只有转诊成功后才向本地，插入患者介绍人
        [self insertPatientIntroducerMap];
    } else {
        //已经转诊过
        if (self.isEditAppointment) {
            [SVProgressHUD showSuccessWithStatus:@"修改预约成功"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"添加预约成功"];
        }
    }
    Patient *tmppatient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.currentNoti.patient_id];
    if (tmppatient != nil) {
        //添加患者自动同步信息
        InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Patient postType:Update dataEntity:[tmppatient.keyValues JSONString] syncStatus:@"0"];
        [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
        
        //添加一条本地预约数据
        BOOL ret = [[LocalNotificationCenter shareInstance] addLocalNotification:self.currentNoti];
        if (ret) {
            if (self.isEditAppointment) {
                [SysMessageTool sendWeiXinReserveNotificationWithNewReserveId:self.currentNoti.ckeyid oldReserveId:self.localNoti.ckeyid isCancel:NO notification:nil type:UpdateReserveType success:nil failure:nil];
                
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCreated object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOtificationUpdated object:nil];
            }else{
                //判断微信发送是否打开
                if (self.weixinSendSwitch.isOn) {
                    //发送微信给治疗医生和患者
                    [SysMessageTool sendWeiXinReserveNotificationWithNewReserveId:self.currentNoti.ckeyid oldReserveId:self.currentNoti.ckeyid isCancel:NO notification:nil type:AddReserveType success:^{} failure:^{}];
                }
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(addReminderViewController:didUpdateReserveRecord:)]) {
                [self.delegate addReminderViewController:self didUpdateReserveRecord:self.currentNoti];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }

}
#pragma mark - 向本地插入患者介绍人关系表
-(void)insertPatientIntroducerMap{
    PatientIntroducerMap *map = [[PatientIntroducerMap alloc]init];
    map.intr_id = [AccountManager currentUserid];
    map.intr_source = @"I";
    map.patient_id = self.currentNoti.patient_id;
    map.doctor_id = self.currentNoti.therapy_doctor_id;
    map.intr_time = [NSString currentDateString];
    [[DBManager shareInstance]insertPatientIntroducerMap:map];
}
#pragma mark - 加载视图数据
- (void)initView{
    [super initView];
    
    if (self.isEditAppointment) {
        self.visitTimeLabel.text = self.localNoti.reserve_time;
        self.visitDurationLabel.text = [NSString stringWithFormat:@"%@小时",self.localNoti.duration];
        self.visitAddressLabel.text = self.localNoti.medical_place;
        self.therapyDoctor.text = self.localNoti.therapy_doctor_name;
        
        //查询患者
        Patient *patientTmp = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.localNoti.patient_id];
        self.patientNameLabel.text = patientTmp.patient_name;
        self.yaweiNameLabel.text = self.localNoti.tooth_position;
        self.yuyueRemarkLabel.text = self.localNoti.reserve_content;
        self.reserveTypeLabel.text = self.localNoti.reserve_type;
        
        //隐藏箭头
        self.patientArrow.hidden = YES;
        self.yaweiArrow.hidden = YES;
        self.reserveTypeArrow.hidden = YES;
        
    }else{
        self.reserveTimeArrow.hidden = YES;
        
        self.visitTimeLabel.text = self.infoDic[@"time"];
        self.visitDurationLabel.text = self.infoDic[@"duration"];
        self.visitAddressLabel.text = [[AccountManager shareInstance] currentUser].hospitalName;
        self.therapyDoctor.text = [[AccountManager shareInstance] currentUser].name;
        
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
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!self.isNextReserve && !self.isAddLocationToPatient && !self.isEditAppointment) {
        self.patientNameLabel.text = [LocalNotificationCenter shareInstance].selectPatient.patient_name;
    }
}

#pragma mark - UITableView  Delegate/DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        return 0;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headerView.backgroundColor = MyColor(237, 237, 237);
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 30)];
    headerLabel.textColor = [UIColor colorWithHex:0x333333];
    headerLabel.backgroundColor = MyColor(237, 237, 237);
    headerLabel.font = [UIFont systemFontOfSize:15];
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
    if (self.isEditAppointment) {
        
        if (indexPath.section == 0) {
            if (indexPath.row == 3) {
                //选择治疗医生
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DoctorStoryboard" bundle:nil];
                DoctorLibraryViewController *doctorVc = [storyboard instantiateViewControllerWithIdentifier:@"DoctorLibraryViewController"];
                doctorVc.isTherapyDoctor = YES;
                doctorVc.delegate = self;
                [self pushViewController:doctorVc animated:YES];
            }
        }
        
        if (indexPath.section == 1){
            if (indexPath.row == 0) {
                //选择时间
                XLSelectYuyueViewController *selectTimeVc = [[XLSelectYuyueViewController alloc] init];
                selectTimeVc.isEditAppointment = YES;
                selectTimeVc.delegate = self;
                selectTimeVc.reserveTime = self.visitTimeLabel.text;
                [self pushViewController:selectTimeVc animated:YES];
                
            }else if (indexPath.row == 3){
                //跳转到备注填写页面
                XLContentWriteViewController *contentVC = [[XLContentWriteViewController alloc] init];
                contentVC.title = @"备注";
                contentVC.delegate = self;
                contentVC.currentContent = self.yuyueRemarkLabel.text;
                [self pushViewController:contentVC animated:YES];
            }
        }
        
    }else{
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                //选择患者
                XLPatientSelectViewController *patientSelectVc = [[XLPatientSelectViewController alloc] init];
                patientSelectVc.patientStatus = PatientStatuspeAll;
                patientSelectVc.isYuYuePush = YES;
                patientSelectVc.hidesBottomBarWhenPushed = YES;
                [self pushViewController:patientSelectVc animated:YES];
            }else if (indexPath.row == 1){
                //选择牙位
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
                self.hengYaVC = [storyboard instantiateViewControllerWithIdentifier:@"HengYaViewController"];
                self.hengYaVC.delegate = self;
                self.hengYaVC.hengYaString = self.yaweiNameLabel.text;
                [self.navigationController addChildViewController:self.hengYaVC];
                [self.navigationController.view addSubview:self.hengYaVC.view];
            }else if(indexPath.row == 2){
                //选择治疗项目
                XLReserveTypesViewController *reserceVC = [[XLReserveTypesViewController alloc] initWithStyle:UITableViewStylePlain];
                reserceVC.reserve_type = self.reserveTypeLabel.text;
                reserceVC.delegate = self;
                TimNavigationViewController *nav = [[TimNavigationViewController alloc]initWithRootViewController:reserceVC];
                [self presentViewController:nav animated:YES completion:nil];
            }else{
                //选择治疗医生
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DoctorStoryboard" bundle:nil];
                DoctorLibraryViewController *doctorVc = [storyboard instantiateViewControllerWithIdentifier:@"DoctorLibraryViewController"];
                doctorVc.isTherapyDoctor = YES;
                doctorVc.delegate = self;
                [self pushViewController:doctorVc animated:YES];
            }
        }else if (indexPath.section == 1){
            if (indexPath.row == 3) {
                //跳转到修改备注页面
                XLContentWriteViewController *contentVC = [[XLContentWriteViewController alloc] init];
                contentVC.title = @"备注";
                contentVC.delegate = self;
                contentVC.currentContent = self.yuyueRemarkLabel.text;
                [self pushViewController:contentVC animated:YES];
            }
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

#pragma mark - DoctorLibraryViewControllerDelegate
- (void)doctorLibraryVc:(DoctorLibraryViewController *)doctorLibraryVc didSelectDoctor:(Doctor *)doctor{
    //选择了医生
    self.therapyDoctor.text = doctor.doctor_name;
    self.currentSelectDoctor = doctor;
}

#pragma mark - XLSelectYuyueViewControllerDelegate
- (void)selectYuyueViewController:(XLSelectYuyueViewController *)vc didSelectData:(NSDictionary *)dic{
    /**
     *  dicM[@"time"] = self.actionSheetTime;
        dicM[@"duration"] = @"30分钟";
        dicM[@"durationFloat"] = @"0.5";
     */
    //获取数据
    self.visitDurationLabel.text = dic[@"duration"];
    self.visitTimeLabel.text = dic[@"time"];
    self.currentSelectDic = dic;
}

#pragma mark - 创建ckeyid
- (NSString *)createCkeyIdWithDoctorId:(NSString *)doctorId {
    if ([NSString isEmptyString:doctorId]) {
        doctorId = @"";
    }
    NSString *timeString = [NSString stringWithFormat:@"%0.0f",[[NSDate date] timeIntervalSince1970]*1000];
    doctorId = [doctorId stringByAppendingString:@"_"];
    doctorId = [doctorId stringByAppendingString:timeString];
    return doctorId;
}

#pragma mark - XLContentWriteViewControllerDelegate
- (void)contentWriteViewController:(XLContentWriteViewController *)contentVC didWriteContent:(NSString *)content{
    self.yuyueRemarkLabel.text = content;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
