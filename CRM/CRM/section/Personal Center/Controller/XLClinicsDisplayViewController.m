//
//  XLClinicsDisplayViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/5/17.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLClinicsDisplayViewController.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "MyClinicTool.h"
#import "AccountManager.h"
#import "XLClinicCell.h"
#import "XLClinicModel.h"
#import "UISearchBar+XLMoveBgView.h"
#import "ClinicDetailViewController.h"
#import "UITableView+NoResultAlert.h"
#import "CRMUserDefalut.h"
#import "AccountManager.h"
#import "XLWebViewController.h"
#import "XLClinicDetailViewController.h"
#import "XLClinicQueryModel.h"
#import "CRMHttpRespondModel.h"

@interface XLClinicsDisplayViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>
//存放诊所对象：ClinicModel
@property (nonatomic, strong)NSArray *dataList;

@property (nonatomic, strong)EMSearchBar *searchBar;//搜索框
@property (nonatomic, strong)EMSearchDisplayController *searchController;//搜索视图

@property (nonatomic, strong)XLClinicQueryModel *queryModel;
@end

@implementation XLClinicsDisplayViewController

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
    
    //请求签约诊所的信息
    [self requestClinicInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ********************* Private Method ***********************
#pragma mark 认证按钮点击
- (void)authodAction{
    XLWebViewController *webVc = [[XLWebViewController alloc] init];
    webVc.urlStr = [NSString stringWithFormat:@"%@his.crm/html/doctor_auth_guide.html?doctor_id=%@",DomainName,[AccountManager currentUserid]];
    webVc.title = @"认证";
    webVc.hideRightButton = YES;
    [self.navigationController pushViewController:webVc animated:YES];
}

#pragma 请求签约诊所的信息
- (void)requestClinicInfo{
    [SVProgressHUD showWithStatus:@"正在加载"];
    WS(weakSelf);
    [MyClinicTool getClinicListWithQueryModel:self.queryModel success:^(NSArray *result) {
        [SVProgressHUD dismiss];
        self.tableView.tableHeaderView = nil;
        if (result) {
            self.tableView.frame = CGRectMake(0, 44, kScreenWidth, kScreenHeight - 64 - 44);
            [self.view addSubview:self.searchBar];
            [self searchController];
            //请求到数据,将数据赋值给当前数组
            _dataList = result;
            //刷新表格
            [weakSelf.tableView reloadData];
        }else{
            //未签约
            self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
            //未签约
            [self.tableView createNoResultWithButtonWithImageName:@"clinic_alert_shenqingrenzheng" ifNecessaryForRowCount:0 buttonTitle:@"申请成为认证医生" target:self action:@selector(authodAction) forControlEvents:UIControlEventTouchUpInside];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        [self.tableView createNoResultWithImageName:@"no_net_alert" ifNecessaryForRowCount:0 target:weakSelf action:@selector(requestClinicInfo)];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark 设置单元格点击事件
- (void)setCellSelectWithIndexPath:(NSIndexPath *)indexPath source:(NSArray *)source{
    //获取当前的数据模型
    XLClinicModel *model = source[indexPath.row];
    //跳转到详情页面
    XLClinicDetailViewController *detailVC = [[XLClinicDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    detailVC.clinicId = model.clinic_id;
    detailVC.title = model.clinic_name;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - ********************* Delegate / DataSource *******************
#pragma mark Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 1.获取当前的模型数据
    XLClinicModel *model = self.dataList[indexPath.row];
    
    // 2.创建cell
    XLClinicCell *cell = [XLClinicCell cellWithTableView:tableView];
    
    // 3.设置模型数据
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [XLClinicCell cellHeight];
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
    WS(weakSelf);
    [SVProgressHUD showWithStatus:@"正在搜索"];
    self.queryModel.KeyWord = searchBar.text;
    [MyClinicTool getClinicListWithQueryModel:self.queryModel success:^(NSArray *result) {
        [SVProgressHUD dismiss];
        if (result) {
            [weakSelf.searchController.resultsSource removeAllObjects];
            [weakSelf.searchController.resultsSource addObjectsFromArray:result];
            [weakSelf.searchController.searchResultsTableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
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
        __weak XLClinicsDisplayViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            // 1.获取当前的模型数据
            XLClinicModel *model = weakSelf.searchController.resultsSource[indexPath.row];
            
            // 2.创建cell
            XLClinicCell *cell = [XLClinicCell cellWithTableView:tableView];
            
            // 3.设置模型数据
            cell.model = model;
            
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [XLClinicCell cellHeight];
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
            [weakSelf setCellSelectWithIndexPath:indexPath source:weakSelf.searchController.resultsSource];
        }];
    }
    
    return _searchController;
}

- (XLClinicQueryModel *)queryModel{
    if (!_queryModel) {
         _queryModel = [[XLClinicQueryModel alloc] initWithKeyWord:@"" isAsc:NO doctorId:[AccountManager currentUserid]];
    }
    return _queryModel;
}

@end
