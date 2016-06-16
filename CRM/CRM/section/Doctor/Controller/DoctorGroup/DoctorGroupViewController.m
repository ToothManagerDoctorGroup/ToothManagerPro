//
//  DoctorGroupViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "DoctorGroupViewController.h"
#import "DoctorGroupTableCell.h"
#import "CustomAlertView.h"
#import "DoctorGroupTool.h"
#import "GroupPatientModel.h"
#import "GroupEntity.h"
#import "DoctorGroupModel.h"
#import "XLGroupManagerViewController.h"
#import "NSString+Conversion.h"
#import "CRMUserDefalut.h"
#import "XLGuideImageView.h"
#import "DoctorGroupTool.h"
#import "AccountManager.h"
#import "UITableView+NoResultAlert.h"

@interface DoctorGroupViewController ()<CustomAlertViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)DoctorGroupModel *selectModel;

@end

@implementation DoctorGroupViewController

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (void)dealloc{
    [self.dataList removeAllObjects];
    self.selectModel = nil;
    self.dataList = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestNewData:) name:DoctorUpdateGroupNameSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestNewData:) name:DoctorDeleteGroupSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestNewData:) name:DoctorAddGroupMemberSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestNewData:) name:DoctorDeleteGroupMemberSuccessNotification object:nil];
    
    //初始化导航栏视图
    [self setUpNav];
    
    //请求分组信息
    [self requestGroupData];
}
#pragma mark - 初始化导航栏视图
- (void)setUpNav{
    self.title = @"我的分组";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"addgroup"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 重新请求数据
- (void)requestNewData:(NSNotification *)note{
    [self requestGroupData];
}

#pragma mark - 请求分组信息
- (void)requestGroupData{
    WS(weakSelf);
    [SVProgressHUD showWithStatus:@"正在加载"];
    [DoctorGroupTool getGroupListWithDoctorId:[[AccountManager shareInstance] currentUser].userid ckId:@"" patientId:@"" success:^(NSArray *result) {
        weakSelf.tableView.tableHeaderView = nil;
        [SVProgressHUD dismiss];
        [weakSelf.dataList removeAllObjects];
        [weakSelf.dataList addObjectsFromArray:result];
//        [weakSelf.tableView createNoResultWithImageName:@"groupList_alert.png" ifNecessaryForRowCount:result.count];
        [weakSelf.tableView createNoResultAlertViewWithImageName:@"groupList_alert.png" showButton:NO ifNecessaryForRowCount:result.count];
        
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (weakSelf.dataList.count == 0) {
            [weakSelf.tableView createNoResultWithImageName:@"no_net_alert" ifNecessaryForRowCount:0 target:weakSelf action:@selector(requestGroupData)];
        }
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}
- (void)onRightButtonAction:(id)sender{
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithAlertTitle:@"新建分组" cancleTitle:@"取消" certainTitle:@"保存"];
    alertView.type = CustomAlertViewTextField;
    alertView.delegate = self;
    [alertView show];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DoctorGroupTableCell *cell = [DoctorGroupTableCell cellWithTableView:tableView];
    //获取数据模型
    DoctorGroupModel *model = self.dataList[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XLGroupManagerViewController *manageVc = [[XLGroupManagerViewController alloc] init];
    manageVc.group = self.dataList[indexPath.row];
    manageVc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:manageVc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    DoctorGroupModel *model = self.dataList[indexPath.row];
    self.selectModel = model;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除分组
        [SVProgressHUD showWithStatus:@"正在删除"];
        [DoctorGroupTool deleteGroupWithCkId:self.selectModel.ckeyid success:^(CRMHttpRespondModel *respondModel) {
            if ([respondModel.code integerValue] == 200) {
                //发送通知
                [self requestGroupData];
            }else{
                [SVProgressHUD showErrorWithStatus:@"删除失败"];
            }
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
            [SVProgressHUD showImage:nil status:error.localizedDescription];
        }];
    }
}


#pragma mark - CustomAlertViewDelegate
- (void)alertView:(CustomAlertView *)alertView didClickCertainButtonWithContent:(NSString *)content{
    if (content.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"分组名不能为空"];
        return;
    }
    if ([content isValidLength:32] == ValidationResultInValid) {
        [SVProgressHUD showErrorWithStatus:@"分组名最多为16个汉字"];
        return;
    }
    
    //添加分组
    [SVProgressHUD showWithStatus:@"正在创建..."];
    GroupEntity *group = [[GroupEntity alloc] initWithName:content desc:@"描述" doctorId:[[AccountManager shareInstance] currentUser].userid];
    [DoctorGroupTool addNewGroupWithGroupEntity:group success:^(CRMHttpRespondModel *respondModel) {
        
        if ([respondModel.code integerValue] == 200) {
            //跳转到分组页面
            [self requestGroupData];
            //跳转到分组页面
            DoctorGroupModel *groupM = [[DoctorGroupModel alloc] initWithGroupEntity:group];
            XLGroupManagerViewController *manageVc = [[XLGroupManagerViewController alloc] init];
            manageVc.group = groupM;
            manageVc.hidesBottomBarWhenPushed = YES;
            [self pushViewController:manageVc animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:respondModel.result];
        }
    
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
