//
//  XLJoinConsultationController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/8.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLJoinConsultationController.h"
#import "XLJoinConsultationCell.h"
#import "MJRefresh.h"
#import "XLTeamTool.h"
#import "AccountManager.h"

@interface XLJoinConsultationController ()

@property (nonatomic, strong)NSArray *dataList;

@end

@implementation XLJoinConsultationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.title = @"参与会诊";
    
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
    self.tableView.header.updatedTimeHidden = YES;
    
    //开始刷新数据
    [self.tableView.header beginRefreshing];
}
#pragma mark - headerRefreshAction
- (void)headerRefreshAction{
    //查询我所参与会诊的患者信息
    [XLTeamTool queryJoinConsultationPatientsWithDoctorId:[AccountManager currentUserid] success:^(NSArray *result) {
        [self.tableView.header endRefreshing];
        
        self.dataList = result;
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}


#pragma mark - UITableViewDataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    // 下面这几行代码是用来设置cell的上下行线的位置
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XLJoinTeamModel *model = self.dataList[indexPath.row];
    
    XLJoinConsultationCell *cell = [XLJoinConsultationCell cellWithTableView:tableView];
    
    cell.model = model;
    
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
