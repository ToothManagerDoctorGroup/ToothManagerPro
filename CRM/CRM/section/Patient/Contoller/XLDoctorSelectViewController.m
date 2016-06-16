//
//  XLDoctorSelectViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/8.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLDoctorSelectViewController.h"
#import "UISearchBar+XLMoveBgView.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "DBTableMode.h"
#import "XLQueryModel.h"
#import "DoctorTool.h"
#import "AccountManager.h"
#import "MJRefresh.h"
#import "DBManager+Patients.h"
#import "DBManager+Doctor.h"
#import "XLDoctorSelectCell.h"
#import "XLTeamMemberParam.h"
#import "XLTeamTool.h"
#import "CRMHttpRespondModel.h"
#import "MJExtension.h"
#import "JSONKit.h"
#import "XLTeamMemberModel.h"

@interface XLDoctorSelectViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,XLDoctorSelectCellDelegate,UISearchDisplayDelegate>{
    UITableView *_tableView;
}

@property (nonatomic,retain) NSArray *modeArray;
@property (nonatomic,retain) NSMutableArray *searchHistoryArray;
@property (nonatomic,retain) Doctor *selectDoctor;

@property (nonatomic, strong)EMSearchBar *searchBar;
@property (nonatomic, strong)EMSearchDisplayController *searchController;

@property (nonatomic, strong)XLQueryModel *queryModel;//分页所需的模型

@property (nonatomic, assign)int pageIndex;

/**
 *  判断是否是UISearchDisplayController
 */
@property (nonatomic, assign)BOOL isSearchDisplayController;
/**
 *  保存UISearchDisplayController的tableView
 */
@property (nonatomic, weak)UITableView *searchResultTableView;

@end

@implementation XLDoctorSelectViewController
#pragma mark - 界面销毁
- (NSMutableArray *)searchHistoryArray{
    if (!_searchHistoryArray) {
        _searchHistoryArray = [NSMutableArray array];
    }
    return _searchHistoryArray;
}

- (void)dealloc{
    self.searchBar = nil;
    self.searchController = nil;
    _tableView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
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
        _searchController.delegate = self;
        
        __weak XLDoctorSelectViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            return [weakSelf setUpTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:weakSelf.searchController.resultsSource];
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 60;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
            [weakSelf selectTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:weakSelf.searchController.resultsSource];
        }];
    }
    return _searchController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageIndex = 1;
    //加载数据
    [self initSubViews];
    
    if (self.type == DoctorSelectTypeAdd) {
        [_tableView.header beginRefreshing];
    }
}

- (void)initSubViews{
    
    self.title = @"医生好友";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"确定"];
    
    //初始化表示图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
    if (self.type == DoctorSelectTypeAdd) {
        //添加上拉刷新和下拉加载
        [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
        _tableView.header.updatedTimeHidden = YES;
        [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction)];
        _tableView.footer.hidden = YES;
    }else{
        [self requestLocalData];
    }
    //初始化搜索框
    [self.view addSubview:self.searchBar];
    [self searchController];
    
}
#pragma mark - 下拉刷新数据
- (void)headerRefreshAction{
    self.pageIndex = 1;
    XLQueryModel *queryModel = [[XLQueryModel alloc] initWithKeyWord:@"" sortField:@"" isAsc:@(YES) pageIndex:@(self.pageIndex) pageSize:@(CommonPageSize)];
    [self requestWlanDataWithQueryModel:queryModel isHeader:YES];
}
#pragma mark - 上拉加载数据
- (void)footerRefreshAction{
    self.pageIndex++;
    XLQueryModel *queryModel = [[XLQueryModel alloc] initWithKeyWord:@"" sortField:@"" isAsc:@(YES) pageIndex:@(self.pageIndex) pageSize:@(CommonPageSize)];
    [self requestWlanDataWithQueryModel:queryModel isHeader:NO];
}

#pragma mark - 请求网络数据
- (void)requestWlanDataWithQueryModel:(XLQueryModel *)queryModel isHeader:(BOOL)isHeader{
    //请求网络数据
    [DoctorTool getDoctorFriendListWithDoctorId:[AccountManager currentUserid] syncTime:@"" queryInfo:queryModel success:^(NSArray *array) {
        if (isHeader) {
            [self.searchHistoryArray removeAllObjects];
        }
        //将数据添加到数组中
        [self.searchHistoryArray addObjectsFromArray:array];
        
        //判断是否存在
        for (Doctor *doc in self.searchHistoryArray) {
            for (XLTeamMemberModel *model in self.existMembers) {
                if ([doc.ckeyid isEqualToString:[model.member_id stringValue]]) {
                    doc.isExist = YES;
                    break;
                }
            }
        }
        
        if (self.searchHistoryArray.count < 50) {
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
#pragma mark - 请求本地数据
- (void)requestLocalData{
    for (XLTeamMemberModel *member in self.existMembers) {
       Doctor *doctor = [[DBManager shareInstance] getDoctorWithCkeyId:[member.member_id stringValue]];
        if (doctor != nil) {
            [self.searchHistoryArray addObject:doctor];
        }
    }
    [_tableView reloadData];
}

#pragma mark - 排序
-(void)orderedByNumber{
    
    NSArray *lastArray = [self.searchHistoryArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Doctor *doctor1 = (Doctor *)obj1;
        Doctor *doctor2 = (Doctor *)obj2;
        NSInteger count1 = [[DBManager shareInstance] getAllPatientWithID:doctor1.ckeyid].count;
        NSInteger count2 = [[DBManager shareInstance] getAllPatientWithID:doctor2.ckeyid].count;
        if (count1 > count2){
            return NSOrderedDescending;
        }
        if(count1 < count2){
            return  NSOrderedAscending;
        }
        return NSOrderedSame;
        
    }];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    for(NSInteger i = lastArray.count;i>0;i--){
        [resultArray addObject:lastArray[i-1]];
    }
    [self.searchHistoryArray removeAllObjects];
    [self.searchHistoryArray addObjectsFromArray:resultArray];
}

- (void)onRightButtonAction:(id)sender{
    [self addGroupMemberWithArray:self.searchHistoryArray];
}

#pragma mark - 添加成员
- (void)addGroupMemberWithArray:(NSArray *)result{
    
    __weak typeof(self) weakSelf = self;
    int index=0;
    NSMutableArray *selectArray = [NSMutableArray array];
    
    if (self.type == DoctorSelectTypeAdd) {
        for (Doctor *doc in result) {
            if (doc.isSelect) {
                XLTeamMemberParam *param = [[XLTeamMemberParam alloc] initWithCaseId:self.mCase.ckeyid patientId:self.mCase.patient_id teamNickName:@"" memberId:@([doc.ckeyid integerValue]) nickName:@"" memberName:doc.doctor_name isConsociation:NO createUserId:@([[AccountManager currentUserid] integerValue])];
                [selectArray addObject:param.keyValues];
                index++;
            }

        }
        //添加成员
        [SVProgressHUD showWithStatus:@"正在添加"];
        [XLTeamTool addTeamMemberWithArray:selectArray success:^(CRMHttpRespondModel *respond) {
            if ([respond.code integerValue] == 200) {
                [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                //发送通知
                [weakSelf postNotificationName:TeamMemberAddSuccessNotification object:self.mCase.ckeyid];
                //退出当前控制器
                [weakSelf popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"添加失败"];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showSuccessWithStatus:@"添加失败"];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }else{
        NSMutableArray *existDoc = [NSMutableArray array];
        for (Doctor *doc in result) {
            if (doc.isSelect) {
                [existDoc addObject:doc];
            }
        }
        NSMutableString *ids = [NSMutableString string];
        for (XLTeamMemberModel *model in self.existMembers) {
            for (Doctor *doc in existDoc) {
                if ([doc.ckeyid isEqualToString:[model.member_id stringValue]]) {
                    [ids appendFormat:@",%@",[model.keyId stringValue]];
                    break;
                }
            }
        }
        NSString *newStr = [ids substringFromIndex:1];
        
        [SVProgressHUD showSuccessWithStatus:@"正在移除"];
        [XLTeamTool removeTeamMemberWithIds:newStr success:^(CRMHttpRespondModel *respond) {
            if ([respond.code integerValue] == 200) {
                [SVProgressHUD showSuccessWithStatus:@"移除成功"];
                //发送通知
                [weakSelf postNotificationName:TeamMemberDeleteSuccessNotification object:self.mCase.ckeyid];
                //退出当前控制器
                [weakSelf popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"移除失败"];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showSuccessWithStatus:@"移除失败"];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
    
}

#pragma mark - TableView Delegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchHistoryArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self setUpTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:self.searchHistoryArray];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:self.searchHistoryArray];
}

#pragma mark -设置单元格
- (UITableViewCell *)setUpTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sourceArray:(NSArray *)sourceArray{
    
    XLDoctorSelectCell *cell = [XLDoctorSelectCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.type = self.type;
    cell.doctor = sourceArray[indexPath.row];
    
    return cell;
}

#pragma mark -设置单元格点击事件
- (void)selectTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sourceArray:(NSArray *)sourceArray{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - XLDoctorSelectCell
- (void)doctorSelectCell:(XLDoctorSelectCell *)cell withChooseStatus:(BOOL)status{
    if (self.isSearchDisplayController) {
        NSIndexPath *indexPath = [self.searchResultTableView indexPathForCell:cell];
        Doctor *doctor = self.searchController.resultsSource[indexPath.row];
        doctor.isSelect = status;
        
        BOOL isChoose = false;
        for (Doctor *doctor in self.searchController.resultsSource) {
            if (doctor.isSelect) {
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
        Doctor *doctor = self.searchHistoryArray[indexPath.row];
        doctor.isSelect = status;
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
 
    WS(weakSelf);
    if ([searchText isNotEmpty]) {
        if (self.type == DoctorSelectTypeAdd) {
            //请求网络数据
            XLQueryModel *queryModel = [[XLQueryModel alloc] initWithKeyWord:searchText sortField:@"" isAsc:@(YES) pageIndex:@(1) pageSize:@(1000)];
            [DoctorTool getDoctorFriendListWithDoctorId:[AccountManager currentUserid] syncTime:@"" queryInfo:queryModel success:^(NSArray *array) {
                
                //判断是否存在
                for (Doctor *doc in array) {
                    for (XLTeamMemberModel *model in weakSelf.existMembers) {
                        if ([doc.ckeyid isEqualToString:[model.member_id stringValue]]) {
                            doc.isExist = YES;
                            break;
                        }
                    }
                }
                
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:array];
                [weakSelf.searchController.searchResultsTableView reloadData];
            } failure:^(NSError *error) {
                if (error) {
                    NSLog(@"error:%@",error);
                }
            }];
        }else{
            //查询本地数组
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doctor_name CONTAINS %@", searchText]; //predicate只能是对象
            NSArray *filteredArray = [self.searchHistoryArray filteredArrayUsingPredicate:predicate];
            
            [self.searchController.resultsSource removeAllObjects];
            [self.searchController.resultsSource addObjectsFromArray:filteredArray];
            [self.searchController.searchResultsTableView reloadData];
        }
    }else{
        NSString *title = [searchBar currentTitle];
        if ([title isEqualToString:@"完成"]) {
            [searchBar changeCancelButtonTitle:@"取消"];
        }
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
    //判断是完成还是取消
    NSString *title = [searchBar currentTitle];
    if ([title isEqualToString:@"完成"]) {
        //将选中的数据添加到分组中
        [self addGroupMemberWithArray:self.searchController.resultsSource];
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
