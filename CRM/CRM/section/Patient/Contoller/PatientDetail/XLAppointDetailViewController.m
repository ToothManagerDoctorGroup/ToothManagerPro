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

#define AddReserveType @"新增预约"
#define CancelReserveType @"取消预约"
#define UpdateReserveType @"修改预约"

@interface XLAppointDetailViewController ()<UIAlertViewDelegate,XLAddReminderViewControllerDelegate>

@property (nonatomic, strong)NSMutableArray *dataList;
@property (nonatomic, strong)NSArray *titles;

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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)setUpNav{
    self.title = @"预约详情";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.view.backgroundColor = MyColor(238, 238, 238);
    
    self.titles = @[@"时间",@"患者",@"牙位",@"事项",@"预约时长",@"医院",@"治疗医生",@"备注"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestLocalDataWithNoti:self.localNoti];
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
            if ([patient.nickName isNotEmpty]) {
                model.content = [NSString stringWithFormat:@"%@(%@)",patient.patient_name,patient.nickName];
            }else{
                model.content = patient.patient_name;
            }
        }else if (i == 2){
            model.content = notification.tooth_position;
        }else if (i == 3){
            model.content = notification.reserve_type;
        }else if (i == 4){
            model.content = [NSString stringWithFormat:@"%@小时",notification.duration];
        }else if (i == 5){
            model.content = notification.medical_place;
        }else if(i == 6){
            model.content = notification.therapy_doctor_name;
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
    if (contentSize.height > 40) {
        return contentSize.height;
    }else{
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XLAppointDetailCell *cell = [XLAppointDetailCell cellWithTableView:tableView];
    XLAppointDetailModel *model = self.dataList[indexPath.row];

    cell.model = model;
    
    return cell;
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) return;
    [SVProgressHUD showWithStatus:@"正在取消预约，请稍候..."];
    [[XLAutoSyncTool shareInstance] deleteAllNeedSyncReserve_record:self.localNoti success:^(CRMHttpRespondModel *respond) {
        if ([respond.code integerValue] == 200) {
            //删除预约成功后
            [SysMessageTool sendWeiXinReserveNotificationWithNewReserveId:self.localNoti.ckeyid oldReserveId:self.localNoti.ckeyid isCancel:YES notification:self.localNoti type:CancelReserveType success:nil failure:nil];
            //删除预约信息
            if([[DBManager shareInstance] deleteLocalNotification_Sync:self.localNoti]){
                [[LocalNotificationCenter shareInstance] cancelNotification:self.localNoti];
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationDeleted object:nil];
                
                [SVProgressHUD showSuccessWithStatus:@"预约取消成功"];
                [self popViewControllerAnimated:YES];
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

#pragma mark - XLAddReminderViewControllerDelegate
- (void)addReminderViewController:(XLAddReminderViewController *)vc didUpdateReserveRecord:(LocalNotification *)localNoti{
    self.localNoti = localNoti;
    [self requestLocalDataWithNoti:localNoti];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
