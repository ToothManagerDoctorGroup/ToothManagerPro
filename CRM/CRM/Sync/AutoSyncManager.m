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

//同步
- (void)autoSyncInsert{
    //上传状态（0：未上传 1：上传中 2：上传成功 3：上传失败）
    //查询所有insert类型和同步状态为0和3的数据
    NSArray *syncArray = [[DBManager shareInstance] getInfoListWithPostType:@"update" syncStatus:@"0,3"];
    if (syncArray.count > 0) {
        for (InfoAutoSync *info in syncArray) {
            [[DBManager shareInstance] updateInfoWithSyncStatus:@"1" byInfoId:info.info_id];
            
            if ([info.data_type isEqualToString:AutoSync_Patient]) {
                //上传需要更新的患者信息
                Patient *patient = [Patient objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
//                 [[CRMHttpRequest shareInstance] editAllNeedSyncPatient:@[patient]];
            }
        }
    }
}

@end
