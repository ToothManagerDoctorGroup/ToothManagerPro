//
//  XLPatientSelectViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/11.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLPatientSelectViewController.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "UISearchBar+XLMoveBgView.h"
#import "SyncManager.h"
#import "DBManager+Patients.h"
#import "DBManager+Materials.h"
#import "UIColor+Extension.h"
#import "CRMMacro.h"
#import "LocalNotificationCenter.h"
#import "PatientDetailViewController.h"
#import "DBManager+sync.h"
#import "DBManager+AutoSync.h"
#import "MJExtension.h"
#import "JSONKit.h"
#import "MJRefresh.h"
#import "DBManager+Doctor.h"
#import "XLContactsViewController.h"
#import "XLCreatePatientViewController.h"

@interface XLPatientSelectViewController () <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    BOOL ifNameBtnSelected;
    BOOL ifStatusBtnSelected;
    BOOL ifNumberBtnSelected;
    BOOL ifIntroducerSelected;
    UITableView *_tableView;
}
@property (nonatomic,retain) NSArray *patientInfoArray;
@property (nonatomic,retain) NSMutableArray *patientCellModeArray;

@property (nonatomic, strong)EMSearchBar *searchBar;
@property (nonatomic, strong)EMSearchDisplayController *searchController;

@property (nonatomic, assign)int pageNum;//分页页数

/**
 *  菜单选项
 */
@property (nonatomic, strong)NSArray *menuList;

@end

@implementation XLPatientSelectViewController

- (NSArray *)menuList{
    if (_menuList == nil) {
        _menuList = [NSArray arrayWithObjects:@"手工录入",@"通讯录导入", nil];
    }
    return _menuList;
}

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

- (void)setupView {
    self.title = @"患者";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];

    //初始化表示图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + 40, kScreenWidth, kScreenHeight - 64 - 44 - 40) style:UITableViewStylePlain];
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
            cellMode.name = patientTmp.patient_name;
            cellMode.phone = patientTmp.patient_phone;
            cellMode.introducerName = patientTmp.intr_name;
            cellMode.statusStr = [Patient statusStrWithIntegerStatus:patientTmp.patient_status];
            cellMode.status = patientTmp.patient_status;
            cellMode.countMaterial = [[DBManager shareInstance] numberMaterialsExpenseWithPatientId:patientTmp.ckeyid];
            Doctor *doc = [[DBManager shareInstance]getDoctorNameByPatientIntroducerMapWithPatientId:patientTmp.ckeyid withIntrId:[AccountManager currentUserid]];
            if ([doc.doctor_name isNotEmpty]) {
                cellMode.isTransfer = YES;
            }else{
                cellMode.isTransfer = NO;
            }
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

#pragma mark - Notification
- (void)addNotificationObserver {
    [self addObserveNotificationWithName:PatientCreatedNotification];
    [self addObserveNotificationWithName:PatientEditedNotification];
    [self addObserveNotificationWithName:MedicalCaseCreatedNotification];
    [self addObserveNotificationWithName:MedicalCaseEditedNotification];
    [self addObserveNotificationWithName:PatientTransferNotification];
}

- (void)removeNotificationObserver {
    [self removeObserverNotificationWithName:PatientCreatedNotification];
    [self removeObserverNotificationWithName:PatientEditedNotification];
    [self removeObserverNotificationWithName:MedicalCaseCreatedNotification];
    [self removeObserverNotificationWithName:MedicalCaseEditedNotification];
    [self removeObserverNotificationWithName:PatientTransferNotification];
}

- (void)handNotification:(NSNotification *)notifacation {
    [super handNotification:notifacation];
    if ([notifacation.name isEqualToString:PatientCreatedNotification]
        || [notifacation.name isEqualToString:PatientEditedNotification]
        || [notifacation.name isEqualToString:MedicalCaseCreatedNotification]
        || [notifacation.name isEqualToString:MedicalCaseEditedNotification]
        ) {
        //有新患者创建或者患者被编辑，需要更新界面
        [self headerRefreshAction];
    }
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - 排序按钮点击
- (UIView *)setUpGroupViewAndButtons{
    
    CGFloat commonW = kScreenWidth / 4;
    CGFloat commonH = 40;
    
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 44, kScreenWidth, commonH);
    bgView.backgroundColor = MyColor(238, 238, 238);
    
    UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nameButton setTitle:@"患者" forState:UIControlStateNormal];
    [nameButton setFrame:CGRectMake(0, 0, commonW, commonH)];
    [nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nameButton addTarget:self action:@selector(nameButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nameButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:nameButton];
    
    
    UIButton *statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [statusButton setTitle:@"状态" forState:UIControlStateNormal];
    [statusButton setFrame:CGRectMake(nameButton.right, 0, commonW, commonH)];
    [statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    statusButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [statusButton addTarget:self action:@selector(statusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:statusButton];
    
    UIButton *introducerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [introducerButton setTitle:@"介绍人" forState:UIControlStateNormal];
    [introducerButton setFrame:CGRectMake(statusButton.right, 0, commonW,commonH)];
    [introducerButton addTarget:self action:@selector(introducerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [introducerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    introducerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:introducerButton];
    
    UIButton *numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [numberButton setTitle:@"数量" forState:UIControlStateNormal];
    [numberButton setFrame:CGRectMake(introducerButton.right, 0, commonW, commonH)];
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
    
    if (self.isYuYuePush){
        Patient *tmpPatient = [[Patient alloc] init];
        tmpPatient.ckeyid = cellMode.patientId;
        tmpPatient.patient_name = cellMode.name;
        [LocalNotificationCenter shareInstance].selectPatient = tmpPatient;
        [[NSNotificationCenter defaultCenter]postNotificationName:YuyuePatientNotification object:tmpPatient];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        //跳转到新的患者详情页面
        PatientDetailViewController *detailVc = [[PatientDetailViewController alloc] init];
        detailVc.patientsCellMode = cellMode;
        detailVc.hidesBottomBarWhenPushed = YES;
        [self pushViewController:detailVc animated:YES];
    }
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
            cellMode.name = patientTmp.patient_name;
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
