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

@interface ReadMessageViewController ()
@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, assign)int pageIndex;

@end

@implementation ReadMessageViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requstData) name:ReadUnReadMessageSuccessNotification object:nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 60;
    
    self.pageIndex = 1;
    
    [self requstData];
//    //添加头部刷新控件
//    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
//    
//    [self.tableView.legendHeader beginRefreshing];
    
    //添加上拉加载的控件
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
}

- (void)requstData{
    [SVProgressHUD showWithStatus:@"正在加载"];
    [SysMessageTool getReadedMessagesWithDoctorId:[[AccountManager shareInstance] currentUser].userid pageIndex:self.pageIndex pageSize:10 success:^(NSArray *result) {
        [SVProgressHUD dismiss];
        self.dataList = [NSMutableArray arrayWithArray:result];
        
        [self.tableView reloadData];
        
        if (result.count < 10) {
            [self.tableView removeFooter];
        }
        self.pageIndex++;
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

- (void)footerRefresh{
    [SysMessageTool getReadedMessagesWithDoctorId:[[AccountManager shareInstance] currentUser].userid pageIndex:self.pageIndex pageSize:10 success:^(NSArray *result) {
        
        if (result.count > 0) {
            [self.dataList addObjectsFromArray:result];
        }
        [self.tableView.legendFooter endRefreshing];
        
        [self.tableView reloadData];
        
        self.pageIndex++;
        
    } failure:^(NSError *error) {
        [self.tableView.legendFooter endRefreshing];
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

- (void)clickMessageActionWithModel:(SysMessageModel *)model{
    //判断消息的类型
    if ([model.message_type isEqualToString:AttainNewPatient]) {
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
}

@end
