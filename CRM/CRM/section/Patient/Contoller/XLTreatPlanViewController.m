//
//  XLTreatPlanViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/2.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLTreatPlanViewController.h"
#import "XLTreatPlanCell.h"
#import "XLTreatPlanDetailViewController.h"
#import "XLTreatPlanEditViewController.h"
#import "XLTeamTool.h"
#import "XLCureProjectModel.h"
#import "MJRefresh.h"
#import "DBTableMode.h"

#define CellHeight 135

@interface XLTreatPlanViewController ()

@property (nonatomic, strong)NSArray *curePros;

@end

@implementation XLTreatPlanViewController

- (NSArray *)curePros{
    if (!_curePros) {
        _curePros = [NSArray array];
    }
    return _curePros;
}
- (void)dealloc{
    [self removeNotificationObserver];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"治疗方案";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_new"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = CellHeight;
    
    [self addNotificationObserver];
    //初始化视图
    [self setUpViews];
    
}
- (void)onRightButtonAction:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Team" bundle:nil];
    XLTreatPlanEditViewController *editVc = [storyboard instantiateViewControllerWithIdentifier:@"XLTreatPlanEditViewController"];
    editVc.mCase = self.mCase;
    [self pushViewController:editVc animated:YES];
}
#pragma mark - 初始化视图
- (void)setUpViews{
    //添加头部刷新控件
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
    self.tableView.header.updatedTimeHidden = YES;
    
    [self.tableView.header beginRefreshing];
}
#pragma mark - 请求网络数据
- (void)headerRefreshAction{
    [XLTeamTool queryCureProsWithCaseId:self.mCase.ckeyid success:^(NSArray *result) {
        [self.tableView.header endRefreshing];
        self.curePros = result;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - UITabelViewDelegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.curePros.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XLCureProjectModel *model = self.curePros[indexPath.row];
    model.step = indexPath.row + 1;
    
    XLTreatPlanCell *cell = [XLTreatPlanCell cellWithTableView:tableView];
    
    cell.model = model;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Team" bundle:nil];
    XLTreatPlanDetailViewController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"XLTreatPlanDetailViewController"];
    detailVc.model = self.curePros[indexPath.row];
    [self pushViewController:detailVc animated:YES];
}

#pragma mark - 通知
//添加通知
- (void)addNotificationObserver{
    [self addObserveNotificationWithName:TreatePlanAddNotification];
}
//移除通知
- (void)removeNotificationObserver{
    [self removeObserverNotificationWithName:TreatePlanAddNotification];
}
//处理通知
- (void)handNotification:(NSNotification *)notifacation{
    if ([notifacation.name isEqualToString:TreatePlanAddNotification]) {
        [self.tableView.header beginRefreshing];
    }
}

@end
