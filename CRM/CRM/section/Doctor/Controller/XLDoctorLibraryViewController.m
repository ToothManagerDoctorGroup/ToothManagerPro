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
#import "NewFriendsViewController.h"
#import "NSDictionary+Extension.h"
#import "DBManager+AutoSync.h"
#import "MJExtension.h"
#import "JSONKit.h"
#import "CacheFactory.h"
#import "IntroducerManager.h"
#import "ChatViewController.h"
#import "XLQueryModel.h"
#import "MJRefresh.h"
#import "CRMMacro.h"
#import "DoctorManager.h"
#import "MyDateTool.h"
#import "XLDoctorDetailViewController.h"
#import "XLNewFriendNotiViewController.h"
#import "XLCommonDoctorCell.h"
#import "DoctorInfoModel.h"
#import "CRMHttpRespondModel.h"
#import "XLCustomAlertView.h"
#import "SysMessageTool.h"
#import "DoctorInfoViewController.h"
#import "UITableView+NoResultAlert.h"
#import "XLDoctorSqureViewController.h"
#import "XLChatModel.h"
#import "UIColor+Extension.h"
#import "MyPatientTool.h"

@interface XLDoctorLibraryViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,DoctorTableViewCellDelegate,UIAlertViewDelegate,XLCommonDoctorCellDelegte>{
    UITableView *_tableView;
}

@property (nonatomic,retain) NSArray *modeArray;
@property (nonatomic,retain) NSMutableArray *searchHistoryArray;
@property (nonatomic,retain) Doctor *selectDoctor;

@property (nonatomic, strong)Doctor *deleteDoctor;//当前要删除的医生好友

@property (nonatomic, weak)UILabel *messageCountLabel;//新的信息数

@property (nonatomic, strong)EMSearchBar *searchBar;
@property (nonatomic, strong)EMSearchDisplayController *searchController;

@property (nonatomic, strong)XLQueryModel *queryModel;//分页所需的模型

@property (nonatomic, assign)int pageIndex;

@property (nonatomic, assign)BOOL isBind;//是否绑定微信

@end

@implementation XLDoctorLibraryViewController
@synthesize isTransfer;
@synthesize userId;
@synthesize patientId;

#pragma mark - ********************* Life Method ***********************
#pragma mark 界面销毁
- (void)dealloc{
    self.searchBar = nil;
    self.searchController = nil;
    _tableView = nil;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageIndex = 1;
    if (!self.isTherapyDoctor) {
        [[AccountManager shareInstance] getFriendsNotificationListWithUserid:[AccountManager currentUserid] successBlock:^{
        } failedBlock:^(NSError *error) {
            [SVProgressHUD showImage:nil status:error.localizedDescription];
        }];
        
    }
    //加载数据
    [self initSubViews];
}


#pragma mark - ********************* Private Method ***********************
- (void)initSubViews{

    NSLog(@"初始化视图");
    
    self.title = @"医生好友";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_add_doctor"]];
    
    //初始化表示图
    if (self.isTransfer) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 64 - 44) style:UITableViewStylePlain];
    }else{
        [self.view addSubview:[self setUpNewFriendView]];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + 44, kScreenWidth, kScreenHeight - 64 - 44 - 44) style:UITableViewStylePlain];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
    //添加上拉刷新和下拉加载
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
    _tableView.header.updatedTimeHidden = YES;
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction)];
    _tableView.footer.hidden = YES;
    
    //初始化搜索框
    [self.view addSubview:self.searchBar];
    [self searchController];
    [_tableView.header beginRefreshing];
}
#pragma mark 下拉刷新数据
- (void)headerRefreshAction{
    self.pageIndex = 1;
    XLQueryModel *queryModel = [[XLQueryModel alloc] initWithKeyWord:@"" sortField:@"" isAsc:@(YES) pageIndex:@(self.pageIndex) pageSize:@(CommonPageSize)];
    [self requestWlanDataWithQueryModel:queryModel isHeader:YES];
}
#pragma mark 上拉加载数据
- (void)footerRefreshAction{
    self.pageIndex++;
    XLQueryModel *queryModel = [[XLQueryModel alloc] initWithKeyWord:@"" sortField:@"" isAsc:@(YES) pageIndex:@(self.pageIndex) pageSize:@(CommonPageSize)];
    [self requestWlanDataWithQueryModel:queryModel isHeader:NO];
}

#pragma mark 请求网络数据
- (void)requestWlanDataWithQueryModel:(XLQueryModel *)queryModel isHeader:(BOOL)isHeader{
    //请求网络数据
    WS(weakSelf);
    [DoctorTool getDoctorFriendListWithDoctorId:[AccountManager currentUserid] syncTime:@"" queryInfo:queryModel success:^(NSArray *array) {
        NSLog(@"网络数据请求成功");
        _tableView.tableHeaderView = nil;
        if (isHeader) {
            [weakSelf.searchHistoryArray removeAllObjects];
            //判断是否是选择治疗医生的状态
            if (weakSelf.isTherapyDoctor) {
                UserObject *user = [AccountManager shareInstance].currentUser;
                Doctor *owner = [[Doctor alloc] init];
                owner.doctor_name = user.name;
                owner.doctor_degree = user.degree;
                owner.doctor_hospital = user.hospitalName;
                owner.doctor_position = user.title;
                owner.doctor_image = user.img;
                owner.ckeyid = user.userid;
            
                [weakSelf.searchHistoryArray addObject:owner];
            }
            //是否显示提示视图
            [_tableView createNoResultWithImageName:@"doctorFriend_alert.png" ifNecessaryForRowCount:array.count];
        }
        //将数据添加到数组中
        [weakSelf.searchHistoryArray addObjectsFromArray:array];
        
        if (weakSelf.searchHistoryArray.count < 50) {
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
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (isHeader) {
            [_tableView.header endRefreshing];
        }else{
            [_tableView.footer endRefreshing];
        }
        [_tableView createNoResultWithImageName:@"no_net_alert" ifNecessaryForRowCount:weakSelf.searchHistoryArray.count target:weakSelf action:@selector(headerRefreshAction)];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}
#pragma mark 添加新的好友视图
- (UIView *)setUpNewFriendView{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 44)];
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
    divider.backgroundColor = [UIColor colorWithHex:0xdddddd];
    [headerView addSubview:divider];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_crm"]];
    arrowView.frame = CGRectMake(kScreenWidth - 13 - 10, (44 - 18) / 2, 13, 18);
    [headerView addSubview:arrowView];
    
    return headerView;
}

#pragma mark 设置单元格
- (UITableViewCell *)setUpTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sourceArray:(NSArray *)sourceArray{
    XLCommonDoctorCell *cell = [XLCommonDoctorCell cellWithTableView:tableView];
    cell.tag = indexPath.row+100;
    Doctor *doctor = [sourceArray objectAtIndex:indexPath.row];
    [cell setFriendListCellWithModel:doctor];
    
    return cell;
}

#pragma mark 设置单元格点击事件
- (void)selectTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath sourceArray:(NSArray *)sourceArray{
    Doctor *doctor = [sourceArray objectAtIndex:indexPath.row];
    //转诊病人
    if (isTransfer) {
        self.selectDoctor = doctor;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确认转诊给%@医生吗?",doctor.doctor_name] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
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
            //查询本地是否有此医生
            Doctor *tmDoc = [[DBManager shareInstance] getDoctorWithCkeyId:doctor.ckeyid];
            if (![tmDoc.doctor_image isEqualToString:doctor.doctor_image]) {
                //将此医生信息保存到本地
                [[DBManager shareInstance] insertDoctorWithDoctor:doctor];
            }
            
            DoctorInfoViewController *doctorinfoVC = [[DoctorInfoViewController alloc]init];
            doctorinfoVC.repairDoctorID = doctor.ckeyid;
            doctorinfoVC.ifDoctorInfo = YES;
            [self pushViewController:doctorinfoVC animated:YES];
        }
    }
}

#pragma mark newFriendAction
- (void)newFriendAction:(UITapGestureRecognizer *)tap{
    
    XLNewFriendNotiViewController *newFriendVc = [[XLNewFriendNotiViewController alloc] initWithStyle:UITableViewStylePlain];
    newFriendVc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:newFriendVc animated:YES];
}

#pragma mark 医生广场入口
- (void)onRightButtonAction:(id)sender {
    XLDoctorSqureViewController *squreVc = [[XLDoctorSqureViewController alloc] init];
    [self pushViewController:squreVc animated:YES];
}

#pragma mark - ******************** Delegate / DataSource *******************
#pragma mark TableView Delegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchHistoryArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XLCommonDoctorCell fixHeight];
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

#pragma mark UIAlertViewDelegate
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
        if (buttonIndex == 0) {
            [_tableView reloadData];
        };
        if (buttonIndex == 1) {
            [SVProgressHUD showWithStatus:@"删除中..."];
            [DoctorTool deleteFriendWithDoctorId:self.deleteDoctor.ckeyid introId:[[AccountManager shareInstance] currentUser].userid success:^(CRMHttpRespondModel *result) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                BOOL res = [[DBManager shareInstance] deleteDoctorWithUserObject:self.deleteDoctor];
                if (res) {
                    //删除成功
                    [self.searchController.resultsSource removeObject:self.deleteDoctor];

                    [_tableView.header beginRefreshing];
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

#pragma mark 转诊成功回调
- (void)transferPatientSuccessWithResult:(NSDictionary *)result
{
    if ([result integerForKey:@"Code"] == 200) {
        NSLog(@"转诊成功");
        Patient *tmppatient = [[DBManager shareInstance] getPatientWithPatientCkeyid:patientId];
        if (tmppatient != nil) {
            //添加患者自动同步信息
            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Patient postType:Update dataEntity:[tmppatient.keyValues JSONString] syncStatus:@"0"];
            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
            //插入患者介绍人
            [self insertDoctorWithDoctorId:self.selectDoctor.ckeyid];
            [self insertPatientIntroducerMap];
        }
        
        __weak typeof(self) weakSelf = self;
        [SVProgressHUD showWithStatus:@"转诊患者成功,正在获取提醒消息"];
        //获取患者绑定微信的状态
        [MyPatientTool getWeixinStatusWithPatientId:self.patientId success:^(CRMHttpRespondModel *respondModel) {
            if ([respondModel.result isEqualToString:@"1"]) {
                //绑定
                weakSelf.isBind = YES;
            }else{
                weakSelf.isBind = NO;
            }
            [weakSelf getPatientSendMessageWithPatient:tmppatient];
        } failure:^(NSError *error) {
            weakSelf.isBind = NO;
            [weakSelf getPatientSendMessageWithPatient:tmppatient];
        }];
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"转诊患者失败"];
    }
}
#pragma mark - 获取患者推送信息
- (void)getPatientSendMessageWithPatient:(Patient *)patient{
    WS(weakSelf);
    [DoctorTool newYuYueMessagePatient:patientId fromDoctor:[AccountManager currentUserid] therapyDoctorId:self.selectDoctor.doctor_id withMessageType:@"转诊" withSendType:@"1" withSendTime:[MyDateTool stringWithDateWithSec:[NSDate date]] success:^(CRMHttpRespondModel *respond) {
        NSLog(@"获取通知");
        if ([respond.code integerValue] == 200) {
            XLCustomAlertView *alertView = [[XLCustomAlertView alloc] initWithTitle:@"提醒患者" message:respond.result Cancel:@"不发送" certain:@"发送" weixinEnalbe:weakSelf.isBind type:CustonAlertViewTypeCheck cancelHandler:^{
                [weakSelf transferBackAction];
            } certainHandler:^(NSString *content, BOOL wenxinSend, BOOL messageSend) {
                [SVProgressHUD showWithStatus:@"正在发送"];
                [SysMessageTool sendMessageWithDoctorId:weakSelf.selectDoctor.doctor_id patientId:patientId isWeixin:weakSelf.isBind isSms:messageSend txtContent:content success:^(CRMHttpRespondModel *respond) {
                    if ([respond.code integerValue] == 200) {
                        [SVProgressHUD showImage:nil status:@"消息发送成功"];
                        //将消息保存在消息记录里
                        [weakSelf savaMessageToChatRecordWithPatient:patient message:content];
                    }else{
                        [SVProgressHUD showImage:nil status:@"消息发送失败"];
                    }
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf transferBackAction];
                    });
                    
                } failure:^(NSError *error) {
                    [SVProgressHUD showImage:nil status:error.localizedDescription];
                    [weakSelf transferBackAction];
                    if (error) {
                        NSLog(@"error:%@",error);
                    }
                }];
            }];
            [alertView show];
        }else{
            [SVProgressHUD showImage:nil status:respond.result];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf transferBackAction];
            });
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        [weakSelf transferBackAction];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

- (void)transferPatientFailedWithError:(NSError *)error
{
    self.selectDoctor = nil;
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}

#pragma mark - 将消息保存在消息记录中
- (void)savaMessageToChatRecordWithPatient:(Patient *)patient message:(NSString *)message{
    //将消息保存在消息记录里
    XLChatModel *chatModel = [[XLChatModel alloc] initWithReceiverId:patient.ckeyid receiverName:patient.patient_name content:message];
    [DoctorTool addNewChatRecordWithChatModel:chatModel success:nil failure:nil];
    //发送环信消息
    [EaseSDKHelper sendTextMessage:message
                                to:patient.ckeyid
                       messageType:eMessageTypeChat
                 requireEncryption:NO
                        messageExt:nil];
}


#pragma mark - 转诊后回调
- (void)transferBackAction{
    self.selectDoctor = nil;
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:PatientTransferNotification object:nil];
    [self popViewControllerAnimated:YES];
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
#pragma mark - 插入好友信息
- (void)insertDoctorWithDoctorId:(NSString *)doctor_id{
    //判断本地是否有此好友
    Doctor *doc = [[DBManager shareInstance] getDoctorWithCkeyId:doctor_id];
    if (doc == nil) {
        //下载医生信息，同时添加到数据库
        [DoctorTool requestDoctorInfoWithDoctorId:doctor_id success:^(DoctorInfoModel *doctorInfo) {
            Doctor *doctor = [Doctor DoctorFromDoctorResult:doctorInfo.keyValues];
            [[DBManager shareInstance] insertDoctorWithDoctor:doctor];
        } failure:^(NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
}

#pragma mark Cell Delegate
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

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [self.searchController.resultsSource removeAllObjects];
    [self.searchController.searchResultsTableView reloadData];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText isEmpty]) {
        [self.searchController.resultsSource removeAllObjects];
        [self.searchController.searchResultsTableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    if ([searchBar.text isNotEmpty]) {
        //请求网络数据
        WS(weakSelf);
        XLQueryModel *queryModel = [[XLQueryModel alloc] initWithKeyWord:searchBar.text sortField:@"" isAsc:@(YES) pageIndex:@(1) pageSize:@(1000)];
        [DoctorTool getDoctorFriendListWithDoctorId:[AccountManager currentUserid] syncTime:@"" queryInfo:queryModel success:^(NSArray *array) {
            
            [weakSelf.searchController.resultsSource removeAllObjects];
            [weakSelf.searchController.resultsSource addObjectsFromArray:array];
            [weakSelf.searchController.searchResultsTableView reloadData];
        } failure:^(NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
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

#pragma mark - ********************* Lazy Method ***********************
- (NSMutableArray *)searchHistoryArray{
    if (!_searchHistoryArray) {
        _searchHistoryArray = [NSMutableArray array];
    }
    return _searchHistoryArray;
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
                        [weakSelf headerRefreshAction];
                        
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



@end
