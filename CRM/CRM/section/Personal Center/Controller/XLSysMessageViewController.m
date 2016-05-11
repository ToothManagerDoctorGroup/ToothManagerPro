//
//  XLSysMessageViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/5/10.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLSysMessageViewController.h"
#import "UITableView+NoResultAlert.h"
#import "MJRefresh.h"
#import "SysMessageTool.h"
#import "AccountManager.h"
#import "SysMessageCell.h"
#import "SysMessageModel.h"
#import "DBManager+Patients.h"
#import "PatientDetailViewController.h"
#import "XLAppointDetailViewController.h"
#import "XLPatientAppointViewController.h"
#import "NewFriendsViewController.h"
#import "DBManager+LocalNotification.h"
#import "MyPatientTool.h"
#import "XLPatientTotalInfoModel.h"
#import "DBManager+Doctor.h"
#import "DoctorTool.h"
#import "DoctorInfoModel.h"
#import "XLNewFriendNotiViewController.h"
#import "DBManager+LocalNotification.h"

static const NSInteger SysMessageViewControllerPageSize = 30;

@interface XLSysMessageViewController ()

@property (nonatomic, strong)NSMutableArray *dataList;
@property (nonatomic, assign)int pageIndex;
@property (nonatomic, weak)UIView *noResultAlertView;

@end

@implementation XLSysMessageViewController

#pragma mark - ********************* Life Method ***********************
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    [self setUpViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ********************* Private Method ***********************
- (void)setUpViews{
    self.title = @"我的消息";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.noResultAlertView = [self.tableView createNoResultAlertViewWithImageName:@"noMessage_alert.png" top:60 showButton:NO buttonClickBlock:nil];
    
    self.pageIndex = 1;
    //添加头部刷新控件
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
    [self.tableView.legendHeader beginRefreshing];
}
#pragma mark 加载数据
- (void)requstDataIsHeader:(BOOL)isHeader{
    WS(weakSelf);
    XLMessageQueryModel *queryModel = [[XLMessageQueryModel alloc] initWithIsRead:@(2) syncTime:@"" sortField:@"create_time" isAsc:NO pageIndex:self.pageIndex pageSize:SysMessageViewControllerPageSize];
    [SysMessageTool getMessageByQueryModel:queryModel success:^(NSArray *result) {
        if (isHeader) {
            [weakSelf.dataList removeAllObjects];
            if (result.count > 0) {
                weakSelf.noResultAlertView.hidden = YES;
            }else{
                weakSelf.noResultAlertView.hidden = NO;
            }
            
            if (result.count < SysMessageViewControllerPageSize) {
                [weakSelf.tableView removeFooter];
            }else{
                //添加上拉加载的控件
                [weakSelf.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction)];
            }
        }
        [weakSelf.dataList addObjectsFromArray:result];
        
        if ([weakSelf.tableView.header isRefreshing]) {
            [weakSelf.tableView.header endRefreshing];
        }else if ([weakSelf.tableView.footer isRefreshing]){
            [weakSelf.tableView.footer endRefreshing];
        }
        
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark 下拉刷新
- (void)headerRefreshAction{
    self.pageIndex = 1;
    [self.dataList removeAllObjects];
    [self requstDataIsHeader:YES];
}
#pragma mark 上拉加载
- (void)footerRefreshAction{
    self.pageIndex++;
    [self requstDataIsHeader:NO];
}

#pragma mark 已读消息点击事件
- (void)clickReadedMessageActionWithModel:(SysMessageModel *)model{
    //判断消息的类型
    if ([model.message_type isEqualToString:AttainNewPatient]) {
        Patient *patient = [[DBManager shareInstance] getPatientCkeyid:model.message_id];
        if (patient == nil) {
            [SVProgressHUD showErrorWithStatus:@"患者不存在"];
            return;
        }
        //跳转到新的患者详情页面
        PatientsCellMode *cellModel = [[PatientsCellMode alloc] init];
        cellModel.patientId = model.message_id;
        PatientDetailViewController *detailVc = [[PatientDetailViewController alloc] init];
        detailVc.patientsCellMode = cellModel;
        detailVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVc animated:YES];
        
    }else if([model.message_type isEqualToString:AttainNewFriend]){
        //新增好友
        NewFriendsViewController *newFriendVc = [[NewFriendsViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:newFriendVc animated:YES];
    }
    
    else if ([model.message_type isEqualToString:InsertReserveRecord] || [model.message_type isEqualToString:UpdateReserveRecord]){
        LocalNotification *local = [[DBManager shareInstance] getLocalNotificationWithCkeyId:model.message_id];
        //跳转到预约详情页面
        XLAppointDetailViewController *detailVc = [[XLAppointDetailViewController alloc] initWithStyle:UITableViewStylePlain];
        detailVc.localNoti = local;
        [self.navigationController pushViewController:detailVc animated:YES];
        
    }else if ([model.message_type isEqualToString:CancelReserveRecord]){
        // 2.跳转到患者预约列表
        XLPatientAppointViewController *appointVc = [[XLPatientAppointViewController alloc] initWithStyle:UITableViewStylePlain];
        appointVc.patient_id = [model.message_id componentsSeparatedByString:@","][0];
        [self.navigationController pushViewController:appointVc animated:YES];
    }
}
#pragma mark 未读消息点击事件
- (void)clickUnReadMessageActionWithModel:(SysMessageModel *)msgModel{
    
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
                    [self setMessageReadWithModel:msgModel noOperate:NO];
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
                    [self setMessageReadWithModel:msgModel noOperate:NO];
                }
            } failure:^(NSError *error) {
                [SVProgressHUD showImage:nil status:error.localizedDescription];
                if (error) {
                    NSLog(@"error:%@",error);
                }
            }];
        }else{
            [self setMessageReadWithModel:msgModel noOperate:NO];
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

#pragma mark 设置消息已读
- (void)setMessageReadWithModel:(SysMessageModel *)model noOperate:(BOOL)noOperate{
    //将消息设置为已读
    WS(weakSelf);
    [SysMessageTool setMessageReadedWithMessageId:model.keyId success:^(CRMHttpRespondModel *respond) {
        //刷新当前单元格
        model.is_read = 1;
        [weakSelf.tableView reloadData];
        
        [SVProgressHUD dismiss];
        //重新请求数据
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
                
            }else if ([model.message_type isEqualToString:InsertReserveRecord] || [model.message_type isEqualToString:UpdateReserveRecord]){
                LocalNotification *local = [[DBManager shareInstance] getLocalNotificationWithCkeyId:model.message_id];
                //跳转到预约详情页面
                XLAppointDetailViewController *detailVc = [[XLAppointDetailViewController alloc] initWithStyle:UITableViewStylePlain];
                detailVc.localNoti = local;
                [weakSelf.navigationController pushViewController:detailVc animated:YES];
            }else{
                //新增好友
                XLNewFriendNotiViewController *newFriendVc = [[XLNewFriendNotiViewController alloc] initWithStyle:UITableViewStylePlain];
                [weakSelf.navigationController pushViewController:newFriendVc animated:YES];
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark 请求预约信息
- (void)getReserveRecordByReserveId:(NSString *)reserve_id messageModel:(SysMessageModel *)msgModel{
    
    //判断预约消息是否存在
    LocalNotification *noti = [[DBManager shareInstance] getLocalNotificationWithCkeyId:reserve_id];
    if (noti != nil){
        //设置已读
        [self setMessageReadWithModel:msgModel noOperate:YES];
        return;
    }
    
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

#pragma mark 缓存患者信息
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

#pragma mark - ******************** Delegate / DataSource *******************
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SysMessageModel *model = self.dataList[indexPath.row];
    return [SysMessageCell cellHeightWithModel:model];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SysMessageModel *model = self.dataList[indexPath.row];
    
    SysMessageCell *cell = [SysMessageCell cellWithTableView:tableView];
    
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SysMessageModel *model = self.dataList[indexPath.row];
    
    if (model.is_read == 1) {
        [self clickReadedMessageActionWithModel:model];
    }else{
        [self clickUnReadMessageActionWithModel:model];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    SysMessageModel *model = self.dataList[indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"确认删除此消息吗？" message:nil cancelHandler:^{
        } comfirmButtonHandlder:^{
            [SysMessageTool deleteMessageWithMessageId:model.keyId success:^(CRMHttpRespondModel *respond) {
                if ([respond.code integerValue] == 200) {
                    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                    [self.dataList removeAllObjects];
                    self.pageIndex = 1;
                    [self requstDataIsHeader:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"删除失败"];
                }
            } failure:^(NSError *error) {
                [SVProgressHUD showImage:nil status:error.localizedDescription];
                if (error) {
                    NSLog(@"error:%@",error);
                }
            }];
        }];
        [alertView show];
    }
}

#pragma mark - ********************* Lazy Method ***********************
- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
