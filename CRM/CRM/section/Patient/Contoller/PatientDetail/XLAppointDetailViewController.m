//
//  XLAppointDetailViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAppointDetailViewController.h"
#import "XLAppointDetailCell.h"
#import "UIColor+Extension.h"
#import "XLAppointDetailModel.h"
#import "LocalNotificationCenter.h"
#import "DBManager+Patients.h"
#import "DBManager+LocalNotification.h"
#import "LocalNotificationCenter.h"
#import "DBManager+AutoSync.h"
#import "MJExtension.h"
#import "JSONKit.h"
#import "DBTableMode.h"
#import "CRMMacro.h"
#import "XLAddReminderViewController.h"
#import "XLAutoSyncTool+XLDelete.h"
#import "SysMessageTool.h"
#import "XLEventStoreManager.h"
#import "DBManager+Doctor.h"
#import "DoctorTool.h"
#import "MyDateTool.h"
#import "XLCustomAlertView.h"
#import "MyPatientTool.h"
#import "SysMessageTool.h"
#import "PatientDetailViewController.h"
#import "PatientsCellMode.h"
#import "XLChatModel.h"


@interface XLAppointDetailViewController ()<UIAlertViewDelegate,XLAddReminderViewControllerDelegate>

@property (nonatomic, strong)NSMutableArray *dataList;
@property (nonatomic, strong)NSArray *titles;

@property (nonatomic, assign)BOOL isBind;//是否绑定微信

@end

@implementation XLAppointDetailViewController

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setUpNav];
    
    //设置子控件
    [self initSubViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestLocalDataWithNoti:self.localNoti];
    //获取患者绑定微信的状态
    __weak typeof(self) weakSelf = self;
    [MyPatientTool getWeixinStatusWithPatientId:self.localNoti.patient_id success:^(CRMHttpRespondModel *respondModel) {
        if ([respondModel.result isEqualToString:@"1"]) {
            //绑定
            weakSelf.isBind = YES;
        }else{
            //未绑定
            weakSelf.isBind = NO;
        }
        
    } failure:^(NSError *error) {
        weakSelf.isBind = NO;
        //未绑定
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];

}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)setUpNav{
    self.title = @"预约详情";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
    self.titles = @[@"时间",@"患者",@"牙位",@"事项",@"预约时长",@"治疗医生",@"预约人",@"医院",@"备注"];
}

- (void)requestLocalDataWithNoti:(LocalNotification *)noti{
    [self.dataList removeAllObjects];
    //获取当前的预约信息
    LocalNotification *notification = [[DBManager shareInstance] getLocalNotificationWithCkeyId:noti.ckeyid];
    for (int i = 0; i < self.titles.count; i++) {
        XLAppointDetailModel *model = [[XLAppointDetailModel alloc] init];
        model.title = self.titles[i];
        if (i == 0) {
            model.content = notification.reserve_time;
        }else if (i == 1){
            Patient *patient = [[DBManager shareInstance] getPatientCkeyid:notification.patient_id];
            model.content = patient.patient_name;
        }else if (i == 2){
            model.content = notification.tooth_position;
        }else if (i == 3){
            model.content = notification.reserve_type;
        }else if (i == 4){
            model.content = [self formatterDuration:notification.duration];
        }else if (i == 5){
            model.content = notification.therapy_doctor_name;
        }else if(i == 6){
            //预约人
            if ([notification.doctor_id isEqualToString:[AccountManager currentUserid]]) {
                model.content = [[AccountManager shareInstance] currentUser].name;
            }else{
                Doctor *doc = [[DBManager shareInstance] getDoctorWithCkeyId:notification.doctor_id];
                if (doc != nil) {
                    model.content = doc.doctor_name;
                }
            }
        }else if(i == 7){
            model.content = notification.medical_place;
        }else{
            model.content = notification.reserve_content;
        }
        [self.dataList addObject:model];
    }
    [self.tableView reloadData];
}

- (void)initSubViews{

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    footerView.backgroundColor = [UIColor clearColor];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(20, 10, (kScreenWidth - 20 * 2 - 15) / 2, 40);
    deleteBtn.backgroundColor = [UIColor colorWithHex:0xff5652];
    [deleteBtn setTitle:@"取消预约" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.layer.cornerRadius = 5;
    deleteBtn.layer.masksToBounds = YES;
    [footerView addSubview:deleteBtn];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(deleteBtn.right + 15, 10, (kScreenWidth - 20 * 2 - 15) / 2, 40);
    editBtn.backgroundColor = [UIColor colorWithHex:0x00a0ea];
    [editBtn setTitle:@"修改预约" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    editBtn.layer.cornerRadius = 5;
    editBtn.layer.masksToBounds = YES;
    [editBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:editBtn];
    
    self.tableView.tableFooterView = footerView;
}

#pragma mark - ********************* Private Method ***********************
#pragma mark 格式化预约时长
- (NSString *)formatterDuration:(NSString *)duraction{
    NSString *temp = nil;
    if ([duraction isEqualToString:@"0.5"]) {
        temp = @"30分钟";
    }else if ([duraction isEqualToString:@"1.0"]){
        temp = @"1小时";
    }else if ([duraction isEqualToString:@"1.5"]){
        temp = @"90分钟";
    }else if ([duraction isEqualToString:@"2.0"]){
        temp = @"2小时";
    }
    return temp;
}
#pragma mark - 按钮点击事件
- (void)deleteBtnAction{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"取消预约" message:@"确认取消预约吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}

- (void)editBtnAction{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    XLAddReminderViewController *addreminderVc = [storyboard instantiateViewControllerWithIdentifier:@"XLAddReminderViewController"];
    addreminderVc.isEditAppointment = YES;
    addreminderVc.localNoti = self.localNoti;
    addreminderVc.delegate = self;
    [self pushViewController:addreminderVc animated:YES];
}

#pragma mark - UITableViewDataSource / Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     XLAppointDetailModel *model = self.dataList[indexPath.row];
    NSString *commonTitle = @"治疗项目";
    CGFloat commomW = [commonTitle sizeWithFont:[UIFont systemFontOfSize:15]].width;
    CGFloat contentW = kScreenWidth - commomW - 10 * 3;
    CGSize contentSize = [model.content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(contentW, MAXFLOAT)];
    if (contentSize.height > 44) {
        return contentSize.height;
    }else{
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XLAppointDetailCell *cell = [XLAppointDetailCell cellWithTableView:tableView];
    if (indexPath.row == 1) {
        cell.ShowAccessoryView = YES;
    }else{
        cell.ShowAccessoryView = NO;
    }
    XLAppointDetailModel *model = self.dataList[indexPath.row];

    cell.model = model;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        //跳转到患者详情页面
        PatientsCellMode *cellModel = [[PatientsCellMode alloc] init];
        cellModel.patientId = self.localNoti.patient_id;
        PatientDetailViewController *detailVc = [[PatientDetailViewController alloc] init];
        detailVc.patientsCellMode = cellModel;
        detailVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) return;
    
    Patient *patientTmp = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.localNoti.patient_id];
    [SVProgressHUD showWithStatus:@"正在取消预约，请稍候..."];
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

#pragma mark - XLAddReminderViewControllerDelegate
- (void)addReminderViewController:(XLAddReminderViewController *)vc didUpdateReserveRecord:(LocalNotification *)localNoti{
    self.localNoti = localNoti;
    [self requestLocalDataWithNoti:localNoti];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
