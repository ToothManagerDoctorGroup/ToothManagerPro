//
//  XLMessageHandleManager.m
//  CRM
//
//  Created by Argo Zhang on 16/5/11.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLMessageHandleManager.h"
#import "SysMessageModel.h"
#import "DBManager+Patients.h"
#import "MyPatientTool.h"
#import "CRMHttpRespondModel.h"
#import "DBManager+Doctor.h"
#import "XLPatientTotalInfoModel.h"
#import "DoctorTool.h"
#import "DoctorInfoModel.h"
#import "SysMessageTool.h"
#import "DBManager+LocalNotification.h"
#import "CRMUserDefalut.h"

#define AutoMessageHandleSyncTimeKey [NSString stringWithFormat:@"%@_autoMessageHandleSyncTime",[AccountManager currentUserid]]

@implementation XLMessageHandleManager

+ (void)beginHandle{
    NSString *messageSyncTime = [CRMUserDefalut objectForKey:AutoMessageHandleSyncTimeKey];
    if (!messageSyncTime) {
        messageSyncTime = [NSString defaultDateString];
        [CRMUserDefalut setObject:messageSyncTime forKey:AutoMessageHandleSyncTimeKey];
    }
    XLMessageQueryModel *queryModel = [[XLMessageQueryModel alloc] initWithIsRead:@(0) syncTime:messageSyncTime sortField:@"create_time" isAsc:YES pageIndex:0 pageSize:0];
    [SysMessageTool getMessageByQueryModel:queryModel success:^(NSArray *result) {
        //数据获取成功之后，将同步时间保存为当前时间
        SysMessageModel *model = [result lastObject];
        NSString *latestTime = model.create_time;
        [CRMUserDefalut setObject:latestTime forKey:AutoMessageHandleSyncTimeKey];
        dispatch_queue_t queue_msghandle = dispatch_queue_create("queue_msghandle", NULL);
        dispatch_async(queue_msghandle, ^{
            //处理未读消息
            [XLMessageHandleManager handleUnReadMessages:result];
        });
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

+ (void)handleUnReadMessages:(NSArray *)messages{
    
    for (SysMessageModel *msgModel in messages) {
        //判断消息的类型
        if ([msgModel.message_type isEqualToString:AttainNewPatient]) {
            //获取患者的id
            Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:msgModel.message_id];
            if (patient == nil) {
                //请求患者数据
                [MyPatientTool getPatientAllInfosWithPatientId:msgModel.message_id doctorID:[AccountManager currentUserid] success:^(CRMHttpRespondModel *respond) {
                    if ([respond.code integerValue] == 200) {
                        NSMutableArray *arrayM = [NSMutableArray array];
                        for (NSDictionary *dic in respond.result) {
                            XLPatientTotalInfoModel *model = [XLPatientTotalInfoModel objectWithKeyValues:dic];
                            [arrayM addObject:model];
                        }
                        //请求成功后缓存患者信息
                        [[DBManager shareInstance] saveAllDownloadPatientInfoWithPatientModel:arrayM[0]];
                        [[NSNotificationCenter defaultCenter] postNotificationName:PatientCreatedNotification object:nil];
                    }
                } failure:^(NSError *error) {
                    if (error) {
                        NSLog(@"error:%@",error);
                    }
                }];
            }
        }else if ([msgModel.message_type isEqualToString:AttainNewFriend]){
            //判断本地是否有此好友
            Doctor *doc = [[DBManager shareInstance] getDoctorWithCkeyId:msgModel.message_id];
            if (doc == nil) {
                //下载医生信息，同时添加到数据库
                [DoctorTool requestDoctorInfoWithDoctorId:msgModel.message_id success:^(DoctorInfoModel *doctorInfo) {
                    Doctor *doctor = [Doctor DoctorFromDoctorResult:doctorInfo.keyValues];
                    [[DBManager shareInstance] insertDoctorWithDoctor:doctor];
                } failure:^(NSError *error) {
                    if (error) {
                        NSLog(@"error:%@",error);
                    }
                }];
            }
        }else if ([msgModel.message_type isEqualToString:InsertReserveRecord]){
            //获取最新的预约消息
            [self getReserveRecordByReserveId:msgModel.message_id];
            
        }else if ([msgModel.message_type isEqualToString:UpdateReserveRecord]){
            //修改预约提醒
            NSString *oldReserveId = [msgModel.message_id componentsSeparatedByString:@","][0];
            NSString *newReserveId = [msgModel.message_id componentsSeparatedByString:@","][1];
            // 1.根据旧的预约id，更新预约信息的状态
            LocalNotification *oldNoti = [[DBManager shareInstance] getLocalNotificationWithCkeyId:oldReserveId];
            if (oldNoti != nil) {
                oldNoti.reserve_status = @"1";
                [[LocalNotificationCenter shareInstance] removeLocalNotification:oldNoti];
            }
            // 2.根据新的预约id，下载最新的预约信息保存到本地
            [self getReserveRecordByReserveId:newReserveId];
        }else if ([msgModel.message_type isEqualToString:CancelReserveRecord]){
            //删除预约
            NSString *reserve_id = [msgModel.message_id componentsSeparatedByString:@","][1];
            // 1.删除本地的预约信息
            LocalNotification *localNoti = [[DBManager shareInstance] getLocalNotificationWithCkeyId:reserve_id];
            if (localNoti != nil) {
                [[LocalNotificationCenter shareInstance] cancelNotification:localNoti];
                [[DBManager shareInstance] deleteLocalNotification_Sync:localNoti];
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationDeleted object:nil];
            }
        }
    }
}

#pragma mark - 请求预约信息
+ (void)getReserveRecordByReserveId:(NSString *)reserve_id{
    
    //判断本地是否有这条预约消息
    LocalNotification *noti = [[DBManager shareInstance] getLocalNotificationWithCkeyId:reserve_id];
    if (noti != nil) return;
    
    [SysMessageTool getReserveRecordByReserveId:reserve_id success:^(CRMHttpRespondModel *respond) {
        if ([respond.code integerValue] == 200) {
            //将预约信息保存到本地
            LocalNotification *local = [LocalNotification LNFromLNFResult:respond.result];
            [[DBManager shareInstance] insertLocalNotification:local];
            
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCreated object:nil];
            //判断患者是否存在
            Patient *patient = [[DBManager shareInstance] getPatientCkeyid:local.patient_id];
            if (patient == nil) {
                //获取所有的患者信息，同时保存到本地
                [MyPatientTool getPatientAllInfosWithPatientId:local.patient_id doctorID:[AccountManager currentUserid] success:^(CRMHttpRespondModel *respond) {
                    if ([respond.code integerValue] == 200) {
                        NSMutableArray *arrayM = [NSMutableArray array];
                        for (NSDictionary *dic in respond.result) {
                            XLPatientTotalInfoModel *model = [XLPatientTotalInfoModel objectWithKeyValues:dic];
                            [arrayM addObject:model];
                        }
                        //请求成功后缓存患者信息
                        [[DBManager shareInstance] saveAllDownloadPatientInfoWithPatientModel:arrayM[0]];
                        [[NSNotificationCenter defaultCenter] postNotificationName:PatientCreatedNotification object:nil];
                    }
                } failure:^(NSError *error) {
                    if (error) {
                        NSLog(@"error:%@",error);
                    }
                }];
            }
        }
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

@end
