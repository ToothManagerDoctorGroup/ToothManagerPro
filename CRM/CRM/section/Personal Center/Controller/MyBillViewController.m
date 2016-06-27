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
#import "UITableView+NoResultAlert.h"
#import "CRMHttpRespondModel.h"
#import "XLClinicAppointDetailViewController.h"
#import "LocalNotificationCenter.h"

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
    self.tableView.tableFooterView = [UIView new];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payedAction:) name:WeixinPayedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payedAction:) name:AlipayPayedNotification object:nil];
    //加载网络数据
    [self requestBillsDataWithType:@"1"];
}

#pragma mark - weixinPayedAction
- (void)payedAction:(NSNotification *)noti{
    if ([noti.object isEqualToString:PayedResultSuccess]) {
        //重新加载数据
        [self requestBillsDataWithType:@"1"];        
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 请求网络数据
- (void)requestBillsDataWithType:(NSString *)type{
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    WS(weakSelf);
    UserObject *currentUser = [[AccountManager shareInstance] currentUser];
    [MyBillTool requestBillsWithDoctorId:currentUser.userid type:type success:^(NSArray *bills) {
        weakSelf.tableView.tableHeaderView = nil;
        [SVProgressHUD dismiss];
        weakSelf.dataList = bills;
        //刷新表格
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        [weakSelf.tableView createNoResultWithImageName:@"no_net_alert" ifNecessaryForRowCount:weakSelf.dataList.count target:weakSelf action:@selector(refreshData)];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

- (void)refreshData{
    [self requestBillsDataWithType:@"1"];
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
    
    LocalNotification *localNoti = [[LocalNotification alloc] init];
    localNoti.clinic_reserve_id = model.KeyId;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    XLClinicAppointDetailViewController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"XLClinicAppointDetailViewController"];
    detailVc.hidesBottomBarWhenPushed = YES;
    detailVc.localNoti = localNoti;
    detailVc.hideCancelButton = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark -MyBillCellDelegate
- (void)didClickAppointCancleButtonWithBillModel:(BillModel *)model{
    [SVProgressHUD showWithStatus:@"正在取消"];
    //取消预约
    [MyBillTool cancleAppointWithAppointId:model.KeyId success:^(CRMHttpRespondModel *respond) {
        if ([respond.code intValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:respond.result];
            [self requestBillsDataWithType:@"1"];
        }else{
            [SVProgressHUD showErrorWithStatus:respond.result];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
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
