//
//  GroupManageViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/9.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "GroupManageViewController.h"
#import "ChineseSearchEngine.h"
#import "CRMMacro.h"
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
#import "GroupPatientCell.h"
#import "MLKMenuPopover.h"
#import "CustomAlertView.h"
#import "DoctorGroupTool.h"
#import "GroupIntroducerModel.h"
#import "GroupPatientDisplayController.h"
#import "DoctorGroupModel.h"
#import "GroupMemberModel.h"
#import "DBTableMode.h"
#import "UISearchBar+XLMoveBgView.h"
#import "XLGroupPatientDisplayViewController.h"

@interface GroupManageViewController ()<MLKMenuPopoverDelegate,CustomAlertViewDelegate,UIAlertViewDelegate>{
    BOOL ifNameBtnSelected;
    BOOL ifStatusBtnSelected;
    BOOL ifNumberBtnSelected;
    BOOL ifIntroducerSelected;
}

@property (nonatomic,strong) NSMutableArray *patientCellModeArray;
@property (nonatomic,strong) NSMutableArray *searchResults;
@property (nonatomic, strong)NSMutableArray *totalPatients;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

/**
 *  菜单选项
 */
@property (nonatomic, strong)NSArray *menuList;
/**
 *  菜单弹出视图
 */
@property (nonatomic, strong)MLKMenuPopover *menuPopover;

/**
 *  当前选中的组员
 */
@property (nonatomic, strong)GroupMemberModel *selectModel;

@end

@implementation GroupManageViewController

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
        _menuList = [NSArray arrayWithObjects:@"添加成员",@"移除成员",@"编辑组名",@"删除分组", nil];
    }
    return _menuList;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [SVProgressHUD dismiss];
    NSLog(@"我被销毁了");
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
    [self setRightBarButtonWithTitle:@"管理"];
    [self.searchDisplayController.searchBar setPlaceholder:@"搜索"];
    
    self.title = self.group.group_name;
    
    [self.searchBar moveBackgroundView];
    
    
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
    //获取当前分组下的所有成员数据
    [SVProgressHUD showWithStatus:@"正在加载"];
    [DoctorGroupTool queryGroupMembersWithCkId:self.group.ckeyid success:^(NSArray *result) {
        [SVProgressHUD dismiss];
        
        _patientCellModeArray = [NSMutableArray arrayWithArray:result];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
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

//增加的表头
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isSearchResultsTableView:tableView]) {
        return self.searchResults.count;
    }
    return self.patientCellModeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GroupPatientCell *cell = [GroupPatientCell cellWithTableView:tableView];
    cell.isManage = YES;
    //赋值,获取患者信息
    NSInteger row = [indexPath row];
    GroupMemberModel *cellMode;
    if ([self isSearchResultsTableView:tableView]) {
        cellMode = [self.searchResults objectAtIndex:row];
    } else {
        cellMode = [self.patientCellModeArray objectAtIndex:row];
    }
    
    cell.model = cellMode;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //获取当前对应的数据模型
    GroupMemberModel *model = self.patientCellModeArray[indexPath.row];
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
        [SVProgressHUD showErrorWithStatus:@"需要同步数据"];
    }
}

//当cell向左滑动时会出现删除或者添加按钮，只要实现了下面的方法，此按钮自动添加
//当点击添加或者删除按钮时，调用下面的方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupMemberModel *model = self.patientCellModeArray[indexPath.row];
    self.selectModel = model;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"移除患者" message:@"移除患者并不会删除患者信息，确认移除患者？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"移除", nil];
        alertView.tag = 130;
        [alertView show];
    }
}
//返回当前cell上的自带按钮是添加按钮还是删除按钮
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewCellEditingStyleDelete;
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
    
    return bgView;
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
            GroupMemberModel *object1 = (GroupMemberModel *)obj1;
            GroupMemberModel *object2 = (GroupMemberModel *)obj2;
            result = [object1.patient_name localizedCompare:object2.patient_name];
            return result == NSOrderedDescending;
        }];
        self.patientCellModeArray = [NSMutableArray arrayWithArray:lastArray];
        [self.tableView reloadData];
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
        [self.tableView reloadData];
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
        [self.tableView reloadData];
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
        [self.tableView reloadData];
        
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
        [self.tableView reloadData];
        
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
        [self.tableView reloadData];
    }
}



#pragma makr - UISearchBar Delegates
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    if ([searchString isNotEmpty]) {
        self.searchResults = [NSMutableArray arrayWithArray:[ChineseSearchEngine resultArraySearchGroupPatientsOnArray:self.patientCellModeArray withSearchText:searchString]];
    }
    return YES;
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
            //移除成员
            [self.tableView setEditing:!self.tableView.isEditing animated:YES];
            break;
        case 2:
            //编辑组名
            [self editGroupName];
            break;
        case 3:
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
    if ([content isEqualToString:self.group.group_name]) {
        [SVProgressHUD showErrorWithStatus:@"分组名称不能相同"];
        return;
    }
    //编辑组名
    GroupEntity *entity = [[GroupEntity alloc] initWithName:content originGroup:self.group];
    [DoctorGroupTool updateGroupWithGroupEntity:entity success:^(CRMHttpRespondModel *respondModel) {
        if ([respondModel.code integerValue] == 200) {
            //修改当前的组名
            self.title = content;
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:DoctorUpdateGroupNameSuccessNotification object:nil];
        }
        
    } failure:^(NSError *error) {
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
            [SVProgressHUD showErrorWithStatus:@"删除失败"];
        }];
    }else{
        if (buttonIndex == 0) return;
        //删除组员
        [SVProgressHUD showWithStatus:@"正在删除"];
        [DoctorGroupTool deleteGroupMemberWithCkId:self.selectModel.ckeyid success:^(CRMHttpRespondModel *respondModel) {
            if ([respondModel.code integerValue] == 200) {
                //重新请求数据
                [self requestGroupMemberData];
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
    }
}

@end
