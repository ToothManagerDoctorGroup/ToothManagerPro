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
#import "GroupPatientDisplayController.h"
#import "DoctorGroupTool.h"
#import "GroupPatientModel.h"
#import "GroupManageViewController.h"
#import "GroupEntity.h"
#import "DoctorGroupModel.h"

@interface DoctorGroupViewController ()<CustomAlertViewDelegate>

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation DoctorGroupViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [SVProgressHUD dismiss];
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
    self.view.backgroundColor = MyColor(248, 248, 248);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 重新请求数据
- (void)requestNewData:(NSNotification *)note{
    [self.dataList removeAllObjects];
    
    [self requestGroupData];
}

#pragma mark - 请求分组信息
- (void)requestGroupData{
    [SVProgressHUD showWithStatus:@"正在加载"];
    [DoctorGroupTool getGroupListWithDoctorId:[[AccountManager shareInstance] currentUser].userid ckId:@"" success:^(NSArray *result) {
        [SVProgressHUD dismiss];
        self.dataList = [NSMutableArray arrayWithArray:result];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    GroupManageViewController *manageVc = [storyboard instantiateViewControllerWithIdentifier:@"GroupManageViewController"];
    manageVc.group = self.dataList[indexPath.row];
    manageVc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:manageVc animated:YES];
}


#pragma mark - CustomAlertViewDelegate
- (void)alertView:(CustomAlertView *)alertView didClickCertainButtonWithContent:(NSString *)content{
    if (content.length == 0 || [content isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"分组名不能为空"];
        return;
    }
    
    //添加分组
    [SVProgressHUD showWithStatus:@"正在创建..."];
    GroupEntity *group = [[GroupEntity alloc] initWithName:content desc:@"描述" doctorId:[[AccountManager shareInstance] currentUser].userid];
    [DoctorGroupTool addNewGroupWithGroupEntity:group success:^(CRMHttpRespondModel *respondModel) {
        
        if ([respondModel.code integerValue] == 200) {
            [self requestGroupData];
        }else{
            [SVProgressHUD showErrorWithStatus:respondModel.result];
        }
    
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"分组创建失败"];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end