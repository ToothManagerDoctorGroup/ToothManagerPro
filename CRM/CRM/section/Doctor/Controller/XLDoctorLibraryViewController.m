//
//  XLDoctorLibraryViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/11.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLDoctorLibraryViewController.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "UISearchBar+XLMoveBgView.h"
#import "AccountManager.h"
#import "DoctorTool.h"
#import "DBManager+Doctor.h"
#import "DBManager+Patients.h"
#import "DoctorSquareViewController.h"
#import "DoctorTableViewCell.h"
#import "DoctorInfoViewController.h"
#import "NewFriendsViewController.h"
#import "NSDictionary+Extension.h"
#import "DBManager+AutoSync.h"
#import "MJExtension.h"
#import "JSONKit.h"
#import "CacheFactory.h"
#import "IntroducerManager.h"
#import "ChatViewController.h"

@interface XLDoctorLibraryViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDelegate,UITableViewDataSource,DoctorTableViewCellDelegate,UIAlertViewDelegate>{
    UITableView *_tableView;
}

@property (nonatomic,retain) NSArray *modeArray;
@property (nonatomic,retain) NSArray *searchHistoryArray;
@property (nonatomic,retain) Doctor *selectDoctor;

@property (nonatomic, strong)Doctor *deleteDoctor;//当前要删除的医生好友

@property (nonatomic, weak)UILabel *messageCountLabel;//新的信息数

@property (nonatomic, strong)EMSearchBar *searchBar;
@property (nonatomic, strong)EMSearchDisplayController *searchController;

@end

@implementation XLDoctorLibraryViewController
@synthesize isTransfer;
@synthesize userId;
@synthesize patientId;

#pragma mark - 界面销毁
- (void)dealloc{
    self.searchBar = nil;
    self.searchController = nil;
    _tableView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
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
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _searchController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
        
        __weak XLDoctorLibraryViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            return [weakSelf setUpTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:weakSelf.searchController.resultsSource];
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 68.f;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
            [weakSelf selectTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:weakSelf.searchController.resultsSource];
        }];
        //设置可编辑模式
        [_searchController setCanEditRowAtIndexPath:^BOOL(UITableView *tableView, NSIndexPath *indexPath) {
            return YES;
        }];
        //编辑模式下的删除操作
        [_searchController setCommitEditingStyleAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            Doctor *doctor = weakSelf.searchController.resultsSource[indexPath.row];
            TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"确认删除该好友？" message:nil cancelHandler:^{
            } comfirmButtonHandlder:^{
                [SVProgressHUD showWithStatus:@"删除中..."];
                [DoctorTool deleteFriendWithDoctorId:doctor.ckeyid introId:[[AccountManager shareInstance] currentUser].userid success:^(CRMHttpRespondModel *result) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                    BOOL res = [[DBManager shareInstance] deleteDoctorWithUserObject:doctor];
                    if (res) {
                        //删除成功
                        [weakSelf.searchController.resultsSource removeObject:doctor];
                        [tableView reloadData];
                        [weakSelf requestWlanData];
                    }else{
                        [SVProgressHUD showErrorWithStatus:@"删除失败"];
                    }
                    
                } failure:^(NSError *error) {
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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.isTherapyDoctor) {
        [[AccountManager shareInstance] getFriendsNotificationListWithUserid:[AccountManager currentUserid] successBlock:^{
        } failedBlock:^(NSError *error) {
            [SVProgressHUD showImage:nil status:error.localizedDescription];
        }];
    }
}

- (void)initView {
    [super initView];
    self.title = @"医生好友";
    self.view.backgroundColor = MyColor(238, 238, 238);
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_new"]];
    
    //初始化表示图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, self.view.height - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    //初始化搜索框
    [self.view addSubview:self.searchBar];
    [self searchController];
}

- (void)initData {
    
    if (self.searchHistoryArray == nil) {
        self.searchHistoryArray = @[];
    }
    [self requestWlanData];
}

#pragma mark - 请求网络数据
- (void)requestWlanData{
    //请求网络数据
    [SVProgressHUD showWithStatus:@"正在加载"];
    [DoctorTool getDoctorFriendListWithDoctorId:[AccountManager currentUserid] success:^(NSArray *array) {
        
        self.searchHistoryArray = array;
        //排序
        [self orderedByNumber];
        
        [SVProgressHUD dismiss];
        [_tableView reloadData];
        //获取数据库中所有的医生信息
        NSArray *dbDoctors = [[DBManager shareInstance] getAllDoctor];
        NSMutableArray *missDoctors = [NSMutableArray array];
        for (Doctor *inDoctor in array) {
            BOOL isExists = NO;
            for (Doctor *doctor in dbDoctors) {
                if ([inDoctor.ckeyid isEqualToString:doctor.ckeyid]) {
                    isExists = YES;
                }
            }
            if (!isExists) {
                [missDoctors addObject:inDoctor];
            }
        }
        //将所有本地不存在的医生存入本地数据库
        if (missDoctors.count > 0) {
            for (Doctor *doc in missDoctors) {
                if([[DBManager shareInstance] insertDoctorWithDoctor:doc]){
                    [_tableView reloadData];
                }
            }
        }
        
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}
#pragma mark - 排序
-(void)orderedByNumber{
    NSArray *lastArray = [NSArray arrayWithArray:self.searchHistoryArray];
    lastArray = [self.searchHistoryArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
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
    self.searchHistoryArray = [NSArray arrayWithArray:resultArray];
}
#pragma mark - 医生广场入口
- (void)onRightButtonAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DoctorStoryboard" bundle:nil];
    DoctorSquareViewController *doctorVC = [storyboard instantiateViewControllerWithIdentifier:@"DoctorSquareViewController"];
    [self pushViewController:doctorVC animated:YES];
}

#pragma mark - TableView Delegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchHistoryArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newFriendAction:)];
    [headerView addGestureRecognizer:tap];
    
    headerView.backgroundColor = [UIColor whiteColor];
    
    NSString *title = @"新的好友";
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:15]];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, titleSize.width, 44)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:titleLabel];
    
    UILabel *messageCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right + 2, 5, 16, 16)];
    messageCountLabel.hidden = YES;
    messageCountLabel.layer.cornerRadius = 8;
    messageCountLabel.layer.masksToBounds = YES;
    messageCountLabel.textColor = [UIColor whiteColor];
    messageCountLabel.backgroundColor = [UIColor redColor];
    messageCountLabel.font = [UIFont systemFontOfSize:10];
    messageCountLabel.textAlignment = NSTextAlignmentCenter;
    self.messageCountLabel = messageCountLabel;
    [headerView addSubview:messageCountLabel];
    
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 43, kScreenWidth, 1)];
    divider.backgroundColor = MyColor(243, 243, 243);
    [headerView addSubview:divider];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_crm"]];
    arrowView.frame = CGRectMake(kScreenWidth - 13 - 10, (44 - 18) / 2, 13, 18);
    [headerView addSubview:arrowView];
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self setUpTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:self.searchHistoryArray];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectTableViewCellWithTableView:tableView indexPath:indexPath sourceArray:self.searchHistoryArray];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isTherapyDoctor) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Doctor *doctor = self.searchHistoryArray[indexPath.row];
    self.deleteDoctor = doctor;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除该好友吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 111;
        [alertView show];
    }
}
#pragma mark -设置单元格
- (UITableViewCell *)setUpTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sourceArray:(NSArray *)sourceArray{
    DoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorTableViewCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DoctorTableViewCell" owner:nil options:nil] objectAtIndex:0];
        [tableView registerNib:[UINib nibWithNibName:@"DoctorTableViewCell" bundle:nil] forCellReuseIdentifier:@"DoctorTableViewCell"];
    }
    cell.delegate = self;
    cell.addButton.backgroundColor = [UIColor clearColor];
    [cell.addButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cell.tag = indexPath.row+100;
    
    Doctor *doctor = [sourceArray objectAtIndex:indexPath.row];
    [cell setCellWithMode:doctor];
    NSInteger count = [[DBManager shareInstance] getAllPatientWithID:doctor.ckeyid].count;
    [cell.addButton setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:UIControlStateNormal];
    cell.addButton.enabled = NO;
    
    return cell;
}

#pragma mark -设置单元格点击事件
- (void)selectTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sourceArray:(NSArray *)sourceArray{
    Doctor *doctor = [sourceArray objectAtIndex:indexPath.row];
    //转诊病人
    if (isTransfer) {
        
        self.selectDoctor = doctor;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认转诊给此好友吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.tag = 110;
        [alertView show];
        
    } else if (self.selectDoctor == nil) {
        if (self.isTherapyDoctor) {
            //选择修复医生
            if (self.delegate && [self.delegate respondsToSelector:@selector(doctorLibraryVc:didSelectDoctor:)]) {
                [self.delegate doctorLibraryVc:self didSelectDoctor:doctor];
            }
            [self popViewControllerAnimated:YES];
            
        }else{
//            EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:doctor.doctor_id conversationType:eConversationTypeChat];
//            ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.chatter conversationType:conversation.conversationType];
//            chatController.title = doctor.doctor_name;
//            chatController.hidesBottomBarWhenPushed = YES;
//            [self pushViewController:chatController animated:YES];
            DoctorInfoViewController *doctorinfoVC = [[DoctorInfoViewController alloc]init];
            doctorinfoVC.repairDoctorID = doctor.ckeyid;
            doctorinfoVC.ifDoctorInfo = YES;
            [self pushViewController:doctorinfoVC animated:YES];
        }
    }
}

#pragma mark - newFriendAction
- (void)newFriendAction:(UITapGestureRecognizer *)tap{
    NewFriendsViewController *newFriendVc = [[NewFriendsViewController alloc] initWithStyle:UITableViewStylePlain];
    newFriendVc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:newFriendVc animated:YES];
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 110) {
        if (buttonIndex == 0) return;
        if (buttonIndex == 1) {
            [[DoctorManager shareInstance] trasferPatient:patientId fromDoctor:[AccountManager shareInstance].currentUser.userid toReceiver:self.selectDoctor.doctor_id successBlock:^{
                [SVProgressHUD showWithStatus:@"正在转诊患者..."];
            } failedBlock:^(NSError *error){
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
        }
    }else{
        if (buttonIndex == 0) return;
        if (buttonIndex == 1) {
            [SVProgressHUD showWithStatus:@"删除中..."];
            [DoctorTool deleteFriendWithDoctorId:self.deleteDoctor.ckeyid introId:[[AccountManager shareInstance] currentUser].userid success:^(CRMHttpRespondModel *result) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                BOOL res = [[DBManager shareInstance] deleteDoctorWithUserObject:self.deleteDoctor];
                if (res) {
                    //删除成功
                    [self.searchController.resultsSource removeObject:self.deleteDoctor];

                    
                    [self requestWlanData];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"删除失败"];
                }
                
            } failure:^(NSError *error) {
                if (error) {
                    NSLog(@"error:%@",error);
                }
            }];
        }
    }
}
#pragma mark - 转诊成功回调
- (void)transferPatientSuccessWithResult:(NSDictionary *)result
{
    if ([result integerForKey:@"Code"] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"转诊患者成功"];
        Patient *tmppatient = [[DBManager shareInstance] getPatientWithPatientCkeyid:patientId];
        if (tmppatient != nil) {
            //添加患者自动同步信息
            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Patient postType:Update dataEntity:[tmppatient.keyValues JSONString] syncStatus:@"0"];
            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
            
            //插入患者介绍人
            [self insertPatientIntroducerMap];
            self.selectDoctor = nil;
            [self popViewControllerAnimated:YES];
        }
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"转诊患者失败"];
    }
}

- (void)insertPatientIntroducerMap{
    PatientIntroducerMap *map = [[PatientIntroducerMap alloc]init];
    map.intr_id = [AccountManager currentUserid];
    map.intr_source = @"I";
    map.patient_id = patientId;
    map.doctor_id = self.selectDoctor.doctor_id;
    map.intr_time = [NSString currentDateString];
    [[DBManager shareInstance] insertPatientIntroducerMap:map];
}

- (void)transferPatientFailedWithError:(NSError *)error
{
    self.selectDoctor = nil;
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}

#pragma mark - Cell Delegate
- (void)addButtonDidSelected:(id)sender {
    DoctorTableViewCell *cell = (DoctorTableViewCell *)sender;
    Doctor *doctor = nil;
    if ([self.searchDisplayController isActive]) {
        doctor = [self.modeArray objectAtIndex:cell.tag-100];
    } else {
        doctor = [self.searchHistoryArray objectAtIndex:cell.tag-100];
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

#pragma mark - 获取好友数据
- (void)getFriendsNotificationListSuccessWithResult:(NSDictionary *)result {
    NSArray *resultArray = [result objectForKey:@"Result"];
    NSString *path = [[CacheFactory sharedCacheFactory] saveToPathAsFileName:@"FriendNotification"];
    NSData *_data = [[NSData alloc] initWithContentsOfFile:path];
    //解档辅助类
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:_data];
    //解码并解档出model
    FriendNotification *friendNotifiObj = [unarchiver decodeObjectForKey:@"FriendNotification"];
    //关闭解档
    [unarchiver finishDecoding];
    
    if (resultArray.count > 0) {
        NSInteger index = resultArray.count - friendNotifiObj.result.count;
        if (index > 0) {
            self.messageCountLabel.hidden = NO;
            self.messageCountLabel.text = [NSString stringWithFormat:@"%ld",(long)index];
            
        }else{
            self.messageCountLabel.hidden = YES;
        }
    }
}

- (void)getFriendsNotificationListFailedWithError:(NSError *)error {
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
        searchResults = [ChineseSearchEngine resultArraySearchDoctorOnArray:self.searchHistoryArray withSearchText:searchBar.text];
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
