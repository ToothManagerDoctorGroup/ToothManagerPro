//
//  XLDoctorSqureViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/4/25.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLDoctorSqureViewController.h"
#import "EMSearchDisplayController.h"
#import "EMSearchBar.h"
#import "UISearchBar+XLMoveBgView.h"
#import "XLCommonDoctorCell.h"
#import "DoctorManager.h"
#import "NSDictionary+Extension.h"
#import "AccountManager.h"
#import "IntroducerManager.h"
#import "UITableView+NoResultAlert.h"
#import "Share.h"
#import "ShareMode.h"
#import "DoctorTool.h"

static const NSInteger kDoctorSqureViewControllerMenuHeight = 44;

@interface XLDoctorSqureViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,XLCommonDoctorCellDelegte,UIActionSheetDelegate>{
    UITableView *_tableView;//表视图
}
@property (nonatomic, strong) NSArray *scellModeArray;
@property (nonatomic, strong) NSMutableArray *searchHistoryArray;

@property (nonatomic, strong)EMSearchBar *searchBar;
@property (nonatomic, strong)EMSearchDisplayController *searchController;

@end

@implementation XLDoctorSqureViewController

#pragma mark - ********************* Life Method ***********************
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化子视图
    [self setUpSubViews];
}

#pragma mark -初始化子视图
- (void)setUpSubViews{
    self.title = @"添加好友";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
    //初始化表示图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kDoctorSqureViewControllerMenuHeight, kScreenWidth, self.view.size.height - kDoctorSqureViewControllerMenuHeight) style:UITableViewStylePlain];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self.view addSubview:_tableView];
    
    //初始化搜索框
    [self.view addSubview:self.searchBar];
    [self searchController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ********************* Private Method *********************
#pragma mark 设置单元格
- (UITableViewCell *)setUpTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sourceArray:(NSArray *)sourceArray{
    
    XLCommonDoctorCell *cell = [XLCommonDoctorCell cellWithTableView:tableView];
    cell.tag = indexPath.row + 100;
    cell.delegate = self;
    Doctor *doctor = [sourceArray objectAtIndex:indexPath.row];
    [cell setDoctorSquareCellWithModel:doctor];
    
    return cell;
}


#pragma mark - ******************** 控件初始化(懒加载) *********************
- (NSMutableArray *)searchHistoryArray{
    if (!_searchHistoryArray) {
        _searchHistoryArray = [NSMutableArray array];
    }
    return _searchHistoryArray;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, kDoctorSqureViewControllerMenuHeight)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索真实姓名";
        [_searchBar moveBackgroundView];
    }
    
    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        WS(weakSelf);
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _searchController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
        _searchController.hideSystomNoResult = YES;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            return [weakSelf setUpTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:weakSelf.searchController.resultsSource];
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [XLCommonDoctorCell fixHeight];
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
        }];
    }
    return _searchController;
}
#pragma mark - ********************* Delegate/DataSource ******************
#pragma mark -XLCommonDoctorCellDelegte
- (void)commonDoctorCell:(XLCommonDoctorCell *)cell addButtonDidSelect:(id)sender{
    Doctor *doctor = [self.scellModeArray objectAtIndex:cell.tag-100];
    if ([doctor.ckeyid isEqualToString:[AccountManager currentUserid]]) {
        [SVProgressHUD showImage:nil status:@"不能添加自己为好友"];
        return;
    }
    
    [[IntroducerManager shareInstance] applyToBecomeIntroducerWithDoctorId:doctor.ckeyid successBlock:^{
        [SVProgressHUD showImage:nil status:@"请求中..."];
        cell.buttonEnable = NO;
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}

#pragma mark 刷新数据
- (void)refreshSeachControllerData{
    [self searchBarSearchButtonClicked:self.searchBar];
}

- (void)applyToBecomeIntroducerSuccess:(NSDictionary *)result {
    NSString *message = [result objectForKey:@"Result"];
    [SVProgressHUD showImage:nil status:message];
}

- (void)applyToBecomeIntroducerFailed:(NSError *)error {
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}

#pragma mark -UITableViewDataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self setUpTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:self.scellModeArray];
    
}

#pragma mark -UISearchBar Delegates
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    if ([searchBar.text isNotEmpty]) {
        WS(weakSelf);
        [DoctorTool searchDoctorWithDoctorName:searchBar.text success:^(NSArray *result) {
            weakSelf.scellModeArray = result;
            weakSelf.searchController.searchResultsTableView.tableHeaderView = nil;
            
            [weakSelf.searchController.resultsSource removeAllObjects];
            [weakSelf.searchController.resultsSource addObjectsFromArray:result];
            [weakSelf.searchDisplayController.searchResultsTableView reloadData];
            
            [weakSelf.searchController.searchResultsTableView createNoResultWithButtonWithImageName:@"noFriendSearch_alert" ifNecessaryForRowCount:result.count buttonTitle:@"邀请好友加入" target:self action:@selector(showShareActionChoose) forControlEvents:UIControlEventTouchUpInside];
            
        } failure:^(NSError *error) {
            [SVProgressHUD showImage:nil status:error.localizedDescription];
            [weakSelf.searchController.searchResultsTableView createNoResultWithImageName:@"no_net_alert" ifNecessaryForRowCount:self.scellModeArray.count target:self action:@selector(refreshSeachControllerData)];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText) {
        [self.searchController.resultsSource removeAllObjects];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - 分享
//分享选择
- (void)showShareActionChoose{
    UIActionSheet *sheetView = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"微信" otherButtonTitles:@"朋友圈", nil];
    [sheetView showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(![WXApi isWXAppInstalled]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先安装微信客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else{
        UserObject *userobj = [[AccountManager shareInstance] currentUser];
        ShareMode *mode = [[ShareMode alloc]init];
        mode.title = @"牙医新生活倡导者：年种植上千颗不是梦";
        mode.message = [NSString stringWithFormat:@"他，3张牙椅上千颗植体；他，拥有上万名高端用户；种牙管家，开启牙医新生活！"];
        mode.url = [NSString stringWithFormat:@"%@%@/view/InviteFriends.aspx?doctorId=%@",DomainRealName,Method_Weixin,userobj.userid];
        mode.image = [UIImage imageNamed:@"crm_logo"];
        
        
        if (buttonIndex == 0) {
            //微信
            [Share shareToPlatform:weixinFriend WithMode:mode];
        }else if(buttonIndex ==1){
            //朋友圈
            [Share shareToPlatform:weixin WithMode:mode];
        }
    }
}

@end
