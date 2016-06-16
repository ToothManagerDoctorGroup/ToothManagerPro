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
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"


static const CGFloat MyClinicViewControllerCellHeight = 70;

@interface MyClinicViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>

//存放诊所对象：ClinicModel
@property (nonatomic, strong)NSArray *dataList;

@property (nonatomic, strong)EMSearchBar *searchBar;//搜索框
@property (nonatomic, strong)EMSearchDisplayController *searchController;//搜索视图

@end

@implementation MyClinicViewController
#pragma mark - ********************* Life Method ***********************
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestClinicInfo) name:DoctorApplyForClinicSuccessNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置子视图
    [self setUpSubViews];
    //请求签约诊所的信息
    [self requestClinicInfo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ********************* Private Method ***********************
#pragma mark 设置子视图
- (void)setUpSubViews{
    self.title = @"我的诊所";
    self.tableView.frame = CGRectMake(0, 44, kScreenWidth, kScreenHeight - 64 - 44);
    [self.view addSubview:self.searchBar];
    [self searchController];
}

#pragma mark 找诊所按钮点击事件
- (void)findClinicAction:(UITapGestureRecognizer *)tap{
    
    SearchClinicViewController *clinicVc = [[SearchClinicViewController alloc] initWithStyle:UITableViewStylePlain];
    clinicVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:clinicVc animated:YES];
    
}

#pragma 请求签约诊所的信息
- (void)requestClinicInfo{
    [SVProgressHUD showWithStatus:@"正在加载"];
    WS(weakSelf);
//    [MyClinicTool requestClinicInfoWithAreacode:@"北京" clinicName:@"" success:^(NSArray *result) {
//        [SVProgressHUD dismiss];
//        //请求到数据,将数据赋值给当前数组
//        _dataList = result;
//        //刷新表格
//        [weakSelf.tableView reloadData];
//    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
//        if (error) {
//            NSLog(@"error:%@",error);
//        }
//    }];
    
    [MyClinicTool requestClinicInfoWithDoctorId:[AccountManager currentUserid] success:^(NSArray *clinics) {
        [SVProgressHUD dismiss];
        //请求到数据,将数据赋值给当前数组
        _dataList = clinics;
        //刷新表格
        [weakSelf.tableView reloadData];
    
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark 设置单元格点击事件
- (void)setCellSelectWithIndexPath:(NSIndexPath *)indexPath source:(NSArray *)source{
    //获取当前的数据模型
    ClinicModel *model = source[indexPath.row];
    //跳转到详情页面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    ClinicDetailViewController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"ClinicDetailViewController"];
    detailVc.model = model;
    detailVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - ********************* Delegate / DataSource *******************
#pragma mark Table view data source
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
    return MyClinicViewControllerCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self setCellSelectWithIndexPath:indexPath source:self.dataList];
    
}


#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    UserObject *currentUser = [[AccountManager shareInstance] currentUser];
    WS(weakSelf);
    [SVProgressHUD showWithStatus:@"正在搜索"];
    [MyClinicTool searchClinicInfoWithDoctorId:currentUser.userid clinicName:searchBar.text success:^(NSArray *clinics) {
        [SVProgressHUD dismiss];
        //刷新单元格
        [weakSelf.searchController.resultsSource removeAllObjects];
        [weakSelf.searchController.resultsSource addObjectsFromArray:clinics];
        [weakSelf.searchController.searchResultsTableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"搜索失败，请检查网络连接");
        }
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - UISearchDisplayDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(nullable NSString *)searchString{
    __weak typeof(self) weakSelf = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.001);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (UIView *subview in weakSelf.searchDisplayController.searchResultsTableView.subviews) {
            if ([subview isKindOfClass: [UILabel class]])
            {
                subview.hidden = YES;
            }
        }
    });
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillHide {
    UITableView *tableView = self.searchController.searchResultsTableView;
    [tableView setContentInset:UIEdgeInsetsZero];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
    
}

#pragma mark - ********************* Lazy Method ***********************
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"诊所名称，地址";
        [_searchBar moveBackgroundView];
    }
    
    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _searchController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
        _searchController.delegate = self;
        __weak MyClinicViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            // 1.获取当前的模型数据
            ClinicModel *model = weakSelf.searchController.resultsSource[indexPath.row];
            
            // 2.创建cell
            ClinicCell *cell = [ClinicCell cellWithTableView:tableView];
            
            // 3.设置模型数据
            cell.model = model;

            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return MyClinicViewControllerCellHeight;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
            [weakSelf setCellSelectWithIndexPath:indexPath source:weakSelf.searchController.resultsSource];
        }];
    }
    
    return _searchController;
}
- (NSArray *)dataList{
    if (!_dataList) {
        _dataList = [NSArray array];
    }
    return _dataList;
}


@end
