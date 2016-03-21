//
//  XLContactsViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/15.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLContactsViewController.h"
#import "XLContactCell.h"
#import "XLContactModel.h"
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

@interface XLContactsViewController ()<XLContactCellDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic,strong) NSMutableArray *sectionArray;//有多少组
@property (nonatomic, strong) NSMutableArray *sectionTitlesArray;//每组多少个联系人
@property (nonatomic, strong)NSMutableArray *contacts;//原数组

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
}

- (NSMutableArray *)contacts{
    if (!_contacts) {
        _contacts = [NSMutableArray array];
    }
    return _contacts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

    //获取所有联系人
    [self getAllContacts];
    //对联系人进行排序
    [self setUpTableSection];
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

#pragma mark - 控件初始化
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
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _searchController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
        
        __weak XLContactsViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            XLContactCell *cell = [XLContactCell cellWithTableView:tableView];
            cell.delegate = weakSelf;
            XLContactModel *model = weakSelf.searchController.resultsSource[indexPath.row];
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
#pragma mark - 数组排序
- (void) setUpTableSection {
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如@[@[以A开头的数据数组], @[以B开头的数据数组], @[以C开头的数据数组], ... @[以#(其它)开头的数据数组]]
    NSUInteger numberOfSections = [[collation sectionTitles] count];
    NSMutableArray *newSectionArray =  [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index<numberOfSections; index++) {
        [newSectionArray addObject:[[NSMutableArray alloc]init]];
    }
    
    //初始化27个空数组加入newSectionsArray
    for (XLContactModel *model in self.contacts) {
        NSUInteger sectionIndex = [collation sectionForObject:model collationStringSelector:@selector(name)];
        [newSectionArray[sectionIndex] addObject:model];
    }
    
     //对每个section中的数组按照name属性排序
    for (NSUInteger index=0; index<numberOfSections; index++) {
        NSMutableArray *personsForSection = newSectionArray[index];
        NSArray *sortedPersonsForSection = [collation sortedArrayFromArray:personsForSection collationStringSelector:@selector(name)];
        newSectionArray[index] = sortedPersonsForSection;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    self.sectionTitlesArray = [NSMutableArray new];
    
    [newSectionArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        if (arr.count == 0) {
            [temp addObject:arr];
        } else {
            [self.sectionTitlesArray addObject:[collation sectionTitles][idx]];
        }
    }];
    [newSectionArray removeObjectsInArray:temp];
    
    self.sectionArray = newSectionArray;
    
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
    
    XLContactModel *model = self.sectionArray[section][row];
    cell.contact = model;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionTitlesArray[section];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionTitlesArray;
}


#pragma mark - XLContactCellDelegate
- (void)ContactCell:(XLContactCell *)cell didclickAddButton:(UIButton *)button{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    XLContactModel *model = nil;
    if (self.isSearchDisplayController) {
        model = self.searchController.resultsSource[indexPath.row];
    }else{
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
    }
}

- (BOOL)insertPatientInfoWithModel:(XLContactModel *)model{
    BOOL ret = NO;
    Patient *patient = [[Patient alloc]init];
    patient.patient_name = model.name;
    patient.patient_phone = model.phone;
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
    return ret;
}
- (BOOL)insertIntrInfoWithModel:(XLContactModel *)model{
    BOOL ret = NO;
    Introducer *introducer = [[Introducer alloc]init];
    introducer.intr_name = model.name;
    introducer.intr_phone = model.phone;
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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", searchText]; //predicate只能是对象
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

#pragma mark - 访问通讯录
- (void)getAllContacts{
    //这个变量用于记录授权是否成功，即用户是否允许我们访问通讯录
    int __block tip=0;
    //声明一个通讯簿的引用
    ABAddressBookRef addBook =nil;
    //因为在IOS6.0之后和之前的权限申请方式有所差别，这里做个判断
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        //创建通讯簿的引用
        addBook=ABAddressBookCreateWithOptions(NULL, NULL);
        //创建一个出事信号量为0的信号
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        //申请访问权限
        ABAddressBookRequestAccessWithCompletion(addBook, ^(bool greanted, CFErrorRef error)        {
            //greanted为YES是表示用户允许，否则为不允许
            if (!greanted) {
                tip=1;
            }
            //发送一次信号
            dispatch_semaphore_signal(sema);
        });
        //等待信号触发
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        //IOS6之前
        addBook =ABAddressBookCreate();
    }
    
    if (tip == 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"种牙管家没有访问手机通讯录的权限，请到系统设置->隐私->通讯录中开启" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addBook);
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addBook);
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个联系人的模型
        XLContactModel *model = [[XLContactModel alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@%@", nameString, lastNameString];
            }
        }
        model.name = nameString;
        
        //读取照片
//        NSData *image = (__bridge NSData*)ABPersonCopyImageData(person);
//        if (image.length == 0) {
//            model.image = [UIImage imageNamed:@"user_icon"];
//        }else{
//            model.image = [UIImage imageWithData:image];
//        }
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        NSString *phoneStr = (__bridge NSString*)value;
                        model.phone = [self editPhoneStyleWithPhone:phoneStr];
                        break;
                    }
                    case 1: {// Email
                        model.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        if (model.phone != nil && [model.name isNotEmpty]) {
            if (self.type == ContactsImportTypePatients) {
                model.hasAdd = [[DBManager shareInstance] isInPatientsTable:model.phone];
            } else if (self.type == ContactsImportTypeIntroducer) {
                model.hasAdd = [[DBManager shareInstance] isInIntroducerTable:model.phone];
            }
            [self.contacts addObject:model];
        }
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
        if (person) CFRelease(person);
    }
    CFRelease(allPeople);
    CFRelease(addBook);
}

#pragma mark - 获取联系人的头像
- (UIImage *)imageWithABRecordRef:(ABRecordRef)recordRef
{
    //头像
    NSData* imageData = (__bridge_transfer NSData*)ABPersonCopyImageDataWithFormat(recordRef,kABPersonImageFormatThumbnail);
    UIImage* image = [UIImage imageWithData:imageData];;
    return image;
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


@end