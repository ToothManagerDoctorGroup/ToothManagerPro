//
//  XLDataAnalyseViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/21.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLDataAnalyseViewController.h"
#import "UIColor+Extension.h"
#import "XLPieChartView.h"
#import "XLAnalyseHeaderView.h"
#import "XLPieChartParam.h"
#import "DBManager+Patients.h"
#import "XLSeniorStatisticsViewController.h"

@interface XLDataAnalyseViewController ()

@property (nonatomic, strong)NSMutableArray *analyseList;

@end

@implementation XLDataAnalyseViewController

- (NSMutableArray *)analyseList{
    if (!_analyseList) {
        NSArray *colors = @[[UIColor colorWithHex:0x3bbdf8],[UIColor colorWithHex:0xff5951],[UIColor colorWithHex:0x61d979],[UIColor colorWithHex:0xbbbbbb]];

        int untreatCount = [[DBManager shareInstance] getPatientsCountWithStatus:PatientStatusUntreatment];
        int unplantCount = [[DBManager shareInstance] getPatientsCountWithStatus:PatientStatusUnplanted];
        int unrepairCount = [[DBManager shareInstance] getPatientsCountWithStatus:PatientStatusUnrepaired];
        int repairedCount = [[DBManager shareInstance] getPatientsCountWithStatus:PatientStatusRepaired];
        int total = untreatCount + unplantCount + unrepairCount + repairedCount;
        NSArray *counts = @[@(untreatCount),@(unplantCount),@(unrepairCount),@(repairedCount)];
        NSArray *status = @[@"未就诊",@"未种植",@"已种未修",@"已修复"];
        NSMutableArray *arryM = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            XLPieChartParam *param = [[XLPieChartParam alloc] initWithColor:colors[i] scale:[counts[i] doubleValue] / total status:status[i] count:[counts[i] doubleValue]];
            [arryM addObject:param];
        }
        _analyseList = arryM;
    }
    return _analyseList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏样式
    [self setUpNavStyle];
    
    //设置子视图
    [self setUpSubViews];
}

#pragma mark - 设置导航栏样式
- (void)setUpNavStyle{
    self.title = @"数据分析";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark - 设置子视图
- (void)setUpSubViews{
    
    XLAnalyseHeaderView *headerView = [[XLAnalyseHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
    headerView.scaleList = self.analyseList;
    self.tableView.tableHeaderView = headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate/Datasource
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"analyse_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, kScreenWidth, 0.5)];
        divider.backgroundColor = [UIColor colorWithHex:0xcccccc];
        [cell.contentView addSubview:divider];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"种植统计";
    }else{
        cell.textLabel.text = @"修复统计";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XLSeniorStatisticsViewController *seniorVC = [[XLSeniorStatisticsViewController alloc] initWithStyle:UITableViewStylePlain];
    if (indexPath.row == 0) {
        seniorVC.type = SeniorStatisticsViewControllerPlant;
    }else{
        seniorVC.type = SeniorStatisticsViewControllerRepair;
    }
    [self pushViewController:seniorVC animated:YES];
}
 
 */

@end
