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
#import "XLPayTool.h"
#import "XLPayManager.h"
#import "XLPayWayAlertView.h"
#import "JSONKit.h"
#import "XLPayAttachModel.h"
#import "AccountManager.h"
#import "MJExtension.h"
#import "UIColor+Extension.h"
#import "WXApi.h"

@interface BillDetailViewController ()<XLPayWayAlertViewDelegate>

@property (nonatomic, strong)UIButton *payButton;

@property (nonatomic, strong)BillDetailModel *detailModel;

@end

@implementation BillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏样式
    [self setUpNavBarStyle];
    
    //添加通知
    [self addNotificationObserver];
    
    //设置子视图
    [self initSubViews];
    
    //请求网络数据
    [self requestBillDetailData];
}

- (void)dealloc{
    [self removeNotificationObserver];
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
    _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payButton setBackgroundImage:[UIImage imageNamed:@"fk"] forState:UIControlStateNormal];
    _payButton.frame = CGRectMake((kScreenWidth - 220) * 0.5, 0, 220, 44);
    [footerView addSubview:_payButton];
    self.tableView.tableFooterView = footerView;
}
#pragma mark 设置付款按钮文字
- (void)initPayButtonWithStatus:(NSString *)status{
    if ([status isEqualToString:@"3"]) {
        [_payButton setTitle:@"付款" forState:UIControlStateNormal];
        [_payButton addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_payButton setTitle:@"已付款" forState:UIControlStateNormal];
        [_payButton removeTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark -付款按钮点击事件
- (void)payAction{
    
    //判断当前费用是否为0
    if ([self.detailModel.total_money floatValue] == 0) {
        //直接付款成功
        [SVProgressHUD showWithStatus:@"正在支付"];
        PayParam *payParam = [PayParam payParamWithBillId:self.billId billType:self.detailModel.reserve_type billPayer:self.detailModel.doctor_name billMoney:self.detailModel.total_money billTime:self.detailModel.reserve_time billStatus:self.detailModel.reserve_status];
        [MyBillTool payWithPayParam:payParam success:^(CRMHttpRespondModel *respondModel) {
            if ([respondModel.code intValue] == 200) {
                //发送支付成功后的通知
                [[NSNotificationCenter defaultCenter] postNotificationName:WeixinPayedNotification object:PayedResultSuccess];
            }else{
                [SVProgressHUD showErrorWithStatus:respondModel.result];
            }
        } failure:^(NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
        
        return;
    }
    
    NSString *title = [NSString stringWithFormat:@"%@预约费用",self.detailModel.clinic_name];
    NSString *detail = @"预约诊所费用，包括椅位助手";
    
    XLPayWayAlertView *payAlertView = [[XLPayWayAlertView alloc] initWithPrice:self.detailModel.total_money certainButtonBlock:^(XLPayWayAlertView *payAlertView, XLPaymentMethod paymentMethod) {
        
        if (paymentMethod == XLPaymentMethodWeixin) {
            NSString *price = [NSString stringWithFormat:@"%d",(int)([self.detailModel.total_money floatValue] * 100)];;
            //微信支付
            XLPayAttachModel *model = [[XLPayAttachModel alloc] initWithBillId:self.billId billPayer:[AccountManager currentUserid] billMoney:price payType:PayAttachTypeClinicReserve clinicId:self.detailModel.clinic_id];
            
            XLOrderParam *order = [[XLOrderParam alloc] initWithBody:title detail:detail attach:[model.keyValues JSONString] totalFee:price goodsTag:@"ZJYY"];
            [SVProgressHUD showWithStatus:@"正在获取交易信息"];
            [XLPayTool payWithOrderParam:order success:^(NSDictionary *result) {
                [SVProgressHUD dismiss];
                if (result) {
                    //微信支付
                    [[XLPayManager shareInstance] wxPayWithDic:result];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"交易信息获取失败"];
                }
            } failure:^(NSError *error) {
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
        }else if (paymentMethod == XLPaymentMethodAlipay){
            NSString *sourcePrice = [NSString stringWithFormat:@"%.2f",[self.detailModel.total_money floatValue]];
            [SVProgressHUD showWithStatus:@"正在获取交易信息"];
            [XLPayTool alipayWithSubject:title body:detail totalFee:sourcePrice billId:self.billId billType:BillPayTypeClinicReserve success:^(CRMHttpRespondModel *result) {
                [SVProgressHUD dismiss];
                if ([result.code integerValue] == 200) {
                    [[XLPayManager shareInstance] aliPayWithOrderString:result.result payCallback:^(NSDictionary *dic) {
                        //支付回调
                        NSLog(@"BillDetailViewController:reslut = %@",dic);
                    }];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"交易信息获取失败"];
                }
            } failure:^(NSError *error) {
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
        }
    }];
    [payAlertView show];
    
    
}
#pragma mark - 通知
- (void)addNotificationObserver{
    [self addObserveNotificationWithName:WeixinPayedNotification];
    [self addObserveNotificationWithName:AlipayPayedNotification];
}

- (void)removeNotificationObserver{
    [self removeObserverNotificationWithName:WeixinPayedNotification];
    [self removeObserverNotificationWithName:AlipayPayedNotification];
}

- (void)handNotification:(NSNotification *)notifacation{
    if ([notifacation.name isEqualToString:WeixinPayedNotification] || [notifacation.name isEqualToString:AlipayPayedNotification]) {
        if ([notifacation.object isEqualToString:PayedResultSuccess]) {
            //支付成功，刷新数据
            [self requestBillDetailData];
        }
    }
}

#pragma mark -请求网络数据
- (void)requestBillDetailData{
    [SVProgressHUD showWithStatus:@"正在加载"];
    [MyBillTool requestBillDetailWithBillId:self.billId success:^(BillDetailModel *billDetail) {
        [SVProgressHUD dismiss];
        //设置数据
        self.detailModel = billDetail;
        
        [self initPayButtonWithStatus:billDetail.reserve_status];
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
