//
//  SysMessageCell.h
//  CRM
//
//  Created by Argo Zhang on 15/12/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

//新增患者
#define AttainNewPatient @"AttainNewPatient"
//新的好友
#define AttainNewFriend @"AttainNewFriend"
//取消预约
#define CancelReserveRecord @"CancelReserveRecord"
//修改预约
#define UpdateReserveRecord @"UpdateReserveRecord"
//新增预约
#define InsertReserveRecord @"InsertReserveRecord"

@class SysMessageModel;
@interface SysMessageCell : UITableViewCell

@property (nonatomic, strong)SysMessageModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
