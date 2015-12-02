//
//  PatientsDisplayViewController.m
//  CRM
//
//  Created by TimTiger on 9/25/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "PatientsDisplayViewController.h"
#import "ChineseSearchEngine.h"
#import "CRMMacro.h"
#import "PatientsCellMode.h"
#import "DBManager+Materials.h"
#import "PatientsTableViewCell.h"
#import "PatientInfoViewController.h"
#import "CreatePatientViewController.h"
#import "AddressBookViewController.h"
#import "SelectDateViewController.h"
#import "DBManager+Patients.h"
#import "MudItemBarItem.h"
#import "MudItemsBar.h"
#import "SDImageCache.h"
#import "LocalNotificationCenter.h"
#import "SVProgressHUD.h"
#import "SyncManager.h"
#import "PatientDetailViewController.h"

@interface PatientsDisplayViewController () <MudItemsBarDelegate>{
    BOOL ifNameBtnSelected;
    BOOL ifStatusBtnSelected;
    BOOL ifNumberBtnSelected;
    BOOL ifIntroducerSelected;
}
@property (nonatomic,retain) MudItemsBar *menubar;
@property (nonatomic) BOOL isBarHidden;
@property (nonatomic,retain) NSArray *patientInfoArray;
@property (nonatomic,retain) NSMutableArray *patientCellModeArray;
@property (nonatomic,retain) NSMutableArray *searchResults;
@end

@implementation PatientsDisplayViewController

- (void)initView {
    [super initView];

    if(self.isTabbarVc == YES){
        [self setLeftBarButtonWithImage:[UIImage imageNamed:@"ic_nav_tongbu"]];
        [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_new"]];
    }else{
        [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    }
    [self setupView];
    
    NSDate* curDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string =  [dateFormatter stringFromDate:curDate];
    

    NSDate* date1 = [[NSDate alloc] init];
    date1 = [curDate dateByAddingTimeInterval:-600];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string1 =  [dateFormatter stringFromDate:date1];
    NSLog(@"延后时间=%@,当前时间=%@",string1,string);
}




-(void)viewWillAppear:(BOOL)animated{
   [self initData];
    [self refreshView];
}

-(void)onLeftButtonAction:(id)sender{
    if(self.isTabbarVc == NO){
        [self popViewControllerAnimated:YES];
    }else{
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
}
- (void)callSync {
    [[SyncManager shareInstance] startSync];
}
- (void)setupView {
    self.title = @"患者";
    [self.searchDisplayController.searchBar setPlaceholder:@"搜索患者"];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)refreshView {
    [self.searchDisplayController.searchResultsTableView reloadData];
    [self.tableView reloadData];
}
- (void)initData {
    [super initData];
    
    self.isBarHidden = YES;
    _patientInfoArray = [[DBManager shareInstance] getPatientsWithStatus:self.patientStatus];
    _patientCellModeArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < _patientInfoArray.count; i++) {
        Patient *patientTmp = [_patientInfoArray objectAtIndex:i];
        PatientsCellMode *cellMode = [[PatientsCellMode alloc]init];
        cellMode.patientId = patientTmp.ckeyid;
        cellMode.introducerId = patientTmp.introducer_id;
        cellMode.name = patientTmp.patient_name;
        cellMode.phone = patientTmp.patient_phone;
       // cellMode.introducerName = [[DBManager shareInstance] getIntroducerByIntroducerID:patientTmp.introducer_id].intr_name;
        cellMode.introducerName = patientTmp.intr_name;
        cellMode.statusStr = [Patient statusStrWithIntegerStatus:patientTmp.patient_status];
        cellMode.status = patientTmp.patient_status;
        cellMode.countMaterial = [[DBManager shareInstance] numberMaterialsExpenseWithPatientId:patientTmp.ckeyid];
        [_patientCellModeArray addObject:cellMode];
    }
    _searchResults = [NSMutableArray arrayWithCapacity:0];
    [self addNotificationObserver];
}

- (void)refreshData {
    _patientInfoArray = nil;
    _patientInfoArray = [[DBManager shareInstance] getPatientsWithStatus:self.patientStatus];
    [_patientCellModeArray removeAllObjects];
    for (NSInteger i = 0; i < _patientInfoArray.count; i++) {
        Patient *patientTmp = [_patientInfoArray objectAtIndex:i];
        PatientsCellMode *cellMode = [[PatientsCellMode alloc]init];
        cellMode.patientId = patientTmp.ckeyid;
        cellMode.introducerId = patientTmp.introducer_id;
        cellMode.name = patientTmp.patient_name;
        cellMode.phone = patientTmp.patient_phone;
      //  cellMode.introducerName = [[DBManager shareInstance] getIntroducerByIntroducerID:patientTmp.introducer_id].intr_name;
        cellMode.introducerName = patientTmp.intr_name;
        cellMode.statusStr = [Patient statusStrWithIntegerStatus:patientTmp.patient_status];
        cellMode.countMaterial = [[DBManager shareInstance] numberMaterialsExpenseWithPatientId:patientTmp.ckeyid];
    
        [_patientCellModeArray addObject:cellMode];
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
}

#pragma mark - Right View
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
        itemAddressBook.text = @"新建患者";
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

#pragma mark - Notification
- (void)addNotificationObserver {
    [self addObserveNotificationWithName:PatientCreatedNotification];
    [self addObserveNotificationWithName:PatientEditedNotification];
    [self addObserveNotificationWithName:MedicalCaseCreatedNotification];
    [self addObserveNotificationWithName:MedicalCaseEditedNotification];
    [self addObserveNotificationWithName:PatientTransferNotification];
    [self addObserveNotificationWithName:@"tongbu"];
}

- (void)removeNotificationObserver {
    [self removeObserverNotificationWithName:PatientCreatedNotification];
    [self removeObserverNotificationWithName:PatientEditedNotification];
    [self removeObserverNotificationWithName:MedicalCaseCreatedNotification];
    [self removeObserverNotificationWithName:MedicalCaseEditedNotification];
    [self removeObserverNotificationWithName:PatientTransferNotification];
    [self removeObserverNotificationWithName:@"tongbu"];
}

- (void)handNotification:(NSNotification *)notifacation {
    [super handNotification:notifacation];
    if ([notifacation.name isEqualToString:PatientCreatedNotification]
        || [notifacation.name isEqualToString:PatientEditedNotification]
        || [notifacation.name isEqualToString:MedicalCaseCreatedNotification]
        || [notifacation.name isEqualToString:MedicalCaseEditedNotification]
       ) {
        //有新患者创建或者患者被编辑，需要更新界面
        [self refreshData];
        [self refreshView];
    }
    if ([notifacation.name isEqualToString:@"tongbu"]) {
        [self initData];
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
    bgView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, 320, 1)];
    label.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:label];
    
    UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nameButton setTitle:@"姓名" forState:UIControlStateNormal];
    [nameButton setFrame:CGRectMake(20, 0, 40, 40)];
    [nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nameButton addTarget:self action:@selector(nameButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nameButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:nameButton];
    
        
    UIButton *statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [statusButton setTitle:@"状态" forState:UIControlStateNormal];
    [statusButton setFrame:CGRectMake(100, 0, 40, 40)];
    [statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    statusButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [statusButton addTarget:self action:@selector(statusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:statusButton]; 
    
    UIButton *introducerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [introducerButton setTitle:@"介绍人" forState:UIControlStateNormal];
    [introducerButton setFrame:CGRectMake(180, 0, 60, 40)];
    [introducerButton addTarget:self action:@selector(introducerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [introducerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    introducerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:introducerButton];
    
    UIButton *numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [numberButton setTitle:@"数量" forState:UIControlStateNormal];
    [numberButton setFrame:CGRectMake(275, 0, 40, 40)];
    [numberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [numberButton addTarget:self action:@selector(numberButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    numberButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:numberButton];
    
    
//    [self.searchDisplayController.searchBar setFrame:CGRectMake(0, 0, self.searchDisplayController.searchBar.frame.size.width, 44)];
//    [self.view addSubview:self.searchDisplayController.searchBar];
    
    
    return bgView;
}
-(void)numberButtonClick:(UIButton *)button{
    ifNumberBtnSelected = !ifNumberBtnSelected;
    if(ifNumberBtnSelected == YES){
        NSArray *lastArray = [NSArray arrayWithArray:self.patientCellModeArray];
        lastArray = [self.patientCellModeArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            PatientsCellMode *object1 = (PatientsCellMode *)obj1;
            PatientsCellMode *object2 = (PatientsCellMode *)obj2;
            if(object1.countMaterial < object2.countMaterial){
                return  NSOrderedAscending;
            }
            if (object1.countMaterial > object2.countMaterial){
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }];
        self.patientCellModeArray = [NSMutableArray arrayWithArray:lastArray];
        [self.tableView reloadData];
    }else{
        NSArray *lastArray = [NSArray arrayWithArray:self.patientCellModeArray];
        lastArray = [self.patientCellModeArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return NSOrderedDescending;
        }];
        self.patientCellModeArray = [NSMutableArray arrayWithArray:lastArray];
        [self.tableView reloadData];
    }
}
-(void)nameButtonClick:(UIButton *)button{
    ifNameBtnSelected = !ifNameBtnSelected;
    if(ifNameBtnSelected == YES){
        NSArray *lastArray = [NSArray arrayWithArray:self.patientCellModeArray];
        lastArray = [self.patientCellModeArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSComparisonResult result;
            PatientsCellMode *object1 = (PatientsCellMode *)obj1;
            PatientsCellMode *object2 = (PatientsCellMode *)obj2;
            result = [object1.name localizedCompare:object2.name];
            return result == NSOrderedDescending;
        }];
        self.patientCellModeArray = [NSMutableArray arrayWithArray:lastArray];
        [self.tableView reloadData];
    }else{
        NSArray *lastArray = [NSArray arrayWithArray:self.patientCellModeArray];
        lastArray = [self.patientCellModeArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSComparisonResult result;
            PatientsCellMode *object1 = (PatientsCellMode *)obj1;
            PatientsCellMode *object2 = (PatientsCellMode *)obj2;
            result = [object1.name localizedCompare:object2.name];
            return result == NSOrderedAscending;
        }];
        self.patientCellModeArray = [NSMutableArray arrayWithArray:lastArray];
        [self.tableView reloadData];
    }
}
-(void)introducerButtonClick:(UIButton*)button{
    ifIntroducerSelected = !ifIntroducerSelected;
    if(ifIntroducerSelected == YES){
        NSArray *lastArray = [NSArray arrayWithArray:self.patientCellModeArray];
        lastArray = [self.patientCellModeArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSComparisonResult result;
            PatientsCellMode *object1 = (PatientsCellMode *)obj1;
            PatientsCellMode *object2 = (PatientsCellMode *)obj2;
            result = [object1.introducerName localizedCompare:object2.introducerName];
            return result == NSOrderedDescending;
        }];
        self.patientCellModeArray = [NSMutableArray arrayWithArray:lastArray];
        [self.tableView reloadData];
    }else{
        NSArray *lastArray = [NSArray arrayWithArray:self.patientCellModeArray];
        lastArray = [self.patientCellModeArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSComparisonResult result;
            PatientsCellMode *object1 = (PatientsCellMode *)obj1;
            PatientsCellMode *object2 = (PatientsCellMode *)obj2;
            result = [object1.introducerName localizedCompare:object2.introducerName];
            return result == NSOrderedDescending;
        }];
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
        for(NSInteger i =lastArray.count;i>0;i--){
            [resultArray addObject:lastArray[i-1]];
        }
        self.patientCellModeArray = [NSMutableArray arrayWithArray:resultArray];
        [self.tableView reloadData];
        
    }
}
-(void)statusButtonClick:(UIButton *)button{
    ifStatusBtnSelected = !ifStatusBtnSelected;
    if(ifStatusBtnSelected == YES){
        NSMutableArray *lastArray = [NSMutableArray arrayWithCapacity:0];
        for(NSInteger i = 0;i<self.patientCellModeArray.count;i++){
            PatientsCellMode *cellMode;
            cellMode = [self.patientCellModeArray objectAtIndex:i];
            if([cellMode.statusStr isEqualToString:@"未就诊"]){
                [lastArray addObject:cellMode];
            }
        }
        for(NSInteger i = 0;i<self.patientCellModeArray.count;i++){
            PatientsCellMode *cellMode;
            cellMode = [self.patientCellModeArray objectAtIndex:i];
            if([cellMode.statusStr isEqualToString:@"未种植"]){
                [lastArray addObject:cellMode];
            }
        }
        for(NSInteger i = 0;i<self.patientCellModeArray.count;i++){
            PatientsCellMode *cellMode;
            cellMode = [self.patientCellModeArray objectAtIndex:i];
            if([cellMode.statusStr isEqualToString:@"已种未修"]){
                [lastArray addObject:cellMode];
            }
        }
        for(NSInteger i = 0;i<self.patientCellModeArray.count;i++){
            PatientsCellMode *cellMode;
            cellMode = [self.patientCellModeArray objectAtIndex:i];
            if([cellMode.statusStr isEqualToString:@"已修复"]){
                [lastArray addObject:cellMode];
            }
        }
        self.patientCellModeArray = [NSMutableArray arrayWithArray:lastArray];
        [self.tableView reloadData];
        
    }else{
        NSMutableArray *lastArray = [NSMutableArray arrayWithCapacity:0];
        for(NSInteger i = 0;i<self.patientCellModeArray.count;i++){
            PatientsCellMode *cellMode;
            cellMode = [self.patientCellModeArray objectAtIndex:i];
            if([cellMode.statusStr isEqualToString:@"已修复"]){
                [lastArray addObject:cellMode];
            }
        }
        for(NSInteger i = 0;i<self.patientCellModeArray.count;i++){
            PatientsCellMode *cellMode;
            cellMode = [self.patientCellModeArray objectAtIndex:i];
            if([cellMode.statusStr isEqualToString:@"已种未修"]){
                [lastArray addObject:cellMode];
            }
        }
        for(NSInteger i = 0;i<self.patientCellModeArray.count;i++){
            PatientsCellMode *cellMode;
            cellMode = [self.patientCellModeArray objectAtIndex:i];
            if([cellMode.statusStr isEqualToString:@"未种植"]){
                [lastArray addObject:cellMode];
            }
        }
        for(NSInteger i = 0;i<self.patientCellModeArray.count;i++){
            PatientsCellMode *cellMode;
            cellMode = [self.patientCellModeArray objectAtIndex:i];
            if([cellMode.statusStr isEqualToString:@"未就诊"]){
                [lastArray addObject:cellMode];
            }
        }
        self.patientCellModeArray = [NSMutableArray arrayWithArray:lastArray];
        [self.tableView reloadData];
        
      
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isSearchResultsTableView:tableView]) {
        return self.searchResults.count;
    }
    return self.patientCellModeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellIdentifier";
    PatientsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PatientsTableViewCell" owner:nil options:nil] objectAtIndex:0];//[[PatientsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [tableView registerNib:[UINib nibWithNibName:@"PatientsTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    }
    
    //赋值,获取患者信息
    NSInteger row = [indexPath row];
    PatientsCellMode *cellMode;
    if ([self isSearchResultsTableView:tableView]) {
        cellMode = [self.searchResults objectAtIndex:row];
    } else {
        cellMode = [self.patientCellModeArray objectAtIndex:row];
    }
    
    [cell configCellWithCellMode:cellMode];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PatientsCellMode *cellMode;
    //获取被点击的患者信息
    if ([self isSearchResultsTableView:tableView]) {
        cellMode =[_searchResults objectAtIndex:indexPath.row];
    } else {
        cellMode = [_patientCellModeArray objectAtIndex:indexPath.row];
    }
    if (self.isScheduleReminderPush) {
        Patient *tmpPatient = [[Patient alloc] init];
        tmpPatient.ckeyid = cellMode.patientId;
        tmpPatient.patient_name = cellMode.name;
        [LocalNotificationCenter shareInstance].selectPatient = tmpPatient;
        SelectDateViewController *selectDateView = [[SelectDateViewController alloc]init];
        [self.navigationController pushViewController:selectDateView animated:YES];
    }else if (self.isYuYuePush){
        Patient *tmpPatient = [[Patient alloc] init];
        tmpPatient.ckeyid = cellMode.patientId;
        tmpPatient.patient_name = cellMode.name;
        [LocalNotificationCenter shareInstance].selectPatient = tmpPatient;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"yuyuePatientNotification" object:tmpPatient];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        //跳转到新的患者详情页面
        PatientDetailViewController *detailVc = [[PatientDetailViewController alloc] init];
        detailVc.patientsCellMode = cellMode;
        detailVc.hidesBottomBarWhenPushed = YES;
        [self pushViewController:detailVc animated:YES];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    //return ![self isSearchResultsTableView:tableView];
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TimAlertView *alertView = [[TimAlertView alloc]initWithTitle:@"确认删除？" message:nil  cancelHandler:^{
            [tableView reloadData];
        } comfirmButtonHandlder:^{
            PatientsCellMode *cellMode = [[PatientsCellMode alloc]init];
            if ([self isSearchResultsTableView:tableView]) {
                cellMode = [self.searchResults objectAtIndex:indexPath.row];
            }else{
                cellMode = [_patientCellModeArray objectAtIndex:indexPath.row];
            }
            NSArray *libArray = [[DBManager shareInstance] getCTLibArrayWithPatientId:cellMode.patientId];
            for (CTLib *lib in libArray) {
                [[SDImageCache sharedImageCache] removeImageForKey:lib.ckeyid fromDisk:YES];
            }
            BOOL ret = [[DBManager shareInstance] deletePatientByPatientID:cellMode.patientId];
            if (ret == NO) {
                [SVProgressHUD showImage:nil status:@"删除失败"];
            } else {
                if ([self isSearchResultsTableView:tableView]) {
                    [self.searchResults removeObjectAtIndex:indexPath.row];
                    [self.patientCellModeArray removeObject:cellMode];
                }else{
                    [self.patientCellModeArray removeObjectAtIndex:indexPath.row];
                }
                [self refreshView];
            }
        }];
        [alertView show];
    }
}

#pragma makr - UISearchBar Delegates
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    if ([searchString isNotEmpty]) {
        self.searchResults = [NSMutableArray arrayWithArray:[ChineseSearchEngine resultArraySearchPatientsOnArray:self.patientCellModeArray withSearchText:searchString]];
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
            addressBook.type = ImportTypePatients;
            addressBook.hidesBottomBarWhenPushed = YES;
            [self pushViewController:addressBook animated:YES];
        }
            break;
        case 1:
        {
            CreatePatientViewController *newPatientVC = [storyBoard instantiateViewControllerWithIdentifier:@"CreatePatientViewController"];
            newPatientVC.hidesBottomBarWhenPushed = YES;
            [self pushViewController:newPatientVC animated:YES];
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
