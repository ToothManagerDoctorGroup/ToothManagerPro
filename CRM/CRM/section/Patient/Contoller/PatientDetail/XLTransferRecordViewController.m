//
//  XLTransferRecordViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/6/14.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLTransferRecordViewController.h"
#import "UIColor+Extension.h"
#import "XLTransferRecordCell.h"
#import "DBManager+Patients.h"
#import "XLDoctorLibraryViewController.h"
#import <Masonry.h>

#define kTransferRecordViewControllerTimeLineColor [UIColor colorWithHex:0x5ec1f0]

@interface XLTransferRecordViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *timeLineView;//时间轴
@property (nonatomic, strong)NSArray *dataList;

@end

@implementation XLTransferRecordViewController

#pragma mark - ********************* Life Method ***********************
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    [self setUpSubViews];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.dataList = [[DBManager shareInstance] getPatientTransferRecordWithPatientId:self.patientId];
    [self.tableView reloadData];
}

#pragma mark - ********************* Private Method ***********************
#pragma mark 初始化
- (void)setUpSubViews{
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"转诊"];
    self.title = @"转诊记录";
    
    [self.view addSubview:self.timeLineView];
    [self.view addSubview:self.tableView];
    
    //设置约束
    [self setUpConstrains];
}
#pragma mark 设置约束
- (void)setUpConstrains{
    [self.timeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(14);
        make.width.mas_equalTo(@1);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark 转诊
- (void)onRightButtonAction:(id)sender{
    Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.patientId];
    XLDoctorLibraryViewController *doctorVC = [[XLDoctorLibraryViewController alloc] init];
    doctorVC.isTransfer = YES;
    doctorVC.userId = patient.doctor_id;
    doctorVC.patientId = patient.ckeyid;
    [self pushViewController:doctorVC animated:YES];
}

#pragma mark - ********************* Delegate / DataSource *******************
#pragma mark UITableViewDelegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XLTransferRecordCell *cell = [XLTransferRecordCell cellWithTableView:tableView];
    XLTransferRecordModel *model = self.dataList[indexPath.row];
    
    cell.model = model;
    
    return cell;
}


#pragma mark - ********************* Lazy Method ***********************
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = [XLTransferRecordCell cellHeight];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (UIView *)timeLineView{
    if (!_timeLineView) {
        _timeLineView = [[UIView alloc] init];
        _timeLineView.backgroundColor = kTransferRecordViewControllerTimeLineColor;
    }
    return _timeLineView;
}

@end
