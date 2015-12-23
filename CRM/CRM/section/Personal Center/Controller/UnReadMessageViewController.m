//
//  UnReadMessageViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "UnReadMessageViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefresh.h"
#import "SysMessageCell.h"
#import "SysMessageModel.h"
#import "SysMessageTool.h"
#import "AccountManager.h"
#import "CRMHttpRequest+Sync.h"
#import "NewFriendsViewController.h"
#import "InPatientNotification.h"
#import "CRMHttpRequest.h"
#import "DBManager+Patients.h"
#import "PatientDetailViewController.h"
#import "PatientsCellMode.h"

@interface UnReadMessageViewController ()

@property (nonatomic, strong)NSArray *dataList;

@end

@implementation UnReadMessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongbuAction:) name:@"tongbu" object:nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 60;
    
    
    [self requestData];
    //添加头部刷新控件
//    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefresh:)];
//    [self.tableView.header beginRefreshing];
}

- (void)dealloc{
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)requestData{
    [SVProgressHUD showWithStatus:@"正在加载"];
    [SysMessageTool getUnReadMessagesWithDoctorId:[[AccountManager shareInstance] currentUser].userid success:^(NSArray *result) {
        [SVProgressHUD dismiss];
        
        self.dataList = result;
        //刷新表格
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SysMessageCell *cell = [SysMessageCell cellWithTableView:tableView];
    
    SysMessageModel *model = self.dataList[indexPath.row];
    
    cell.model = model;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SysMessageModel *model = self.dataList[indexPath.row];
    
    //点击消息
    [self clickMessageActionWithModel:model];
    
}

- (void)clickMessageActionWithModel:(SysMessageModel *)model{
    
    //判断消息的类型
    if ([model.message_type isEqualToString:AttainNewPatient]) {
        
        //获取患者的id
        Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:model.message_id];
        if (patient == nil) {
            //新增患者
            [SVProgressHUD showWithStatus:@"正在同步信息..."];
            //同步数据
            [self syncData];
        }else{
            [SysMessageTool setMessageReadedWithMessageId:model.keyId success:^(CRMHttpRespondModel *respond) {
                //重新请求数据
                [self requestData];
                
                //跳转到新的患者详情页面
                PatientsCellMode *cellModel = [[PatientsCellMode alloc] init];
                cellModel.patientId = model.message_id;
                PatientDetailViewController *detailVc = [[PatientDetailViewController alloc] init];
                detailVc.patientsCellMode = cellModel;
                detailVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detailVc animated:YES];
                
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:ReadUnReadMessageSuccessNotification object:nil];
            } failure:^(NSError *error) {
                [SVProgressHUD dismiss];
                if (error) {
                    NSLog(@"error:%@",error);
                }
            }];
        }
        
        
    }else if([model.message_type isEqualToString:AttainNewFriend]){
        
        [SysMessageTool setMessageReadedWithMessageId:model.keyId success:^(CRMHttpRespondModel *respond) {
            //重新请求数据
            [self requestData];
            //新增好友
            NewFriendsViewController *newFriendVc = [[NewFriendsViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:newFriendVc animated:YES];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
        
    }
    
}

- (void)syncData{
    //开启一个全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        //添加多线程进行下载操作
        // 创建一个组
        dispatch_group_t group = dispatch_group_create();
        // 关联一个任务到group
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval: 0.2];
            [[CRMHttpRequest shareInstance] getMaterialTable];
        });
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval: 0.2];
            
            [[CRMHttpRequest shareInstance] getIntroducerTable];
        });
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval: 0.2];
            [[CRMHttpRequest shareInstance] getReserverecordTable];
        });
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval: 0.2];
            [[CRMHttpRequest shareInstance] getPatIntrMapTable];
            
        });
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval: 0.2];
            
            [[CRMHttpRequest shareInstance] getRepairDoctorTable];
        });
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval: 0.2];
            [[CRMHttpRequest shareInstance] getDoctorTable];
        });
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval: 0.2];
            [[CRMHttpRequest shareInstance] getPatientTable];
            
        });
    });
}

- (void)tongbuAction:(NSNotification *)noti{
    //同步完成之后
    
}


@end
