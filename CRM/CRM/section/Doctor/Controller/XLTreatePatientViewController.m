//
//  XLTreatePatientViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/8.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLTreatePatientViewController.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "UISearchBar+XLMoveBgView.h"
#import "MJRefresh.h"
#import "XLTreatePatientCell.h"
#import "UIColor+Extension.h"
#import "CommonMacro.h"

@interface XLTreatePatientViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    UITableView *_tableView;
}

@property (nonatomic, strong)EMSearchBar *searchBar;
@property (nonatomic, strong)EMSearchDisplayController *searchController;

@end

@implementation XLTreatePatientViewController

#pragma mark - 控件初始化
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
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
        
        __weak XLTreatePatientViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            return nil;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 68.f;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
        
        }];
    }
    return _searchController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载数据
    [self initSubViews];
    
//    [_tableView.header beginRefreshing];
}

- (void)initSubViews{
    
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
    //初始化表示图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    _tableView.backgroundColor = [UIColor colorWithHex:VIEWCONTROLLER_BACKGROUNDCOLOR];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
    //添加上拉刷新和下拉加载
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
    _tableView.header.updatedTimeHidden = YES;
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction)];
    _tableView.footer.hidden = YES;
    
    //初始化搜索框
    [self.view addSubview:self.searchBar];
    [self searchController];
}
#pragma mark - 下拉刷新数据
- (void)headerRefreshAction{
}
#pragma mark - 上拉加载数据
- (void)footerRefreshAction{

}

#pragma mark - 请求网络数据


#pragma mark - UITableViewDataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XLTreatePatientCell *cell = [XLTreatePatientCell cellWithTableView:tableView];
    
    return cell;
    
}

#pragma mark - UISearchBar Delegates
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isNotEmpty]) {

            
//            [self.searchController.resultsSource removeAllObjects];
//            [self.searchController.resultsSource addObjectsFromArray:array];
//            [self.searchController.searchResultsTableView reloadData];
    }
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
