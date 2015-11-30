//
//  AppointDetailViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/11/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimViewController.h"

@class BillModel,LocalNotification;
@interface AppointDetailViewController : TimViewController

@property (nonatomic, strong)BillModel *model;//账单详情

@property (nonatomic, assign)BOOL isHomeTo;//是首页跳转过来

@property (nonatomic, strong)LocalNotification *localNoti;//本地预约详情的数据

@end
