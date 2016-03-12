//
//  XLTreateGroupViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/7.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLTreateGroupViewController.h"
#import "XLGroupMembersView.h"
#import "XLTeamTool.h"
#import "DBTableMode.h"
#import "MJRefresh.h"

@interface XLTreateGroupViewController (){
    XLGroupMembersView *_memberView;
}

@property (nonatomic, strong)NSArray *dataList;

@end

@implementation XLTreateGroupViewController

- (void)dealloc{
    [self removeNotificationObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotificationObserver];
    //初始化子视图
    [self setUpViews];
}

- (void)setUpViews{
    self.title = @"团队服务";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
    [self.tableView.header beginRefreshing];
}
//下拉刷新数据
- (void)headerRefreshAction{
    //查询网络数据
    [self requestDataWithCaseId:self.mCase.ckeyid];
}

#pragma mark - 查询网络数据
- (void)requestDataWithCaseId:(NSString *)caseId{
    __weak typeof(self) weakSelf = self;
    [XLTeamTool queryMedicalCaseMembersWithCaseId:caseId success:^(NSArray *result) {
        if ([weakSelf.tableView.header isRefreshing]) {
            [weakSelf.tableView.header endRefreshing];
        }
        weakSelf.dataList = result;
        
        NSInteger count = (weakSelf.dataList.count + 2) % 5 == 0 ? (weakSelf.dataList.count + 2) / 5 : (weakSelf.dataList.count + 2) / 5 + 1;
        _memberView = [[XLGroupMembersView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, count * 75 + 20 * (count + 1))];
        _memberView.members = weakSelf.dataList;
        _memberView.mCase = weakSelf.mCase;
        
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        if ([weakSelf.tableView.header isRefreshing]) {
            [weakSelf.tableView.header endRefreshing];
        }
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - UITableViewDataSource/Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return _memberView.bounds.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _memberView;
}

#pragma mark - 通知
- (void)addNotificationObserver{
    [self addObserveNotificationWithName:TeamMemberAddSuccessNotification];
    [self addObserveNotificationWithName:TeamMemberDeleteSuccessNotification];
}
- (void)removeNotificationObserver{
    [self removeObserverNotificationWithName:TeamMemberAddSuccessNotification];
    [self removeObserverNotificationWithName:TeamMemberDeleteSuccessNotification];
}

- (void)handNotification:(NSNotification *)notifacation{
    if ([notifacation.name isEqualToString:TeamMemberAddSuccessNotification] || [notifacation.name isEqualToString:TeamMemberDeleteSuccessNotification]) {
        [self requestDataWithCaseId:self.mCase.ckeyid];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
