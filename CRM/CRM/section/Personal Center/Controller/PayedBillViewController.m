//
//  PayedBillViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/11/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "PayedBillViewController.h"
#import "MyBillCell.h"
#import "BillDetailViewController.h"

#import "MyBillTool.h"
#import "DBTableMode.h"
#import "AccountManager.h"

#import "BillModel.h"
#import "WMPageConst.h"
#import "AppointDetailViewController.h"

@interface PayedBillViewController ()

//数据列表
@property (nonatomic, strong)NSArray *dataList;

@end

@implementation PayedBillViewController

#pragma mark -懒加载
- (NSArray *)dataList{
    if (!_dataList) {
        _dataList = [NSArray array];
    }
    return _dataList;
}

- (void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = MyColor(239, 239, 239);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessAction:) name:DoctorPaySuccessNotification object:nil];
    
    //请求网络数据
    [self requestBillsDataWithType:@"2"];
    
}

#pragma mark -支付成功后
- (void)paySuccessAction:(NSNotification *)note{
    //请求网络数据
    [self requestBillsDataWithType:@"2"];
}


- (void)requestBillsDataWithType:(NSString *)type{
    [SVProgressHUD showWithStatus:@"正在加载"];
    self.tableView.hidden = YES;
    UserObject *currentUser = [[AccountManager shareInstance] currentUser];
    [MyBillTool requestBillsWithDoctorId:currentUser.userid type:type success:^(NSArray *bills) {
        [SVProgressHUD dismiss];
        self.dataList = bills;
        //刷新表格
        [self.tableView reloadData];
        //显示表格
        self.tableView.hidden = NO;
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取模型数据
    BillModel *model = self.dataList[indexPath.row];
    
    //创建cell
    MyBillCell *cell = [MyBillCell cellWithTableView:tableView];
    
    //添加模型数据
    cell.model = model;
    cell.type = @"2";
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //获取数据模型
    BillModel *model = self.dataList[indexPath.row];
    
    //跳转到详情页面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    AppointDetailViewController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"AppointDetailViewController"];
    detailVc.hidesBottomBarWhenPushed = YES;
    detailVc.model = model;
    [self.navigationController pushViewController:detailVc animated:YES];
}


@end
