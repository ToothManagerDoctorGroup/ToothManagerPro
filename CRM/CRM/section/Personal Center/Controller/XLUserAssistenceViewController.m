//
//  XLUserAssistenceViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/28.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLUserAssistenceViewController.h"
#import "UIColor+Extension.h"
#import "XLAssistenceDetailViewController.h"
#import "XLAssistenceModel.h"
#import "DoctorTool.h"
#import "UITableView+NoResultAlert.h"

@interface XLUserAssistenceViewController ()

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation XLUserAssistenceViewController

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏样式
    [self setNavStyle];
    
    //请求数据
    [self requestData];
}

#pragma mark - 设置导航栏样式
- (void)setNavStyle{
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.title = @"使用帮助";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)dealloc{
    [SVProgressHUD dismiss];
}

#pragma mark - 请求数据
- (void)requestData{
    [SVProgressHUD showWithStatus:@"正在加载"];
    __weak typeof(self) weakSelf = self;
    [DoctorTool getAllUsingHelpSuccess:^(NSArray *array) {
        weakSelf.tableView.tableHeaderView = nil;
        [SVProgressHUD dismiss];
        [weakSelf.dataList addObjectsFromArray:array];
        
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        [weakSelf.tableView createNoResultWithImageName:@"no_net_alert" ifNecessaryForRowCount:weakSelf.dataList.count target:weakSelf action:@selector(requestData)];
        if (error) {
            NSLog(@"error:%@",error.localizedDescription);
        }
    }];
}

#pragma mark - UITableViewDelegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"assistence_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, cell.height - 1, kScreenWidth, 1)];
        view.backgroundColor = [UIColor colorWithHex:0xdddddd];
        [cell.contentView addSubview:view];
    }
    
    XLAssistenceModel *model = self.dataList[indexPath.row];
    
    cell.textLabel.text = model.help_name;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XLAssistenceModel *model = self.dataList[indexPath.row];
    
    XLAssistenceDetailViewController *detailVc = [[XLAssistenceDetailViewController alloc] init];
    detailVc.model = model;
    if (indexPath.row == 0) {
        detailVc.image = [UIImage imageNamed:@"assistence_01"];
        detailVc.title = @"初诊患者到医院就诊";
    }else if (indexPath.row == 1){
        detailVc.image = [UIImage imageNamed:@"assistence_02"];
        detailVc.title = @"复诊患者到医院就诊";
    }else if (indexPath.row == 2){
        detailVc.image = [UIImage imageNamed:@"assistence_03"];
        detailVc.title = @"患者治疗需要协助";
    }else{
        detailVc.image = [UIImage imageNamed:@"assistence_04"];
        detailVc.title = @"患者介绍朋友给医生";
    }
    [self pushViewController:detailVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
