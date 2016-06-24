//
//  XLClinicDetailViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/5/24.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLClinicDetailViewController.h"
#import "XLImageScrollView.h"
#import "XLClinicDetailHeaderView.h"
#import "XLClinicSeatCell.h"
#import "XLClinicImagesCell.h"
#import "MyClinicTool.h"
#import "ClinicDetailModel.h"
#import "UITableView+NoResultAlert.h"
#import "XLClinicAppointmentViewController.h"
#import "XLClinicModel.h"

@interface XLClinicDetailViewController ()

@property (nonatomic, strong)XLClinicDetailHeaderView *headerView;
@property (nonatomic, strong)ClinicDetailModel *curDetailModel;

@end

@implementation XLClinicDetailViewController

#pragma mark - ********************* Life Method ***********************
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    [self setUpSubViews];
    //加载数据
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ********************* Private Method ***********************
#pragma mark 初始化
- (void)setUpSubViews{
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"预约"];
    
}

- (void)onRightButtonAction:(id)sender{
    //预约诊所
    XLClinicAppointmentViewController *appointVc = [[XLClinicAppointmentViewController alloc] init];
    XLClinicModel *model = [[XLClinicModel alloc] init];
    model.clinic_id = self.curDetailModel.clinic_id;
    model.clinic_name = self.curDetailModel.clinic_name;
    appointVc.clinicModel = model;
    [self pushViewController:appointVc animated:YES];
}

#pragma mark 请求网络数据
- (void)requestData{
    [SVProgressHUD showWithStatus:@"正在加载"];
    WS(weakSelf);
    //请求网络数据测试
    [MyClinicTool requestClinicDetailWithClinicId:self.clinicId accessToken:nil success:^(ClinicDetailModel *result) {
        [SVProgressHUD dismiss];
        //根据数据模型加载视图
        weakSelf.curDetailModel = result;
        weakSelf.tableView.tableHeaderView = weakSelf.headerView;
        [weakSelf setUpHeaderData];
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        
        [weakSelf.tableView createNoResultWithImageName:@"no_net_alert" ifNecessaryForRowCount:0 target:self action:@selector(requestData)];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}
#pragma mark 设置头视图的数据
- (void)setUpHeaderData{
    self.headerView.businessTime.text = self.curDetailModel.business_hours;
    self.headerView.clinicPhone.text = self.curDetailModel.clinic_phone;
    self.headerView.clinicAddress.text = self.curDetailModel.clinic_location;
}

#pragma mark - ******************* Delegate / DataSource *******************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 404;
    }
    return 170;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"诊所实景图";
    }
    return @"牙椅配置";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 50)];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont systemFontOfSize:16];
    if (section == 0) {
        headerLabel.text = @"牙椅配置";
    }else{
        headerLabel.text = @"诊所实景图";
    }
    [header addSubview:headerLabel];
    header.backgroundColor = [UIColor clearColor];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        XLClinicSeatCell *cell = [XLClinicSeatCell cellWithTableView:tableView];
        if (self.curDetailModel && self.curDetailModel.Seats.count > 0) {
            cell.model = self.curDetailModel;
        }
        
        return cell;
    }
    
    XLClinicImagesCell *cell = [XLClinicImagesCell cellWithTableView:tableView];
    if (self.curDetailModel && self.curDetailModel.ClinicInfo.count > 0) {
        cell.model = self.curDetailModel;
    }
    
    return cell;
}


#pragma mark - ********************* Lazy Method ***********************
- (XLClinicDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"XLClinicDetailHeaderView" owner:self options:nil] lastObject];
    }
    return _headerView;
}


@end
