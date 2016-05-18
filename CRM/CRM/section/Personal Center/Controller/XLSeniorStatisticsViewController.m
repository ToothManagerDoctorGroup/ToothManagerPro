//
//  XLSeniorStatisticsViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/22.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLSeniorStatisticsViewController.h"
#import "XLSeniorStatisticsHeaderView.h"
#import "XLSeniorStatisticCell.h"
#import "DoctorTool.h"
#import "AccountManager.h"
#import "XLGroupManagerViewController.h"

@interface XLSeniorStatisticsViewController ()<XLSeniorStatisticsHeaderViewDelegate>

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation XLSeniorStatisticsViewController

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
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
    if (self.type == SeniorStatisticsViewControllerPlant) {
        self.title = @"种植统计";
    }else{
        self.title = @"修复统计";
    }
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 初始化子视图
- (void)setUpSubViews{
    XLSeniorStatisticsHeaderView *headerView;
    if (self.type == SeniorStatisticsViewControllerPlant) {
        headerView = [[XLSeniorStatisticsHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
        headerView.type = @"plant";
    }else{
        headerView = [[XLSeniorStatisticsHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 210)];
        headerView.type = @"repair";
    }
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;
}


#pragma mark - UITableViewDelegate/Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 400;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XLSeniorStatisticCell *cell = [XLSeniorStatisticCell cellWithTableView:tableView];
    if (self.type == SeniorStatisticsViewControllerPlant) {
        cell.title = @"种植患者";
    }else{
        cell.title = @"修复患者";
    }
    cell.dataList = self.dataList;
    
    return cell;
}

#pragma mark - XLSeniorStatisticsHeaderViewDelegate
- (void)seniorStatisticsHeaderView:(XLSeniorStatisticsHeaderView *)headerView didSearchWithStartTime:(NSString *)startTime endTime:(NSString *)endTime repairDoctor:(Doctor *)repairDoctor{
    
    //判断是哪种搜索
    if (self.type == SeniorStatisticsViewControllerPlant) {
        //种植搜索
        [SVProgressHUD showWithStatus:@"正在查询"];
        //搜索
        [DoctorTool queryPlantPatientsWithDoctorId:[AccountManager currentUserid] beginDate:startTime endDate:endTime success:^(NSArray *array) {
            [SVProgressHUD dismiss];
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:array];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }else{
        //修复搜索
        NSString *starStr = startTime == nil ? @"" : startTime;
        NSString *endStr = endTime == nil ? @"" : endTime;
        [SVProgressHUD showWithStatus:@"正在查询"];
        [DoctorTool queryRepairPatientsWithDoctorId:[AccountManager currentUserid] beginDate:starStr endDate:endStr repairDoctorId:repairDoctor.ckeyid success:^(NSArray *array) {
            [SVProgressHUD dismiss];
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:array];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
