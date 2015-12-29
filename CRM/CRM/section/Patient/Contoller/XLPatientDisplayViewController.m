//
//  XLPatientDisplayViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/24.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLPatientDisplayViewController.h"
#import "EMSearchDisplayController.h"
#import "EMSearchBar.h"
#import "RealtimeSearchUtil.h"
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
#import "GroupManageViewController.h"
#import "DoctorGroupViewController.h"
#import "UISearchBar+XLMoveBgView.h"

@interface XLPatientDisplayViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>{
    BOOL ifNameBtnSelected;
    BOOL ifStatusBtnSelected;
    BOOL ifNumberBtnSelected;
    BOOL ifIntroducerSelected;

}

@property (nonatomic, strong)EMSearchBar *searchBar;

@property (nonatomic, strong)EMSearchDisplayController *searchController;

@property (nonatomic, strong)NSMutableArray *patientCellModeArray;
@property (nonatomic,retain) NSArray *patientInfoArray;

@end

@implementation XLPatientDisplayViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height - 40);
    
    self.tableView.tableHeaderView = self.searchBar;
    
    [self searchController];
    
    //添加通知
    [self addNotification];
}
//添加通知
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction:) name:PatientCreatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction:) name:PatientEditedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction:) name:MedicalCaseCreatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction:) name:MedicalCaseEditedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction:) name:PatientTransferNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initAction:) name:@"tongbu" object:nil];
}

- (void)refreshAction:(NSNotification *)noti{
    [self refreshData];
    [self refreshView];
}

- (void)initAction:(NSNotification *)noti{
    [self initData];
    [self refreshView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self initData];
    [self refreshView];
}

- (void)refreshView {
    [self.tableView reloadData];
}
- (void)initData {
    
    _patientInfoArray = [[DBManager shareInstance] getPatientsWithStatus:self.patientStatus];
    _patientCellModeArray = [NSMutableArray arrayWithCapacity:0];
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
        //        cellMode.introducerName = [[DBManager shareInstance] getIntroducerByIntroducerID:patientTmp.introducer_id].intr_name;
        cellMode.introducerName = patientTmp.intr_name;
        cellMode.statusStr = [Patient statusStrWithIntegerStatus:patientTmp.patient_status];
        cellMode.status = patientTmp.patient_status;
        cellMode.countMaterial = [[DBManager shareInstance] numberMaterialsExpenseWithPatientId:patientTmp.ckeyid];
        [_patientCellModeArray addObject:cellMode];
    }
    
    if (_patientCellModeArray.count > 0) {
        [self refreshView];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, 200, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
//        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
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
        
        __weak XLPatientDisplayViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            static NSString *cellID = @"cellIdentifier";
            PatientsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"PatientsTableViewCell" owner:nil options:nil] objectAtIndex:0];
                [tableView registerNib:[UINib nibWithNibName:@"PatientsTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
            }
            
            //赋值,获取患者信息
            NSInteger row = [indexPath row];
            PatientsCellMode *cellMode = [weakSelf.searchController.resultsSource objectAtIndex:row];
            [cell configCellWithCellMode:cellMode];
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 40;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
            PatientsCellMode *model = weakSelf.searchController.resultsSource[indexPath.row];
            //跳转到新的患者详情页面
            PatientDetailViewController *detailVc = [[PatientDetailViewController alloc] init];
            detailVc.patientsCellMode = model;
            detailVc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:detailVc animated:YES];
            
        }];
    }
    
    return _searchController;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.patientCellModeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellIdentifier";
    PatientsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PatientsTableViewCell" owner:nil options:nil] objectAtIndex:0];
        [tableView registerNib:[UINib nibWithNibName:@"PatientsTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    }
    
    //赋值,获取患者信息
    NSInteger row = [indexPath row];
    PatientsCellMode *cellMode = [self.patientCellModeArray objectAtIndex:row];
    [cell configCellWithCellMode:cellMode];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientsCellMode *model = self.patientCellModeArray[indexPath.row];
    //跳转到新的患者详情页面
    PatientDetailViewController *detailVc = [[PatientDetailViewController alloc] init];
    detailVc.patientsCellMode = model;
    detailVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TimAlertView *alertView = [[TimAlertView alloc]initWithTitle:@"确认删除？" message:nil  cancelHandler:^{
            [tableView reloadData];
        } comfirmButtonHandlder:^{
            PatientsCellMode *cellMode = [_patientCellModeArray objectAtIndex:indexPath.row];
            NSArray *libArray = [[DBManager shareInstance] getCTLibArrayWithPatientId:cellMode.patientId];
            for (CTLib *lib in libArray) {
                [[SDImageCache sharedImageCache] removeImageForKey:lib.ckeyid fromDisk:YES];
            }
            BOOL ret = [[DBManager shareInstance] deletePatientByPatientID:cellMode.patientId];
            if (ret == NO) {
                [SVProgressHUD showImage:nil status:@"删除失败"];
            } else {
                
                [self.patientCellModeArray removeObjectAtIndex:indexPath.row];
                [self refreshView];
            }
        }];
        [alertView show];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableArray *searchResults;
    if ([searchText isNotEmpty]) {
        searchResults = [NSMutableArray arrayWithArray:[ChineseSearchEngine resultArraySearchPatientsOnArray:self.patientCellModeArray withSearchText:searchText]];
        
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

#pragma mark - 排序按钮点击
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    superView.backgroundColor = [UIColor whiteColor];
    
    UIView *groupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    groupView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [groupView addGestureRecognizer:tapAction];
    [superView addSubview:groupView];
    
//    UIView *toplineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
//    toplineView.backgroundColor = MyColor(188, 186, 193);
//    [groupView addSubview:toplineView];
    
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
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kScreenWidth, 10)];
//    lineView.backgroundColor = MyColor(188, 186, 193);
//    [groupView addSubview:lineView];
    
    
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 40, kScreenWidth, 40);
    [superView addSubview:bgView];
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
    
    return superView;
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    DoctorGroupViewController *manageVc = [[DoctorGroupViewController alloc] initWithStyle:UITableViewStylePlain];
    manageVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:manageVc animated:YES];
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

@end