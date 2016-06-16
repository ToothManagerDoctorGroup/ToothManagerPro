//
//  XLIntroducerViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/11.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLIntroducerViewController.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "MudItemsBar.h"
#import "MudItemBarItem.h"
#import "DBManager+Introducer.h"
#import "IntroducerCellMode.h"
#import "UISearchBar+XLMoveBgView.h"
#import "DBManager+sync.h"
#import "SyncManager.h"
#import "CRMMacro.h"
#import "UIColor+Extension.h"
#import "IntroducerTableViewCell.h"
#import "IntroPeopleDetailViewController.h"
#import "DBManager+AutoSync.h"
#import "MJExtension.h"
#import "JSONKit.h"
#import "CreateIntroducerViewController.h"
#import "MJRefresh.h"
#import "MLKMenuPopover.h"
#import "XLContactsViewController.h"
#import "XLNoIntroducerTintView.h"
#import "XLAutoGetSyncTool.h"

@interface XLIntroducerViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,MLKMenuPopoverDelegate>{
    UITableView *_tableView;
}

@property (nonatomic,retain) NSMutableArray * introducerCellModeArray;
@property (nonatomic,retain) NSArray * introducerInfoArray;

@property (nonatomic, strong)EMSearchBar *searchBar;
@property (nonatomic, strong)EMSearchDisplayController *searchController;

@property (nonatomic, assign)int pageCount;//分页使用的页数，默认是0
@property (nonatomic, assign)NSInteger allCount;//所有数据
/**
 *  菜单选项
 */
@property (nonatomic, strong)NSArray *menuList;
/**
 *  菜单弹出视图
 */
@property (nonatomic, strong)MLKMenuPopover *menuPopover;

@property (nonatomic, strong)XLNoIntroducerTintView *noIntroducerView;//提示视图

@end

@implementation XLIntroducerViewController;


#pragma mark - ********************* Life Method ***********************
- (void)dealloc {
    [self removeNotificationObserver];
    self.searchBar = nil;
    self.searchController = nil;
    _tableView = nil;
    self.noIntroducerView = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotificationObserver];
    
    //请求患者数据
    self.pageCount = 0;
    
    //加载子视图
    [self initSubViews];
    
    //显示加载视图
    [SVProgressHUD showWithStatus:@"正在加载"];
    //加载本地数据
    [self firstRequestLocalData];
}

#pragma mark - ********************* Private Method ***********************
- (void)refreshTableView{
    [_tableView reloadData];
}

- (void)initSubViews{
    if (self.isHome) {
        [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_new"]];
    }else{
        [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
        [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_new"]];
    }
    self.title = @"介绍人";
    
    //添加标题视图
    [self.view addSubview:[self setUpGroupViewAndButtons]];
    
    //初始化表示图
    if (self.isHome) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + 40, kScreenWidth, kScreenHeight - 64 - 44 - 44 - 40) style:UITableViewStylePlain];
    }else{
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + 40, kScreenWidth, kScreenHeight - 64 - 44 - 40) style:UITableViewStylePlain];
    }
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
     [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self.view addSubview:_tableView];
    //添加头部刷新控件
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
    _tableView.header.updatedTimeHidden = YES;
    //初始化搜索框
    [self.view addSubview:self.searchBar];
    [self searchController];
    [self noIntroducerView];
}

#pragma mark 加载本地数据
- (void)firstRequestLocalData{
    self.allCount = [[DBManager shareInstance] getIntroducerAllCount];
    self.pageCount = 0;
    [self requestLocalDataWitPage:self.pageCount isHeader:YES];
}

#pragma mark 下拉刷新
- (void)headerRefreshAction{
    //加载网络数据
    [SVProgressHUD showWithStatus:@"正在加载最新数据"];
    [[XLAutoGetSyncTool shareInstance] getIntroducerTableHasNext:NO];
}
#pragma mark 上拉加载
- (void)footerRefreshAction{
    if (self.introducerCellModeArray.count < self.allCount) {
        self.pageCount++;
        [self requestLocalDataWitPage:self.pageCount isHeader:NO];
    }
    else{
        [_tableView.footer noticeNoMoreData];
    }
}

#pragma mark 请求本地介绍人数据
- (void)requestLocalDataWitPage:(int)pageCount isHeader:(BOOL)isHeader
{
    WS(weakSelf);
    dispatch_queue_t introducer_queue = dispatch_queue_create("introducer_queue", NULL);
    dispatch_async(introducer_queue, ^{
        weakSelf.introducerInfoArray = [[DBManager shareInstance] getAllIntroducerWithPage:pageCount];
        
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSInteger i = 0; i < weakSelf.introducerInfoArray.count; i++) {
            Introducer *introducerInfo = [weakSelf.introducerInfoArray objectAtIndex:i];
            IntroducerCellMode *cellMode = [[IntroducerCellMode alloc]init];
            cellMode.ckeyid = introducerInfo.ckeyid;
            cellMode.name = introducerInfo.intr_name;
            cellMode.level = introducerInfo.intr_level;
            cellMode.count = [[DBManager shareInstance] numberIntroducedWithIntroducerId:introducerInfo.ckeyid];
            [arrayM addObject:cellMode];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            //刷新
            if (isHeader) {
                [weakSelf.introducerCellModeArray removeAllObjects];
                if ([_tableView.header isRefreshing]) {
                    [_tableView.header endRefreshing];
                }
                if (weakSelf.introducerInfoArray.count < CommonPageSize) {
                    [_tableView removeFooter];
                }else{
                    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction)];
                }
            }else{
                if ([_tableView.footer isRefreshing]) {
                    [_tableView.footer endRefreshing];
                }
            }
            [weakSelf.introducerCellModeArray addObjectsFromArray:[arrayM copy]];
            if (weakSelf.introducerInfoArray.count == 0) {
                weakSelf.noIntroducerView.hidden = NO;
                _tableView.tableHeaderView = weakSelf.noIntroducerView;
            }else{
                weakSelf.noIntroducerView.hidden = YES;
                _tableView.tableHeaderView = nil;
            }
            [_tableView reloadData];
            
        });
    });
}

#pragma mark 设置标题栏视图
- (UIView *)setUpGroupViewAndButtons{
    
    CGFloat commonW = kScreenWidth / 3;
    CGFloat commonH = 40;
    
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 44, kScreenWidth, commonH);
    bgView.backgroundColor = MyColor(238, 238, 238);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, kScreenWidth, 1)];
    label.backgroundColor = [UIColor colorWithHex:0xdddddd];
    [bgView addSubview:label];
    
    UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nameButton setTitle:@"姓名" forState:UIControlStateNormal];
    [nameButton setFrame:CGRectMake(0, 0, commonW, commonH)];
    [nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nameButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:nameButton];
    
    UIButton *statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [statusButton setTitle:@"介绍人数" forState:UIControlStateNormal];
    [statusButton setFrame:CGRectMake(nameButton.right, 0, commonW, commonH)];
    [statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    statusButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:statusButton];
    
    UIButton *introducerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [introducerButton setTitle:@"星级评分" forState:UIControlStateNormal];
    [introducerButton setFrame:CGRectMake(statusButton.right, 0, commonW, commonH)];
    [introducerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    introducerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:introducerButton];
    
    return bgView;
}

#pragma mark 按介绍人数量进行排序
- (void)sortByIntroCount{
    NSArray *lastArray = [NSArray arrayWithArray:self.introducerCellModeArray];
    lastArray = [self.introducerCellModeArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        IntroducerCellMode *object1 = (IntroducerCellMode *)obj1;
        IntroducerCellMode *object2 = (IntroducerCellMode *)obj2;
        if(object1.count < object2.count){
            return  NSOrderedDescending;
        }
        if (object1.count > object2.count){
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    self.introducerCellModeArray = [NSMutableArray arrayWithArray:lastArray];
}

#pragma mark Button Aciton
- (void)onBackButtonAction:(id)sender {
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [super onBackButtonAction:sender];
    }
}
- (void)onRightButtonAction:(id)sender {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self.menuPopover showInView:keyWindow];
}

#pragma mark NOtification
- (void)addNotificationObserver {
    [self addObserveNotificationWithName:IntroducerCreatedNotification];
    [self addObserveNotificationWithName:IntroducerEditedNotification];
    [self addObserveNotificationWithName:SyncGetSuccessNotification];
}

- (void)handNotification:(NSNotification *)notifacation {
    if ([notifacation.name isEqualToString:IntroducerCreatedNotification]
        || [notifacation.name isEqualToString:IntroducerEditedNotification] || [notifacation.name isEqualToString:SyncGetSuccessNotification]) {
        if ([_tableView.header isRefreshing]) {
            [_tableView.header endRefreshing];
        }
        [self firstRequestLocalData];
    }
}

#pragma mark - ******************* Delegate / DataSource *********************
#pragma mark UITableView Delegate
-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.introducerCellModeArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self setUpTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:self.introducerCellModeArray];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:self.introducerCellModeArray];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WS(weakSelf);
        TimAlertView *alertView = [[TimAlertView alloc]initWithTitle:@"确认删除？" message:nil  cancelHandler:^{
            [tableView reloadData];
        } comfirmButtonHandlder:^{
            Introducer *intro = [weakSelf.introducerInfoArray objectAtIndex:indexPath.row];
            BOOL ret = [[DBManager shareInstance] deleteIntroducerWithId:intro.ckeyid];
            if (ret) {
                //删除介绍人自动同步信息
                InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Introducer postType:Delete dataEntity:[intro.keyValues JSONString] syncStatus:@"0"];
                [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                
                [weakSelf.introducerCellModeArray removeObjectAtIndex:indexPath.row];
                [weakSelf refreshTableView];
            }
        }];
        [alertView show];
    }
}

#pragma mark MLKMenuPopoverDelegate
- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    [self.menuPopover dismissMenuPopover];
    if (selectedIndex == 0) {
        CreateIntroducerViewController *newIntoducerVC = [storyBoard instantiateViewControllerWithIdentifier:@"CreateIntroducerViewController"];
        newIntoducerVC.hidesBottomBarWhenPushed = YES;
        [self pushViewController:newIntoducerVC animated:YES];
    }else if (selectedIndex == 1){
        XLContactsViewController *contactVc = [[XLContactsViewController alloc] initWithStyle:UITableViewStylePlain];
        contactVc.type = ContactsImportTypeIntroducer;
        contactVc.hidesBottomBarWhenPushed = YES;
        [self pushViewController:contactVc animated:YES];
    }
}

#pragma mark 设置单元格
- (UITableViewCell *)setUpTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sourceArray:(NSArray *)sourceArray{
    static NSString * ideString = @"introducerCell";
    //cell选中时的背景颜色要与圆圈的背景颜色一致
    UIColor * seleColor = [UIColor colorWithRed:94.0f / 255.0f green:170.0f / 255.0f blue:235.0f / 255.0f alpha:1];
    
    IntroducerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ideString];
    if (cell == nil) {
        cell = [[IntroducerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ideString];
        //cell的背景颜色
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        //设置选中之后的颜色
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        [cell.selectedBackgroundView setBackgroundColor:seleColor];
    }
    
    //取出介绍人姓名和电话，以及介绍了多少个病人
    IntroducerCellMode *cellMode = [sourceArray objectAtIndex:indexPath.row];
    cell.name = cellMode.name;
    cell.count = cellMode.count;
    cell.level = cellMode.level;
    
    return cell;
}

#pragma mark 设置单元格点击事件
- (void)selectTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sourceArray:(NSArray *)sourceArray{
    NSInteger row = [indexPath row];
    
    
    IntroducerCellMode *cellMode = [sourceArray objectAtIndex:row];
    Introducer *introducer = [[DBManager shareInstance] getIntroducerByCkeyId:cellMode.ckeyid];
    
    //如果是“编辑患者”选择“介绍人”进来，则只显示intr_id为0的介绍人，也就是本地介绍人
    if (self.Mode == IntroducePersonViewSelect && self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didSelectedIntroducer:)]) {
            [self.delegate didSelectedIntroducer:introducer];
            [self onBackButtonAction:nil];
        }
    } else {
        IntroPeopleDetailViewController * detailCtl = [[IntroPeopleDetailViewController alloc] init];
        [detailCtl setIntroducer:introducer];
        detailCtl.hidesBottomBarWhenPushed = YES;
        [self pushViewController:detailCtl animated:YES];
    }
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
        searchResults = [[DBManager shareInstance] getIntroducerByName:searchText];
        [self.searchController.resultsSource removeAllObjects];
        for (Introducer *intro in searchResults) {
            IntroducerCellMode *cellMode = [[IntroducerCellMode alloc] init];
            cellMode.ckeyid = intro.ckeyid;
            cellMode.name = intro.intr_name;
            cellMode.level = intro.intr_level;
            cellMode.count = [[DBManager shareInstance] numberIntroducedWithIntroducerId:intro.ckeyid];
            [self.searchController.resultsSource addObject:cellMode];
        }
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

#pragma mark - UISearchDisplayDelegate
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - ********************* Lazy Method ***********************
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
        __weak XLIntroducerViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            return [weakSelf setUpTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:weakSelf.searchController.resultsSource];
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 44;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
            [weakSelf selectTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:weakSelf.searchController.resultsSource];
            
        }];
        //设置可编辑模式
        [_searchController setCanEditRowAtIndexPath:^BOOL(UITableView *tableView, NSIndexPath *indexPath) {
            return YES;
        }];
        //编辑模式下的删除操作
        [_searchController setCommitEditingStyleAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            
            TimAlertView *alertView = [[TimAlertView alloc]initWithTitle:@"确认删除？" message:nil  cancelHandler:^{
            } comfirmButtonHandlder:^{
                IntroducerCellMode *introCell = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
                Introducer *intro = [[DBManager shareInstance] getIntroducerByCkeyId:introCell.ckeyid];
                BOOL ret = [[DBManager shareInstance] deleteIntroducerWithId:intro.ckeyid];
                if (ret) {
                    //删除介绍人自动同步信息
                    InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Introducer postType:Delete dataEntity:[intro.keyValues JSONString] syncStatus:@"0"];
                    [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                    
                    [weakSelf.searchController.resultsSource removeObject:introCell];
                    [tableView reloadData];
                    
                    if ([weakSelf.introducerCellModeArray containsObject:introCell]) {
                        [weakSelf.introducerCellModeArray removeObject:introCell];
                    }
                    [weakSelf refreshTableView];
                    
                }
                
            }];
            [alertView show];
        }];
    }
    return _searchController;
}

- (XLNoIntroducerTintView *)noIntroducerView{
    if (!_noIntroducerView) {
        _noIntroducerView = [[XLNoIntroducerTintView alloc] initWithFrame:_tableView.bounds];
        _noIntroducerView.hidden = YES;
    }
    return _noIntroducerView;
}

- (MLKMenuPopover *)menuPopover{
    if (!_menuPopover) {
        MLKMenuPopover *menuPopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake(kScreenWidth - 120 - 8, 64, 120, self.menuList.count * 44) menuItems:self.menuList];
        menuPopover.menuPopoverDelegate = self;
        _menuPopover = menuPopover;
    }
    return _menuPopover;
}

- (NSArray *)menuList{
    if (_menuList == nil) {
        _menuList = [NSArray arrayWithObjects:@"手工录入",@"通讯录导入", nil];
    }
    return _menuList;
}

- (NSMutableArray *)introducerCellModeArray{
    if (!_introducerCellModeArray) {
        _introducerCellModeArray = [NSMutableArray array];
    }
    return _introducerCellModeArray;
}

- (NSArray *)introducerInfoArray{
    if (!_introducerInfoArray) {
        _introducerInfoArray = [NSArray array];
    }
    return _introducerInfoArray;
}

@end
