//
//  NewFriendsViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/17.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "NewFriendsViewController.h"
#import "AccountManager.h"
#import "DoctorTableViewCell.h"
#import "CacheFactory.h"
#import "DBManager+Introducer.h"
#import "DBManager+sync.h"
#import "NSDictionary+Extension.h"
#import "CRMHttpRequest+Sync.h"
#import "CRMHttpTool.h"
#import "CRMUserDefalut.h"
#import "XLUserInfoViewController.h"
#import "DBManager+Doctor.h"

@interface NewFriendsViewController ()<DoctorTableViewCellDelegate>

@property (nonatomic,retain) FriendNotification *friendNotifiObj;
@property (nonatomic,retain) FriendNotificationItem *selectFriendNotiItem;
@property (nonatomic,retain) Doctor *addDoctor;

@end

@implementation NewFriendsViewController

- (void)dealloc{
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setUpNav];
    
    //请求数据
    [self refreshData];
}

- (void)setUpNav{
    self.title = @"新的好友";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
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

- (void)initData {
    [super initData];
    _friendNotifiObj = [[FriendNotification alloc]init];
    
}

- (void)refreshData{
    [super refreshData];
    [self requestDataList];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friendNotifiObj.result.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        //好友消息
        DoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorTableViewCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DoctorTableViewCell" owner:nil options:nil] objectAtIndex:0];
            [tableView registerNib:[UINib nibWithNibName:@"DoctorTableViewCell" bundle:nil] forCellReuseIdentifier:@"DoctorTableViewCell"];
        }
        cell.tag = indexPath.row+100;
        cell.delegate = self;
        FriendNotificationItem *friNotiItem = [self.friendNotifiObj.result objectAtIndex:indexPath.row];
        [cell setCellWithFrienNotifi:friNotiItem];
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

#pragma mark - 好友数据请求成功
- (void)getFriendsNotificationListSuccessWithResult:(NSDictionary *)result {
    [SVProgressHUD dismiss];
    
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
    [self refreshView];
}

//接受申请
- (void)approveIntroducerApplySuccessWithResult:(NSDictionary *)result {
//    Introducer *intro = [[Introducer alloc] init];
//    //    intro.ckeyid = self.addDoctor.ckeyid; //TODO: 不知道是要用拉取下来的id呢，还用自己本地创造的。
//    intro.intr_name = self.addDoctor.doctor_name;
//    intro.intr_phone = self.addDoctor.doctor_phone;
//    intro.intr_level = 1;
//    intro.intr_id = self.addDoctor.doctor_id;
//    BOOL ret = [[DBManager shareInstance] insertIntroducer:intro];
//    if (ret) {
//        [SVProgressHUD showImage:nil status:[result stringForKey:@"Result"]];
//        
//        NSMutableArray *recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllNeedSyncIntroducer]];
//        
//        if (0 != [recordArray count])
//        {
//            [[CRMHttpRequest shareInstance] postAllNeedSyncIntroducer:recordArray];
//            [NSThread sleepForTimeInterval: 0.5];
//        }
//        
//    } else {
//        [SVProgressHUD showImage:nil status:@"接受失败"];
//    }
    
    
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

//拒绝申请
- (void)refuseIntroducerApplySuccessWithResult:(NSDictionary *)result {
    [SVProgressHUD showImage:nil status:@"已拒绝"];
}

- (void)refuseIntroducerApplyFailedWithError:(NSError *)error {
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}

- (void)getFriendsNotificationListFailedWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}

//cell delegate
- (void)addButtonDidSelected:(id)sender {
    //    DoctorTableViewCell *cell = (DoctorTableViewCell *)sender;
    if (self.selectFriendNotiItem == nil) {
        DoctorTableViewCell *cell = (DoctorTableViewCell *)sender;
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

- (void)approveButtonDidSelected:(id)sender {
    
}

- (void)refuseButtonDidSelected:(id)sender {
    DoctorTableViewCell *cell = (DoctorTableViewCell *)sender;
    FriendNotificationItem *notifiItem = [self.friendNotifiObj.result objectAtIndex:cell.tag-100];
    [[AccountManager shareInstance] refuseIntroducerApply:notifiItem.doctor_id successBlock:^{
        [SVProgressHUD showWithStatus:@"处理中..."];
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
