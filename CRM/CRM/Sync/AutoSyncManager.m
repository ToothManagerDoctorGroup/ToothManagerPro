//
//  AutoSyncManager.m
//  CRM
//
//  Created by Argo Zhang on 15/12/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "AutoSyncManager.h"
#import "DBManager+AutoSync.h"
#import "AFNetworkReachabilityManager.h"
#import "CRMHttpRequest+Sync.h"
#import "DBTableMode.h"
#import "CRMHttpRequest+Sync.h"
#import "JSONKit.h"
#import "MJExtension.h"
#import "XLAutoSyncTool.h"
#import "XLAutoSyncTool+XLInsert.h"
#import "XLAutoSyncTool+XLDelete.h"
#import "CRMHttpRespondModel.h"

@implementation AutoSyncManager
Realize_ShareInstance(AutoSyncManager);

/**
 *  开始自动同步
 */
- (void)startAutoSync{
    // 检测网络连接状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 连接状态回调处理
    /* AFNetworking的Block内使用self须改为weakSelf, 避免循环强引用, 无法释放 */
    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         switch (status)
         {
             case AFNetworkReachabilityStatusUnknown:
                 // 未知状态
                 NSLog(@"未知");
                 break;
             case AFNetworkReachabilityStatusNotReachable:
                 // 无网络
                 NSLog(@"无网络");
                 break;
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 // 手机自带网络
                 NSLog(@"手机自带网络");
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 // 当有wifi情况下自动进行同步
                 [weakSelf autoSyncInsert];
                 break;
             default:
                 break;
         }
     }];
}
#pragma mark - 将json字符串转换为字典
- (NSDictionary *)dicFromJsonStr:(NSString *)jsonStr{
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    return dic;
}

#pragma mark - 开始insert类型的数据上传
- (void)autoSyncInsert{
    //上传状态（0：未上传 1：上传中 2：上传成功 3：上传失败）
    //查询所有insert类型和同步状态为0和3的数据
    NSArray *syncArray = [[DBManager shareInstance] getInfoListWithPostType:@"update" syncStatus:@"0,3"];
    if (syncArray.count > 0) {
        for (InfoAutoSync *info in syncArray) {
            [[DBManager shareInstance] updateInfoWithSyncStatus:@"1" byInfoId:info.info_id];
            
            //上传患者信息
            if ([info.data_type isEqualToString:AutoSync_Patient]) {
                //上传需要更新的患者信息
                Patient *patient = [Patient objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                 [[XLAutoSyncTool shareInstance] editAllNeedSyncPatient:patient success:^(CRMHttpRespondModel *respond) {
                     if ([respond.code integerValue] == 200) {
                         NSLog(@"患者数据更新成功");
                         //上传成功,删除当前的同步信息
                         if([[DBManager shareInstance] updateInfoWithSyncStatus:@"2" byInfoId:info.info_id]){
                             [[DBManager shareInstance] deleteInfoWithInfoAutoSync:info];
                         };
                         
                     }else{
                         NSLog(@"患者数据更新失败");
                         //上传失败
                         [[DBManager shareInstance] updateInfoWithSyncStatus:@"3" byInfoId:info.info_id];
                     }
                 } failure:^(NSError *error) {
                     //上传失败
                     [[DBManager shareInstance] updateInfoWithSyncStatus:@"3" byInfoId:info.info_id];
                     if (error) {
                         NSLog(@"error:%@",error);
                     }
                 }];
            }
        }
    }
}

@end
