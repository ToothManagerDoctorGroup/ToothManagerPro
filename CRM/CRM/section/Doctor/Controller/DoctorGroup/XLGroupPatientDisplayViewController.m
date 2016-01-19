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


@end

@implementation XLGroupPatientDisplayViewController

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
    
    //初始化
    [self setupView];
    //请求数据
    [self requestData];
}


- (void)setupView {
    self.title = @"选择患者";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"添加"];
    
    //初始化表示图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, self.view.height - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    //初始化搜索框
    [self.view addSubview:self.searchBar];
    [self searchController];
    
    _patientCellModeArray = [NSMutableArray arrayWithCapacity:0];
    
    
}

- (void)requestData {
    [SVProgressHUD showWithStatus:@"正在加载..."];
    __weak typeof(self) weakSelf = self;
    [DoctorGroupTool getGroupPatientsWithDoctorId:[AccountManager currentUserid] success:^(NSArray *result) {
        _patientCellModeArray = [NSMutableArray arrayWithArray:result];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (weakSelf.GroupMembers.count > 0) {
                for (GroupMemberModel *member in weakSelf.GroupMembers) {
                    for (GroupMemberModel *patient in _patientCellModeArray) {
                        if ([member.ckeyid isEqualToString:patient.ckeyid]) {
                            patient.isMember = YES;
                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [weakSelf reloadTableView];
            });
        });
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
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

//增加的表头
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
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
    [chooseButton addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
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
- (void)chooseAction:(UIButton *)button{
    if (self.isChooseAll) {
        self.isChooseAll = NO;
    }else{
        self.isChooseAll = YES;
    }
    
    for (GroupMemberModel *model in self.patientCellModeArray) {
        if (!model.isMember) {
            model.isChoose = self.isChooseAll;
        }
    }
    [_tableView reloadData];
    
}

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
    self.isChooseAll = index == (self.patientCellModeArray.count - self.GroupMembers.count);
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
