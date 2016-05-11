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
- (void)requstData{
    WS(weakSelf);
    [SysMessageTool getReadedMessagesWithDoctorId:[[AccountManager shareInstance] currentUser].userid pageIndex:self.pageIndex pageSize:SysMessageViewControllerPageSize success:^(NSArray *result) {
        if (result.count > 0) {
            [weakSelf.dataList addObjectsFromArray:result];
            weakSelf.noResultAlertView.hidden = YES;
        }else{
            weakSelf.noResultAlertView.hidden = NO;
        }
        if ([weakSelf.tableView.header isRefreshing]) {
            [weakSelf.tableView.header endRefreshing];
        }else if ([weakSelf.tableView.footer isRefreshing]){
            [weakSelf.tableView.footer endRefreshing];
        }
        [weakSelf.tableView reloadData];
        
        if (result.count < 30) {
            [weakSelf.tableView removeFooter];
        }else{
            //添加上拉加载的控件
            [weakSelf.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction)];
        }
        weakSelf.pageIndex++;
        
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
    [self requstData];
}
#pragma mark 上拉加载
- (void)footerRefreshAction{
    WS(weakSelf);
    [SysMessageTool getReadedMessagesWithDoctorId:[[AccountManager shareInstance] currentUser].userid pageIndex:self.pageIndex pageSize:30 success:^(NSArray *result) {
        
        if (result.count > 0) {
            [weakSelf.dataList addObjectsFromArray:result];
        }
        [weakSelf.tableView.legendFooter endRefreshing];
        
        [weakSelf.tableView reloadData];
        
        weakSelf.pageIndex++;
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.legendFooter endRefreshing];
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
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
    
    //点击消息
    [self clickMessageActionWithModel:model];
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
                    [self requstData];
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

- (void)clickMessageActionWithModel:(SysMessageModel *)model{
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

#pragma mark - ********************* Lazy Method ***********************
- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
