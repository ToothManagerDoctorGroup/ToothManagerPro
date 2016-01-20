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

@interface XLGroupPatientDisplayViewController ()<GroupPatientCellDelegate,UISearchDisplayDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
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
/**
 *  判断是否是UISearchDisplayController
 */
@property (nonatomic, assign)BOOL isSearchDisplayController;
/**
 *  保存UISearchDisplayController的tableView
 */
@property (nonatomic, weak)UITableView *searchResultTableView;
@property (nonatomic, assign)int postNum;//上传总数

@property (nonatomic, strong)EMSearchBar *searchBar;
@property (nonatomic, strong)EMSearchDisplayController *searchController;


@property (nonatomic, assign)int pageIndex;//分页的页数
@property (nonatomic, copy)NSString *sortFieldText;//用于排序查询
@property (nonatomic, assign)BOOL isAsc;//是否是正序还是倒序

@end

@implementation XLGroupPatientDisplayViewController

#pragma mark - 控件初始化
- (NSMutableArray *)patientCellModeArray{
    if (!_patientCellModeArray) {
        _patientCellModeArray = [NSMutableArray array];
    }
    return _patientCellModeArray;
}

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
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _searchController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
        
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"添加"];
    
    //初始化表示图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + 40, kScreenWidth, kScreenHeight - 64 - 44 - 40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
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
    XLQueryModel *queryModel = [[XLQueryModel alloc] initWithKeyWord:@"" sortField:sortFieldText isAsc:@(isAsc) pageIndex:@(self.pageIndex) pageSize:CommonPageSize];
    [self requestWlanDataWithQueryModel:queryModel isHeader:YES];
}
#pragma mark - 上拉加载数据
- (void)footerRefreshAction{
    self.pageIndex++;
    NSString *sortFieldText = self.sortFieldText == nil ? @"" : self.sortFieldText;
    BOOL isAsc = self.isAsc == YES ? true : false;
    XLQueryModel *queryModel = [[XLQueryModel alloc] initWithKeyWord:@"" sortField:sortFieldText isAsc:@(isAsc) pageIndex:@(self.pageIndex) pageSize:CommonPageSize];
    [self requestWlanDataWithQueryModel:queryModel isHeader:NO];
}

- (void)requestWlanDataWithQueryModel:(XLQueryModel *)queryModel isHeader:(BOOL)isHeader{
    
    if (isHeader) {
        [self.patientCellModeArray removeAllObjects];
    }
    [DoctorGroupTool getGroupPatientsWithDoctorId:[AccountManager currentUserid] groupId:self.group.ckeyid queryModel:queryModel success:^(NSArray *result) {
        //将数据添加到数组中
        [self.patientCellModeArray addObjectsFromArray:result];
        
        if (self.patientCellModeArray.count < 50) {
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
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

- (void)reloadTableView{
    [_tableView reloadData];
}

- (void)onRightButtonAction:(id)sender{
    int index = 0;
    NSMutableArray *selectMemberArr = [NSMutableArray array];
    for (GroupMemberModel *model in self.patientCellModeArray) {
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
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"添加失败"];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
    
    if (index == 0) {
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
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, 320, 40)];
    bgView.backgroundColor = MyColor(238, 238, 238);
    
    UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nameButton setTitle:@"姓名" forState:UIControlStateNormal];
    [nameButton setFrame:CGRectMake(10, 0, 40, 40)];
    [nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nameButton addTarget:self action:@selector(nameButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nameButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:nameButton];
    
    
    UIButton *statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [statusButton setTitle:@"状态" forState:UIControlStateNormal];
    [statusButton setFrame:CGRectMake(80, 0, 40, 40)];
    [statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    statusButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [statusButton addTarget:self action:@selector(statusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:statusButton];
    
    UIButton *introducerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [introducerButton setTitle:@"介绍人" forState:UIControlStateNormal];
    [introducerButton setFrame:CGRectMake(150, 0, 60, 40)];
    [introducerButton addTarget:self action:@selector(introducerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [introducerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    introducerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:introducerButton];
    
    UIButton *numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [numberButton setTitle:@"数量" forState:UIControlStateNormal];
    [numberButton setFrame:CGRectMake(230, 0, 40, 40)];
    [numberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [numberButton addTarget:self action:@selector(numberButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    numberButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:numberButton];
    
    UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseButton.frame = CGRectMake(275, 0, 40, 40);
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
    GroupMemberModel *cellMode = sourceArray[indexPath.row];
    Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:cellMode.ckeyid];
    if (patient != nil) {
        //跳转到患者详细信息页面
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        EditPatientDetailViewController *editDetail = [storyboard instantiateViewControllerWithIdentifier:@"EditPatientDetailViewController"];
        editDetail.patient = patient;
        editDetail.isGroup = YES;
        [self.navigationController pushViewController:editDetail animated:YES];
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

#pragma mark - UISearchBar Delegates
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isNotEmpty]) {
        XLQueryModel *queryModel = [[XLQueryModel alloc] initWithKeyWord:searchText sortField:@"" isAsc:@(true) pageIndex:@(1) pageSize:@(1000)];
        [DoctorGroupTool getGroupPatientsWithDoctorId:[AccountManager currentUserid] groupId:self.group.ckeyid queryModel:queryModel success:^(NSArray *result) {
            
            [self.searchController.resultsSource removeAllObjects];
            [self.searchController.resultsSource addObjectsFromArray:result];
            [self.searchController.searchResultsTableView reloadData];
            
        } failure:^(NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
        
        
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


#pragma mark - GroupPatientCellDelegate
- (void)didChooseCell:(GroupPatientCell *)cell withChooseStatus:(BOOL)status{
    
    //获取当前对应的数据模型
    if (self.isSearchDisplayController) {
        NSIndexPath *indexPath = [self.searchResultTableView indexPathForCell:cell];
        GroupMemberModel *model = self.searchController.resultsSource[indexPath.row];
        model.isChoose = status;
        
        for (GroupMemberModel *temp in self.patientCellModeArray) {
            if ([model.ckeyid isEqualToString:temp.ckeyid]) {
                temp.isChoose = model.isChoose;
            }
        }
    }else{
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        GroupMemberModel *model = self.patientCellModeArray[indexPath.row];
        model.isChoose = status;
    }
    
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
