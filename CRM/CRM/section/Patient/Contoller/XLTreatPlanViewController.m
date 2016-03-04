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

@interface XLTreatPlanViewController ()

@property (nonatomic, strong)NSArray *dataList;

@end

@implementation XLTreatPlanViewController

- (NSArray *)dataList{
    if (!_dataList) {
        _dataList = @[@"0",@"1",@"2",@"3"];
    }
    return _dataList;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"治疗方案";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_new"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)onRightButtonAction:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Team" bundle:nil];
    XLTreatPlanEditViewController *editVc = [storyboard instantiateViewControllerWithIdentifier:@"XLTreatPlanEditViewController"];
    [self pushViewController:editVc animated:YES];
}

#pragma mark - UITabelViewDelegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XLTreatPlanCell *cell = [XLTreatPlanCell cellWithTableView:tableView];
    
    cell.step = self.dataList[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Team" bundle:nil];
    XLTreatPlanDetailViewController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"XLTreatPlanDetailViewController"];
    [self pushViewController:detailVc animated:YES];
}

@end
