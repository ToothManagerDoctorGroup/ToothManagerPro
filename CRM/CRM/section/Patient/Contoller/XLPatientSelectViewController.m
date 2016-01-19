//
//  XLPatientSelectViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/11.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLPatientSelectViewController.h"
#import "MudItemBarItem.h"
#import "MudItemsBar.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "UISearchBar+XLMoveBgView.h"
#import "SyncManager.h"
#import "DBManager+Patients.h"
#import "DBManager+Materials.h"
#import "UIColor+Extension.h"
#import "CRMMacro.h"
#import "LocalNotificationCenter.h"
#import "SelectDateViewController.h"
#import "PatientDetailViewController.h"
#import "DBManager+sync.h"
#import "DBManager+AutoSync.h"
#import "MJExtension.h"
#import "JSONKit.h"
#import "AddressBookViewController.h"
#import "CreatePatientViewController.h"
#import "MJRefresh.h"

@interface XLPatientSelectViewController () <MudItemsBarDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate>{
    BOOL ifNameBtnSelected;
    BOOL ifStatusBtnSelected;
    BOOL ifNumberBtnSelected;
    BOOL ifIntroducerSelected;
    UITableView *_tableView;
}
@property (nonatomic,retain) MudItemsBar *menubar;
@property (nonatomic) BOOL isBarHidden;
@property (nonatomic,retain) NSArray *patientInfoArray;
@property (nonatomic,retain) NSMutableArray *patientCellModeArray;

@property (nonatomic, strong)EMSearchBar *searchBar;
@property (nonatomic, strong)EMSearchDisplayController *searchController;

@property (nonatomic, assign)int pageNum;//分页页数

@end

@implementation XLPatientSelectViewController

- (NSArray *)patientInfoArray{
    if (!_patientInfoArray) {
        _patientInfoArray = [NSArray array];
    }
    return _patientInfoArray;
}

- (NSMutableArray *)patientCellModeArray{
    if (!_patientCellModeArray) {
        _patientCellModeArray = [NSMutableArray array];
    }
    return _patientCellModeArray;
}
#pragma mark - 控件初始化
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"患者姓名、备注名、手机号";
        [_searchBar moveBackgroundView];
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
        
        __weak XLPatientSelectViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            return [weakSelf setUpTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:weakSelf.searchController.resultsSource];
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 40.f;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
            [weakSelf selectTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:weakSelf.searchController.resultsSource];
            
        }];
    }
    return _searchController;
}

- (void)dealloc {
    [self removeNotificationObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotificationObserver];
    
    self.pageNum = 0;
    //设置子视图
    [self setupView];
    
    //第一次刷新
    [_tableView.header beginRefreshing];
}

#pragma mark - 设置
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
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.view.backgroundColor = [UIColor whiteColor];

    //初始化表示图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, self.view.height - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    //添加上拉加载和下拉事件
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
    _tableView.header.updatedTimeHidden = YES;
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction)];
    
    //初始化搜索框
    [self.view addSubview:self.searchBar];
    [self searchController];
    [self.view addSubview:[self setUpGroupViewAndButtons]];

}

#pragma mark - 下拉刷新
- (void)headerRefreshAction{
    self.pageNum = 0;
    [self requestLocalDataWithPage:self.pageNum isHeader:YES];
}
#pragma mark - 上拉加载
- (void)footerRefreshAction{
    [self requestLocalDataWithPage:self.pageNum isHeader:NO];
}

- (void)refreshView {
    [_tableView reloadData];
}

- (void)requestLocalDataWithPage:(int)pageNum isHeader:(BOOL)isHeader{
    
    self.isBarHidden = YES;
        self.patientInfoArray = [[DBManager shareInstance] getPatientsWithStatus:self.patientStatus page:pageNum];
        if (self.patientInfoArray.count > 50) {
            self.pageNum++;
        }
        if (isHeader) {
            [self.patientCellModeArray removeAllObjects];
        }
        for (NSInteger i = 0; i < self.patientInfoArray.count; i++) {
            Patient *patientTmp = [self.patientInfoArray objectAtIndex:i];
            PatientsCellMode *cellMode = [[PatientsCellMode alloc]init];
            cellMode.patientId = patientTmp.ckeyid;
            cellMode.introducerId = patientTmp.introducer_id;
            if (patientTmp.nickName != nil && [patientTmp.nickName isNotEmpty]) {
                cellMode.name = patientTmp.nickName;
            }else{
                cellMode.name = patientTmp.patient_name;
            }
            cellMode.phone = patientTmp.patient_phone;
            cellMode.introducerName = patientTmp.intr_name;
            cellMode.statusStr = [Patient statusStrWithIntegerStatus:patientTmp.patient_status];
            cellMode.status = patientTmp.patient_status;
            cellMode.countMaterial = [[DBManager shareInstance] numberMaterialsExpenseWithPatientId:patientTmp.ckeyid];
            [self.patientCellModeArray addObject:cellMode];
        }
        if (self.patientCellModeArray.count < 50) {
            [self removeFooter];
        }
        if (isHeader) {
            [self headerEndRefresh];
        }else{
            [self footerEndRefresh];
        }
        //刷新表示图
        [self refreshView];
}
#pragma mark - 停止刷新
- (void)headerEndRefresh{
    [_tableView.header endRefreshing];
}
- (void)footerEndRefresh{
    [_tableView.footer endRefreshing];
}
- (void)removeFooter{
    [_tableView removeFooter];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isBarHidden == NO){                      //如果是显示状态
        [self.menubar hiddenBar:self.navigationController.view WithBarAnimation:MudItemsBarAnimationTop];
    }
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

#pragma mark - 排序按钮点击
- (UIView *)setUpGroupViewAndButtons{
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 0, kScreenWidth, 40);
    bgView.backgroundColor = MyColor(238, 238, 238);
    
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
        [_tableView reloadData];
    }else{
        NSArray *lastArray = [NSArray arrayWithArray:self.patientCellModeArray];
        lastArray = [self.patientCellModeArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return NSOrderedDescending;
        }];
        self.patientCellModeArray = [NSMutableArray arrayWithArray:lastArray];
        [_tableView reloadData];
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
        [_tableView reloadData];
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
        [_tableView reloadData];
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
        [_tableView reloadData];
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
        [_tableView reloadData];
        
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
        [_tableView reloadData];
        
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
        [_tableView reloadData];
        
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.patientCellModeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self setUpTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:self.patientCellModeArray];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:self.patientCellModeArray];
}

#pragma mark -设置单元格
- (UITableViewCell *)setUpTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sourceArray:(NSArray *)sourceArray{
    static NSString *cellID = @"cellIdentifier";
    PatientsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PatientsTableViewCell" owner:nil options:nil] objectAtIndex:0];
        
        [tableView registerNib:[UINib nibWithNibName:@"PatientsTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    }
    
    //赋值,获取患者信息
    NSInteger row = [indexPath row];
    PatientsCellMode *cellMode = [sourceArray objectAtIndex:row];
    
    [cell configCellWithCellMode:cellMode];
    
    return cell;
}
#pragma mark -设置单元格点击事件
- (void)selectTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sourceArray:(NSArray *)sourceArray{
    
    PatientsCellMode *cellMode = [sourceArray objectAtIndex:indexPath.row];
    
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

#pragma mark - 单元格删除事件
- (void)deleteMaterialWithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView sourceArray:(NSMutableArray *)sourceArray{
    TimAlertView *alertView = [[TimAlertView alloc]initWithTitle:@"确认删除？" message:nil  cancelHandler:^{
        [tableView reloadData];
    } comfirmButtonHandlder:^{
        PatientsCellMode *cellMode = [[PatientsCellMode alloc]init];
        cellMode = [sourceArray objectAtIndex:indexPath.row];
        
        NSArray *libArray = [[DBManager shareInstance] getCTLibArrayWithPatientId:cellMode.patientId];
        for (CTLib *lib in libArray) {
            [[SDImageCache sharedImageCache] removeImageForKey:lib.ckeyid fromDisk:YES];
        }
        BOOL ret = [[DBManager shareInstance] deletePatientByPatientID:cellMode.patientId];
        if (ret == NO) {
            [SVProgressHUD showImage:nil status:@"删除失败"];
        } else {
            if (tableView != _tableView) {
                [sourceArray removeObjectAtIndex:indexPath.row];
                [self.patientCellModeArray removeObject:cellMode];
                
                [tableView reloadData];
            }else{
                [sourceArray removeObjectAtIndex:indexPath.row];
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

#pragma mark - UISearchBar Delegates
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isNotEmpty]) {
        NSArray *results = [[DBManager shareInstance] getPatientWithKeyWords:searchText];
        [self.searchController.resultsSource removeAllObjects];
        for (Patient *patient in results) {
            Patient *patientTmp = patient;
            PatientsCellMode *cellMode = [[PatientsCellMode alloc]init];
            cellMode.patientId = patientTmp.ckeyid;
            cellMode.introducerId = patientTmp.introducer_id;
            if (patientTmp.nickName != nil && [patientTmp.nickName isNotEmpty]) {
                cellMode.name = patientTmp.nickName;
            }else{
                cellMode.name = patientTmp.patient_name;
            }
            cellMode.phone = patientTmp.patient_phone;
            cellMode.introducerName = patientTmp.intr_name;
            cellMode.statusStr = [Patient statusStrWithIntegerStatus:patientTmp.patient_status];
            cellMode.status = patientTmp.patient_status;
            cellMode.countMaterial = [[DBManager shareInstance] numberMaterialsExpenseWithPatientId:patientTmp.ckeyid];
            
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
