//
//  XLNewFriendNotiViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/22.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLNewFriendNotiViewController.h"
#import "AccountManager.h"
#import "CacheFactory.h"
#import "XLCommonDoctorCell.h"
#import "XLUserInfoViewController.h"
#import "DBManager+Doctor.h"
#import "NSDictionary+Extension.h"
#import "UITableView+NoResultAlert.h"

@interface XLNewFriendNotiViewController ()<XLCommonDoctorCellDelegte>

@property (nonatomic,retain) FriendNotification *friendNotifiObj;
@property (nonatomic,retain) FriendNotificationItem *selectFriendNotiItem;
@property (nonatomic,retain) Doctor *addDoctor;

@end

@implementation XLNewFriendNotiViewController

- (void)dealloc{
    [SVProgressHUD dismiss];
    
    self.friendNotifiObj = nil;
    self.selectFriendNotiItem = nil;
    self.addDoctor = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 请求数据
- (void)requestDataList{
    [[AccountManager shareInstance] getFriendsNotificationListWithUserid:[AccountManager currentUserid] successBlock:^{
        [SVProgressHUD showWithStatus:@"加载中..."];
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}

- (void)refreshView {
    [super refreshView];
    [self.tableView reloadData];
}

- (void)initView{
    self.title = @"新的好友";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)initData {
    [super initData];
    _friendNotifiObj = [[FriendNotification alloc]init];
    [self requestDataList];
}

#pragma mark - 好友数据请求成功
- (void)getFriendsNotificationListSuccessWithResult:(NSDictionary *)result {
    [self.friendNotifiObj.result removeAllObjects];
    NSArray *resultArray = [result objectForKey:@"Result"];
    if (resultArray && resultArray.count > 0) {
        for (NSDictionary *dic in resultArray) {
            FriendNotificationItem *notifiItem = [FriendNotificationItem friendnotificationWithDic:dic];
            if ([notifiItem.doctor_id isEqualToString:[AccountManager currentUserid]] &&
                notifiItem.notification_type.integerValue == 1 &&
                notifiItem.notification_status.integerValue == 1) {
                [[DoctorManager shareInstance] addDoctorToDoctorLibrary:notifiItem];
            }
            [self.friendNotifiObj.result addObject:notifiItem];
        }
        //存入本地
        NSMutableData *data = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:self.friendNotifiObj forKey:@"FriendNotification"];
        [archiver finishEncoding];
        NSString *path = [[CacheFactory sharedCacheFactory] saveToPathAsFileName:@"FriendNotification"];
        [data writeToFile: path atomically:YES];//写进文件
    }
    [SVProgressHUD dismiss];
    [self refreshView];
}

- (void)getFriendsNotificationListFailedWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}

#pragma mark - UITableViewDataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView createNoResultAlertViewWithImageName:@"doctorNewFriend_alert.png" showButton:NO ifNecessaryForRowCount:self.friendNotifiObj.result.count];
    return self.friendNotifiObj.result.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XLCommonDoctorCell fixHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //好友消息
    XLCommonDoctorCell *cell = [XLCommonDoctorCell cellWithTableView:tableView];
    cell.tag = indexPath.row+100;
    cell.delegate = self;
    FriendNotificationItem *friNotiItem = [self.friendNotifiObj.result objectAtIndex:indexPath.row];
    [cell setNewFriendCellWithFrienNotifi:friNotiItem];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendNotificationItem *friNotifiItem = [self.friendNotifiObj.result objectAtIndex:indexPath.row];
    
    Doctor *tmpdoctor = [[Doctor alloc] init];
    //判断当前接收方是否是自己
    if (![friNotifiItem.receiver_id isEqualToString:[AccountManager currentUserid]]) {
        tmpdoctor.ckeyid = friNotifiItem.receiver_id;
        tmpdoctor.doctor_name = friNotifiItem.receiver_name;
    }else{
        tmpdoctor.ckeyid = friNotifiItem.doctor_id;
        tmpdoctor.doctor_name = friNotifiItem.doctor_name;
    }
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    XLUserInfoViewController *userInfo = [storyBoard instantiateViewControllerWithIdentifier:@"XLUserInfoViewController"];
    userInfo.doctor = tmpdoctor;
    userInfo.needGet = YES;
    [self pushViewController:userInfo animated:YES];
}

#pragma mark - XLCommonDoctorCellDelegte
- (void)commonDoctorCell:(XLCommonDoctorCell *)cell addButtonDidSelect:(id)sender{
    if (self.selectFriendNotiItem == nil) {
        FriendNotificationItem *notifiItem = [self.friendNotifiObj.result objectAtIndex:cell.tag-100];
        self.selectFriendNotiItem = notifiItem;
        [[DoctorManager shareInstance] getDoctorListWithUserId:self.selectFriendNotiItem.doctor_id successBlock:^{
            [SVProgressHUD showWithStatus:@"加载中..."];
        } failedBlock:^(NSError *error) {
            [SVProgressHUD showImage:nil status:error.localizedDescription];
        }];
    }
}

//获取用户的医生列表
- (void)getDoctorListSuccessWithResult:(NSDictionary *)result {
    if (self.selectFriendNotiItem && self == self.navigationController.topViewController) {
        NSArray *dicArray = [result objectForKey:@"Result"];
        if (dicArray && dicArray.count > 0) {
            for (NSDictionary *dic in dicArray) {
                Doctor *tmpDoctor = [Doctor DoctorFromDoctorResult:dic];
                self.addDoctor = tmpDoctor;
                
                [[AccountManager shareInstance] approveIntroducerApply:tmpDoctor.ckeyid successBlock:^{
                } failedBlock:^(NSError *error) {
                    [SVProgressHUD showImage:nil status:error.localizedDescription];
                }];
                return;
            }
        }
    }
}

- (void)getDoctorListFailedWithError:(NSError *)error {
    if (self.selectFriendNotiItem && self == self.navigationController.topViewController) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }
}

//接受申请
- (void)approveIntroducerApplySuccessWithResult:(NSDictionary *)result {
    
    [SVProgressHUD showImage:nil status:[result stringForKey:@"Result"]];
    self.selectFriendNotiItem.notification_status = [NSNumber numberWithInteger:1];
    [self.tableView reloadData];
    self.selectFriendNotiItem = nil;
    
    //将医生保存到本地
    if (self.addDoctor != nil) {
        [[DBManager shareInstance] insertDoctorWithDoctor:self.addDoctor];
    }
}

- (void)approveIntroducerApplyFailedWithError:(NSError *)error {
    [SVProgressHUD showImage:nil status:error.localizedDescription];
    self.selectFriendNotiItem = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
