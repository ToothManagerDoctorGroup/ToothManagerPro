//
//  IntroducePersonViewController.m
//  CRM
//
//  Created by fankejun on 14-5-13.
//  Copyright (c) 2014年 mifeo. All rights reserved.
//

#import "IntroducePersonViewController.h"
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


@interface IntroducePersonViewController () <UISearchBarDelegate,TimNavigationBarMenuViewDelegate>
{
    TimNavigationBarMenuView *menuView;
}


@property (nonatomic,retain) UITableView * myTableView;
@property (nonatomic,retain) TimSearchBar * mySerchBar;
@property (nonatomic,retain) NSMutableArray * introducerCellModeArray;
@property (nonatomic,retain) NSArray * introducerInfoArray;
@property (nonatomic,readwrite) BOOL useSearchResult;
@property (nonatomic,readonly) NSArray *searchResults;

@end

@implementation IntroducePersonViewController
@synthesize mySerchBar,myTableView,introducerInfoArray,introducerCellModeArray,useSearchResult = _useSearchResult,searchResults = _searchResults;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"介绍人";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNotificationObserver];
}

- (void)initView  {
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_new"]];
    [self loadSearchBar];
    [self loadTableView];
}

- (void)refreshView {
    [super refreshView];
    [self.myTableView reloadData];
}

- (void)initData
{
    introducerInfoArray = [[DBManager shareInstance] getAllIntroducerWithPage:0];
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
}

- (void)refreshData {
    introducerInfoArray = nil;
    introducerInfoArray = [[DBManager shareInstance] getAllIntroducerWithPage:0];
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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (menuView) {
        menuView.hidden = YES;
    }
}

- (void)dealloc {
    [self removeNotificationObserver];
}

#pragma mark - Private API
- (void)loadSearchBar
{
    mySerchBar = [[TimSearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    mySerchBar.delegate = self;
    [self.view addSubview:mySerchBar];
}

- (void)loadTableView
{
    myTableView = [[UITableView alloc]init];
    [myTableView setFrame:CGRectMake(0,
                                     mySerchBar.frame.origin.y + mySerchBar.frame.size.height,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height - mySerchBar.frame.size.height)];
    [myTableView setBackgroundColor:[UIColor clearColor]];
    [myTableView setDelegate:self];
    [myTableView setDataSource:self];
    //去掉多余的cell
    myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:myTableView];
}

#pragma mark - Button Action
- (void)onRightButtonAction:(id)sender {
    if (menuView == nil) {
        menuView = [[TimNavigationBarMenuView alloc]initWithFrame:CGRectMake(self.navigationController.view.bounds.size.width-160,64, 150, 80)];
        menuView.delegate = self;
        menuView.menuArray = @[@"通讯录导入",@"新建介绍人"];
        [self.navigationController.view addSubview:menuView];
         menuView.hidden = YES;
    }
    menuView.hidden = !menuView.hidden;
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
    if (_useSearchResult) {
        return [_searchResults count];
    } else {
        return [introducerCellModeArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString * ideString = @"introducerCell";
    //cell选中时的背景颜色要与圆圈的背景颜色一致
    UIColor * seleColor = [UIColor colorWithRed:94.0f / 255.0f green:170.0f / 255.0f blue:235.0f / 255.0f alpha:1];
    
    IntroducerTableViewCell * cell = [myTableView dequeueReusableCellWithIdentifier:ideString];
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
    if (_useSearchResult) {
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
    if (_useSearchResult) {
        IntroducerCellMode *cellMode = [_searchResults objectAtIndex:row];
        for (Introducer *introducerTmp in introducerInfoArray) {
            if (introducerTmp.ckeyid == cellMode.ckeyid) {
                introducer = introducerTmp;
            }
        }
    } else {
        introducer = [introducerInfoArray objectAtIndex:row];
    }
    if (self.Mode == IntroducePersonViewSelect && self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didSelectedIntroducer:)]) {
            [self.delegate didSelectedIntroducer:introducer];
            [self popViewControllerAnimated:YES];
        }
    } else {
        IntroPeopleDetailViewController * detailCtl = [[IntroPeopleDetailViewController alloc]init];
        [detailCtl setIntroducer:introducer];
        [self pushViewController:detailCtl animated:YES];
    }
}

//tableview editing
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return !_useSearchResult;
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

#pragma mark -  UISearchBar Delegates
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if ([searchText isEmpty]) {
        _useSearchResult = NO;
        [myTableView reloadData];
        return;
    }
    
    _searchResults = nil;
    _searchResults = [ChineseSearchEngine resultArraySearchIntroducerOnArray:introducerCellModeArray withSearchText:searchText];
    _useSearchResult = YES;
    [myTableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = nil;
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardHideNotification object:nil];
}

#pragma mark -- keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [mySerchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TimNavigationBarMenuViewDelegate
- (void)menuView:(UITableView *)menuView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            AddressBookViewController *addressBook = [[AddressBookViewController alloc]init];
            addressBook.type = ImportTypeIntroducer;
            [self pushViewController:addressBook animated:YES];
        }
            break;
        case 1:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            CreateIntroducerViewController * createIntroCtl = [storyboard instantiateViewControllerWithIdentifier:@"CreateIntroducerViewController"];
            [self pushViewController:createIntroCtl animated:YES];
        }
            break;
        default:
            break;
    }
}


@end
