//
//  MyClinicViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/11/11.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "MyClinicViewController.h"
#import "MyClinicTool.h"
#import "AccountManager.h"
#import "DBTableMode.h"
#import "ClinicModel.h"
#import "ClinicCell.h"
#import "SearchClinicViewController.h"
#import "ClinicDetailViewController.h"
#import "UISearchBar+XLMoveBgView.h"

@interface MyClinicViewController ()<UISearchBarDelegate>

//存放诊所对象：ClinicModel
@property (nonatomic, strong)NSArray *dataList;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation MyClinicViewController

#pragma -懒加载数据
- (NSArray *)dataList{
    if (!_dataList) {
        _dataList = [NSArray array];
    }
    return _dataList;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestClinicInfo) name:DoctorApplyForClinicSuccessNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置导航栏样式
    [self setUpNavBar];
    
    //请求签约诊所的信息
    [self requestClinicInfo];
}

#pragma mark - 设置导航栏样式
- (void)setUpNavBar{
    [super initView];
    self.title = @"我的诊所";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"pic_search"]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.searchBar moveBackgroundView];
    
    //设置右侧按钮
    UILabel *right = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    right.text = @"找诊所";
    right.textColor = [UIColor whiteColor];
    right.font = [UIFont systemFontOfSize:16];
    right.userInteractionEnabled = YES;
    //添加单击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(findClinicAction:)];
    [right addGestureRecognizer:tap];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
}

#pragma mark -找诊所按钮点击事件
- (void)findClinicAction:(UITapGestureRecognizer *)tap{
    
    SearchClinicViewController *clinicVc = [[SearchClinicViewController alloc] initWithStyle:UITableViewStylePlain];
    clinicVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:clinicVc animated:YES];
    
}

#pragma -请求签约诊所的信息
- (void)requestClinicInfo{
    [SVProgressHUD showWithStatus:@"正在加载"];
    UserObject *currentUser = [[AccountManager shareInstance] currentUser];
    [MyClinicTool requestClinicInfoWithDoctorId:currentUser.userid success:^(NSArray *clinics) {
        [SVProgressHUD dismiss];
        //请求到数据,将数据赋值给当前数组
        _dataList = clinics;
        //刷新表格
        [self.tableView reloadData];
    
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 1.获取当前的模型数据
    ClinicModel *model = self.dataList[indexPath.row];
    
    // 2.创建cell
    ClinicCell *cell = [ClinicCell cellWithTableView:tableView];
    
    // 3.设置模型数据
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //获取当前的数据模型
    ClinicModel *model = self.dataList[indexPath.row];
    //跳转到详情页面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    ClinicDetailViewController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"ClinicDetailViewController"];
    detailVc.model = model;
    detailVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}


#pragma -UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //开始拖动的时候，隐藏键盘
    [self.view endEditing:YES];
}

#pragma mark -UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //隐藏键盘
    [self.view endEditing:YES];
    //点击搜索按钮
    [self searchClinicWithClinicName:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //点击搜索按钮
    [self searchClinicWithClinicName:searchText];
}

- (void)searchClinicWithClinicName:(NSString *)clinicName{
    UserObject *currentUser = [[AccountManager shareInstance] currentUser];
    [MyClinicTool searchClinicInfoWithDoctorId:currentUser.userid clinicName:clinicName success:^(NSArray *clinics) {
        
        _dataList = clinics;
        //刷新单元格
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"搜索失败，请检查网络连接");
        }
    }];
}


@end
