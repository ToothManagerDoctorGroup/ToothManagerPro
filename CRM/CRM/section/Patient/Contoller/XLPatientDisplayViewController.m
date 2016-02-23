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
#import "MJRefresh.h"
#import "DBManager+Doctor.h"

@interface XLPatientDisplayViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,PatientDetailViewControllerDelegate>{
    BOOL ifNameBtnSelected;
    BOOL ifStatusBtnSelected;
    BOOL ifNumberBtnSelected;
    BOOL ifIntroducerSelected;

}

@property (nonatomic, strong)EMSearchBar *searchBar;
@property (nonatomic, strong)EMSearchDisplayController *searchController;

@property (nonatomic, strong)NSMutableArray *patientCellModeArray;
@property (nonatomic,retain) NSArray *patientInfoArray;

@property (nonatomic, assign)int pageNum;//分页显示的页数，默认从0开始

@end

@implementation XLPatientDisplayViewController

- (NSMutableArray *)patientCellModeArray{
    if (!_patientCellModeArray) {
        _patientCellModeArray = [NSMutableArray array];
    }
    return _patientCellModeArray;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum = 0;
    self.tableView.frame = CGRectMake(0, 44 + 80, kScreenWidth, kScreenHeight - 64 - 80 - 44);
    //初始化搜索框
    [self.view addSubview:self.searchBar];
    [self.view addSubview:[self setUpGroupViewAndButtons]];
    
    [self searchController];
    //添加通知
    [self addNotification];
    
    //设置上拉加载和下拉刷新
    self.showRefreshHeader = YES;
    
    //重新请求数据
    [self.tableView.header beginRefreshing];
}

//添加通知
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewDidTriggerHeaderRefresh) name:PatientCreatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewDidTriggerHeaderRefresh) name:PatientEditedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewDidTriggerHeaderRefresh) name:MedicalCaseCreatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewDidTriggerHeaderRefresh) name:MedicalCaseEditedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewDidTriggerHeaderRefresh) name:PatientTransferNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewDidTriggerHeaderRefresh) name:@"tongbu" object:nil];
}
#pragma mark - 下拉刷新事件
- (void)tableViewDidTriggerHeaderRefresh{
    self.pageNum = 0;
    //重新请求数据
    [self requestLocalDataWithPage:self.pageNum isHeader:YES isFooter:NO];
}
#pragma mark - 上拉加载事件
- (void)tableViewDidTriggerFooterRefresh{
    //首先将页码加1
    [self requestLocalDataWithPage:self.pageNum isHeader:NO isFooter:YES];
}

//加载本地数据
- (void)requestLocalDataWithPage:(int)pageNum isHeader:(BOOL)isHeader isFooter:(BOOL)isFooter{
        self.patientInfoArray = [[DBManager shareInstance] getPatientsWithStatus:self.patientStatus page:pageNum];
        if (self.patientInfoArray.count > 0) {
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
//            cellMode.countMaterial = [[DBManager shareInstance] numberMaterialsExpenseWithPatientId:patientTmp.ckeyid];
            cellMode.countMaterial = patientTmp.expense_num;
            Doctor *doc = [[DBManager shareInstance]getDoctorNameByPatientIntroducerMapWithPatientId:patientTmp.ckeyid withIntrId:[AccountManager currentUserid]];
            if ([doc.doctor_name isNotEmpty]) {
                cellMode.isTransfer = YES;
            }else{
                cellMode.isTransfer = NO;
            }
            [self.patientCellModeArray addObject:cellMode];
        }
    
    if (isHeader) {
        if (self.patientCellModeArray.count > 50) {
            self.showRefreshFooter = YES;
        }else{
            self.showRefreshFooter = NO;
        }
        [self tableViewDidFinishTriggerHeader:YES reload:NO];
    }else if (isFooter){
        [self tableViewDidFinishTriggerHeader:NO reload:NO];
    }
    //刷新表示图
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
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
        
        [_searchController setCanEditRowAtIndexPath:^BOOL(UITableView *tableView, NSIndexPath *indexPath) {
            return YES;
        }];
        
        [_searchController setCommitEditingStyleAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [weakSelf deletePatientWithTableView:tableView indexPath:indexPath sourceArray:weakSelf.searchController.resultsSource type:@"searchTableView"];
        }];
    }
    
    return _searchController;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.patientCellModeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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
    detailVc.delegate = self;
    [self.navigationController pushViewController:detailVc animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deletePatientWithTableView:tableView indexPath:indexPath sourceArray:self.patientCellModeArray type:@"tableView"];
    }
}

#pragma mark - 患者删除事件
- (void)deletePatientWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sourceArray:(NSMutableArray *)souryArray type:(NSString *)type{
    TimAlertView *alertView = [[TimAlertView alloc]initWithTitle:@"确认删除？" message:nil  cancelHandler:^{
        [tableView reloadData];
    } comfirmButtonHandlder:^{
        PatientsCellMode *cellMode = [souryArray objectAtIndex:indexPath.row];
        NSArray *libArray = [[DBManager shareInstance] getCTLibArrayWithPatientId:cellMode.patientId];
        for (CTLib *lib in libArray) {
            [[SDImageCache sharedImageCache] removeImageForKey:lib.ckeyid fromDisk:YES];
        }
        BOOL ret = [[DBManager shareInstance] deletePatientByPatientID:cellMode.patientId];
        if (ret == NO) {
            [SVProgressHUD showImage:nil status:@"删除失败"];
        } else {
            if ([type isEqualToString:@"searchTableView"]) {
                [souryArray removeObject:cellMode];
                
                if ([self.patientCellModeArray containsObject:cellMode]) {
                    [self.patientCellModeArray removeObject:cellMode];
                }
                //刷新表示图
                [tableView reloadData];
                [self.tableView reloadData];
            }else{
                [souryArray removeObject:cellMode];
                [self.tableView reloadData];
            }
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
                
                //获取所有的预约数据进行删除
            }
        }
    }];
    [alertView show];
}


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
            cellMode.countMaterial = patientTmp.expense_num;
            
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

#pragma mark - 排序按钮点击
- (UIView *)setUpGroupViewAndButtons{
    
    CGFloat commonW = kScreenWidth / 4;
    CGFloat commonH = 40;
    
    UIView *superView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 80)];
    superView.backgroundColor = [UIColor whiteColor];
    
    UIView *groupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, commonH)];
    groupView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [groupView addGestureRecognizer:tapAction];
    [superView addSubview:groupView];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"group_gray"]];
    iconView.frame = CGRectMake(20, 13, 16, 14);
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
    lineView.backgroundColor = [UIColor colorWithHex:0xdddddd];
    [groupView addSubview:lineView];
    
    
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 40, kScreenWidth, commonH);
    [superView addSubview:bgView];
    bgView.backgroundColor = MyColor(238, 238, 238);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, kScreenWidth, 1)];
    label.backgroundColor = [UIColor colorWithHex:0xdddddd];
    [bgView addSubview:label];
    
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
    [introducerButton setFrame:CGRectMake(statusButton.right, 0, commonW, commonH)];
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

#pragma mark - PatientDetailViewControllerDelegate
- (void)didLoadDataSuccessWithModel:(PatientsCellMode *)model{
    [SVProgressHUD showSuccessWithStatus:@"CT片下载成功，正在加载数据"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //跳转到新的患者详情页面
        PatientDetailViewController *detailVc = [[PatientDetailViewController alloc] init];
        detailVc.patientsCellMode = model;
        detailVc.hidesBottomBarWhenPushed = YES;
        detailVc.delegate = self;
        [self.navigationController pushViewController:detailVc animated:YES];
    });
    
}

@end
