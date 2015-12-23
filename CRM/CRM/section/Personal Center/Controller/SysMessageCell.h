//
//  SysMessageCell.h
//  CRM
//
//  Created by Argo Zhang on 15/12/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AttainNewPatient @"AttainNewPatient"
#define AttainNewFriend @"AttainNewFriend"

@class SysMessageModel;
@interface SysMessageCell : UITableViewCell

@property (nonatomic, strong)SysMessageModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
