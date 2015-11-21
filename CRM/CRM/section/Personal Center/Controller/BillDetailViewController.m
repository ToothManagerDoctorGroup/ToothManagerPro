//
//  BillDetailViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/11/13.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "BillDetailViewController.h"
#import "MyBillTool.h"
#import "BillDetailModel.h"
#import "MaterialModel.h"

#import "CRMHttpRespondModel.h"
#import "PayParam.h"

@interface BillDetailViewController ()

@property (nonatomic, strong)BillDetailModel *detailModel;

@end

@implementation BillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏样式
    [self setUpNavBarStyle];
    
    //设置子视图
    [self initSubViews];
    
    //请求网络数据
    [self requestBillDetailData];
}

#pragma mark -设置导航栏样式
- (void)setUpNavBarStyle{
    self.title = @"收费明细";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.tableView.backgroundColor = MyColor(239, 239, 239);
}

#pragma mark -设置子视图
- (void)initSubViews{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, 44)];
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([self.type isEqualToString:@"1"]) {
        [payButton setTitle:@"付款" forState:UIControlStateNormal];
        [payButton addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [payButton setTitle:@"已付款" forState:UIControlStateNormal];
    }
    
    [payButton setBackgroundImage:[UIImage imageNamed:@"fk"] forState:UIControlStateNormal];
    payButton.frame = CGRectMake((kScreenWidth - 220) * 0.5, 0, 220, 44);
    [footerView addSubview:payButton];
    self.tableView.tableFooterView = footerView;
}
#pragma mark -付款按钮点击事件
- (void)payAction{
    
    [SVProgressHUD showWithStatus:@"正在支付"];
    PayParam *payParam = [PayParam payParamWithBillId:self.billId billType:self.detailModel.reserve_type billPayer:self.detailModel.doctor_name billMoney:self.detailModel.total_money billTime:self.detailModel.reserve_time billStatus:self.detailModel.reserve_status];
    [MyBillTool payWithPayParam:payParam success:^(CRMHttpRespondModel *respondModel) {
        if ([respondModel.code intValue] == 200) {
            //发送支付成功后的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:DoctorPaySuccessNotification object:nil];
            //移除当前控制器
            [self.navigationController popViewControllerAnimated:YES];
            //支付成功后调用代理方法
            if ([self.delegate respondsToSelector:@selector(didPaySuccess:)]) {
                [self.delegate didPaySuccess:respondModel.result];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:respondModel.result];
        }
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
    
    
}

#pragma mark -请求网络数据
- (void)requestBillDetailData{
    [SVProgressHUD showWithStatus:@"正在加载"];
    [MyBillTool requestBillDetailWithBillId:self.billId success:^(BillDetailModel *billDetail) {
        [SVProgressHUD dismiss];
        //设置数据
        self.detailModel = billDetail;
        //刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 3;
    }else{
        return self.detailModel.extras.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //创建cell
    static NSString *ID = @"billDetail_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.detailTextLabel.textColor = [UIColor orangeColor];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"共用时:%@",[self minChangeToHour:self.detailModel.used_time]];
        cell.textLabel.textColor = [UIColor blueColor];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"总费用:￥%@",self.detailModel.total_money];
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"椅位";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",self.detailModel.seat_money];
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"助手";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",self.detailModel.assist_money];
            
        }else{
            cell.textLabel.text = @"种植体";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",self.detailModel.material_money];
        }
    }else{
        for (int i = 0; i < self.detailModel.extras.count; i++) {
            //获取模型数据
            MaterialModel *model = self.detailModel.extras[i];
            if (indexPath.row == i) {
                cell.textLabel.text = model.mat_name;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",model.actual_money];
            }
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"收费明细";
    }else if(section == 2){
        return @"其它费用";
    }
    return nil;
}

//将分钟转换为小时
- (NSString *)minChangeToHour:(NSString *)str{
    int min = [str intValue];
    NSString *hourStr;
    NSString *minStr;
    NSString *result;
    if (min > 60) {
        hourStr = [NSString stringWithFormat:@"%d",min / 60];
        minStr = [NSString stringWithFormat:@"%d",min % 60];
        result = [NSString stringWithFormat:@"%@小时%@分",hourStr,minStr];
    }else{
        minStr = [NSString stringWithFormat:@"%d",min];
        result = [NSString stringWithFormat:@"%@分钟",minStr];
    }
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
