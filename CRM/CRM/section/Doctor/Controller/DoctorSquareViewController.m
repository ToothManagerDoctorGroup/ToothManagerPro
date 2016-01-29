//
//  DoctorSquareViewController.m
//  CRM
//
//  Created by fankejun on 14-9-25.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "DoctorSquareViewController.h"
#import "DoctorTableViewCell.h"
#import "DoctorManager.h"
#import "CRMHttpRequest+Doctor.h"
#import "SVProgressHUD.h"
#import "NSDictionary+Extension.h"
#import "UserInfoViewController.h"
#import "IntroducerManager.h"
#import "CRMHttpRequest+Introducer.h"
#import "DBManager+Doctor.h"
#import "UISearchBar+XLMoveBgView.h"

@interface DoctorSquareViewController () <CRMHttpRequestDoctorDelegate,UISearchBarDelegate,DoctorTableViewCellDelegate>
@property (nonatomic,retain) NSArray *scellModeArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,retain) NSMutableArray *searchHistoryArray;
@end

@implementation DoctorSquareViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.searchBar moveBackgroundView];
    self.searchBar.placeholder = @"搜索真实姓名";
}

- (void)initView {
    [super initView];
    self.title = @"添加好友";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
}

- (void)initData {
    [super initData];
    self.searchHistoryArray = [NSMutableArray arrayWithCapacity:0];
    self.scellModeArray = @[];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated. 
}

#pragma mark - Private API
- (void)addSearchHistory:(NSArray *)array {
    [self.searchHistoryArray addObjectsFromArray:array];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isSearchResultsTableView:tableView]) {
        return self.scellModeArray.count;
    }
    return self.searchHistoryArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorTableViewCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DoctorTableViewCell" owner:nil options:nil] objectAtIndex:0];
        [tableView registerNib:[UINib nibWithNibName:@"DoctorTableViewCell" bundle:nil] forCellReuseIdentifier:@"DoctorTableViewCell"];
    }
    
    cell.delegate = self;
    cell.tag = indexPath.row+100;
    Doctor *doctor = nil;
    if ([self isSearchResultsTableView:tableView]) {
        doctor = [self.scellModeArray objectAtIndex:indexPath.row];
    } else {
        doctor = [self.searchHistoryArray objectAtIndex:indexPath.row];
    }
    [cell setCellWithSquareMode:doctor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    Doctor *doctor = nil;
//    if ([self isSearchResultsTableView:tableView]) {
//        doctor = [self.scellModeArray objectAtIndex:indexPath.row];
//    } else {
//        doctor = [self.searchHistoryArray objectAtIndex:indexPath.row];
//    }
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
//    UserInfoViewController *userInfoVC = [storyBoard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
//    userInfoVC.doctor = doctor;
//    [self pushViewController:userInfoVC animated:YES];
}

#pragma mark - SearchDisplay delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.scellModeArray = @[];
    [self.searchDisplayController.searchResultsTableView reloadData];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [[DoctorManager shareInstance] searchDoctorWithName:searchBar.text successBlock:^{
        [SVProgressHUD showWithStatus:@"搜索中..."];
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}

#pragma Doctor request Delegate
- (void)searchDoctorWithNameFailedWithError:(NSError *)error {
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}

- (void)searchDoctorWithNameSuccessWithResult:(NSDictionary *)result {
    [SVProgressHUD dismiss];
    if ([result integerForKey:@"Code"] == 200) {
        self.scellModeArray  = [[DoctorManager shareInstance] arrayWithDoctorResult:[result objectForKey:@"Result"]];
        [self.searchDisplayController.searchResultsTableView reloadData];
        [self.tableView reloadData];
    } else {
        [SVProgressHUD showImage:nil status:@"查询失败"];
    }
}

#pragma mark - Cell Delegate
- (void)addButtonDidSelected:(id)sender {
    DoctorTableViewCell *cell = (DoctorTableViewCell *)sender;
    Doctor *doctor = nil;
    if ([self.searchDisplayController isActive]) {
        doctor = [self.scellModeArray objectAtIndex:cell.tag-100];
    } else {
        doctor = [self.searchHistoryArray objectAtIndex:cell.tag-100];
    }
    if ([doctor.ckeyid isEqualToString:[AccountManager currentUserid]]) {
        [SVProgressHUD showImage:nil status:@"不能添加自己为好友"];
        return;
    }
    
    [[IntroducerManager shareInstance] applyToBecomeIntroducerWithDoctorId:doctor.ckeyid successBlock:^{
        [SVProgressHUD showImage:nil status:@"请求中..."];
        [cell.addButton setTitle:@"正在验证" forState:UIControlStateNormal];
        [cell.addButton setBackgroundColor:[UIColor lightGrayColor]];
        cell.addButton.enabled = NO;
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}

#pragma mark -
- (void)applyToBecomeIntroducerSuccess:(NSDictionary *)result {
    NSString *message = [result objectForKey:@"Result"];
    [SVProgressHUD showImage:nil status:message];
}

- (void)applyToBecomeIntroducerFailed:(NSError *)error {
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}


@end
