//
//  XLGroupManagerViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/11.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLGroupManagerViewController.h"
#import "CustomAlertView.h"
#import "MLKMenuPopover.h"
#import "GroupMemberModel.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "UISearchBar+XLMoveBgView.h"
#import "DoctorGroupTool.h"
#import "GroupPatientCell.h"
#import "DBManager+Patients.h"
#import "PatientDetailViewController.h"
#import "XLGroupPatientDisplayViewController.h"
#import "MyPatientTool.h"
#import "AccountManager.h"
#import "MJRefresh.h"
#import "XLPatientTotalInfoModel.h"
#import "CRMUserDefalut.h"
#import "XLGuideImageView.h"
#import "UITableView+NoResultAlert.h"

@interface XLGroupManagerViewController ()<MLKMenuPopoverDelegate,CustomAlertViewDelegate,UIAlertViewDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    BOOL ifNameBtnSelected;
    BOOL ifStatusBtnSelected;
    BOOL ifNumberBtnSelected;
    BOOL ifIntroducerSelected;
    
    UITableView *_tableView;
}
@property (nonatomic,strong) NSMutableArray *patientCellModeArray;
@property (nonatomic,strong) NSMutableArray *searchResults;
@property (nonatomic, strong)NSMutableArray *totalPatients;

@property (nonatomic, strong)EMSearchBar *searchBar;
@property (nonatomic, strong)EMSearchDisplayController *searchController;

//菜单选项
@property (nonatomic, strong)NSArray *menuList;
//菜单弹出视图
@property (nonatomic, strong)MLKMenuPopover *menuPopover;
//当前选中的组员
@property (nonatomic, strong)GroupMemberModel *selectModel;

@end

@implementation XLGroupManagerViewController

#pragma mark - 控件初始化
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
        
        __weak XLGroupManagerViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            GroupPatientCell *cell = [GroupPatientCell cellWithTableView:tableView];
            cell.isManage = YES;
            //赋值,获取患者信息
            NSInteger row = [indexPath row];
            GroupMemberModel *cellMode = [weakSelf.searchController.resultsSource objectAtIndex:row];
            cell.model = cellMode;
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 40;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
            [weakSelf selectTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:weakSelf.searchController.resultsSource];
        }];
        //设置可编辑模式
        [_searchController setCanEditRowAtIndexPath:^BOOL(UITableView *tableView, NSIndexPath *indexPath) {
            if (weakSelf.isAnalyse) {
                return NO;
            }
            return YES;
        }];
        //编辑模式下的删除操作
        [_searchController setCommitEditingStyleAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            GroupMemberModel *model = weakSelf.searchController.resultsSource[indexPath.row];
            weakSelf.selectModel = model;
            TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"移除患者并不会删除患者信息，确认移除患者？" message:nil cancelHandler:^{
            } comfirmButtonHandlder:^{
                //删除组员
                [SVProgressHUD showWithStatus:@"正在删除"];
                [DoctorGroupTool deleteGroupMemberWithCkId:weakSelf.selectModel.ckeyid groupId:weakSelf.group.ckeyid success:^(CRMHttpRespondModel *respondModel) {
                    if ([respondModel.code integerValue] == 200) {
                        //删除数组中的信息
                        [weakSelf.searchController.resultsSource removeObject:model];
                        [tableView reloadData];
                        
                        //重新请求数据
                        [weakSelf requestGroupMemberData];
                        //发送通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:DoctorDeleteGroupMemberSuccessNotification object:nil];
                        return;
                    }
                    [SVProgressHUD showErrorWithStatus:@"删除失败"];
                } failure:^(NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"删除失败"];
                    if (error) {
                        NSLog(@"error:%@",error);
                    }
                }];
                
            }];
            [alertView show];
        }];
    }
    return _searchController;
}
- (NSMutableArray *)totalPatients{
    if (!_totalPatients) {
        _totalPatients = [NSMutableArray array];
    }
    return _totalPatients;
}

- (MLKMenuPopover *)menuPopover{
    if (!_menuPopover) {
        MLKMenuPopover *menuPopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake(kScreenWidth - 120 - 8, 64, 120, self.menuList.count * 44) menuItems:self.menuList];
        menuPopover.menuPopoverDelegate = self;
        _menuPopover = menuPopover;
    }
    return _menuPopover;
}

- (NSArray *)menuList{
    if (_menuList == nil) {
        _menuList = [NSArray arrayWithObjects:@"添加成员",@"编辑组名",@"删除分组", nil];
    }
    return _menuList;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [SVProgressHUD dismiss];
    NSLog(@"我被销毁了");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super initView];
    [super viewDidLoad];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addGroupMemberAction:) name:DoctorAddGroupMemberSuccessNotification object:nil];
    
    //初始化
    [self setupView];
    //请求数据
    [self requestGroupMemberData];
    
}

- (void)setupView {
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    if (!self.isAnalyse) {
        [self setRightBarButtonWithTitle:@"管理"];
        self.title = self.group.group_name;
    }
    
    //初始化表示图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + 40, kScreenWidth, kScreenHeight - 64 - 40 - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
    //初始化搜索框
    [self.view addSubview:self.searchBar];
    [self searchController];
    
    [self.view addSubview:[self setUpHeaderView]];
    
    
    _patientCellModeArray = [NSMutableArray arrayWithCapacity:0];
    _searchResults = [NSMutableArray arrayWithCapacity:0];
}

//添加组员成功
- (void)addGroupMemberAction:(NSNotification *)note{
    [self.patientCellModeArray removeAllObjects];
    //重新请求数据
    [self requestGroupMemberData];
}

- (void)requestGroupMemberData{
    if (self.isAnalyse) {
        [_patientCellModeArray addObjectsFromArray:self.analyseList];
        [_tableView reloadData];
    }else{
        //获取当前分组下的所有成员数据
        [SVProgressHUD showWithStatus:@"正在加载"];
        [DoctorGroupTool queryGroupMembersWithCkId:self.group.ckeyid success:^(NSArray *result) {
            _tableView.tableHeaderView = nil;
            [SVProgressHUD dismiss];
            
            [_patientCellModeArray removeAllObjects];
            [_patientCellModeArray addObjectsFromArray:result];
            [_tableView createNoResultWithImageName:@"groupDetail_alert" ifNecessaryForRowCount:self.patientCellModeArray.count];
            [_tableView reloadData];
            
        } failure:^(NSError *error) {
            [SVProgressHUD showImage:nil status:error.localizedDescription];
            if (_patientCellModeArray.count == 0) {
                [_tableView createNoResultWithImageName:@"no_net_alert" ifNecessaryForRowCount:0 target:self action:@selector(requestGroupMemberData)];
            }
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
}

- (void)onRightButtonAction:(id)sender{
    //显示菜单
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self.menuPopover showInView:keyWindow];
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.patientCellModeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GroupPatientCell *cell = [GroupPatientCell cellWithTableView:tableView];
    cell.isManage = YES;
    //赋值,获取患者信息
    NSInteger row = [indexPath row];
    GroupMemberModel *cellMode = [self.patientCellModeArray objectAtIndex:row];
    cell.model = cellMode;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:self.patientCellModeArray];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isAnalyse) {
        return NO;
    }
    return YES;
}

//当cell向左滑动时会出现删除或者添加按钮，只要实现了下面的方法，此按钮自动添加
//当点击添加或者删除按钮时，调用下面的方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupMemberModel *model = self.patientCellModeArray[indexPath.row];
    self.selectModel = model;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"移除患者" message:@"移除患者并不会删除患者信息，确认移除患者？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 130;
        [alertView show];
    }
}
//返回当前cell上的自带按钮是添加按钮还是删除按钮
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewCellEditingStyleDelete;
}

-(UIView *)setUpHeaderView{
    
    CGFloat commonW = (kScreenWidth - 30) / 4;
    CGFloat commonH = 40;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, commonH)];
    bgView.backgroundColor = MyColor(238, 238, 238);
    
    UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nameButton setTitle:@"姓名" forState:UIControlStateNormal];
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
    
    return bgView;
}

#pragma mark -设置单元格点击事件
- (void)selectTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sourceArray:(NSArray *)sourceArray{
    //获取当前对应的数据模型
    GroupMemberModel *model = sourceArray[indexPath.row];
    Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:model.ckeyid];
    if (patient != nil) {
        PatientsCellMode *cellModel = [[PatientsCellMode alloc] init];
        cellModel.patientId = patient.ckeyid;
        //跳转到新的患者详情页面
        PatientDetailViewController *detailVc = [[PatientDetailViewController alloc] init];
        detailVc.patientsCellMode = cellModel;
        detailVc.hidesBottomBarWhenPushed = YES;
        [self pushViewController:detailVc animated:YES];
    }else {
        //根据患者id去服务器获取数据保存到本地
        [SVProgressHUD showWithStatus:@"正在获取患者数据"];
        [MyPatientTool getPatientAllInfosWithPatientId:model.ckeyid doctorID:[AccountManager currentUserid] success:^(CRMHttpRespondModel *respond) {
            if ([respond.code integerValue] == 200) {
                NSMutableArray *arrayM = [NSMutableArray array];
                for (NSDictionary *dic in respond.result) {
                    XLPatientTotalInfoModel *model = [XLPatientTotalInfoModel objectWithKeyValues:dic];
                    [arrayM addObject:model];
                }
                
                [SVProgressHUD dismiss];
                BOOL ret = [[DBManager shareInstance] saveAllDownloadPatientInfoWithPatientModel:arrayM[0]];
                if (ret) {
                    PatientsCellMode *cellModel = [[PatientsCellMode alloc] init];
                    cellModel.patientId = patient.ckeyid;
                    //跳转到新的患者详情页面
                    PatientDetailViewController *detailVc = [[PatientDetailViewController alloc] init];
                    detailVc.patientsCellMode = cellModel;
                    detailVc.hidesBottomBarWhenPushed = YES;
                    [self pushViewController:detailVc animated:YES];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:respond.result];
            }
            
       } failure:^(NSError *error) {
           [SVProgressHUD showWithStatus:@"患者数据获取失败"];
           if (error) {
               NSLog(@"error:%@",error);
           }
       }];
    }
}

#pragma mark - 排序按钮点击事件
-(void)numberButtonClick:(UIButton *)button{
    ifNumberBtnSelected = !ifNumberBtnSelected;
    if(ifNumberBtnSelected == YES){
        NSArray *lastArray = [NSArray arrayWithArray:self.patientCellModeArray];
        lastArray = [self.patientCellModeArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            GroupMemberModel *object1 = (GroupMemberModel *)obj1;
            GroupMemberModel *object2 = (GroupMemberModel *)obj2;
            if(object1.expense_num < object2.expense_num){
                return  NSOrderedAscending;
            }
            if (object1.expense_num > object2.expense_num){
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
            GroupMemberModel *object1 = (GroupMemberModel *)obj1;
            GroupMemberModel *object2 = (GroupMemberModel *)obj2;
            result = [object1.patient_name localizedCompare:object2.patient_name];
            return result == NSOrderedDescending;
        }];
        self.patientCellModeArray = [NSMutableArray arrayWithArray:lastArray];
        [_tableView reloadData];
    }else{
        NSArray *lastArray = [NSArray arrayWithArray:self.patientCellModeArray];
        lastArray = [self.patientCellModeArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSComparisonResult result;
            GroupMemberModel *object1 = (GroupMemberModel *)obj1;
            GroupMemberModel *object2 = (GroupMemberModel *)obj2;
            result = [object1.patient_name localizedCompare:object2.patient_name];
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
            GroupMemberModel *object1 = (GroupMemberModel *)obj1;
            GroupMemberModel *object2 = (GroupMemberModel *)obj2;
            result = [object1.intr_name localizedCompare:object2.intr_name];
            return result == NSOrderedDescending;
        }];
        self.patientCellModeArray = [NSMutableArray arrayWithArray:lastArray];
        [_tableView reloadData];
    }else{
        NSArray *lastArray = [NSArray arrayWithArray:self.patientCellModeArray];
        lastArray = [self.patientCellModeArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSComparisonResult result;
            GroupMemberModel *object1 = (GroupMemberModel *)obj1;
            GroupMemberModel *object2 = (GroupMemberModel *)obj2;
            result = [object1.intr_name localizedCompare:object2.intr_name];
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
            GroupMemberModel *cellMode;
            cellMode = [self.patientCellModeArray objectAtIndex:i];
            if([cellMode.statusStr isEqualToString:@"未就诊"]){
                [lastArray addObject:cellMode];
            }
        }
        for(NSInteger i = 0;i<self.patientCellModeArray.count;i++){
            GroupMemberModel *cellMode;
            cellMode = [self.patientCellModeArray objectAtIndex:i];
            if([cellMode.statusStr isEqualToString:@"未种植"]){
                [lastArray addObject:cellMode];
            }
        }
        for(NSInteger i = 0;i<self.patientCellModeArray.count;i++){
            GroupMemberModel *cellMode;
            cellMode = [self.patientCellModeArray objectAtIndex:i];
            if([cellMode.statusStr isEqualToString:@"已种未修"]){
                [lastArray addObject:cellMode];
            }
        }
        for(NSInteger i = 0;i<self.patientCellModeArray.count;i++){
            GroupMemberModel *cellMode;
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
            GroupMemberModel *cellMode;
            cellMode = [self.patientCellModeArray objectAtIndex:i];
            if([cellMode.statusStr isEqualToString:@"已修复"]){
                [lastArray addObject:cellMode];
            }
        }
        for(NSInteger i = 0;i<self.patientCellModeArray.count;i++){
            GroupMemberModel *cellMode;
            cellMode = [self.patientCellModeArray objectAtIndex:i];
            if([cellMode.statusStr isEqualToString:@"已种未修"]){
                [lastArray addObject:cellMode];
            }
        }
        for(NSInteger i = 0;i<self.patientCellModeArray.count;i++){
            GroupMemberModel *cellMode;
            cellMode = [self.patientCellModeArray objectAtIndex:i];
            if([cellMode.statusStr isEqualToString:@"未种植"]){
                [lastArray addObject:cellMode];
            }
        }
        for(NSInteger i = 0;i<self.patientCellModeArray.count;i++){
            GroupMemberModel *cellMode;
            cellMode = [self.patientCellModeArray objectAtIndex:i];
            if([cellMode.statusStr isEqualToString:@"未就诊"]){
                [lastArray addObject:cellMode];
            }
        }
        self.patientCellModeArray = [NSMutableArray arrayWithArray:lastArray];
        [_tableView reloadData];
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
    NSArray *searchResults;
    if ([searchText isNotEmpty]) {
        searchResults = [ChineseSearchEngine resultArraySearchGroupPatientsOnArray:self.patientCellModeArray withSearchText:searchText];
        
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

#pragma mark - 菜单栏点击事件
- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex{
    [self.menuPopover dismissMenuPopover];
    
    switch (selectedIndex) {
        case 0:
            //添加成员
            [self addGroupMember];
            break;
        case 1:
            //编辑组名
            [self editGroupName];
            break;
        case 2:
            //删除分组
            [self deleteGroup];
            break;
            
        default:
            break;
    }
}
#pragma mark - 添加成员
- (void)addGroupMember{
    XLGroupPatientDisplayViewController *patientVc = [[XLGroupPatientDisplayViewController alloc] init];
    patientVc.patientStatus = PatientStatuspeAll;
    patientVc.group = self.group;
    patientVc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:patientVc animated:YES];
}

#pragma mark 编辑组名
- (void)editGroupName{
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithAlertTitle:@"编辑组名" cancleTitle:@"取消" certainTitle:@"保存"];
    alertView.type = CustomAlertViewTextField;
    alertView.tipContent = self.group.group_name;
    alertView.delegate = self;
    [alertView show];
}

- (void)deleteGroup{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除分组" message:@"删除分组并不会删除患者信息，确认删除分组？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    alertView.tag = 120;
    [alertView show];
}

#pragma mark CustomAlertViewDelegate
- (void)alertView:(CustomAlertView *)alertView didClickCertainButtonWithContent:(NSString *)content{
    if (content.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"分组名不能为空"];
        return;
    }
    if ([content isValidLength:32] == ValidationResultInValid) {
        [SVProgressHUD showErrorWithStatus:@"分组名最多为16个汉字"];
        return;
    }
    //编辑组名
    GroupEntity *entity = [[GroupEntity alloc] initWithName:content originGroup:self.group];
    [DoctorGroupTool updateGroupWithGroupEntity:entity success:^(CRMHttpRespondModel *respondModel) {
        if ([respondModel.code integerValue] == 200) {
            //修改当前的组名
            self.title = content;
            self.group.group_name = content;
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:DoctorUpdateGroupNameSuccessNotification object:nil];
        }else{
            [SVProgressHUD showImage:nil status:respondModel.result];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 120) {
        if (buttonIndex == 0) return;
        //删除分组
        [SVProgressHUD showWithStatus:@"正在删除"];
        [DoctorGroupTool deleteGroupWithCkId:self.group.ckeyid success:^(CRMHttpRespondModel *respondModel) {
            if ([respondModel.code integerValue] == 200) {
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:DoctorDeleteGroupSuccessNotification object:nil];
                //删除成功
                [self popViewControllerAnimated:YES];
                
            }else{
                [SVProgressHUD showErrorWithStatus:@"删除失败"];
            }
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
            [SVProgressHUD showImage:nil status:error.localizedDescription];
        }];
    }else{
        if (buttonIndex == 0) return;
        //删除组员
        [SVProgressHUD showWithStatus:@"正在删除"];
        [DoctorGroupTool deleteGroupMemberWithCkId:self.selectModel.ckeyid groupId:self.group.ckeyid success:^(CRMHttpRespondModel *respondModel) {
            if ([respondModel.code integerValue] == 200) {
                //重新请求数据
                [self requestGroupMemberData];
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:DoctorDeleteGroupMemberSuccessNotification object:nil];
                return;
            }
            [SVProgressHUD showErrorWithStatus:@"删除失败"];
        } failure:^(NSError *error) {
            [SVProgressHUD showImage:nil status:error.localizedDescription];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
