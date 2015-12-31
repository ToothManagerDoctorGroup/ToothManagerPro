//
//  RepairDoctorViewController.m
//  CRM
//
//  Created by ANine on 4/21/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "RepairDoctorViewController.h"
#import "DBManager.h"
#import "DBManager+Patients.h"
#import "MudItemsBar.h"
#import "DBTableMode.h"
#import "ChineseSearchEngine.h"
#import "RepairDoctorTableViewCell.h"
#import "DBManager+RepairDoctor.h"
#import "RepairDoctorCellMode.h"
#import "CRMMacro.h"
#import "UIColor+Extension.h"
#import "MudItemBarItem.h"
#import "MudItemsBar.h"
#import "AddressBookViewController.h"
#import "CreatRepairDoctorViewController.h"
#import "RepairDoctorDetailViewController.h"
#import "UISearchBar+XLMoveBgView.h"

#import "JSONKit.h"
#import "MJExtension.h"
#import "DBManager+AutoSync.h"


@interface RepairDoctorViewController ()<MudItemsBarDelegate>
@property (nonatomic,retain) MudItemsBar *menubar;
@property (nonatomic) BOOL isBarHidden;
@property (nonatomic,retain) NSArray *repairDoctorArray;
@property (nonatomic,retain) NSMutableArray *repairDoctorModeArray;
@property (nonatomic, strong) NSArray *searchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation RepairDoctorViewController

- (void)initView {
    [super initView];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_new"]];
    [self setupView];
    
    [self.searchBar moveBackgroundView];
}

- (void)setupView {
    self.title = @"修复医生";
    [self.searchDisplayController.searchBar setPlaceholder:@"搜索修复医生"];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)refreshView {
    [self.tableView reloadData];
}

- (void)onRightButtonAction:(id)sender
{
    NSLog(@"click");
    if (self.isBarHidden == YES) { //如果是消失状态
        [self setupMenuBar];
        [self.menubar showBar:self.navigationController.view WithBarAnimation:MudItemsBarAnimationTop];
    } else {                      //如果是显示状态
        [self.menubar hiddenBar:self.navigationController.view WithBarAnimation:MudItemsBarAnimationTop];
    }
    self.isBarHidden = !self.isBarHidden;
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isBarHidden == NO){                      //如果是显示状态
        [self.menubar hiddenBar:self.navigationController.view WithBarAnimation:MudItemsBarAnimationTop];
    }
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

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//增加的表头
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    bgView.backgroundColor = MyColor(238, 238, 238);
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, 320, 1)];
//    label.backgroundColor = [UIColor lightGrayColor];
//    [bgView addSubview:label];
    
    UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nameButton setTitle:@"姓名" forState:UIControlStateNormal];
    [nameButton setFrame:CGRectMake(20, 0, 40, 40)];
    [nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nameButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:nameButton];
    
    
    UIButton *introducerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [introducerButton setTitle:@"电话" forState:UIControlStateNormal];
    [introducerButton setFrame:CGRectMake(145, 0, 60, 40)];
    [introducerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    introducerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:introducerButton];
    
    UIButton *numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [numberButton setTitle:@"修复人数" forState:UIControlStateNormal];
    [numberButton setFrame:CGRectMake(255, 0, 60, 40)];
    [numberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    numberButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:numberButton];
    
    return bgView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.repairDoctorModeArray.count;
    }
    else {
        return self.searchResults.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"RepairDoctorTableViewCell";
    RepairDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RepairDoctorTableViewCell" owner:nil options:nil] objectAtIndex:0];//[[PatientsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [tableView registerNib:[UINib nibWithNibName:@"RepairDoctorTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    }
    
    //赋值,获取患者信息
    NSInteger row = [indexPath row];
    RepairDoctorCellMode *cellMode;
    if (tableView == self.tableView) {
        cellMode = [self.repairDoctorModeArray objectAtIndex:row];
    } else {
        cellMode = [self.searchResults objectAtIndex:row];
    }
// cell.repairDoctorIDLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
   // cell.repairDoctorNameLabel.text = [NSString stringWithFormat:@"%2d        %@",indexPath.row,cellMode.name];
    cell.repairDoctorNameLabel.text = cellMode.name;
    cell.repairDoctorPhoneNumLabel.text = cellMode.phoneNum;
    cell.patienNumLabel.text = [NSString stringWithFormat:@"%d人",cellMode.count];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepairDoctor *cellMode = [_repairDoctorArray objectAtIndex:indexPath.row];
    if ([self isSearchResultsTableView:tableView]) {
        cellMode =[_searchResults objectAtIndex:indexPath.row];
    } else {
        cellMode = [_repairDoctorArray objectAtIndex:indexPath.row];
    }
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

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return ![self isSearchResultsTableView:tableView];
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

#pragma makr - UISearchBar Delegates
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    if ([searchString isNotEmpty]) {
        self.searchResults = [ChineseSearchEngine resultArraySearchRepairDoctorOnArray:self.repairDoctorModeArray withSearchText:self.searchDisplayController.searchBar.text];
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

- (void)dealloc {
    [self removeNotificationObserver];
}

@end
