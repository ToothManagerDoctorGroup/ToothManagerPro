//
//  MyBillViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/11/13.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "MyBillViewController.h"
#import "MyBillCell.h"
#import "BillDetailViewController.h"

#import "MyBillTool.h"
#import "DBTableMode.h"
#import "AccountManager.h"

#import "BillModel.h"
#import "WMPageConst.h"
#import "AppointDetailViewController.h"

@interface MyBillViewController ()<MyBillCellDelegate>

//数据列表
@property (nonatomic, strong)NSArray *dataList;

@end

@implementation MyBillViewController

#pragma mark -懒加载
- (NSArray *)dataList{
    if (!_dataList) {
        _dataList = [NSArray array];
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = MyColor(239, 239, 239);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //加载网络数据
    [self requestBillsDataWithType:@"1"];
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
    cell.delegate = self;
    
    //添加模型数据
    cell.model = model;
    
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

#pragma mark -MyBillCellDelegate
- (void)didClickAppointCancleButtonWithBillModel:(BillModel *)model{
    [SVProgressHUD showWithStatus:@"正在取消"];
    //取消预约
    [MyBillTool cancleAppointWithAppointId:model.KeyId success:^(NSString *result,NSNumber *code) {
        if ([code intValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:result];
            [self requestBillsDataWithType:@"1"];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
       
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

- (void)didPaySuccessWithResult:(NSString *)result{
    //显示支付结果
    [SVProgressHUD showSuccessWithStatus:result];
    //重新请求当前的网络数据
    [self requestBillsDataWithType:@"1"];
}
@end
