//
//  UnReadMessageViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "UnReadMessageViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefresh.h"
#import "SysMessageCell.h"
#import "SysMessageModel.h"
#import "SysMessageTool.h"
#import "AccountManager.h"
#import "CRMHttpRequest+Sync.h"
#import "NewFriendsViewController.h"
#import "InPatientNotification.h"
#import "CRMHttpRequest.h"
#import "DBManager+Patients.h"
#import "PatientDetailViewController.h"
#import "PatientsCellMode.h"
#import "MyPatientTool.h"
#import "XLPatientTotalInfoModel.h"
#import "DBTableMode.h"
#import "DBManager+Patients.h"
#import "CRMHttpRequest+Sync.h"
#import "PatientManager.h"
#import "DBManager+Materials.h"
#import "DBManager+LocalNotification.h"
#import "XLAppointDetailViewController.h"
#import "XLPatientAppointViewController.h"
#import "CRMMacro.h"
#import "DBManager+Doctor.h"
#import "SDWebImageManager.h"
#import "DoctorTool.h"
#import "DoctorInfoModel.h"
#import "XLNewFriendNotiViewController.h"
#import "MJRefresh.h"
#import "UITableView+NoResultAlert.h"

@interface UnReadMessageViewController ()

@property (nonatomic, strong)NSArray *dataList;

@end

@implementation UnReadMessageViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加通知
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //加载子控件
    [self initSubViews];
    
    //第一次加载
    [self.tableView.header beginRefreshing];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 加载子控件
- (void)initSubViews{
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerAction)];
    self.tableView.header.updatedTimeHidden = YES;
}

#pragma mark - 下拉刷新
- (void)headerAction{
    [self requestData];
}

- (void)requestData{
    [SysMessageTool getUnReadMessagesWithDoctorId:[[AccountManager shareInstance] currentUser].userid success:^(NSArray *result) {
        
        if ([self.tableView.header isRefreshing]) {
            [self.tableView.header endRefreshing];
        }
        self.dataList = result;
        //刷新表格
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        if ([self.tableView.header isRefreshing]) {
            [self.tableView.header endRefreshing];
        }
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView createNoResultWithImageName:@"message_alert.png" ifNecessaryForRowCount:self.dataList.count];
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SysMessageModel *model = self.dataList[indexPath.row];
    CGSize contentSize = [model.message_content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kScreenWidth - 10 * 2, MAXFLOAT)];
    if (contentSize.height + 5 + 20 + 10 + 10 > 60) {
        return contentSize.height + 5 + 20 + 10 + 10;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SysMessageCell *cell = [SysMessageCell cellWithTableView:tableView];
    
    SysMessageModel *model = self.dataList[indexPath.row];
    
    cell.model = model;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SysMessageModel *model = self.dataList[indexPath.row];
    
    //点击消息
    [self clickMessageActionWithModel:model];
}

- (void)clickMessageActionWithModel:(SysMessageModel *)msgModel{
    
    //判断消息的类型
    if ([msgModel.message_type isEqualToString:AttainNewPatient]) {
        //获取患者的id
        Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:msgModel.message_id];
        if (patient == nil) {
            //新增患者
            [SVProgressHUD showWithStatus:@"正在获取患者数据..."];
            //请求患者数据
            [MyPatientTool getPatientAllInfosWithPatientId:msgModel.message_id doctorID:[AccountManager currentUserid] success:^(CRMHttpRespondModel *respond) {
                if ([respond.code integerValue] == 200) {
                    NSMutableArray *arrayM = [NSMutableArray array];
                    for (NSDictionary *dic in respond.result) {
                        XLPatientTotalInfoModel *model = [XLPatientTotalInfoModel objectWithKeyValues:dic];
                        [arrayM addObject:model];
                    }
                    //请求成功后缓存患者信息
                    [self savePatientDataWithModel:arrayM[0] messageModel:msgModel];
                }else{
                    [self setMessageReadWithModel:msgModel noOperate:YES];
                    [SVProgressHUD showErrorWithStatus:respond.result];
                }
                
            } failure:^(NSError *error) {
                [SVProgressHUD showImage:nil status:error.localizedDescription];
                if (error) {
                    NSLog(@"error:%@",error);
                }
            }];
            
        }else{
            //将消息设置为已读
            [self setMessageReadWithModel:msgModel noOperate:NO];
        }
        
    }else if([msgModel.message_type isEqualToString:AttainNewFriend]){
        
        //判断本地是否有此好友
        Doctor *doc = [[DBManager shareInstance] getDoctorWithCkeyId:msgModel.message_id];
        if (doc == nil) {
            //下载医生信息，同时添加到数据库
            [SVProgressHUD showWithStatus:@"正在加载"];
            [DoctorTool requestDoctorInfoWithDoctorId:msgModel.message_id success:^(DoctorInfoModel *doctorInfo) {
                Doctor *doctor = [Doctor DoctorFromDoctorResult:doctorInfo.keyValues];
                if ([[DBManager shareInstance] insertDoctorWithDoctor:doctor]) {
                    [self setMessageReadWithModel:msgModel];
                }
            } failure:^(NSError *error) {
                [SVProgressHUD showImage:nil status:error.localizedDescription];
                if (error) {
                    NSLog(@"error:%@",error);
                }
            }];
        }else{
            [self setMessageReadWithModel:msgModel];
        }
    }
    else if ([msgModel.message_type isEqualToString:InsertReserveRecord]){
        //新增预约提醒
        // 1.直接获取预约信息
        [self getReserveRecordByReserveId:msgModel.message_id messageModel:msgModel];
        
    }else if ([msgModel.message_type isEqualToString:UpdateReserveRecord]){
        //修改预约提醒
        NSString *oldReserveId = [msgModel.message_id componentsSeparatedByString:@","][0];
        NSString *newReserveId = [msgModel.message_id componentsSeparatedByString:@","][1];
        // 1.根据旧的预约id，更新预约信息的状态
        LocalNotification *oldNoti = [[DBManager shareInstance] getLocalNotificationWithCkeyId:oldReserveId];
        if (oldNoti != nil) {
            oldNoti.reserve_status = @"1";
            [[LocalNotificationCenter shareInstance] removeLocalNotification:oldNoti];
        }
        // 2.根据新的预约id，下载最新的预约信息保存到本地
        [self getReserveRecordByReserveId:newReserveId messageModel:msgModel];
        
    }else if ([msgModel.message_type isEqualToString:CancelReserveRecord]){
        //删除预约
        NSString *reserve_id = [msgModel.message_id componentsSeparatedByString:@","][1];
        // 1.删除本地的预约信息
        LocalNotification *localNoti = [[DBManager shareInstance] getLocalNotificationWithCkeyId:reserve_id];
        if (localNoti != nil) {
            [[LocalNotificationCenter shareInstance] cancelNotification:localNoti];
            [[DBManager shareInstance] deleteLocalNotification_Sync:localNoti];
        }
        //设置消息已读
        [self setMessageReadWithModel:msgModel noOperate:NO];
        
    }
}

#pragma mark - 新增好友设置已读并且跳转
- (void)setMessageReadWithModel:(SysMessageModel *)model{
    __weak typeof(self) weakSelf = self;
    [SysMessageTool setMessageReadedWithMessageId:model.keyId success:^(CRMHttpRespondModel *respond) {
        [SVProgressHUD dismiss];
        //重新请求数据
        [weakSelf requestData];
        //新增好友
        XLNewFriendNotiViewController *newFriendVc = [[XLNewFriendNotiViewController alloc] initWithStyle:UITableViewStylePlain];
        [weakSelf.navigationController pushViewController:newFriendVc animated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - 设置消息已读
- (void)setMessageReadWithModel:(SysMessageModel *)model noOperate:(BOOL)noOperate{
    //将消息设置为已读
    WS(weakSelf);
    [SysMessageTool setMessageReadedWithMessageId:model.keyId success:^(CRMHttpRespondModel *respond) {
        [SVProgressHUD dismiss];
        //重新请求数据
        [weakSelf requestData];
        if (!noOperate) {
            if ([model.message_type isEqualToString:AttainNewPatient]) {
                //跳转到新的患者详情页面
                PatientsCellMode *cellModel = [[PatientsCellMode alloc] init];
                cellModel.patientId = model.message_id;
                PatientDetailViewController *detailVc = [[PatientDetailViewController alloc] init];
                detailVc.patientsCellMode = cellModel;
                detailVc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:detailVc animated:YES];
            }else if ([model.message_type isEqualToString:CancelReserveRecord]){
                // 2.跳转到患者预约列表
                XLPatientAppointViewController *appointVc = [[XLPatientAppointViewController alloc] initWithStyle:UITableViewStylePlain];
                appointVc.patient_id = [model.message_id componentsSeparatedByString:@","][0];
                [weakSelf.navigationController pushViewController:appointVc animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationDeleted object:nil];
                
            }else if ([model.message_type isEqualToString:InsertReserveRecord] || [model.message_type isEqualToString:UpdateReserveRecord]){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCreated object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOtificationUpdated object:nil];
                
                LocalNotification *local = [[DBManager shareInstance] getLocalNotificationWithCkeyId:model.message_id];
                //跳转到预约详情页面
                XLAppointDetailViewController *detailVc = [[XLAppointDetailViewController alloc] initWithStyle:UITableViewStylePlain];
                detailVc.localNoti = local;
                [weakSelf.navigationController pushViewController:detailVc animated:YES];
            }
        }
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:ReadUnReadMessageSuccessNotification object:nil];
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - 请求预约信息
- (void)getReserveRecordByReserveId:(NSString *)reserve_id messageModel:(SysMessageModel *)msgModel{
    [SVProgressHUD showWithStatus:@"正在获取预约信息"];
    [SysMessageTool getReserveRecordByReserveId:reserve_id success:^(CRMHttpRespondModel *respond) {
        if ([respond.code integerValue] == 200) {
            //将预约信息保存到本地
            LocalNotification *local = [LocalNotification LNFromLNFResult:respond.result];
            [[DBManager shareInstance] insertLocalNotification:local];
            //判断患者是否存在
            Patient *patient = [[DBManager shareInstance] getPatientCkeyid:local.patient_id];
            if (patient == nil) {
                //获取所有的患者信息，同时保存到本地
                [MyPatientTool getPatientAllInfosWithPatientId:local.patient_id doctorID:[AccountManager currentUserid] success:^(CRMHttpRespondModel *respond) {
                    if ([respond.code integerValue] == 200) {
                        NSMutableArray *arrayM = [NSMutableArray array];
                        for (NSDictionary *dic in respond.result) {
                            XLPatientTotalInfoModel *model = [XLPatientTotalInfoModel objectWithKeyValues:dic];
                            [arrayM addObject:model];
                        }
                        //请求成功后缓存患者信息
                        [self savePatientDataWithModel:arrayM[0] messageModel:msgModel];
                    }else{
                        [SVProgressHUD showErrorWithStatus:respond.result];
                    }
                } failure:^(NSError *error) {
                    [SVProgressHUD showImage:nil status:error.localizedDescription];
                    if (error) {
                        NSLog(@"error:%@",error);
                    }
                }];
            }else{
                //设置已读
                [SVProgressHUD showErrorWithStatus:@"该预约已被取消"];
                [self setMessageReadWithModel:msgModel noOperate:NO];
                
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"预约信息获取失败"];
            //设置已读
            [self setMessageReadWithModel:msgModel noOperate:YES];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - 缓存患者信息
- (void)savePatientDataWithModel:(XLPatientTotalInfoModel *)model messageModel:(SysMessageModel *)msgModel{
    BOOL ret = [[DBManager shareInstance] saveAllDownloadPatientInfoWithPatientModel:model];
    if (ret) {
        //设置已读
        [self setMessageReadWithModel:msgModel noOperate:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:PatientCreatedNotification object:nil];
    }else{
        [SVProgressHUD showErrorWithStatus:@"患者信息获取失败!"];
    }
}

//获取图片
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

@end
