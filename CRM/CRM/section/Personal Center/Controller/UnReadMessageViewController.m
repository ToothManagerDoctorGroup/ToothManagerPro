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
#import "MyPatientTool.h"
#import "XLPatientTotalInfoModel.h"
#import "DBTableMode.h"
#import "DBManager+Patients.h"
#import "CRMHttpRequest+Sync.h"
#import "PatientManager.h"
#import "DBManager+Materials.h"


@interface UnReadMessageViewController ()

@property (nonatomic, strong)NSArray *dataList;

@end

@implementation UnReadMessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加通知
    
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

- (void)clickMessageActionWithModel:(SysMessageModel *)msgModel{
    
    //判断消息的类型
    if ([msgModel.message_type isEqualToString:AttainNewPatient]) {
        
        //获取患者的id
        Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:msgModel.message_id];
        if (patient == nil) {
            //新增患者
            [SVProgressHUD showWithStatus:@"正在获取患者数据..."];
            //请求患者数据
            [MyPatientTool getPatientAllInfosWithPatientId:msgModel.message_id doctorID:[AccountManager currentUserid] success:^(XLPatientTotalInfoModel *model) {
                //请求成功后缓存患者信息
                [self savePatientDataWithModel:model messageModel:msgModel];
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"患者信息获取失败"];
                if (error) {
                    NSLog(@"error:%@",error);
                }
            }];
            
        }else{
            //将消息设置为已读
            [self setMessageReadWithModel:msgModel];
        }
        
        
    }else if([msgModel.message_type isEqualToString:AttainNewFriend]){
        
        [SysMessageTool setMessageReadedWithMessageId:msgModel.keyId success:^(CRMHttpRespondModel *respond) {
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

- (void)setMessageReadWithModel:(SysMessageModel *)model{
    //将消息设置为已读
    [SysMessageTool setMessageReadedWithMessageId:model.keyId success:^(CRMHttpRespondModel *respond) {
        [SVProgressHUD dismiss];
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

#pragma mark - 缓存患者信息
- (void)savePatientDataWithModel:(XLPatientTotalInfoModel *)model messageModel:(SysMessageModel *)msgModel{
    //"ckeyid": "1009_1451464419254",
    if (model.baseInfo[@"ckeyid"] == nil) {
        //如果患者为空
        [SVProgressHUD showErrorWithStatus:@"患者信息获取失败!"];
        return;
    }
    
    NSInteger total = 1 + model.medicalCase.count + model.medicalCourse.count + model.cT.count + model.consultation.count + model.expense.count;
    NSInteger current = 0;
    //保存患者消息
    Patient *patient = [Patient PatientFromPatientResult:model.baseInfo];
   [[DBManager shareInstance] insertPatient:patient];
    //稍后条件判断是否成功的代码
    if([[DBManager shareInstance] insertPatientBySync:patient]){
        current++;
    };
    
    //判断medicalCase数据是否存在
    if (model.medicalCase.count > 0) {
        //保存病历数据
        for (NSDictionary *dic in model.medicalCase) {
            MedicalCase *medicalCase = [MedicalCase MedicalCaseFromPatientMedicalCase:dic];
            if([[DBManager shareInstance] insertMedicalCase:medicalCase]){
                current++;
            };
        }
        
    }
    //判断medicalCourse数据是否存在
    if (model.medicalCourse.count > 0) {
        for (NSDictionary *dic in model.medicalCourse) {
            MedicalRecord *medicalrecord = [MedicalRecord MRFromMRResult:dic];
            if([[DBManager shareInstance] insertMedicalRecord:medicalrecord]){
                current++;
            }
        }
    }
    
    //判断CT数据是否存在
    if (model.cT.count > 0) {
        for (NSDictionary *dic in model.cT) {
            CTLib *ctlib = [CTLib CTLibFromCTLibResult:dic];
            if([[DBManager shareInstance] insertCTLib:ctlib]){
                current++;
            }
            if ([ctlib.ct_image isNotEmpty]) {
                NSString *urlImage = [NSString stringWithFormat:@"%@%@_%@", ImageDown, ctlib.ckeyid, ctlib.ct_image];
                
                UIImage *image = [self getImageFromURL:urlImage];
                
                if (nil != image) {
                    [PatientManager pathImageSaveToDisk:image withKey:ctlib.ct_image];
                }
                
            }
        }
    }
    
    //判断consultation数据是否存在
    if (model.consultation.count > 0) {
        for (NSDictionary *dic in model.consultation) {
            PatientConsultation *patientC = [PatientConsultation PCFromPCResult:dic];
            if([[DBManager shareInstance] insertPatientConsultation:patientC]){
                current++;
            }
        }
    }
    
    //判断expense数据是否存在
    if (model.expense.count > 0) {
        for (NSDictionary *dic in model.expense) {
            MedicalExpense *medicalexpense = [MedicalExpense MEFromMEResult:dic];
            if([[DBManager shareInstance] insertMedicalExpenseWith:medicalexpense]){
                current++;
            }
        }
    }
    
    if (total == current) {
        //同步数据成功,跳转到患者详情页面
        [self setMessageReadWithModel:msgModel];
    }else{
        [SVProgressHUD showErrorWithStatus:@"获取患者数据失败"];
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

//获取图片
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

@end
