//
//  ReadMessageViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "ReadMessageViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefresh.h"
#import "SysMessageTool.h"
#import "SysMessageModel.h"
#import "SysMessageCell.h"
#import "AccountManager.h"
#import "NewFriendsViewController.h"
#import "PatientDetailViewController.h"
#import "XLAppointDetailViewController.h"
#import "DBManager+LocalNotification.h"
#import "XLPatientAppointViewController.h"
#import "DBManager+Patients.h"
#import "MJRefresh.h"
#import "UITableView+NoResultAlert.h"

@interface ReadMessageViewController ()
@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, assign)int pageIndex;

@end

@implementation ReadMessageViewController

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requstData) name:ReadUnReadMessageSuccessNotification object:nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.pageIndex = 1;
    
    //添加头部刷新控件
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    [self.tableView.legendHeader beginRefreshing];
}

- (void)requstData{
    [SysMessageTool getReadedMessagesWithDoctorId:[[AccountManager shareInstance] currentUser].userid pageIndex:self.pageIndex pageSize:30 success:^(NSArray *result) {
        if (result.count > 0) {
            [self.dataList addObjectsFromArray:result];
        }
        if ([self.tableView.header isRefreshing]) {
            [self.tableView.header endRefreshing];
        }else if ([self.tableView.footer isRefreshing]){
            [self.tableView.footer endRefreshing];
        }
        [self.tableView reloadData];
        
        if (result.count < 30) {
            [self.tableView removeFooter];
        }else{
            //添加上拉加载的控件
            [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        }
        self.pageIndex++;
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

- (void)headerRefresh{
    self.pageIndex = 1;
    [self.dataList removeAllObjects];
    [self requstData];
}

- (void)footerRefresh{
    [SysMessageTool getReadedMessagesWithDoctorId:[[AccountManager shareInstance] currentUser].userid pageIndex:self.pageIndex pageSize:30 success:^(NSArray *result) {
        
        if (result.count > 0) {
            [self.dataList addObjectsFromArray:result];
        }
        [self.tableView.legendFooter endRefreshing];
        
        [self.tableView reloadData];
        
        self.pageIndex++;
        
    } failure:^(NSError *error) {
        [self.tableView.legendFooter endRefreshing];
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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



@end
