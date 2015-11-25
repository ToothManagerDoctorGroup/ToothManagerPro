//
//  IntroducerViewController.m
//  CRM
//
//  Created by TimTiger on 10/22/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "IntroducerViewController.h"
#import "IntroducerTableViewCell.h"
#import "IntroducerCellMode.h"
#import "CRMMacro.h"
#import "UIColor+Extension.h"
#import "ChineseSearchEngine.h"
#import "IntroPeopleDetailViewController.h"
#import "CreateIntroducerViewController.h"
#import "DBManager.h"
#import "DBManager+Introducer.h"
#import "ChineseSearchEngine.h"
#import "AddressBookViewController.h"
#import "DoctorsViewController.h"
#import "MudItemBarItem.h"
#import "MudItemsBar.h"
#import "CreateIntroducerViewController.h"
#import "SyncManager.h"

@interface IntroducerViewController () <MudItemsBarDelegate>
@property (nonatomic,retain) MudItemsBar *menubar;
@property (nonatomic) BOOL isBarHidden;
@property (nonatomic,retain) NSMutableArray * introducerCellModeArray;
@property (nonatomic,retain) NSArray * introducerInfoArray;
@property (nonatomic,readwrite) BOOL useSearchResult;
@property (nonatomic,retain) NSArray *searchResults;
@end

@implementation IntroducerViewController
@synthesize introducerInfoArray,introducerCellModeArray,useSearchResult = _useSearchResult,searchResults = _searchResults;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initView {
    [super initView];
    if (self.isHome) {
        [self setLeftBarButtonWithImage:[UIImage imageNamed:@"ic_nav_tongbu"]];
    }else{
        [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    }
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_new"]];
    self.searchDisplayController.searchBar.placeholder = @"搜索介绍人";
    self.title = @"介绍人";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)refreshView {
    [super refreshView];
    [self.tableView reloadData];
}

- (void)initData
{
    [super initData];
    self.isBarHidden = YES;
    introducerInfoArray = [[DBManager shareInstance] getAllIntroducer];
    introducerCellModeArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < introducerInfoArray.count; i++) {
        Introducer *introducerInfo = [introducerInfoArray objectAtIndex:i];
        IntroducerCellMode *cellMode = [[IntroducerCellMode alloc]init];
        cellMode.ckeyid = introducerInfo.ckeyid;
        cellMode.name = introducerInfo.intr_name;
        cellMode.level = introducerInfo.intr_level;
        cellMode.count = [[DBManager shareInstance] numberIntroducedWithIntroducerId:introducerInfo.ckeyid];
        [introducerCellModeArray addObject:cellMode];
    }
    
    //如果是“编辑患者”选择“介绍人”进来，则只显示intr_id为0的介绍人，也就是本地介绍人
    if (self.Mode == IntroducePersonViewSelect && self.delegate) {
        [introducerCellModeArray removeAllObjects];
        for (NSInteger i = 0; i < introducerInfoArray.count; i++) {
            Introducer *introducerInfo = [introducerInfoArray objectAtIndex:i];

            if([introducerInfo.intr_id isEqualToString:@"0"]){
                IntroducerCellMode *cellMode = [[IntroducerCellMode alloc]init];
                cellMode.ckeyid = introducerInfo.ckeyid;
                cellMode.name = introducerInfo.intr_name;
                cellMode.level = introducerInfo.intr_level;
                cellMode.count = [[DBManager shareInstance] numberIntroducedWithIntroducerId:introducerInfo.ckeyid];
                [introducerCellModeArray addObject:cellMode];
            }
        }
    }
}

- (void)refreshData {
    introducerInfoArray = nil;
    introducerInfoArray = [[DBManager shareInstance] getAllIntroducer];
    [introducerCellModeArray removeAllObjects];
    for (NSInteger i = 0; i < introducerInfoArray.count; i++) {
        Introducer *introducerInfo = [introducerInfoArray objectAtIndex:i];
        IntroducerCellMode *cellMode = [[IntroducerCellMode alloc]init];
        cellMode.ckeyid = introducerInfo.ckeyid;
        cellMode.name = introducerInfo.intr_name;
        cellMode.level = introducerInfo.intr_level;
        cellMode.count = [[DBManager shareInstance] numberIntroducedWithIntroducerId:introducerInfo.ckeyid];
        [introducerCellModeArray addObject:cellMode];
    }
    //如果是“编辑患者”选择“介绍人”进来，则只显示intr_id为0的介绍人，也就是本地介绍人
    if (self.Mode == IntroducePersonViewSelect && self.delegate) {
        [introducerCellModeArray removeAllObjects];
        for (NSInteger i = 0; i < introducerInfoArray.count; i++) {
            Introducer *introducerInfo = [introducerInfoArray objectAtIndex:i];
            
            if([introducerInfo.intr_id isEqualToString:@"0"]){
                IntroducerCellMode *cellMode = [[IntroducerCellMode alloc]init];
                cellMode.ckeyid = introducerInfo.ckeyid;
                cellMode.name = introducerInfo.intr_name;
                cellMode.level = introducerInfo.intr_level;
                cellMode.count = [[DBManager shareInstance] numberIntroducedWithIntroducerId:introducerInfo.ckeyid];
                [introducerCellModeArray addObject:cellMode];
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isBarHidden == NO){                      //如果是显示状态
        [self.menubar hiddenBar:self.navigationController.view WithBarAnimation:MudItemsBarAnimationTop];
    }
}

- (void)dealloc {
    [self removeNotificationObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Aciton
- (void)onBackButtonAction:(id)sender {
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
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
}

- (void)removeNotificationObserver {
    [super removeNotificationObserver];
    [self removeObserverNotificationWithName:IntroducerCreatedNotification];
    [self removeObserverNotificationWithName:IntroducerEditedNotification];
}

- (void)handNotification:(NSNotification *)notifacation {
    [super handNotification:notifacation];
    if ([notifacation.name isEqualToString:IntroducerCreatedNotification]
        || [notifacation.name isEqualToString:IntroducerEditedNotification]) {
        [self refreshData];
        [self refreshView];
    }
}

#pragma mark - UITableView Delegate
-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self isSearchResultsTableView:tableView]) {
        return [self.searchResults count];
    } else {
        return [self.introducerCellModeArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    IntroducerCellMode * cellMode = nil;
    if ([self isSearchResultsTableView:tableView]) {
        cellMode = [_searchResults objectAtIndex:indexPath.row];
    } else {
        cellMode = [introducerCellModeArray objectAtIndex:indexPath.row];
    }
    
    cell.name = cellMode.name;
    cell.count = cellMode.count;
    cell.level = cellMode.level;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    Introducer * introducer;
    if ([self isSearchResultsTableView:tableView]) {
        IntroducerCellMode *cellMode = [_searchResults objectAtIndex:row];
        for (Introducer *introducerTmp in introducerInfoArray) {
            if (introducerTmp.ckeyid == cellMode.ckeyid) {
                introducer = introducerTmp;
            }
        }
    } else {
        introducer = [introducerInfoArray objectAtIndex:row];
    }
    //如果是“编辑患者”选择“介绍人”进来，则只显示intr_id为0的介绍人，也就是本地介绍人
    if (self.Mode == IntroducePersonViewSelect && self.delegate) {
        NSMutableArray *aara = [[NSMutableArray alloc]initWithCapacity:0];
            for (NSInteger i = 0; i < introducerInfoArray.count; i++) {
                Introducer *introducerInfo = [introducerInfoArray objectAtIndex:i];
                if([introducerInfo.intr_id isEqualToString:@"0"]){
                    [aara addObject:introducerInfo];
                }
            }
        introducer = [aara objectAtIndex:row];
        
        //如果是搜索栏下
        if([self isSearchResultsTableView:tableView]){
            NSMutableArray *aara = [[NSMutableArray alloc]initWithCapacity:0];
            for(NSInteger i = 0;i<[_searchResults count];i++){
                for(NSInteger j=0;j<[introducerInfoArray count];j++){
                    Introducer *introducerTmp = [introducerInfoArray objectAtIndex:j];
                    IntroducerCellMode *cellMode = [_searchResults objectAtIndex:i];
                    if(introducerTmp.ckeyid == cellMode.ckeyid && [introducerTmp.intr_id isEqualToString:@"0"]){
                        [aara addObject:introducerTmp];
                    }
                }
            }
            introducer = [aara objectAtIndex:row];
        }
        
        if ([self.delegate respondsToSelector:@selector(didSelectedIntroducer:)]) {
            [self.delegate didSelectedIntroducer:introducer];
            [self onBackButtonAction:nil];
        }
    } else {
        IntroPeopleDetailViewController * detailCtl = [[IntroPeopleDetailViewController alloc]init];
        [detailCtl setIntroducer:introducer];
        detailCtl.hidesBottomBarWhenPushed = YES;
        [self pushViewController:detailCtl animated:YES];
    }
}

#pragma mark - TableView Editing
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return ![self isSearchResultsTableView:tableView];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TimAlertView *alertView = [[TimAlertView alloc]initWithTitle:@"确认删除？" message:nil  cancelHandler:^{
            [tableView reloadData];
        } comfirmButtonHandlder:^{
            Introducer *intro = [introducerInfoArray objectAtIndex:indexPath.row];
            BOOL ret = [[DBManager shareInstance] deleteIntroducerWithId:intro.ckeyid];
            if (ret) {
                [self refreshData];
                [self refreshView];
            }
        }];
        [alertView show];
    }
}

#pragma mark - Searching 
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    if ([searchString isNotEmpty]) {
        self.searchResults = [ChineseSearchEngine resultArraySearchIntroducerOnArray:introducerCellModeArray withSearchText:searchString];
    }
    return YES;
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

@end
