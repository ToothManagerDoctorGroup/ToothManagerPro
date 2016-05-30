//
//  XLGroupPatientDisplayViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/12.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLGroupPatientDisplayViewController.h"
#import "GroupPatientCell.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "UISearchBar+XLMoveBgView.h"
#import "DoctorGroupTool.h"
#import "GroupMemberModel.h"
#import "DBManager+Patients.h"
#import "EditPatientDetailViewController.h"
#import "MJRefresh.h"
#import "PatientDetailViewController.h"
#import "MyPatientTool.h"
#import "XLPatientTotalInfoModel.h"
#import "XLGuideImageView.h"
#import "CRMUserDefalut.h"
#import "UITableView+NoResultAlert.h"

@interface XLGroupPatientDisplayViewController ()<GroupPatientCellDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate>{
    BOOL ifNameBtnSelected;
    BOOL ifStatusBtnSelected;
    BOOL ifNumberBtnSelected;
    BOOL ifIntroducerSelected;
    
    UITableView *_tableView;
}

/**
 *  UITableView的数据源
 */
@property (nonatomic,retain) NSMutableArray *patientCellModeArray;
/**
 *  UISearchDisplayController的数据源
 */
@property (nonatomic, assign)BOOL isChooseAll; //是否全选
@property (nonatomic, weak)UIButton *chooseButton;//全选的按钮
///**
// *  判断是否是UISearchDisplayController
// */
//@property (nonatomic, assign)BOOL isSearchDisplayController;
///**
// *  保存UISearchDisplayController的tableView
// */
//@property (nonatomic, weak)UITableView *searchResultTableView;
@property (nonatomic, assign)int postNum;//上传总数

@property (nonatomic, strong)EMSearchBar *searchBar;
@property (nonatomic, strong)EMSearchDisplayController *searchController;


@property (nonatomic, assign)int pageIndex;//分页的页数
@property (nonatomic, copy)NSString *sortFieldText;//用于排序查询
@property (nonatomic, assign)BOOL isAsc;//是否是正序还是倒序


/**
 *  判断是否是UISearchDisplayController
 */
@property (nonatomic, assign)BOOL isSearchDisplayController;
/**
 *  保存UISearchDisplayController的tableView
 */
@property (nonatomic, weak)UITableView *searchResultTableView;

@end

@implementation XLGroupPatientDisplayViewController

#pragma mark - 控件初始化
- (NSMutableArray *)patientCellModeArray{
    if (!_patientCellModeArray) {
        _patientCellModeArray = [NSMutableArray array];
    }
    return _patientCellModeArray;
}

#pragma mark - 设置按钮是否可点
- (void)setButtonEnable:(BOOL)enable{
    self.navigationItem.rightBarButtonItem.enabled = enable;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        [_searchBar changeCancelButtonTitle:@"搜索"];
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
        _searchController.delegate = self;
        
        __weak XLGroupPatientDisplayViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            GroupPatientCell *cell = [GroupPatientCell cellWithTableView:tableView];
            cell.delegate = weakSelf;
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
            //单元格点击事件
            [weakSelf selectTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:weakSelf.searchController.resultsSource];
        }];
        //设置可编辑模式
        [_searchController setCanEditRowAtIndexPath:^BOOL(UITableView *tableView, NSIndexPath *indexPath) {
            return NO;
        }];
    }
    return _searchController;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}


- (void)viewDidLoad {
    [super initView];
    [super viewDidLoad];
    
    self.pageIndex = 1;
    
    //初始化
    [self setupView];
    //请求数据
    [_tableView.header beginRefreshing];
}


- (void)setupView {
    self.title = @"选择患者";
    
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"添加"];
    
    //初始化表示图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + 40, kScreenWidth, kScreenHeight - 64 - 44 - 40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
    //初始化搜索框
    [self.view addSubview:self.searchBar];
    [self searchController];
    
    [self.view addSubview:[self setUpGroupViewAndButtons]];
    
    //添加上拉刷新和下拉加载
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
    _tableView.header.updatedTimeHidden = YES;
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction)];
    _tableView.footer.hidden = YES;
}

#pragma mark - 下拉刷新数据
- (void)headerRefreshAction{
    self.pageIndex = 1;
    NSString *sortFieldText = self.sortFieldText == nil ? @"" : self.sortFieldText;
    BOOL isAsc = self.isAsc == YES ? true : false;
    XLQueryModel *queryModel = [[XLQueryModel alloc] initWithKeyWord:@"" sortField:sortFieldText isAsc:@(isAsc) pageIndex:@(self.pageIndex) pageSize:@(CommonPageSize)];
    [self requestWlanDataWithQueryModel:queryModel isHeader:YES];
}
#pragma mark - 上拉加载数据
- (void)footerRefreshAction{
    self.pageIndex++;
    NSString *sortFieldText = self.sortFieldText == nil ? @"" : self.sortFieldText;
    BOOL isAsc = self.isAsc == YES ? true : false;
    XLQueryModel *queryModel = [[XLQueryModel alloc] initWithKeyWord:@"" sortField:sortFieldText isAsc:@(isAsc) pageIndex:@(self.pageIndex) pageSize:@(CommonPageSize)];
    [self requestWlanDataWithQueryModel:queryModel isHeader:NO];
}

- (void)requestWlanDataWithQueryModel:(XLQueryModel *)queryModel isHeader:(BOOL)isHeader{
    WS(weakSelf);
    [DoctorGroupTool getGroupPatientsWithDoctorId:[AccountManager currentUserid] groupId:self.group.ckeyid queryModel:queryModel success:^(NSArray *result) {
        _tableView.tableHeaderView = nil;
        if (isHeader) {
            [weakSelf.patientCellModeArray removeAllObjects];
            [_tableView createNoResultWithImageName:@"groupAddMember_alert" ifNecessaryForRowCount:result.count];
        }
        //将数据添加到数组中
        [weakSelf.patientCellModeArray addObjectsFromArray:result];
        
        if (weakSelf.patientCellModeArray.count < 50) {
            [_tableView removeFooter];
        }else{
            _tableView.footer.hidden = NO;
        }
        
        if (isHeader) {
            [_tableView.header endRefreshing];
        }else{
            [_tableView.footer endRefreshing];
        }
        //刷新表格
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        if (isHeader) {
            [_tableView.header endRefreshing];
        }else{
            [_tableView.footer endRefreshing];
        }
        if (isHeader) {
            if (weakSelf.patientCellModeArray.count == 0) {
                [_tableView createNoResultWithImageName:@"no_net_alert" ifNecessaryForRowCount:0 target:weakSelf action:@selector(headerRefreshAction)];
            }
        }
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

- (void)reloadTableView{
    [_tableView reloadData];
}

- (void)onRightButtonAction:(id)sender{
    [self addPatientToGroupWithArray:self.patientCellModeArray];
}

#pragma mark - 添加患者
- (void)addPatientToGroupWithArray:(NSArray *)result{
    [self setButtonEnable:NO];
    int index = 0;
    NSMutableArray *selectMemberArr = [NSMutableArray array];
    for (GroupMemberModel *model in result) {
        if (model.isChoose && !model.isMember) {
            index++;
            //新增患者
            GroupMemberEntity *member = [[GroupMemberEntity alloc] initWithGroupName:self.group.group_name groupId:self.group.ckeyid doctorId:self.group.doctor_id patientId:model.ckeyid patientName:model.patient_name ckeyId:self.group.ckeyid];
            
            [selectMemberArr addObject:member.keyValues];
        }
    }
    
    if (selectMemberArr.count > 0) {
        [DoctorGroupTool addGroupMemberWithGroupMemberEntity:selectMemberArr success:^(CRMHttpRespondModel *respondModel) {
            [SVProgressHUD dismiss];
            if ([respondModel.code integerValue] == 200) {
                NSLog(@"添加成功");
                //发送一个通知
                [[NSNotificationCenter defaultCenter] postNotificationName:DoctorAddGroupMemberSuccessNotification object:nil];
                [self popViewControllerAnimated:YES];
            }else{
                [self setButtonEnable:YES];
                [SVProgressHUD showErrorWithStatus:respondModel.result];
            }
        } failure:^(NSError *error) {
            [self setButtonEnable:YES];
            [SVProgressHUD showErrorWithStatus:@"添加失败"];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
    
    if (index == 0) {
        [self setButtonEnable:YES];
        [SVProgressHUD showErrorWithStatus:@"请选择患者"];
        return;
    }
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
    cell.delegate = self;
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

-(UIView *)setUpGroupViewAndButtons{
    
    CGFloat commonW = (kScreenWidth - 50) / 4;
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
    
    UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseButton.frame = CGRectMake(numberButton.right + 5, 0, 40, 40);
    chooseButton.selected = self.isChooseAll;
    [chooseButton setImage:[UIImage imageNamed:@"no-choose"] forState:UIControlStateNormal];
    [chooseButton setImage:[UIImage imageNamed:@"remove-blue"] forState:UIControlStateSelected];
    [chooseButton addTarget:self action:@selector(choosePatientAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:chooseButton];
    self.chooseButton = chooseButton;
    
    return bgView;
}

#pragma mark -设置单元格点击事件
- (void)selectTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sourceArray:(NSMutableArray *)sourceArray{
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

#pragma mark - 全选按钮点击事件
- (void)choosePatientAction:(UIButton *)button{
    if (self.isChooseAll) {
        self.isChooseAll = NO;
    }else{
        self.isChooseAll = YES;
    }
    
    button.selected = self.isChooseAll;
    
    for (GroupMemberModel *model in self.patientCellModeArray) {
        if (!model.isMember) {
            model.isChoose = self.isChooseAll;
        }
    }
    [_tableView reloadData];
    
}

-(void)numberButtonClick:(UIButton *)button{
    ifNumberBtnSelected = !ifNumberBtnSelected;
    self.sortFieldText = @"数量";
    if(ifNumberBtnSelected == YES){
        //正序
        self.isAsc = YES;
    }else{
        //倒序
        self.isAsc = NO;
    }
//    [self headerRefreshAction];
    [_tableView.header beginRefreshing];
}
-(void)nameButtonClick:(UIButton *)button{
    ifNameBtnSelected = !ifNameBtnSelected;
    self.sortFieldText = @"姓名";
    if(ifNameBtnSelected == YES){
        //正序
        self.isAsc = YES;
    }else{
        self.isAsc = NO;
    }
    
//    [self headerRefreshAction];
    [_tableView.header beginRefreshing];
    
}
-(void)introducerButtonClick:(UIButton*)button{
    ifIntroducerSelected = !ifIntroducerSelected;
    self.sortFieldText = @"介绍人";
    if(ifIntroducerSelected == YES){
        self.isAsc = YES;
    }else{
        self.isAsc = NO;
    }
//    [self headerRefreshAction];
    [_tableView.header beginRefreshing];
    
}
-(void)statusButtonClick:(UIButton *)button{
    ifStatusBtnSelected = !ifStatusBtnSelected;
    self.sortFieldText = @"状态";
    if(ifStatusBtnSelected == YES){
        self.isAsc = YES;
    }else{
        self.isAsc = NO;
    }
//    [self headerRefreshAction];
    [_tableView.header beginRefreshing];
}

#pragma mark - GroupPatientCellDelegate
- (void)didChooseCell:(GroupPatientCell *)cell withChooseStatus:(BOOL)status{
    if (self.isSearchDisplayController) {
        NSIndexPath *indexPath = [self.searchResultTableView indexPathForCell:cell];
        GroupMemberModel *model = self.searchController.resultsSource[indexPath.row];
        model.isChoose = status;
        
        BOOL isChoose = false;
        for (GroupMemberModel *model in self.searchController.resultsSource) {
            if (model.isChoose) {
                isChoose = YES;
            }
        }
        if (isChoose) {
            [self.searchController.searchBar changeCancelButtonTitle:@"完成"];
        }else{
            [self.searchController.searchBar changeCancelButtonTitle:@"取消"];
        }
        
        
    }else{
        //获取当前对应的数据模型
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        GroupMemberModel *model = self.patientCellModeArray[indexPath.row];
        model.isChoose = status;
        //获取所有的模型的点击状态
        int index = 0;
        for (GroupMemberModel *model in self.patientCellModeArray) {
            if (model.isChoose && !model.isMember) {
                index++;
            }
        }
        //表示当前全选
        self.isChooseAll = index == self.patientCellModeArray.count;
        self.chooseButton.selected = self.isChooseAll;
    }
}

#pragma mark - UISearchBar Delegates
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    NSLog(@"searchBarShouldBeginEditing");
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (![searchText isNotEmpty]) {
        NSString *title = [searchBar currentTitle];
        if ([title isEqualToString:@"完成"]) {
            [searchBar changeCancelButtonTitle:@"取消"];
        }
    }
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldEndEditing");
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBarSearchButtonClicked");
    [searchBar resignFirstResponder];
    WS(weakSelf);
    [SVProgressHUD showWithStatus:@"正在查询"];
    XLQueryModel *queryModel = [[XLQueryModel alloc] initWithKeyWord:searchBar.text sortField:@"" isAsc:@(true) pageIndex:@(1) pageSize:@(1000)];
    [DoctorGroupTool getGroupPatientsWithDoctorId:[AccountManager currentUserid] groupId:weakSelf.group.ckeyid queryModel:queryModel success:^(NSArray *result) {
        [SVProgressHUD dismiss];
        
        [weakSelf.searchController.resultsSource removeAllObjects];
        [weakSelf.searchController.resultsSource addObjectsFromArray:result];
        [weakSelf.searchController.searchResultsTableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //判断是完成还是取消
    NSString *title = [searchBar currentTitle];
    if ([title isEqualToString:@"完成"]) {
        //将选中的数据添加到分组中
        [self addPatientToGroupWithArray:self.searchController.resultsSource];
    }else{
        //取消
        searchBar.text = @"";
        [searchBar resignFirstResponder];
        [searchBar setShowsCancelButton:NO animated:YES];
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
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
