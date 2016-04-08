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
#import "AddressBookViewController.h"
#import "DBManager+Patients.h"
#import "MudItemBarItem.h"
#import "MudItemsBar.h"
#import "SDImageCache.h"
#import "LocalNotificationCenter.h"
#import "SVProgressHUD.h"
#import "SyncManager.h"
#import "PatientDetailViewController.h"
#import "GroupManageViewController.h"
#import "DoctorGroupViewController.h"
#import "UISearchBar+XLMoveBgView.h"

#import "MJExtension.h"
#import "JSONKit.h"
#import "DBManager+AutoSync.h"
#import "DBManager+sync.h"
#import "AutoSyncGetManager.h"

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
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation PatientsDisplayViewController

- (void)initView {
    [super initView];

    if(self.isTabbarVc == NO){
        [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    }
    [self setupView];
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
//    [[SyncManager shareInstance] startSync];
    [[AutoSyncGetManager shareInstance] startSyncGet];
}
- (void)setupView {
    self.title = @"患者";
    [self.searchDisplayController.searchBar setPlaceholder:@"搜索患者"];
    [self.searchBar moveBackgroundView];
}

- (void)refreshView {
    [self.searchDisplayController.searchResultsTableView reloadData];
    [self.tableView reloadData];
}
- (void)initData {
    [super initData];
    
    //设置tableView的内填充
    if (self.isTabbarVc) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
    }
    
    self.isBarHidden = YES;
    _patientInfoArray = [[DBManager shareInstance] getPatientsWithStatus:self.patientStatus page:0];
    _patientCellModeArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < _patientInfoArray.count; i++) {
        Patient *patientTmp = [_patientInfoArray objectAtIndex:i];
        PatientsCellMode *cellMode = [[PatientsCellMode alloc]init];
        cellMode.patientId = patientTmp.ckeyid;
        cellMode.introducerId = patientTmp.introducer_id;
        cellMode.name = patientTmp.patient_name;
//        if (patientTmp.nickName != nil && [patientTmp.nickName isNotEmpty]) {
//            cellMode.name = patientTmp.nickName;
//        }else{
//            cellMode.name = patientTmp.patient_name;
//        }
        cellMode.phone = patientTmp.patient_phone;
//        cellMode.introducerName = [[DBManager shareInstance] getIntroducerByIntroducerID:patientTmp.introducer_id].intr_name;
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
    _patientInfoArray = [[DBManager shareInstance] getPatientsWithStatus:self.patientStatus page:0];
    [_patientCellModeArray removeAllObjects];
    for (NSInteger i = 0; i < _patientInfoArray.count; i++) {
        Patient *patientTmp = [_patientInfoArray objectAtIndex:i];
        PatientsCellMode *cellMode = [[PatientsCellMode alloc]init];
        cellMode.patientId = patientTmp.ckeyid;
        cellMode.introducerId = patientTmp.introducer_id;
        
        if (patientTmp.nickName != nil && [patientTmp.nickName isNotEmpty]) {
            cellMode.name = patientTmp.nickName;
        }else{
            cellMode.name = patientTmp.patient_name;
        }
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
        itemAddressBook.text = @"手工录入";
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
    [self addObserveNotificationWithName:SyncGetSuccessNotification];
}

- (void)removeNotificationObserver {
    [self removeObserverNotificationWithName:PatientCreatedNotification];
    [self removeObserverNotificationWithName:PatientEditedNotification];
    [self removeObserverNotificationWithName:MedicalCaseCreatedNotification];
    [self removeObserverNotificationWithName:MedicalCaseEditedNotification];
    [self removeObserverNotificationWithName:PatientTransferNotification];
    [self removeObserverNotificationWithName:SyncGetSuccessNotification];
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
    if ([notifacation.name isEqualToString:SyncGetSuccessNotification]) {
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
    if (self.isTabbarVc && ![self isSearchResultsTableView:tableView]) {
        return 80;
    }else {
        return 40;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    superView.backgroundColor = [UIColor whiteColor];
    
    UIView *groupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    groupView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [groupView addGestureRecognizer:tapAction];
    [superView addSubview:groupView];
    
    UIView *toplineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    toplineView.backgroundColor = MyColor(188, 186, 193);
    [groupView addSubview:toplineView];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"group_gray"]];
    iconView.frame = CGRectMake(20, 13, 21, 14);
    [groupView addSubview:iconView];
    
    UILabel *groupNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 40)];
    groupNameLabel.textColor = MyColor(35, 35, 35);
    groupNameLabel.font = [UIFont systemFontOfSize:15];
    groupNameLabel.text = @"我的分组";
    [groupView addSubview:groupNameLabel];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_crm"]];
    arrowView.frame = CGRectMake(kScreenWidth - 10 - 15, 12.5, 15, 15);
    [groupView addSubview:arrowView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kScreenWidth, 10)];
    lineView.backgroundColor = MyColor(188, 186, 193);
    [groupView addSubview:lineView];
    
    
    UIView *bgView = [[UIView alloc]init];
    if (self.isTabbarVc && ![self isSearchResultsTableView:tableView]) {
        bgView.frame = CGRectMake(0, 40, kScreenWidth, 40);
        [superView addSubview:bgView];
    }else{
        bgView.frame = CGRectMake(0, 0, kScreenWidth, 40);
    }
    
    bgView.backgroundColor = MyColor(238, 238, 238);
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, 320, 1)];
//    label.backgroundColor = MyColor(188, 186, 193);
//    [bgView addSubview:label];
    
    UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nameButton setTitle:@"患者" forState:UIControlStateNormal];
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
    
    if (self.isTabbarVc && ![self isSearchResultsTableView:tableView]) {
        return superView;
    }else{
        return bgView;
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{

    DoctorGroupViewController *manageVc = [[DoctorGroupViewController alloc] initWithStyle:UITableViewStylePlain];
    manageVc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:manageVc animated:YES];
    
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
                
                Patient *pateintTemp = [[DBManager shareInstance] getPatientCkeyid:cellMode.patientId];
                //自动同步信息
                if (pateintTemp != nil) {
                    InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Patient postType:Delete dataEntity:[pateintTemp.keyValues JSONString] syncStatus:@"0"];
                    [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                    
                    
                    //获取所有的病历进行删除
                    NSArray *medicalcases = [[DBManager shareInstance] getAllDeleteNeedSyncMedical_case];
                    if (medicalcases.count > 0) {
                        for (MedicalCase *mCase in medicalcases) {
                            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_MedicalCase postType:Delete dataEntity:[mCase.keyValues JSONString] syncStatus:@"0"];
                            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                        }
                    }
                    
                    //获取所有的耗材信息进行删除
                    NSArray *medicalExpenses = [[DBManager shareInstance] getAllDeleteNeedSyncMedical_expense];
                    if (medicalcases.count > 0) {
                        for (MedicalExpense *expense in medicalExpenses) {
                            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_MedicalExpense postType:Delete dataEntity:[expense.keyValues JSONString] syncStatus:@"0"];
                            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                        }
                    }
                    
                    //获取所有的病历记录进行删除
                    NSArray *medicalRecords = [[DBManager shareInstance] getAllDeleteNeedSyncMedical_record];
                    if (medicalRecords.count > 0) {
                        for (MedicalRecord *record in medicalRecords) {
                            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_MedicalRecord postType:Delete dataEntity:[record.keyValues JSONString] syncStatus:@"0"];
                            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                        }
                    }
                    
                    //获取所有的ct数据进行删除
                    NSArray *ctLibs = [[DBManager shareInstance] getAllDeleteNeedSyncCt_lib];
                    if (ctLibs.count > 0) {
                        for (CTLib *ctLib in ctLibs) {
                            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_CtLib postType:Delete dataEntity:[ctLib.keyValues JSONString] syncStatus:@"0"];
                            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                        }
                    }
                    
                    //获取所有的会诊记录进行删除
                    NSArray *patientCons = [[DBManager shareInstance] getPatientConsultationWithPatientId:cellMode.patientId];
                    if (patientCons.count > 0) {
                        for (PatientConsultation *patientC in patientCons) {
                            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_PatientConsultation postType:Delete dataEntity:[patientC.keyValues JSONString] syncStatus:@"0"];
                            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                        }
                    }
                }
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



@end
