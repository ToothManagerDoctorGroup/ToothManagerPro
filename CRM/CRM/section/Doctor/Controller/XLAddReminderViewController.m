//
//  XLAddReminderViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/21.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLAddReminderViewController.h"
#import "AccountManager.h"
#import "LocalNotificationCenter.h"
#import "XLHengYaViewController.h"
#import "XLRuYaViewController.h"
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
#import "XLSelectYuyueViewController.h"
#import "UIColor+Extension.h"
#import "CRMMacro.h"
#import "NSString+Conversion.h"
#import "DBManager+LocalNotification.h"
#import "XLAutoSyncTool.h"
#import "XLAutoSyncTool+XLDelete.h"
#import "XLAutoSyncTool+XLInsert.h"
#import "SysMessageTool.h"
#import "DBManager+Doctor.h"
#import "NSDictionary+Extension.h"
#import "DoctorTool.h"
#import "XLPatientSelectViewController.h"
#import "XLDoctorLibraryViewController.h"
#import "XLCustomAlertView.h"
#import "MyPatientTool.h"
#import "SysMessageTool.h"
#import "MyDateTool.h"
#import "EditAllergyViewController.h"
#import "XLChatModel.h"

#define AddReserveType @"新增预约"
#define CancelReserveType @"取消预约"
#define UpdateReserveType @"修改预约"

#define EditTextColor [UIColor colorWithHex:0x888888]

@interface XLAddReminderViewController ()<XLHengYaDeleate,XLRuYaDelegate,XLReserveTypesViewControllerDelegate,XLDoctorLibraryViewControllerDelegate,XLSelectYuyueViewControllerDelegate,EditAllergyViewControllerDelegate>{
    
    __weak IBOutlet UILabel *_yaweiTitle;
    __weak IBOutlet UILabel *_nameTitle;
    __weak IBOutlet UILabel *_reserTypeTitle;
    __weak IBOutlet UILabel *_hospitalTitle;
    __weak IBOutlet UILabel *_timeTitle;
}

@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;//患者名称
@property (weak, nonatomic) IBOutlet UILabel *yaweiNameLabel;//牙位
@property (weak, nonatomic) IBOutlet UILabel *reserveTypeLabel;//预约类型
@property (weak, nonatomic) IBOutlet UILabel *visitTimeLabel;//就诊时间
@property (weak, nonatomic) IBOutlet UILabel *visitAddressLabel;//就诊地点
@property (weak, nonatomic) IBOutlet UILabel *visitDurationLabel;//就诊时长
@property (weak, nonatomic) IBOutlet UILabel *yuyueRemarkLabel;

@property (weak, nonatomic) IBOutlet UILabel *therapyDoctor;

@property (nonatomic,retain) XLHengYaViewController *hengYaVC;//恒牙
@property (nonatomic,retain) XLRuYaViewController *ruYaVC;//乳牙
@property (nonatomic, strong)LocalNotification *currentNoti;//当前需要添加的预约信息
@property (nonatomic, strong)Doctor *currentSelectDoctor;//当前选择的治疗医生
@property (nonatomic, strong)NSDictionary *currentSelectDic;//当前选中的时间字典

@property (weak, nonatomic) IBOutlet UIImageView *patientArrow;
@property (weak, nonatomic) IBOutlet UIImageView *yaweiArrow;
@property (weak, nonatomic) IBOutlet UIImageView *reserveTypeArrow;
@property (weak, nonatomic) IBOutlet UIImageView *reserveTimeArrow;
@property (weak, nonatomic) IBOutlet UIImageView *treatDoctorArrow;

@property (nonatomic, assign)BOOL isBind;//是否绑定了微信

@end

@implementation XLAddReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"保存"];
    if (self.isEditAppointment) {
        self.title = @"修改预约";
    }else{
        self.title = @"添加预约";
    }
}

- (void)dealloc{
    [LocalNotificationCenter shareInstance].selectPatient = nil;
}

#pragma mark - 设置按钮是否可点
- (void)setButtonEnable:(BOOL)enable{
    self.navigationItem.rightBarButtonItem.enabled = enable;
}

#pragma mark - 保存按钮点击
- (void)onRightButtonAction:(id)sender{
    
    if (self.isEditAppointment) {
        [self setButtonEnable:NO];
        //判断当前的预约时间和原来的预约时间是否相同,当前的治疗医生和之前的治疗医生是否相同
        if ([self.localNoti.reserve_time isEqualToString:self.visitTimeLabel.text] && self.currentSelectDoctor == nil) {
            //没有修改时间，只是修改备注
            self.localNoti.reserve_content = self.yuyueRemarkLabel.text;
            //更新预约信息表
            [SVProgressHUD showWithStatus:@"正在修改预约，请稍候..."];
            [[XLAutoSyncTool shareInstance] editAllNeedSyncReserve_record:self.localNoti success:^(CRMHttpRespondModel *respond) {
                if ([respond.code integerValue] == 200) {
                    if([[DBManager shareInstance] updateLocalNotificaiton:self.localNoti]){
                        [SVProgressHUD showSuccessWithStatus:@"预约修改成功"];
                        //发送通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOtificationUpdated object:nil];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self popToScheduleVc];
                        });
                    }
                }else{
                    [self setButtonEnable:YES];
                    [SVProgressHUD showErrorWithStatus:@"预约修改失败"];
                }
            } failure:^(NSError *error) {
                [self setButtonEnable:YES];
                [SVProgressHUD showImage:nil status:error.localizedDescription];
                if (error) {
                    NSLog(@"error:%@",error);
                }
            }];
        }else{
            //首先更新之前的预约
            self.localNoti.reserve_status = @"1";//表示已经改约
            [SVProgressHUD showWithStatus:@"正在修改预约，请稍候..."];
            [SysMessageTool updateReserveRecordStatusWithReserveId:self.localNoti.ckeyid therapy_doctor_id:self.localNoti.therapy_doctor_id success:^(CRMHttpRespondModel *respond) {
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
                    otherNoti.doctor_id = [AccountManager currentUserid];
                    if (self.currentSelectDoctor && ![self.currentSelectDoctor.ckeyid isEqualToString:self.localNoti.therapy_doctor_id]) {
                        otherNoti.therapy_doctor_id = self.currentSelectDoctor.ckeyid;
                        otherNoti.therapy_doctor_name = self.currentSelectDoctor.doctor_name;
                    }
                    otherNoti.ckeyid = [self createCkeyIdWithDoctorId:otherNoti.therapy_doctor_id];
                    self.currentNoti = otherNoti;
                    
                    //添加一个新的预约
                    [[XLAutoSyncTool shareInstance] postAllNeedSyncReserve_record:otherNoti success:^(CRMHttpRespondModel *respond) {
                        if ([respond.code integerValue] == 200) {
                            
                            //修改预约成功后，如果修改了治疗医生，要进行转诊操作
                            if (![self.localNoti.therapy_doctor_id isEqualToString:otherNoti.therapy_doctor_id]) {
                                //进行转诊操作
                                [DoctorTool transferPatientWithPatientId:otherNoti.patient_id doctorId:[AccountManager currentUserid] receiverId:otherNoti.therapy_doctor_id success:^(CRMHttpRespondModel *result) {
                                    //转诊成功
                                    [self transferPatientSuccessWithResult:result send:NO];
                                } failure:^(NSError *error) {
                                    [self setButtonEnable:YES];
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
                            [self setButtonEnable:YES];
                            [SVProgressHUD showErrorWithStatus:@"预约修改失败"];
                        }
                    } failure:^(NSError *error) {
                        [self setButtonEnable:YES];
                        [SVProgressHUD showErrorWithStatus:@"预约修改失败"];
                        if (error) {
                            NSLog(@"error:%@",error);
                        }
                    }];
                    
                }else{
                    [self setButtonEnable:YES];
                    [SVProgressHUD showErrorWithStatus:@"预约修改失败"];
                }
            } failure:^(NSError *error) {
                [self setButtonEnable:YES];
                [SVProgressHUD showErrorWithStatus:@"预约修改失败"];
                if (error) {
                    NSLog(@"error:%@",error);
                }
            }];
        }
    }else{
        //添加预约
        if(self.patientNameLabel.text.length == 0){
            [SVProgressHUD showImage:nil status:@"请选择患者"];
            return;
        }
        if (self.reserveTypeLabel.text.length == 0) {
            [SVProgressHUD showImage:nil status:@"请选择预约事项"];
            return;
        }
        
        [self setButtonEnable:NO];
        
        LocalNotification *notification = [[LocalNotification alloc] init];
        notification.reserve_time = [NSString stringWithFormat:@"%@:00",self.visitTimeLabel.text];
        notification.reserve_type = self.reserveTypeLabel.text;
        notification.medical_place = self.visitAddressLabel.text;
        notification.medical_chair = @"";
        notification.update_date = [NSString defaultDateString];
        notification.reserve_content = self.yuyueRemarkLabel.text;
        notification.case_id = @"";
        
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
        
        //直接调用接口上传数据
        [self saveNotificationWithNoti:notification sendWeiXin:YES];
    }
}
#pragma mark - 修改预约方法
- (void)updateReserveRecordSuccess{

    Patient *patientTmp = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.currentNoti.patient_id];
    //向本地保存一条预约信息
    if([[LocalNotificationCenter shareInstance] addLocalNotification:self.currentNoti]){
        //更新所有病历的下次预约时间
        [self updateNextReserveTimeWithPatientId:self.currentNoti.patient_id time:self.currentNoti.reserve_time];
        
        [SVProgressHUD showSuccessWithStatus:@"预约修改成功"];
        //获取消息,发送给医生
        [SysMessageTool sendWeiXinReserveNotificationWithNewReserveId:self.currentNoti.ckeyid oldReserveId:self.localNoti.ckeyid isCancel:NO notification:nil type:UpdateReserveType success:nil failure:nil];
        
        //发送消息给患者
        NSString *formatterStr = @"yyyy年MM月dd日 HH时mm分";
        NSString *preDateStr = [MyDateTool stringWithDateFormatterStr:formatterStr dateStr:[NSString stringWithFormat:@"%@:00",self.localNoti.reserve_time]];
        NSString *currentDateStr = [MyDateTool stringWithDateFormatterStr:formatterStr dateStr:self.currentNoti.reserve_time];
        NSString *template = [NSString stringWithFormat:@"您好，我是%@医生，原定于%@的预约已调整为%@，请您准时就诊。如有疑问请随时联系！",[AccountManager shareInstance].currentUser.name,preDateStr,currentDateStr];
        __weak typeof(self) weakSelf = self;
        XLCustomAlertView *alertView = [[XLCustomAlertView alloc] initWithTitle:@"提醒患者" message:template Cancel:@"不发送" certain:@"发送" weixinEnalbe:self.isBind type:CustonAlertViewTypeCheck cancelHandler:^{
            //退出当前页面
            [weakSelf popToScheduleVc];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(addReminderViewController:didUpdateReserveRecord:)]) {
                [weakSelf.delegate addReminderViewController:weakSelf didUpdateReserveRecord:weakSelf.currentNoti];
            }
        } certainHandler:^(NSString *content, BOOL wenxinSend, BOOL messageSend) {
            [SVProgressHUD  showWithStatus:@"正在发送消息"];
            [SysMessageTool sendMessageWithDoctorId:[AccountManager currentUserid] patientId:weakSelf.currentNoti.patient_id isWeixin:wenxinSend isSms:messageSend txtContent:content success:^(CRMHttpRespondModel *respond) {
                
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(addReminderViewController:didUpdateReserveRecord:)]) {
                    [weakSelf.delegate addReminderViewController:weakSelf didUpdateReserveRecord:weakSelf.currentNoti];
                }
                
                if ([respond.code integerValue] == 200) {
                    [SVProgressHUD showImage:nil status:@"消息发送成功"];
                    //将消息保存在消息记录里
                    [weakSelf savaMessageToChatRecordWithPatient:patientTmp message:content];
                }else{
                    [SVProgressHUD showImage:nil status:@"消息发送失败"];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf popToScheduleVc];
                });
            } failure:^(NSError *error) {
                [SVProgressHUD showImage:nil status:@"消息发送失败"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf popToScheduleVc];
                });
                if (error) {
                    NSLog(@"error:%@",error);
                }
            }];
        }];
        [alertView show];
    }
}

#pragma mark - 保存本地预约,给患者发送预约信息
- (void)saveNotificationWithNoti:(LocalNotification *)noti sendWeiXin:(BOOL)isSend{
    Patient *patientTmp = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.currentNoti.patient_id];
    [SVProgressHUD showWithStatus:@"正在添加预约，请稍候..."];
    [[XLAutoSyncTool shareInstance] postAllNeedSyncReserve_record:noti success:^(CRMHttpRespondModel *respond) {
        if ([respond.code integerValue] == 200) {
            //判断当前治疗医生是否是当前登录人
            if (![noti.therapy_doctor_id isEqualToString:[AccountManager currentUserid]]) {
                //进行转诊操作
                [DoctorTool transferPatientWithPatientId:noti.patient_id doctorId:[AccountManager currentUserid] receiverId:noti.therapy_doctor_id success:^(CRMHttpRespondModel *result) {
                    //转诊成功回调
                    [self transferPatientSuccessWithResult:result send:YES];
                } failure:^(NSError *error) {
                    [self setButtonEnable:YES];
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
                if (self.isEditAppointment) {
                    [SVProgressHUD showSuccessWithStatus:@"修改预约成功"];
                }else {
                    [SVProgressHUD showSuccessWithStatus:@"添加预约成功"];
                }
                
                //添加一条本地预约数据
                BOOL ret = [[LocalNotificationCenter shareInstance] addLocalNotification:noti];
                if (ret) {
                    //修改所有病历的下次预约信息
                    [self updateNextReserveTimeWithPatientId:noti.patient_id time:noti.reserve_time];
                    
                    //发送微信消息给医生
                    [SysMessageTool sendWeiXinReserveNotificationWithNewReserveId:noti.ckeyid oldReserveId:noti.ckeyid isCancel:NO notification:nil type:AddReserveType success:nil failure:nil];
                    //获取消息
                    __weak typeof(self) weakSelf = self;
                    [self sendMessageWithNoti:noti cancel:^{
                        [weakSelf popToScheduleVc];
                    } certain:^(NSString *content, BOOL wenxinSend, BOOL messageSend) {
                        [SVProgressHUD showWithStatus:@"正在发送消息"];
                        [SysMessageTool sendMessageWithDoctorId:[AccountManager currentUserid] patientId:weakSelf.currentNoti.patient_id isWeixin:wenxinSend isSms:messageSend txtContent:content success:^(CRMHttpRespondModel *respond) {
                            if ([respond.code integerValue] == 200) {
                                [SVProgressHUD showImage:nil status:@"消息发送成功"];
                                //将消息保存在消息记录里
                                [weakSelf savaMessageToChatRecordWithPatient:patientTmp message:content];
                            }else{
                                [SVProgressHUD showImage:nil status:@"消息发送失败"];
                            }
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [weakSelf popToScheduleVc];
                            });
                        } failure:^(NSError *error) {
                            [SVProgressHUD showImage:nil status:error.localizedDescription];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [weakSelf popToScheduleVc];
                            });
                            if (error) {
                                NSLog(@"error:%@",error);
                            }
                        }];
                    }];
                }
            }
        }else{
            [self setButtonEnable:YES];
            [SVProgressHUD showErrorWithStatus:@"预约添加失败"];
        }
    } failure:^(NSError *error) {
        [self setButtonEnable:YES];
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - 转诊患者成功
- (void)transferPatientSuccessWithResult:(CRMHttpRespondModel *)resultModel send:(BOOL)send
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
            //修改所有病历的下次预约时间
            [self updateNextReserveTimeWithPatientId:self.currentNoti.patient_id time:self.currentNoti.reserve_time];
            
            //发送转诊成功的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:PatientTransferNotification object:nil];
            
            //发送转诊成功通知给医生
            if (self.isEditAppointment) {
                [SysMessageTool sendWeiXinReserveNotificationWithNewReserveId:self.currentNoti.ckeyid oldReserveId:self.localNoti.ckeyid isCancel:NO notification:nil type:UpdateReserveType success:nil failure:nil];
            }else{
                //发送微信给治疗医生
                [SysMessageTool sendWeiXinReserveNotificationWithNewReserveId:self.currentNoti.ckeyid oldReserveId:self.currentNoti.ckeyid isCancel:NO notification:nil type:AddReserveType success:^{} failure:^{}];
            }
            if (send) {
                //发送微信消息给患者，需要医生手动发送
                __weak typeof(self) weakSelf = self;
                [self sendMessageWithNoti:self.currentNoti cancel:^{
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(addReminderViewController:didUpdateReserveRecord:)]) {
                        [weakSelf.delegate addReminderViewController:weakSelf didUpdateReserveRecord:weakSelf.currentNoti];
                    }
                    [weakSelf popToScheduleVc];
                } certain:^(NSString *content, BOOL wenxinSend, BOOL messageSend) {
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(addReminderViewController:didUpdateReserveRecord:)]) {
                        [weakSelf.delegate addReminderViewController:weakSelf didUpdateReserveRecord:weakSelf.currentNoti];
                    }
                    [SVProgressHUD showWithStatus:@"正在发送消息"];
                    [SysMessageTool sendMessageWithDoctorId:[AccountManager currentUserid] patientId:weakSelf.currentNoti.patient_id isWeixin:wenxinSend isSms:messageSend txtContent:content success:^(CRMHttpRespondModel *respond) {
                        if ([respond.code integerValue] == 200) {
                            [SVProgressHUD showImage:nil status:@"消息发送成功"];
                            //将消息保存在消息记录里
                            [weakSelf savaMessageToChatRecordWithPatient:tmppatient message:content];
                        }else{
                            [SVProgressHUD showImage:nil status:@"消息发送失败"];
                        }
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf popToScheduleVc];
                        });
                    } failure:^(NSError *error) {
                        [SVProgressHUD showImage:nil status:error.localizedDescription];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf popToScheduleVc];
                        });
                        if (error) {
                            NSLog(@"error:%@",error);
                        }
                    }];
                }];
            }else{
                if (self.delegate && [self.delegate respondsToSelector:@selector(addReminderViewController:didUpdateReserveRecord:)]) {
                    [self.delegate addReminderViewController:self didUpdateReserveRecord:self.currentNoti];
                }
                [self popToScheduleVc];
            }
        }
    }
}

#pragma mark - 发送消息
- (void)sendMessageWithNoti:(LocalNotification *)noti cancel:(void(^)())cancel certain:(void(^)(NSString *content, BOOL wenxinSend, BOOL messageSend))certain{
    
    [DoctorTool yuYueMessagePatient:noti.patient_id fromDoctor:[AccountManager currentUserid] withMessageType:self.reserveTypeLabel.text withSendType:@"0" withSendTime:self.visitTimeLabel.text success:^(CRMHttpRespondModel *result) {
        
        XLCustomAlertView *alertView = [[XLCustomAlertView alloc] initWithTitle:@"提醒患者" message:result.result Cancel:@"不发送" certain:@"发送" weixinEnalbe:self.isBind type:CustonAlertViewTypeCheck cancelHandler:^{
            if (cancel) {
                cancel();
            }
        } certainHandler:^(NSString *content, BOOL wenxinSend, BOOL messageSend) {
            if (certain) {
                certain(content,wenxinSend,messageSend);
            }
        }];
        [alertView show];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - 将消息保存在消息记录中
- (void)savaMessageToChatRecordWithPatient:(Patient *)patient message:(NSString *)message{
    //将消息保存在消息记录里
    XLChatModel *chatModel = [[XLChatModel alloc] initWithReceiverId:patient.ckeyid receiverName:patient.patient_name content:message];
    [DoctorTool addNewChatRecordWithChatModel:chatModel success:nil failure:nil];
    //发送环信消息
    [EaseSDKHelper sendTextMessage:message
                                to:patient.ckeyid
                       messageType:eMessageTypeChat
                 requireEncryption:NO
                        messageExt:nil];
}

#pragma mark - 退出到日程表
- (void)popToScheduleVc{
    UITabBarController *rootVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC setSelectedViewController:[rootVC.viewControllers objectAtIndex:0]];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 向本地插入患者介绍人关系表
-(void)insertPatientIntroducerMap{
    PatientIntroducerMap *map = [[PatientIntroducerMap alloc]init];
    map.intr_id = [AccountManager currentUserid];
    map.intr_source = @"I";
    map.patient_id = self.currentNoti.patient_id;
    map.doctor_id = self.currentNoti.therapy_doctor_id;
    map.intr_time = [NSString currentDateString];
    [[DBManager shareInstance] insertPatientIntroducerMap:map];
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
        
        //修改文字颜色
        [self editReserveStyle];
        
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
    
    self.navigationController.navigationBar.translucent = YES;
    NSString *patient_id;
    if (!self.isNextReserve && !self.isAddLocationToPatient && !self.isEditAppointment) {
        //是添加预约时选择患者
        self.patientNameLabel.text = [LocalNotificationCenter shareInstance].selectPatient.patient_name;
        patient_id = [LocalNotificationCenter shareInstance].selectPatient.ckeyid;
    }else if(self.isAddLocationToPatient){
        //给指定患者添加预约
        patient_id = self.patient.ckeyid;
    }else{
        //修改预约
        patient_id = self.localNoti.patient_id;
    }
    if (![NSString isEmptyString:patient_id]) {
        //获取患者绑定微信的状态
        [MyPatientTool getWeixinStatusWithPatientId:patient_id success:^(CRMHttpRespondModel *respondModel) {
            if ([respondModel.result isEqualToString:@"1"]) {
                //绑定
                self.isBind = YES;
            }else{
                //未绑定
                self.isBind = NO;
            }
            
        } failure:^(NSError *error) {
            self.isBind = NO;
            //未绑定
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
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
    headerView.backgroundColor = [UIColor colorWithHex:VIEWCONTROLLER_BACKGROUNDCOLOR];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 30)];
    headerLabel.textColor = [UIColor colorWithHex:0x333333];
    headerLabel.backgroundColor = [UIColor colorWithHex:VIEWCONTROLLER_BACKGROUNDCOLOR];
    headerLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:headerLabel];
    
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
                XLDoctorLibraryViewController *docLibrary = [[XLDoctorLibraryViewController alloc] init];
                docLibrary.isTherapyDoctor = YES;
                docLibrary.delegate = self;
                [self pushViewController:docLibrary animated:YES];
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
                EditAllergyViewController *allergyVc = [[EditAllergyViewController alloc] init];
                allergyVc.title = @"备注";
                allergyVc.content = self.yuyueRemarkLabel.text;
                allergyVc.limit = 200;
                allergyVc.type = EditAllergyViewControllerRemark;
                allergyVc.delegate = self;
                [self pushViewController:allergyVc animated:YES];
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
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                self.hengYaVC = [storyboard instantiateViewControllerWithIdentifier:@"XLHengYaViewController"];
                self.hengYaVC.delegate = self;
                self.hengYaVC.hengYaString = self.yaweiNameLabel.text;
                [self.navigationController addChildViewController:self.hengYaVC];
                [self.navigationController.view addSubview:self.hengYaVC.view];
            }else if(indexPath.row == 2){
                //选择治疗项目
                XLReserveTypesViewController *reserceVC = [[XLReserveTypesViewController alloc] initWithStyle:UITableViewStylePlain];
                reserceVC.reserve_type = self.reserveTypeLabel.text;
                reserceVC.delegate = self;
                [self pushViewController:reserceVC animated:YES];
            }else{
                //选择治疗医生
                XLDoctorLibraryViewController *docLibrary = [[XLDoctorLibraryViewController alloc] init];
                docLibrary.isTherapyDoctor = YES;
                docLibrary.delegate = self;
                [self pushViewController:docLibrary animated:YES];
            }
        }else if (indexPath.section == 1){
            if (indexPath.row == 3) {
                //跳转到修改备注页面
                EditAllergyViewController *allergyVc = [[EditAllergyViewController alloc] init];
                allergyVc.title = @"备注";
                allergyVc.limit = 200;
                allergyVc.content = self.yuyueRemarkLabel.text;
                allergyVc.type = EditAllergyViewControllerRemark;
                allergyVc.delegate = self;
                [self pushViewController:allergyVc animated:YES];
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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    self.ruYaVC = [storyboard instantiateViewControllerWithIdentifier:@"XLRuYaViewController"];
    self.ruYaVC.delegate = self;
    self.ruYaVC.ruYaString = self.yaweiNameLabel.text;
    [self.navigationController addChildViewController:self.ruYaVC];
    [self.navigationController.view addSubview:self.ruYaVC.view];
}
-(void)changeToHengYaVC{
    [self removeRuYaVC];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    self.hengYaVC = [storyboard instantiateViewControllerWithIdentifier:@"XLHengYaViewController"];
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
- (void)doctorLibraryVc:(XLDoctorLibraryViewController *)doctorLibraryVc didSelectDoctor:(Doctor *)doctor{
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
    NSString *timeString = [NSString stringWithFormat:@"%0.0f",[[NSDate date] timeIntervalSince1970] * 1000];
    doctorId = [doctorId stringByAppendingString:@"_"];
    doctorId = [doctorId stringByAppendingString:timeString];
    return doctorId;
}

#pragma mark - EditAllergyViewControllerDelegate
- (void)editViewController:(EditAllergyViewController *)editVc didEditWithContent:(NSString *)content type:(EditAllergyViewControllerType)type{
    
    if (content.length > 300) {
        [SVProgressHUD showImage:nil status:@"备注信息过长，请重新输入"];
        return;
    }
    self.yuyueRemarkLabel.text = content;
}


#pragma mark - 添加预约成功之后，更新所有的病历数据中的下次预约时间
- (void)updateNextReserveTimeWithPatientId:(NSString *)patient_id time:(NSString *)time{
    //根据患者id获取病历数据
    NSArray *medicalCases = [[DBManager shareInstance] getMedicalCaseArrayWithPatientId:patient_id];
    for (MedicalCase *mCase in medicalCases) {
        //更新所有的病历数据的下次预约时间
        mCase.next_reserve_time = time;
        //更新数据库中的数据
        BOOL ret = [[DBManager shareInstance] updateMedicalCase:mCase];
        if (ret) {
            //自动更新数据
            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_MedicalCase postType:Update dataEntity:[mCase.keyValues JSONString] syncStatus:@"0"];
            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
        }
    }
}
#pragma mark - 添加预约和修改预约样式切换
- (void)editReserveStyle{
    self.patientNameLabel.textColor = EditTextColor;
    self.yaweiNameLabel.textColor = EditTextColor;
    self.reserveTypeLabel.textColor = EditTextColor;
    self.visitDurationLabel.textColor = EditTextColor;
    self.visitAddressLabel.textColor = EditTextColor;
    
    _yaweiTitle.textColor = EditTextColor;
    _nameTitle.textColor = EditTextColor;
    _reserTypeTitle.textColor = EditTextColor;
    _hospitalTitle.textColor = EditTextColor;
    _timeTitle.textColor = EditTextColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
