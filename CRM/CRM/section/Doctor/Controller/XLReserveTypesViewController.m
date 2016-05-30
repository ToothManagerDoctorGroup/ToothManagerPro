//
//  XLReserveTypesViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/23.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLReserveTypesViewController.h"
#import "XLMessageTemplateTool.h"
#import "AccountManager.h"
#import "XLMessageTemplateModel.h"
#import "XLTemplateDetailViewController.h"
#import "MJRefresh.h"
#import "UITableView+NoResultAlert.h"

@interface XLReserveTypesViewController ()

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation XLReserveTypesViewController

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
    self.title = @"选择预约事项";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_new"]];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTemplateAction:) name:MessageTemplateAddNotification object:nil];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
    self.tableView.header.updatedTimeHidden = YES;
 
    [self.tableView.header beginRefreshing];
}
//下拉刷新
- (void)headerRefreshAction{
    [self requestWlanData];
}

- (void)onRightButtonAction:(id)sender{
    XLTemplateDetailViewController *detailVc = [[XLTemplateDetailViewController alloc] initWithStyle:UITableViewStylePlain];
    detailVc.isSystem = YES;
    [self pushViewController:detailVc animated:YES];
}
//添加预约事项的通知
- (void)addTemplateAction:(NSNotification *)noti{
    [self requestWlanData];
}

- (void)requestWlanData{
    WS(weakSelf);
    [XLMessageTemplateTool getMessageTemplateByDoctorId:[AccountManager currentUserid] success:^(NSArray *result) {
        weakSelf.tableView.tableHeaderView = nil;
        [self.dataList removeAllObjects];
        if ([weakSelf.tableView.header isRefreshing]) {
            [weakSelf.tableView.header endRefreshing];
        }
        //对数据进行分组
        for (XLMessageTemplateModel *model in result) {
            if ([model.message_name isEqualToString:@"种植术后注意事项"] || [model.message_name isEqualToString:@"修复术后注意事项"] ||
                [model.message_name isEqualToString:@"转诊后通知"] ||
                [model.message_name isEqualToString:@"成为介绍人通知"]) {
            }else{
                [weakSelf.dataList addObject:model];
            }
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        if ([self.tableView.header isRefreshing]) [self.tableView.header endRefreshing];
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        [weakSelf.tableView createNoResultWithImageName:@"no_net_alert" ifNecessaryForRowCount:weakSelf.dataList.count target:weakSelf action:@selector(requestWlanData)];
        
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - UITableView Delegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    XLMessageTemplateModel *model = self.dataList[indexPath.row];
    cell.textLabel.text = model.message_type;
    
    if ([model.message_type isEqualToString:self.reserve_type] && model.message_type != nil) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XLMessageTemplateModel *model = self.dataList[indexPath.row];
    
    self.reserve_type = model.message_type;
    
    [self.tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(reserveTypesViewController:didSelectReserveType:)]) {
        [self.delegate reserveTypesViewController:self didSelectReserveType:model.message_type];
    }
    [self popViewControllerAnimated:YES];
}
@end
