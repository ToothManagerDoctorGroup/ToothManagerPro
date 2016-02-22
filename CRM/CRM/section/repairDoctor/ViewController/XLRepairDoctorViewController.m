//
//  XLRepairDoctorViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/11.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLRepairDoctorViewController.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "UISearchBar+XLMoveBgView.h"
#import "MudItemsBar.h"
#import "UIColor+Extension.h"
#import "CRMMacro.h"
#import "MudItemBarItem.h"
#import "DBManager+RepairDoctor.h"
#import "RepairDoctorCellMode.h"
#import "AddressBookViewController.h"
#import "CreatRepairDoctorViewController.h"
#import "RepairDoctorTableViewCell.h"
#import "RepairDoctorDetailViewController.h"
#import "DBManager+AutoSync.h"
#import "MJExtension.h"
#import "JSONKit.h"

#define CellHeight 40

@interface XLRepairDoctorViewController ()<UISearchBarDelegate,MudItemsBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}

@property (nonatomic,retain) MudItemsBar *menubar;
@property (nonatomic) BOOL isBarHidden;
@property (nonatomic,retain) NSArray *repairDoctorArray;
@property (nonatomic,retain) NSMutableArray *repairDoctorModeArray;
@property (nonatomic, strong) NSArray *searchResults;

@property (nonatomic, strong)EMSearchBar *searchBar;
@property (nonatomic, strong)EMSearchDisplayController *searchController;

@end

@implementation XLRepairDoctorViewController

#pragma mark - 界面销毁
- (void)dealloc{
    self.searchBar = nil;
    self.searchController = nil;
    _tableView = nil;
    [self removeNotificationObserver];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isBarHidden == NO){                      //如果是显示状态
        [self.menubar hiddenBar:self.navigationController.view WithBarAnimation:MudItemsBarAnimationTop];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加通知
    [self addNotificationObserver];
}


#pragma mark - UISearchBar控件初始化
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
        
        __weak XLRepairDoctorViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            return [weakSelf setUpTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:weakSelf.searchController.resultsSource];
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return CellHeight;
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
                RepairDoctorCellMode *cellMode = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
                RepairDoctor *doc = [[DBManager shareInstance] getRepairDoctorWithCkeyId:cellMode.ckeyid];
                
                BOOL ret = [[DBManager shareInstance] deleteRepairDoctorWithCkeyId:doc.ckeyid];
                if (ret == NO) {
                    [SVProgressHUD showImage:nil status:@"删除失败"];
                } else {
                    [weakSelf.searchController.resultsSource removeObject:cellMode];
                    //自动同步信息
                    InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_RepairDoctor postType:Delete dataEntity:[doc.keyValues JSONString] syncStatus:@"0"];
                    [[DBManager shareInstance ] insertInfoWithInfoAutoSync:info];
                    
                    [tableView reloadData];
                    //刷新单元格
                    [weakSelf refreshData];
                    [weakSelf refreshView];
                }
            }];
            [alertView show];
        }];
        
        
    }
    return _searchController;
}

#pragma mark - initView
- (void)initView {
    [super initView];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
//    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_new"]];
    
    self.title = @"修复医生";
    
    //初始化表示图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, self.view.height - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
    //初始化搜索框
    [self.view addSubview:self.searchBar];
    [self searchController];
}
#pragma mark - refreshView
- (void)refreshView {
    [_tableView reloadData];
}

- (void)initData {
    [super initData];
    self.isBarHidden = YES;
    _repairDoctorArray = [[DBManager shareInstance] getAllRepairDoctor];
    _repairDoctorModeArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < _repairDoctorArray.count; i++) {
        RepairDoctor *repairDoctorInfo = [_repairDoctorArray objectAtIndex:i];
        RepairDoctorCellMode *cellMode = [[RepairDoctorCellMode alloc]init];
        cellMode.ckeyid = repairDoctorInfo.ckeyid;
        cellMode.name = repairDoctorInfo.doctor_name;
        cellMode.phoneNum = repairDoctorInfo.doctor_phone;
        cellMode.count = [[DBManager shareInstance] numberPatientsWithRepairDoctorId:repairDoctorInfo.ckeyid];
        [_repairDoctorModeArray addObject:cellMode];
    }
    [self addNotificationObserver];
}

- (void)refreshData {
    _repairDoctorArray = [[DBManager shareInstance] getAllRepairDoctor];
    _repairDoctorModeArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < _repairDoctorArray.count; i++) {
        RepairDoctor *repairDoctorInfo = [_repairDoctorArray objectAtIndex:i];
        RepairDoctorCellMode *cellMode = [[RepairDoctorCellMode alloc]init];
        cellMode.ckeyid = repairDoctorInfo.ckeyid;
        cellMode.name = repairDoctorInfo.doctor_name;
        cellMode.phoneNum = repairDoctorInfo.doctor_phone;
        cellMode.count = [[DBManager shareInstance] numberPatientsWithRepairDoctorId:repairDoctorInfo.ckeyid];
        [_repairDoctorModeArray addObject:cellMode];
    }
}

- (void)onRightButtonAction:(id)sender
{
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
        itemAddressBook.text = @"新建医生";
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
    [self addObserveNotificationWithName:RepairDoctorCreatedNotification];
    [self addObserveNotificationWithName:RepairDoctorEditedNotification];
    [self addObserveNotificationWithName:PatientCreatedNotification];
    [self addObserveNotificationWithName:PatientEditedNotification];
    [self addObserveNotificationWithName:MedicalCaseCreatedNotification];
    [self addObserveNotificationWithName:MedicalCaseEditedNotification];
    [self addObserveNotificationWithName:PatientTransferNotification];
}

- (void)removeNotificationObserver {
    [super removeNotificationObserver];
    [self removeObserverNotificationWithName:RepairDoctorCreatedNotification];
    [self removeObserverNotificationWithName:RepairDoctorEditedNotification];
    [self removeObserverNotificationWithName:PatientCreatedNotification];
    [self removeObserverNotificationWithName:PatientEditedNotification];
    [self removeObserverNotificationWithName:MedicalCaseCreatedNotification];
    [self removeObserverNotificationWithName:MedicalCaseEditedNotification];
    [self removeObserverNotificationWithName:PatientTransferNotification];
}

- (void)handNotification:(NSNotification *)notifacation {
    [super handNotification:notifacation];
    if ([notifacation.name isEqualToString:RepairDoctorCreatedNotification]
        || [notifacation.name isEqualToString:RepairDoctorEditedNotification]
        || [notifacation.name isEqualToString:PatientCreatedNotification]
        || [notifacation.name isEqualToString:PatientEditedNotification]
        || [notifacation.name isEqualToString:MedicalCaseCreatedNotification]
        || [notifacation.name isEqualToString:MedicalCaseEditedNotification]
        ) {
        [self refreshData];
        [self refreshView];
    }
}

#pragma mark - TableView Delegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//增加的表头
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CellHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self headerViewForTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.repairDoctorModeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self setUpTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:self.repairDoctorModeArray];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self selectTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:self.repairDoctorArray];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TimAlertView *alertView = [[TimAlertView alloc]initWithTitle:@"确认删除？" message:nil  cancelHandler:^{
            [tableView reloadData];
        } comfirmButtonHandlder:^{
            RepairDoctor *cellMode = [_repairDoctorArray objectAtIndex:indexPath.row];
            cellMode.creation_date = [NSString defaultDateString];
            BOOL ret = [[DBManager shareInstance] deleteRepairDoctorWithCkeyId:cellMode.ckeyid];
            if (ret == NO) {
                [SVProgressHUD showImage:nil status:@"删除失败"];
            } else {
                //自动同步信息
                InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_RepairDoctor postType:Delete dataEntity:[cellMode.keyValues JSONString] syncStatus:@"0"];
                [[DBManager shareInstance ] insertInfoWithInfoAutoSync:info];
                
                [self refreshData];
                [self refreshView];
            }
        }];
        [alertView show];
    }
}
#pragma mark -设置单元格方法
- (UITableViewCell *)setUpTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sourceArray:(NSArray *)sourceArray{
    
    static NSString *cellID = @"RepairDoctorTableViewCell";
    RepairDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RepairDoctorTableViewCell" owner:nil options:nil] objectAtIndex:0];
        [tableView registerNib:[UINib nibWithNibName:@"RepairDoctorTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    }
    //赋值,获取患者信息
    NSInteger row = [indexPath row];
    RepairDoctorCellMode *cellMode = [sourceArray objectAtIndex:row];
    cell.repairDoctorNameLabel.text = cellMode.name;
    cell.repairDoctorPhoneNumLabel.text = cellMode.phoneNum;
    cell.patienNumLabel.text = [NSString stringWithFormat:@"%ld人",(long)cellMode.count];
    return cell;
}
#pragma mark - 设置单元格点击事件
- (void)selectTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sourceArray:(NSArray *)sourceArray{
    RepairDoctor *cellMode = [sourceArray objectAtIndex:indexPath.row];
    
    if (self.delegate == nil) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        RepairDoctorDetailViewController *repairDocDetailVC = [[RepairDoctorDetailViewController alloc]init];
        repairDocDetailVC.repairDoctorID = cellMode.ckeyid;
        [self.navigationController pushViewController:repairDocDetailVC animated:YES];
    } else {
        [self.delegate didSelectedRepairDoctor:cellMode];
        [self popViewControllerAnimated:YES];
    }
}
#pragma mark - 设置头视图
- (UIView *)headerViewForTableView{
    
    CGFloat commonW = kScreenWidth / 3;
    CGFloat commonH = 40;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, commonH)];
    bgView.backgroundColor = MyColor(238, 238, 238);
    
    UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nameButton setTitle:@"姓名" forState:UIControlStateNormal];
    [nameButton setFrame:CGRectMake(0, 0, commonW, commonH)];
    [nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nameButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:nameButton];
    
    
    UIButton *introducerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [introducerButton setTitle:@"电话" forState:UIControlStateNormal];
    [introducerButton setFrame:CGRectMake(nameButton.right, 0, commonW, commonH)];
    [introducerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    introducerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:introducerButton];
    
    UIButton *numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [numberButton setTitle:@"修复人数" forState:UIControlStateNormal];
    [numberButton setFrame:CGRectMake(introducerButton.right, 0, commonW, commonH)];
    [numberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    numberButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:numberButton];
    
    return bgView;
}


#pragma mark - MudItemsBarDelegate
- (void)itemsBar:(MudItemsBar *)itemsBar clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    switch (buttonIndex) {
        case 0:
        {
            AddressBookViewController *addressBook =[storyBoard instantiateViewControllerWithIdentifier:@"AddressBookViewController"];
            addressBook.type = ImportTypeRepairDoctor;
            [self pushViewController:addressBook animated:YES];
        }
            break;
        case 1:
        {
            CreatRepairDoctorViewController *newRepairDoctorVC = [storyBoard instantiateViewControllerWithIdentifier:@"CreatRepairDoctorViewController"];
            [self pushViewController:newRepairDoctorVC animated:YES];
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
        searchResults = [ChineseSearchEngine resultArraySearchRepairDoctorOnArray:self.repairDoctorModeArray withSearchText:self.searchDisplayController.searchBar.text];
        
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
