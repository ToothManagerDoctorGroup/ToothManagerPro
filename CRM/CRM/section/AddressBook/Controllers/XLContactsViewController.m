
//
//  XLContactsViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/15.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLContactsViewController.h"
#import "XLContactCell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "DBManager+Patients.h"
#import "DBManager+Introducer.h"
#import "DBManager+AutoSync.h"
#import "JSONKit.h"
#import "MJExtension.h"
#import "PatientSegumentController.h"
#import "XLAddressBookFailView.h"
#import "XLContactsManager.h"

@interface XLContactsViewController ()<XLContactCellDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic,strong) NSMutableArray *sectionArray;//有多少组
@property (nonatomic, strong) NSMutableArray *sectionTitlesArray;//每组多少个联系人
@property (nonatomic, strong) NSMutableArray *contacts;//原数组

@property (nonatomic, strong)EMSearchBar *searchBar;
@property (nonatomic, strong)EMSearchDisplayController *searchController;

/**
 *  判断是否是UISearchDisplayController
 */
@property (nonatomic, assign)BOOL isSearchDisplayController;
/**
 *  保存UISearchDisplayController的tableView
 */
@property (nonatomic, weak)UITableView *searchResultTableView;

@end

@implementation XLContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //子控件初始化
    [self setUpViews];
    //添加通知
    [self addNotificationObserver];
    //获取所有联系人
    [self getAllContacts];
}

#pragma mark - 子控件初始化
- (void)setUpViews{
    //判断类型
    if (self.type == ContactsImportTypePatients) {
        self.title = @"通讯录导入患者";
    }
    if (self.type == ContactsImportTypeIntroducer) {
        self.title = @"通讯录导入介绍人";
    }
    self.tableView.allowsSelection = NO;
    
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
    self.tableView.rowHeight = [XLContactCell fixedHeight];
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionHeaderHeight = 25;
    //设置搜索框
    self.tableView.tableHeaderView = [self searchBar];
    [self searchController];
}

#pragma mark - 添加通知
- (void)addNotificationObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(allowAccessContacts)
                                                 name:XLContactAccessAllowedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accessDenied)
                                                 name:XLContactAccessDeniedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accessFailed)
                                                 name:XLContactAccessFailedNotification
                                               object:nil];
}

#pragma mark - 获取联系人数据
- (void)getAllContacts{
    //获取联系人
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在获取联系人列表"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        XLContactsManager *manager = [[XLContactsManager alloc] init];
        [weakSelf.contacts addObjectsFromArray:[manager loadAllPeople]];
        if (self.type == ContactsImportTypePatients) {
            for (XLContact *model in weakSelf.contacts) {
                if (model.phoneNumbers.count > 0) {
                    model.hasAdd = [[DBManager shareInstance] isInPatientsTable:model.phoneNumbers[0]];
                }
            }
        } else if (self.type == ContactsImportTypeIntroducer) {
            for (XLContact *model in weakSelf.contacts) {
                if (model.phoneNumbers.count > 0) {
                    model.hasAdd = [[DBManager shareInstance] isInIntroducerTable:model.phoneNumbers[0]];
                }
            }
        }
        //对联系人进行排序
        [weakSelf setUpTableSection];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [weakSelf.tableView reloadData];
        });
    });
}

- (void)onBackButtonAction:(id)sender{
    if (self.type == ContactsImportTypePatients) {
        UITabBarController *rootVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [rootVC setSelectedViewController:[rootVC.viewControllers objectAtIndex:1]];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self popViewControllerAnimated:YES];
    }
}

#pragma mark - 数组排序
- (void) setUpTableSection {
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如@[@[以A开头的数据数组], @[以B开头的数据数组], @[以C开头的数据数组], ... @[以#(其它)开头的数据数组]]
    NSUInteger numberOfSections = [[collation sectionTitles] count];
    for (NSUInteger index = 0; index<numberOfSections; index++) {
        [self.sectionArray addObject:[[NSMutableArray alloc]init]];
    }
    
    //初始化27个空数组加入newSectionsArray
    for (XLContact *model in self.contacts) {
        NSUInteger sectionIndex = [collation sectionForObject:model collationStringSelector:@selector(fullName)];
        [self.sectionArray[sectionIndex] addObject:model];
    }
    
    //对每个section中的数组按照name属性排序
    for (NSUInteger index=0; index<numberOfSections; index++) {
        NSMutableArray *personsForSection = self.sectionArray[index];
        NSArray *sortedPersonsForSection = [collation sortedArrayFromArray:personsForSection collationStringSelector:@selector(fullName)];
        self.sectionArray[index] = sortedPersonsForSection;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    self.sectionTitlesArray = [NSMutableArray new];
    
    [self.sectionArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        if (arr.count == 0) {
            [temp addObject:arr];
        } else {
            [self.sectionTitlesArray addObject:[collation sectionTitles][idx]];
        }
    }];
    [self.sectionArray removeObjectsInArray:temp];
}

#pragma mark - tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitlesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XLContactCell *cell = [XLContactCell cellWithTableView:tableView];
    cell.delegate = self;
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    XLContact *model = self.sectionArray[section][row];
    cell.contact = model;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (self.isSearchDisplayController) {
        return nil;
    }
    return self.sectionTitlesArray[section];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    if (self.isSearchDisplayController) {
        return nil;
    }
    return self.sectionTitlesArray;
}


#pragma mark - XLContactCellDelegate
- (void)ContactCell:(XLContactCell *)cell didclickAddButton:(UIButton *)button{
    XLContact *model = nil;
    if (self.isSearchDisplayController) {
        NSIndexPath *indexPath = [self.searchResultTableView indexPathForCell:cell];
        model = self.searchController.resultsSource[indexPath.row];
    }else{
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        model = self.sectionArray[indexPath.section][indexPath.row];
    }
    BOOL ret = NO;
    if (self.type == ContactsImportTypePatients) {
        ret = [self insertPatientInfoWithModel:model];
    } else  if (self.type == ContactsImportTypeIntroducer){
        ret = [self insertIntrInfoWithModel:model];
    }
    if (ret) {
        model.hasAdd = YES;
        button.enabled = NO;
    }else{
        [SVProgressHUD showErrorWithStatus:@"该联系人没有名称或手机号码"];
    }
}

#pragma mark - 插入患者信息
- (BOOL)insertPatientInfoWithModel:(XLContact *)model{
    BOOL ret = NO;
    if (model.phoneNumbers.count > 0 && [model.fullName isNotEmpty]) {
        Patient *patient = [[Patient alloc]init];
        patient.patient_name = model.fullName;
        patient.patient_phone = model.phoneNumbers[0];
        ret = [[DBManager shareInstance] insertPatientsWithArray:@[patient]];
        if (ret) {
            [[DBManager shareInstance] updateUpdateDate:patient.ckeyid];
            //获取患者信息
            Patient *tempPatient = [[DBManager shareInstance] getPatientWithPatientCkeyid:patient.ckeyid];
            if (tempPatient != nil) {
                [self postNotificationName:PatientCreatedNotification object:nil];
                //添加自动同步信息
                InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Patient postType:Insert dataEntity:[tempPatient.keyValues JSONString] syncStatus:@"0"];
                [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
            }
        }
    }
    return ret;
}
#pragma mark - 插入介绍人信息
- (BOOL)insertIntrInfoWithModel:(XLContact *)model{
    BOOL ret = NO;
    if (model.phoneNumbers.count > 0 && [model.fullName isNotEmpty]) {
        Introducer *introducer = [[Introducer alloc]init];
        introducer.intr_name = model.fullName;
        introducer.intr_phone = model.phoneNumbers[0];
        introducer.intr_level = 1;
        introducer.intr_id = @"0";
        ret = [[DBManager shareInstance] insertIntroducersWithArray:@[introducer]];
        if (ret) {
            [self postNotificationName:IntroducerCreatedNotification object:nil];
            //获取介绍人信息
            Introducer *tempIntr = [[DBManager shareInstance] getIntroducerByCkeyId:introducer.ckeyid];
            if (tempIntr != nil) {
                //添加自动同步信息
                InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Introducer postType:Insert dataEntity:[tempIntr.keyValues JSONString] syncStatus:@"0"];
                [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
            }
        }
    }
    
    return ret;
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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fullName CONTAINS %@", searchText]; //predicate只能是对象
        searchResults = [self.contacts filteredArrayUsingPredicate:predicate];
        
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


#pragma mark - 修改电话号码格式
- (NSString *)editPhoneStyleWithPhone:(NSString *)phone{
    NSString* normalPhone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if ([normalPhone hasPrefix:@"86"]) {
        NSString *formatStr = [normalPhone substringWithRange:NSMakeRange(2, [phone length]-2)];
        return formatStr;
    }
    else if ([normalPhone hasPrefix:@"+86"])
    {
        if ([normalPhone hasPrefix:@"+86·"]) {
            NSString *formatStr = [normalPhone substringWithRange:NSMakeRange(4, [phone length]-4)];
            return formatStr;
        }
        else
        {
            NSString *formatStr = [normalPhone substringWithRange:NSMakeRange(3, [normalPhone length]-3)];
            return formatStr;
        }
    }else{
        return normalPhone;
    }
}
#pragma mark - notification action
- (void)allowAccessContacts {
    NSLog(@"accessAllowed");
}
- (void)accessDenied {
    
}
- (void)accessFailed {
//    TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"温馨提示" message:@"种牙管家没有访问手机通讯录的权限，请到系统设置->隐私->通讯录中开启" cancel:@"取消" certain:@"前往设置" cancelHandler:^{
//    } comfirmButtonHandlder:^{
//        
//    }];
//    [alertView show];
    XLAddressBookFailView *failView = [[XLAddressBookFailView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:failView];
}

#pragma mark - UISearchDisplayDelegate
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller NS_DEPRECATED_IOS(3_0,8_0){
    //相对于上面的接口，这个接口可以动画的改变statusBar的前景色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller NS_DEPRECATED_IOS(3_0,8_0){
    //相对于上面的接口，这个接口可以动画的改变statusBar的前景色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
    self.isSearchDisplayController = YES;
    self.searchResultTableView = tableView;
}

#pragma mark - UISearchDisplayDelegate
- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView{
    self.isSearchDisplayController = NO;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView{
    self.searchResultTableView = nil;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark 控件初始化
- (NSMutableArray *)sectionArray{
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}

- (NSMutableArray *)sectionTitlesArray{
    if (!_sectionTitlesArray) {
        _sectionTitlesArray = [NSMutableArray array];
    }
    return _sectionTitlesArray;
}

- (NSMutableArray *)contacts{
    if (!_contacts) {
        _contacts = [NSMutableArray array];
    }
    return _contacts;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
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
        __weak XLContactsViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            XLContactCell *cell = [XLContactCell cellWithTableView:tableView];
            cell.delegate = weakSelf;
            XLContact *model = weakSelf.searchController.resultsSource[indexPath.row];
            cell.contact = model;
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [XLContactCell fixedHeight];
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
        }];
    }
    
    return _searchController;
}

#pragma mark - dealloc
- (void)dealloc{
    [self.sectionArray removeAllObjects];
    [self.sectionTitlesArray removeAllObjects];
    [self.contacts removeAllObjects];
    self.searchBar.delegate = nil;
    self.searchController.delegate = nil;
    
    self.sectionArray = nil;
    self.sectionTitlesArray = nil;
    self.contacts = nil;
    self.searchBar = nil;
    self.searchController = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"我被销毁了");
}

@end





