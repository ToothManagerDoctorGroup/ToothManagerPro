//
//  XLPatientEducationViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/4/28.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLPatientEducationViewController.h"
#import "DoctorTool.h"
#import "UIColor+Extension.h"
#import "CRMHttpRespondModel.h"
#import "XLPatientEducationModel.h"
#import "XLWebViewController.h"

@interface XLPatientEducationViewController ()
@property (nonatomic, strong)NSMutableArray *dataList;
@end

@implementation XLPatientEducationViewController

#pragma mark - ********************* Life Method ***********************
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏样式
    [self setNavStyle];
    
    //请求数据
    [self  requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - ********************* Private Method ***********************
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
    WS(weakSelf);
    [DoctorTool getPatientEducationWithType:@"" success:^(NSArray *result) {
        [SVProgressHUD dismiss];
        
        [weakSelf.dataList addObjectsFromArray:result];
        
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - ********************* Delegate / DataSource ****************
#pragma mark - UITableViewDelegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"patient_education_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, cell.height - 1, kScreenWidth, 1)];
        view.backgroundColor = [UIColor colorWithHex:0xdddddd];
        [cell.contentView addSubview:view];
    }
    
    XLPatientEducationModel *model = self.dataList[indexPath.row];
    
    cell.textLabel.text = model.u_name;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XLPatientEducationModel *model = self.dataList[indexPath.row];
    
    XLWebViewController *webVc = [[XLWebViewController alloc] init];
    webVc.urlStr = model.u_url;
    webVc.title = model.u_name;
    [self pushViewController:webVc animated:YES];
}

#pragma mark - ********************* Lazy Method ***********************
- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
