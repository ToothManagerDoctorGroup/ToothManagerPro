//
//  SysMsgViewController.m
//  CRM
//
//  Created by TimTiger on 11/3/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "SysMsgViewController.h"
#import "DoctorTableViewCell.h"
#import "SystemMessageCell.h"
#import "TimFramework.h"
#import "DoctorTableViewCell.h"
#import "SystemMessageCell.h"
#import "AccountManager.h"
#import "SVProgressHUD.h"
#import "FriendNotification.h"
#import "InPatientNotification.h"
#import "UserInfoViewController.h"
#import "CRMHttpRequest+PersonalCenter.h"
#import "DBManager+Introducer.h"
#import "PatientInfoCellTableViewCell.h"
#import "CacheFactory.h"
#import "DBManager+Patients.h"
#import "IntroPeopleDetailViewController.h"
#import "DoctorInfoViewController.h"
#import "DBManager+Doctor.h"
#import "SyncManager.h"
#import "CRMHttpRequest+Sync.h"
#import "DBManager+sync.h"

@interface SysMsgViewController () <DoctorTableViewCellDelegate,CRMHttpRequestNotificationDelegate,CRMHttpRequestPersonalCenterDelegate>
@property (nonatomic,retain) InPatientNotification *inPatientNotifiObj;
@property (nonatomic,retain) InPatientNotification *outPatientNotifiObj;
@property (nonatomic,retain) FriendNotificationItem *selectFriendNotiItem;
@property (nonatomic,retain) FriendNotification *friendNotifiObj;
@property (nonatomic,retain) Doctor *addDoctor;
@end

@implementation SysMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置提示框
    //设置segument
    [self.segmentView setSelectedSegmentIndex:0];
    self.segmentView.tintColor = [UIColor colorWithHex:0x00a0ea];
    
    
    UIImage *image1 = [[UIImage imageNamed:@"ic_tabbar_message"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image2 = [[UIImage imageNamed:@"ic_tabbar_message_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:image1 selectedImage:image2];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIColor colorWithRed:59.0f/255.0f green:161.0f/255.0f blue:233.0f/255.0f alpha:1], NSForegroundColorAttributeName,
                                             nil] forState:UIControlStateSelected];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIColor lightGrayColor], NSForegroundColorAttributeName,
                                             nil] forState:UIControlStateNormal];
    
}

- (void)initView {
    [super initView];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"ic_nav_tongbu"]];
    self.title = @"系统通知";
    self.view.backgroundColor = [UIColor whiteColor];
    [self refreshData];
}
-(void)onRightButtonAction:(id)sender{
    [SVProgressHUD showWithStatus:@"同步中..."];
    if ([[AccountManager shareInstance] isLogin]) {
        [NSTimer scheduledTimerWithTimeInterval:0.2
                                         target:self
                                       selector:@selector(callSync)
                                       userInfo:nil
                                        repeats:NO];
        
    } else {
        NSLog(@"User did not login");
        [SVProgressHUD showWithStatus:@"同步失败，请先登录..."];
        [SVProgressHUD dismiss];
        [NSThread sleepForTimeInterval: 1];
    }
}
- (void)callSync {
    [[SyncManager shareInstance] startSync];
}
- (void)refreshView {
    [super refreshView];
    [self.tableView reloadData];
}

- (void)initData {
    [super initData];
    _friendNotifiObj = [[FriendNotification alloc]init];
    _inPatientNotifiObj = [[InPatientNotification alloc]init];
    _outPatientNotifiObj = [[InPatientNotification alloc]init];

}
- (void)viewWillAppear:(BOOL)animated{
    [self refreshData];
    [self refreshView];
}
- (void)refreshData {
    [super refreshData];
    
//    [self.friendNotifiObj.result removeAllObjects];
//    [self.inPatientNotifiObj.result removeAllObjects];
//    [self.outPatientNotifiObj.result removeAllObjects];
    
    [[AccountManager shareInstance] getFriendsNotificationListWithUserid:[AccountManager currentUserid] successBlock:^{
        [SVProgressHUD showWithStatus:@"加载中..."];
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
    
//    [[AccountManager shareInstance] getSystemNotificationListWithUserid:[AccountManager currentUserid] successBlock:^{
//        [SVProgressHUD showWithStatus:@"加载中..."];
//    } failedBlock:^(NSError *error) {
//        [SVProgressHUD showImage:nil status:error.localizedDescription];
//    }];
    
    //转入
    [[AccountManager shareInstance] getInpatientNotificationListWithUserid:[AccountManager currentUserid] Sync_time:[NSString defaultDateString] successBlock:^{
        [SVProgressHUD showWithStatus:@"加载中..."];
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
    
    //转出
    [[AccountManager shareInstance] getOutpatientNotificationListWithUserid:[AccountManager currentUserid] Sync_time:[NSString defaultDateString] successBlock:^{
        [SVProgressHUD showWithStatus:@"加载中..."];
    } failedBlock:^(NSError *error){
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];

}

#pragma mark - IBAction / Button Action
- (IBAction)segmentValueChanged:(id)sender {
    [self.tableView reloadData];
}

#pragma mark - TableView Delegate / DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.segmentView.selectedSegmentIndex) {
        case 2:
        {
            return self.friendNotifiObj.result.count;
        }
            break;
        case 1:
        {
            return self.outPatientNotifiObj.result.count;
        }
            break;
        case 0:
        {
            return self.inPatientNotifiObj.result.count;
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segmentView.selectedSegmentIndex == 2) {
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
    } else if (self.segmentView.selectedSegmentIndex == 1) {
        //新增患者消息
        PatientInfoCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatientInfoCellTableViewCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PatientInfoCellTableViewCell" owner:nil options:nil] objectAtIndex:0];
            [tableView registerNib:[UINib nibWithNibName:@"PatientInfoCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatientInfoCellTableViewCell"];
        }
        cell.tag = indexPath.row+100;
        if ([self.outPatientNotifiObj.result count] > 0) {
            InPatientNotificationItem *outpatientNotiItem = [self.outPatientNotifiObj.result objectAtIndex:indexPath.row];
            [cell setCellWithPatientNotifi:outpatientNotiItem];
            [cell.secondTitleLabel setText:[NSString stringWithFormat:@"你转出了患者:%@",outpatientNotiItem.patient_name]];
        }
       // cell.secondTitleLabel.text = @"你转出了患者:";
        
        return cell;
    } else {
        //转入患者
        PatientInfoCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatientInfoCellTableViewCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PatientInfoCellTableViewCell" owner:nil options:nil] objectAtIndex:0];
            [tableView registerNib:[UINib nibWithNibName:@"PatientInfoCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatientInfoCellTableViewCell"];
        }
        cell.tag = indexPath.row+100;
        if ([self.inPatientNotifiObj.result count] > 0) {
            InPatientNotificationItem *inpatientNotiItem = [self.inPatientNotifiObj.result objectAtIndex:indexPath.row];
            [cell setCellWithPatientNotifi:inpatientNotiItem];
            [cell.secondTitleLabel setText:[NSString stringWithFormat:@"给你介绍了患者:%@",inpatientNotiItem.patient_name]];
            
        }
        //cell.secondTitleLabel.text = @"给你介绍了患者:";
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (self.segmentView.selectedSegmentIndex) {
        case 2:
        {
            FriendNotificationItem *friNotifiItem = [self.friendNotifiObj.result objectAtIndex:indexPath.row];
            Doctor *tmpdoctor = [[Doctor alloc] init];
            tmpdoctor.ckeyid = friNotifiItem.doctor_id;
            tmpdoctor.doctor_name = friNotifiItem.doctor_name;
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            UserInfoViewController *userInfoVC = [storyBoard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
            userInfoVC.doctor = tmpdoctor;
            userInfoVC.needGet = YES;
            userInfoVC.hidesBottomBarWhenPushed = YES;
            [self pushViewController:userInfoVC animated:YES];
        }
            break;
        case 1:
        {
            //转出患者
            if ([self.outPatientNotifiObj.result count] > 0) {
                InPatientNotificationItem *outpatientNotiItem = [self.outPatientNotifiObj.result objectAtIndex:indexPath.row];
                DoctorInfoViewController *doctorinfoVC = [[DoctorInfoViewController alloc]init];
                doctorinfoVC.repairDoctorID = outpatientNotiItem.doctor_info_id;
                doctorinfoVC.hidesBottomBarWhenPushed = YES;
                [self pushViewController:doctorinfoVC animated:YES];
            }

        }
            break;
        case 0:
        {
            //转入患者
            if ([self.inPatientNotifiObj.result count] > 0) {
                InPatientNotificationItem *inpatientNotiItem = [self.inPatientNotifiObj.result objectAtIndex:indexPath.row];
             //   Doctor *doctor1 = [[DBManager shareInstance] getDoctorWithCkeyId:inpatientNotiItem.doctor_info_id];
               NSArray *introducerInfoArray = [[DBManager shareInstance] getAllIntroducer];
                
                for (NSInteger i = 0; i < introducerInfoArray.count; i++) {
                    Introducer *introducerInfo = [introducerInfoArray objectAtIndex:i];
                    if([introducerInfo.intr_name isEqualToString:inpatientNotiItem.doctor_info_name]){
                        IntroPeopleDetailViewController * detailCtl = [[IntroPeopleDetailViewController alloc]init];
                        [detailCtl setIntroducer:introducerInfo];
                        detailCtl.hidesBottomBarWhenPushed = YES;
                        [self pushViewController:detailCtl animated:YES];
                    }
                }
            }
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - Delegate 
//request delegate
- (void)getSystemNotificationListSuccessWithResult:(NSDictionary *)result {
    [SVProgressHUD dismiss];
}

- (void)getSystemNotificationListFailedWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}

- (void)getFriendsNotificationListSuccessWithResult:(NSDictionary *)result {
    [SVProgressHUD dismiss];
//    NSLog(@"Friends = %@",result);
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"test",@"UserName",@"73",@"doctor_id",@"1",@"receiver_id",@"1",@"notification_type",@"test向你申请加为好友",@"notification_content",@"1",@"notification_status",@"2014-09-29 15:13:34",@"creation_time",nil];
//    NSArray *resultArray = [NSArray arrayWithObjects:dic,dic, nil];
    
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

- (void)getInpatientNotificationListSuccessWithResult:(NSDictionary *)result {
    [SVProgressHUD dismiss];
    
    [self.inPatientNotifiObj.result removeAllObjects];

    
    NSArray *resultArray = [result objectForKey:@"Result"];
    if (resultArray && resultArray.count > 0) {
        for (NSDictionary *dic in resultArray) {
            InPatientNotificationItem *notifiItem = [InPatientNotificationItem inpatientNotificationWithDic:dic];
            NSLog(@"inpatientName:%@",notifiItem.patient_name);
            
            [self.inPatientNotifiObj.result addObject:notifiItem];
        }
        //存入本地
        NSMutableData *data = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:self.inPatientNotifiObj forKey:@"InPatientNotification"];
        [archiver finishEncoding];
        NSString *path = [[CacheFactory sharedCacheFactory] saveToPathAsFileName:@"InPatientNotification"];
        [data writeToFile: path atomically:YES];//写进文件
        
//        //去本地数据
//        NSMutableData *data1 = [[NSMutableData alloc]initWithContentsOfFile:path];//加载本地数据
//        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data1];//解归档数据
//        InPatientNotification *info = (InPatientNotification *)[unArchiver decodeObjectForKey:@"InPatientNotification"];
    }
    [self refreshView];
}

- (void)getOutpatientNotificationListSuccessWithResult:(NSDictionary *)result
{
    [SVProgressHUD dismiss];
    NSLog(@"Outpatient = %@",result);
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"162_1429458124058",@"patient_id",@"abc",@"patient_name",@"156",@"doctor_info_id",@"亮",@"doctor_info_name",@"2015-04-19 23:45:32",@"intro_time",@"http://122.114.62.57/avatar/156_201534.jpg",@"doctor_info_image",@"3",@"patients",nil];
//    NSArray *resultArray = [NSArray arrayWithObjects:dic,dic, nil];


    [self.outPatientNotifiObj.result removeAllObjects];
    
    NSArray *resultArray = [result objectForKey:@"Result"];
    if (resultArray && resultArray.count > 0) {
        for (NSDictionary *dic in resultArray) {
            InPatientNotificationItem *notifiItem = [InPatientNotificationItem inpatientNotificationWithDic:dic];
            NSLog(@"outPatientName:%@",notifiItem.patient_name);
            [self.outPatientNotifiObj.result addObject:notifiItem];
        }
        //存入本地
        NSMutableData *data = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:self.outPatientNotifiObj forKey:@"OutPatientNotification"];
        [archiver finishEncoding];
        NSString *path = [[CacheFactory sharedCacheFactory] saveToPathAsFileName:@"OutPatientNotification"];
        [data writeToFile: path atomically:YES];//写进文件
    }
    [self refreshView];
}

//接受申请
- (void)approveIntroducerApplySuccessWithResult:(NSDictionary *)result {
    Introducer *intro = [[Introducer alloc] init];
//    intro.ckeyid = self.addDoctor.ckeyid; //TODO: 不知道是要用拉取下来的id呢，还用自己本地创造的。
    intro.intr_name = self.addDoctor.doctor_name;
    intro.intr_phone = self.addDoctor.doctor_phone;
    intro.intr_level = 1;
    intro.intr_id = self.addDoctor.doctor_id;
    BOOL ret = [[DBManager shareInstance] insertIntroducer:intro];
    if (ret) {
        [SVProgressHUD showImage:nil status:[result stringForKey:@"Result"]];
        
       NSMutableArray *recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllNeedSyncIntroducer]];
        
        if (0 != [recordArray count])
        {
            [[CRMHttpRequest shareInstance] postAllNeedSyncIntroducer:recordArray];
            [NSThread sleepForTimeInterval: 0.5];
        }
        
        } else {
        [SVProgressHUD showImage:nil status:@"接受失败"];
    }
    self.selectFriendNotiItem.notification_status = [NSNumber numberWithInteger:1];
    [self.tableView reloadData];
    self.selectFriendNotiItem = nil;
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

@end
