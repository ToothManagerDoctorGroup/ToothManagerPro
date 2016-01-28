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
#import "AddressBookViewController.h"
#import "CreateIntroducerViewController.h"
#import "MJRefresh.h"

@interface XLIntroducerViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,MudItemsBarDelegate,UISearchDisplayDelegate>{
    UITableView *_tableView;
}

@property (nonatomic,retain) MudItemsBar *menubar;
@property (nonatomic) BOOL isBarHidden;
@property (nonatomic,retain) NSMutableArray * introducerCellModeArray;
@property (nonatomic,retain) NSArray * introducerInfoArray;

@property (nonatomic, strong)EMSearchBar *searchBar;
@property (nonatomic, strong)EMSearchDisplayController *searchController;

@property (nonatomic, assign)int pageCount;//分页使用的页数，默认是0

@end

@implementation XLIntroducerViewController;

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

- (void)dealloc {
    [self removeNotificationObserver];
    self.searchBar = nil;
    self.searchController = nil;
    _tableView = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotificationObserver];
    
    //请求患者数据
    self.pageCount = 0;
    
    //加载子视图
    [self initSubViews];
    
    //加载数据
    [_tableView.header beginRefreshing];
    
}

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

- (void)refreshTableView{
    [_tableView reloadData];
}

- (void)initSubViews{
    if (self.isHome) {
        [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_new"]];
//        [self setLeftBarButtonWithImage:[UIImage imageNamed:@"ic_nav_tongbu"]];
    }else{
        [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
        [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_new"]];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"介绍人";
    
    //初始化表示图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 64 - 44 - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    //添加头部刷新控件
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
    _tableView.header.updatedTimeHidden = YES;
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction)];
    //初始化搜索框
    [self.view addSubview:self.searchBar];
    [self searchController];
}

#pragma mark - 下拉刷新
- (void)headerRefreshAction{
    self.pageCount = 0;
    [self requestLocalDataWitPage:self.pageCount isHeader:YES];
}
#pragma mark - 上拉加载
- (void)footerRefreshAction{
    [self requestLocalDataWitPage:self.pageCount isHeader:NO];
}

#pragma mark - 请求本地介绍人数据
- (void)requestLocalDataWitPage:(int)pageCount isHeader:(BOOL)isHeader
{
    self.isBarHidden = YES;
    if (self.Mode == IntroducePersonViewSelect) {
        self.introducerInfoArray = [[DBManager shareInstance] getLocalIntroducerWithPage:self.pageCount];
    }else {
        self.introducerInfoArray = [[DBManager shareInstance] getAllIntroducerWithPage:pageCount];
    }
    if (self.introducerInfoArray.count > 50) {
        self.pageCount++;
    }
    if (isHeader) {
        [self.introducerCellModeArray removeAllObjects];
    }
    
    for (NSInteger i = 0; i < self.introducerInfoArray.count; i++) {
        Introducer *introducerInfo = [self.introducerInfoArray objectAtIndex:i];
        IntroducerCellMode *cellMode = [[IntroducerCellMode alloc]init];
        cellMode.ckeyid = introducerInfo.ckeyid;
        cellMode.name = introducerInfo.intr_name;
        cellMode.level = introducerInfo.intr_level;
        cellMode.count = [[DBManager shareInstance] numberIntroducedWithIntroducerId:introducerInfo.ckeyid];
        [self.introducerCellModeArray addObject:cellMode];
    }
//    //如果是“编辑患者”选择“介绍人”进来，则只显示intr_id为0的介绍人，也就是本地介绍人
//    if (self.Mode == IntroducePersonViewSelect && self.delegate) {
//        for (NSInteger i = 0; i < self.introducerInfoArray.count; i++) {
//            Introducer *introducerInfo = [self.introducerInfoArray objectAtIndex:i];
//            if([introducerInfo.intr_id isEqualToString:@"0"]){
//                IntroducerCellMode *cellMode = [[IntroducerCellMode alloc]init];
//                cellMode.ckeyid = introducerInfo.ckeyid;
//                cellMode.name = introducerInfo.intr_name;
//                cellMode.level = introducerInfo.intr_level;
//                cellMode.count = [[DBManager shareInstance] numberIntroducedWithIntroducerId:introducerInfo.ckeyid];
//                [self.introducerCellModeArray addObject:cellMode];
//            }
//        }
//    }else{
//        
//    }
    
    //对数据进行排序，按介绍人数进行排序
//    [self sortByIntroCount];
    
    if (self.introducerCellModeArray.count < 50) {
        [_tableView removeFooter];
    }
    //刷新
    if (isHeader) {
        [_tableView.header endRefreshing];
    }else{
        [_tableView.footer endRefreshing];
    }
    [_tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    if (self.isBarHidden == NO){                      //如果是显示状态
        [self.menubar hiddenBar:self.navigationController.view WithBarAnimation:MudItemsBarAnimationTop];
    }
}
#pragma mark - 按介绍人数量进行排序
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

#pragma mark - Button Aciton
- (void)onBackButtonAction:(id)sender {
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [super onBackButtonAction:sender];
    }
}

-(void)onLeftButtonAction:(id)sender{
    [SVProgressHUD showWithStatus:@"同步中..."];
    if ([[AccountManager shareInstance] isLogin]) {
        [NSTimer scheduledTimerWithTimeInterval:0.2
                                         target:self
                                       selector:@selector(callSync)
                                       userInfo:nil
                                        repeats:NO];
        
    } else {
        NSLog(@"User did not login");
        [SVProgressHUD showWithStatus:@"同步失败，请先登录..."];
        [SVProgressHUD dismiss];
        [NSThread sleepForTimeInterval: 1];
    }
}
- (void)callSync {
    [[SyncManager shareInstance] startSync];
}

- (void)onRightButtonAction:(id)sender {
    if (self.isBarHidden == YES) { //如果是消失状态
        [self setupMenuBar];
        [self.menubar showBar:self.navigationController.view WithBarAnimation:MudItemsBarAnimationTop];
    } else {                      //如果是显示状态
        [self.menubar hiddenBar:self.navigationController.view WithBarAnimation:MudItemsBarAnimationTop];
    }
    self.isBarHidden = !self.isBarHidden;
}

- (void)setupMenuBar {
    if (self.menubar == nil) {
        _menubar = [[MudItemsBar alloc]init];
        self.menubar.delegate = self;
        self.menubar.duration = 0.15;
        self.menubar.barOrigin = CGPointMake(0, 64.5);
        self.menubar.backgroundColor = [UIColor colorWithHex:MENU_BAR_BACKGROUND_COLOR];
        UIImage *normalImage = [[UIImage imageNamed:@"baritem_normal_bg"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5];
        UIImage *selectImage = [[UIImage imageNamed:@"baritem_select_bg"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5];
        MudItemBarItem *itemAddressBook = [[MudItemBarItem alloc]init];
        itemAddressBook.text = @"新建介绍人";
        itemAddressBook.iteImage = [UIImage imageNamed:@"file"];
        [itemAddressBook setBackgroundImage:normalImage forState:UIControlStateNormal];
        [itemAddressBook setBackgroundImage:selectImage forState:UIControlStateHighlighted];
        MudItemBarItem *itemAdd = [[MudItemBarItem alloc]init];
        itemAdd.text = @"通讯录导入";
        itemAdd.iteImage = [UIImage imageNamed:@"copyfile"];
        [itemAdd setBackgroundImage:normalImage forState:UIControlStateNormal];
        [itemAdd setBackgroundImage:selectImage forState:UIControlStateHighlighted];
        self.menubar.items = [NSArray arrayWithObjects:itemAdd,itemAddressBook,nil];
    }
}

#pragma mark - NOtification
- (void)addNotificationObserver {
    [super addNotificationObserver];
    [self addObserveNotificationWithName:IntroducerCreatedNotification];
    [self addObserveNotificationWithName:IntroducerEditedNotification];
    [self addObserveNotificationWithName:@"tongbu"];
}


- (void)handNotification:(NSNotification *)notifacation {
    [super handNotification:notifacation];
    if ([notifacation.name isEqualToString:IntroducerCreatedNotification]
        || [notifacation.name isEqualToString:IntroducerEditedNotification] || [notifacation.name isEqualToString:@"tongbu"]) {
        [self headerRefreshAction];
    }
}


#pragma mark - UITableView Delegate
-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.introducerCellModeArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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

#pragma mark - TableView Editing
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TimAlertView *alertView = [[TimAlertView alloc]initWithTitle:@"确认删除？" message:nil  cancelHandler:^{
            [tableView reloadData];
        } comfirmButtonHandlder:^{
            Introducer *intro = [self.introducerInfoArray objectAtIndex:indexPath.row];
            BOOL ret = [[DBManager shareInstance] deleteIntroducerWithId:intro.ckeyid];
            if (ret) {
                //删除介绍人自动同步信息
                InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Introducer postType:Delete dataEntity:[intro.keyValues JSONString] syncStatus:@"0"];
                [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                
                [self.introducerCellModeArray removeObjectAtIndex:indexPath.row];
                [self refreshTableView];
            }
        }];
        [alertView show];
    }
}

#pragma mark -设置单元格
- (UITableViewCell *)setUpTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sourceArray:(NSArray *)sourceArray{
    static NSString * ideString = @"introducerCell";
    //cell选中时的背景颜色要与圆圈的背景颜色一致
    UIColor * seleColor = [UIColor colorWithRed:94.0f / 255.0f green:170.0f / 255.0f blue:235.0f / 255.0f alpha:1];
    
    IntroducerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ideString];
    if (cell == nil) {
        cell = [[IntroducerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ideString];
        //cell的背景颜色
        [cell.contentView setBackgroundColor:self.view.backgroundColor];
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

#pragma mark -设置单元格点击事件
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


#pragma mark - MudItemsBarDelegate
- (void)itemsBar:(MudItemsBar *)itemsBar clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    switch (buttonIndex) {
            
        case 0:
        {
            AddressBookViewController *addressBook =[storyBoard instantiateViewControllerWithIdentifier:@"AddressBookViewController"];
            addressBook.type = ImportTypeIntroducer;
            addressBook.hidesBottomBarWhenPushed = YES;
            [self pushViewController:addressBook animated:YES];
        }
            break;
        case 1:
        {
            CreateIntroducerViewController *newIntoducerVC = [storyBoard instantiateViewControllerWithIdentifier:@"CreateIntroducerViewController"];
            newIntoducerVC.hidesBottomBarWhenPushed = YES;
            [self pushViewController:newIntoducerVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)itemsBarWillDisAppear {
    self.isBarHidden = YES;
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
//        searchResults = [ChineseSearchEngine resultArraySearchIntroducerOnArray:self.introducerCellModeArray withSearchText:searchText];
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


@end
