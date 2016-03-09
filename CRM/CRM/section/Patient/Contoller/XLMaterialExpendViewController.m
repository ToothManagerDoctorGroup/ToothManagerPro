//
//  XLMaterialExpendViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLMaterialExpendViewController.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "UISearchBar+XLMoveBgView.h"
#import "UIColor+Extension.h"
#import "CommonMacro.h"
#import "XLMaterialExpenseCell.h"
#import "DBManager+Materials.h"
#import "CaseMaterialsViewController.h"

@interface XLMaterialExpendViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,CaseMaterialsViewControllerDelegate>{
    UITableView *_tableView;
}

@property (nonatomic, strong)NSArray *expenses;

@property (nonatomic, strong)EMSearchBar *searchBar;
@property (nonatomic, strong)EMSearchDisplayController *searchController;

@end

@implementation XLMaterialExpendViewController

- (NSArray *)expenses{
    if (!_expenses) {
        _expenses = [[DBManager shareInstance] getMedicalExpenseArrayWithMedicalCaseId:self.medicalCase_id];
        for (MedicalExpense *temp in _expenses) {
            temp.mat_name = [[DBManager shareInstance] getMaterialWithId:temp.mat_id].mat_name;
        }
    }
    return _expenses;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所用耗材";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"管理"];
    
    //初始化子视图
    [self setUpView];
}
#pragma mark - 初始化子视图
- (void)setUpView{
    //初始化搜索框
    [self.view addSubview:self.searchBar];
    [self searchController];
    //初始化表示图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 * 2, kScreenWidth, self.view.height - 44 * 2) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
    [self setUpTitleView];
    
}
//设置标题视图
- (void)setUpTitleView{
    CGFloat commonW = kScreenWidth / 2;
    NSArray *titles = @[@"耗材类型",@"数量"];
    for (int i = 0; i < titles.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(commonW * i, 44, commonW, 44)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor colorWithHex:0x333333];
        titleLabel.backgroundColor = MyColor(238, 238, 238);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = titles[i];
        [self.view addSubview:titleLabel];
    }
    
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 87.5, kScreenWidth, 0.5)];
    divider.backgroundColor = [UIColor colorWithHex:0xCCCCCC];
    [self.view addSubview:divider];
}

#pragma mark - Table view data source
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"患者姓名、备注名、手机号";
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
        
        __weak XLMaterialExpendViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            return nil;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 40;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
        }];
        
        [_searchController setCanEditRowAtIndexPath:^BOOL(UITableView *tableView, NSIndexPath *indexPath) {
            return YES;
        }];
        
        [_searchController setCommitEditingStyleAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
        
        }];
    }
    
    return _searchController;
}

- (void)onRightButtonAction:(id)sender{
    //跳转界面
    CaseMaterialsViewController *caseMaterialVC = [[CaseMaterialsViewController alloc]initWithStyle:UITableViewStylePlain];
    caseMaterialVC.materialsArray = [NSMutableArray arrayWithCapacity:0];
    [caseMaterialVC.materialsArray addObjectsFromArray:self.expenses];
    caseMaterialVC.delegate = self;
    [self pushViewController:caseMaterialVC animated:YES];
}

#pragma mark - UITableViewDataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.expenses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XLMaterialExpenseCell *cell = [XLMaterialExpenseCell cellWithTableView:tableView];
    cell.expense = self.expenses[indexPath.row];
    
    return cell;
}

#pragma mark - CaseMaterialsViewControllerDelegate
- (void)didSelectedMaterialsArray:(NSArray *)array{
    self.expenses = array;
    [_tableView reloadData];
}

#pragma mark - UISearchBar Delegates
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSArray *searchResults;
    if ([searchText isNotEmpty]) {
//        searchResults = [ChineseSearchEngine resultArraySearchMaterialOnArray:dataArray withSearchText:searchText];
        [self.searchController.resultsSource removeAllObjects];
        [self.searchController.resultsSource addObjectsFromArray:searchResults];
        [self.searchController.searchResultsTableView reloadData];
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