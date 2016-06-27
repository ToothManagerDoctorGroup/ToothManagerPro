//
//  XLClinicAppointDetailViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/5/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLClinicAppointDetailViewController.h"
#import "MyBillTool.h"
#import "BillDetailModel.h"
#import "MaterialModel.h"
#import "AssistModel.h"
#import "PatientDetailViewController.h"
#import "XLClinicDetailViewController.h"
#import "UIColor+Extension.h"
#import "CRMHttpRespondModel.h"
#import "DBTableMode.h"
#import "DBManager+Patients.h"
#import "XLAutoSyncTool+XLDelete.h"
#import "DBManager+LocalNotification.h"
#import "SysMessageTool.h"
#import "DoctorTool.h"
#import "XLChatModel.h"
#import "XLCustomAlertView.h"
#import "MyPatientTool.h"

@interface XLClinicAppointDetailViewController ()
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//患者姓名
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
//牙位
@property (weak, nonatomic) IBOutlet UILabel *toothPositionLabel;
//预约类型
@property (weak, nonatomic) IBOutlet UILabel *reserveTypeLabel;
//预约时长
@property (weak, nonatomic) IBOutlet UILabel *appointTimeLabel;
//医院
@property (weak, nonatomic) IBOutlet UILabel *medicalPlaceLabel;
//椅位
@property (weak, nonatomic) IBOutlet UILabel *chairLabel;
//耗材
@property (weak, nonatomic) IBOutlet UILabel *materialLabel;
//助手
@property (weak, nonatomic) IBOutlet UILabel *assistLabel;
//备注
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (nonatomic, strong)BillDetailModel *currentModel;


@property (nonatomic, strong)UIButton *deleteButton;

@property (nonatomic, assign)BOOL isBind;

@end

@implementation XLClinicAppointDetailViewController

#pragma mark - ********************* Life Method ***********************
- (void)viewDidLoad {
    [super viewDidLoad];
   //初始化子视图
    [self setUpSubViews];
    //加载数据
    [self requestAppointData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - ********************* Private Method ***********************
#pragma mark 初始化子视图
- (void)setUpSubViews{
    self.title = @"预约详情";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
    //设置取消预约按钮
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    footerView.backgroundColor = [UIColor clearColor];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(20, 0, kScreenWidth - 20 * 2, 40);
    deleteBtn.backgroundColor = [UIColor colorWithHex:0xff5652];
    [deleteBtn setTitle:@"取消预约" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.layer.cornerRadius = 5;
    deleteBtn.layer.masksToBounds = YES;
    self.deleteButton = deleteBtn;
    [footerView addSubview:deleteBtn];
    
    self.tableView.tableFooterView = footerView;
}
#pragma mark 删除预约
- (void)deleteBtnAction{
    WS(weakSelf);
    TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"取消预约" message:@"确认取消预约吗？" cancelHandler:^{
    } comfirmButtonHandlder:^{
        [SVProgressHUD showWithStatus:@"正在取消预约"];
        [MyPatientTool getWeixinStatusWithPatientId:self.currentModel.patient_id success:^(CRMHttpRespondModel *respondModel) {
            if ([respondModel.result isEqualToString:@"1"]) {
                //绑定
                self.isBind = YES;
            }else{
                //未绑定
                self.isBind = NO;
            }
            
            [MyBillTool cancleAppointWithAppointId:self.currentModel.KeyId success:^(CRMHttpRespondModel *respond) {
                if ([respond.code integerValue] == 200) {
                    [weakSelf cancelAppointment];
                }else{
                    [SVProgressHUD showImage:nil status:@"预约取消失败"];
                }
            } failure:^(NSError *error) {
                [SVProgressHUD showImage:nil status:error.localizedDescription];
                if (error) {
                    NSLog(@"error:%@",error);
                }
            }];
            
        } failure:^(NSError *error) {
            self.isBind = NO;
            [SVProgressHUD showImage:nil status:error.localizedDescription];
            //未绑定
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }];
    [alertView show];
}

#pragma mark  取消预约
- (void)cancelAppointment{
    Patient *patientTmp = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.localNoti.patient_id];
    [[XLAutoSyncTool shareInstance] deleteAllNeedSyncReserve_record:self.localNoti success:^(CRMHttpRespondModel *respond) {
        if ([respond.code integerValue] == 200) {
            //删除预约成功后，发送给医生信息
            [SysMessageTool sendWeiXinReserveNotificationWithNewReserveId:self.localNoti.ckeyid oldReserveId:self.localNoti.ckeyid isCancel:YES notification:self.localNoti type:CancelReserveType success:nil failure:nil];
            //删除预约信息
            if([[DBManager shareInstance] deleteLocalNotification_Sync:self.localNoti]){
                [[LocalNotificationCenter shareInstance] cancelNotification:self.localNoti];
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationDeleted object:nil];
                
                [SVProgressHUD showSuccessWithStatus:@"预约取消成功"];
                __weak typeof(self) weakSelf = self;
                [DoctorTool yuYueMessagePatient:self.localNoti.patient_id fromDoctor:[AccountManager currentUserid] withMessageType:@"取消预约" withSendType:@"0" withSendTime:self.localNoti.reserve_time success:^(CRMHttpRespondModel *result) {
                    
                    XLCustomAlertView *alertView = [[XLCustomAlertView alloc] initWithTitle:@"提醒患者" message:result.result Cancel:@"不发送" certain:@"发送" weixinEnalbe:self.isBind type:CustonAlertViewTypeCheck cancelHandler:^{
                        [self popViewControllerAnimated:YES];
                    } certainHandler:^(NSString *content, BOOL wenxinSend, BOOL messageSend) {
                        [SVProgressHUD  showWithStatus:@"正在发送消息"];
                        [SysMessageTool sendMessageWithDoctorId:[AccountManager currentUserid] patientId:weakSelf.localNoti.patient_id isWeixin:wenxinSend isSms:messageSend txtContent:content success:^(CRMHttpRespondModel *respond) {
                            
                            if ([respond.code integerValue] == 200) {
                                [SVProgressHUD showImage:nil status:@"消息发送成功"];
                                //将消息保存在消息记录里
                                [weakSelf savaMessageToChatRecordWithPatient:patientTmp message:content];
                            }else{
                                [SVProgressHUD showImage:nil status:@"消息发送失败"];
                            }
                            [weakSelf popViewControllerAnimated:YES];
                        } failure:^(NSError *error) {
                            [SVProgressHUD showImage:nil status:@"消息发送失败"];
                            [weakSelf popViewControllerAnimated:YES];
                            if (error) {
                                NSLog(@"error:%@",error);
                            }
                        }];
                    }];
                    [alertView show];
                    
                } failure:^(NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"提醒内容获取失败，请检查网络设置"];
                    [self popViewControllerAnimated:YES];
                    if (error) {
                        NSLog(@"error:%@",error);
                    }
                }];
            }
        }else{
            [SVProgressHUD showSuccessWithStatus:@"预约取消失败"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"预约取消失败"];
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

#pragma mark 加载诊所数据
- (void)requestAppointData{
    [SVProgressHUD showWithStatus:@"正在加载"];
    [MyBillTool requestBillDetailWithBillId:self.localNoti.clinic_reserve_id success:^(BillDetailModel *billDetail) {
        [SVProgressHUD dismiss];
        
        self.currentModel = billDetail;
        //设置控件的数据
        self.timeLabel.text = billDetail.reserve_time;
        self.patientNameLabel.text = billDetail.patient_name;
        self.toothPositionLabel.text = billDetail.tooth_position;
        self.reserveTypeLabel.text = billDetail.reserve_type;
        self.appointTimeLabel.text = [NSString stringWithFormat:@"%@小时",billDetail.reserve_duration];
        self.medicalPlaceLabel.text = billDetail.clinic_name;
        self.chairLabel.text = billDetail.seat_name;
        
        if (billDetail.materials.count > 0) {
            NSString *materialStr = @"";
            for (MaterialModel *material in billDetail.materials) {
                materialStr = [materialStr stringByAppendingFormat:@"%@%@个 ",material.mat_name,material.actual_num];
            }
            self.materialLabel.text = materialStr;
        }
        
        if (billDetail.assists.count > 0) {
            NSString *assistStr = @"";
            for (AssistModel *assist in billDetail.assists) {
                assistStr = [assistStr stringByAppendingFormat:@"%@%@人 ",assist.assist_name,assist.actual_num];
            }
            self.assistLabel.text = assistStr;
        }
        
        //判断预约状态
        if ([billDetail.reserve_status integerValue] > 0) {
            [self.deleteButton setTitle:@"预约已开始" forState:UIControlStateNormal];
            self.deleteButton.backgroundColor = [UIColor grayColor];
            self.deleteButton.userInteractionEnabled = NO;
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - ******************* Delegate / DataSource *****************
#pragma mark UITableViewDelegate/DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        //跳转到患者详情页面
        PatientsCellMode *cellModel = [[PatientsCellMode alloc] init];
        cellModel.patientId = self.currentModel.patient_id;
        PatientDetailViewController *detailVc = [[PatientDetailViewController alloc] init];
        detailVc.patientsCellMode = cellModel;
        [self.navigationController pushViewController:detailVc animated:YES];
    }else if (indexPath.row == 5){
        //跳转到诊所详情
        XLClinicDetailViewController *detailVC = [[XLClinicDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        detailVC.clinicId = self.currentModel.clinic_id;
        detailVC.title = self.currentModel.clinic_name;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}


- (void)setHideCancelButton:(BOOL)hideCancelButton{
    _hideCancelButton = hideCancelButton;
    if(hideCancelButton){
        self.tableView.tableFooterView = nil;
    }

}
@end
