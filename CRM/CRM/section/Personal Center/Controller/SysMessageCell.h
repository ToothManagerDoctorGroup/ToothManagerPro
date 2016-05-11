//
//  SysMessageCell.h
//  CRM
//
//  Created by Argo Zhang on 15/12/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

//新增患者
extern NSString * const AttainNewPatient;
extern NSString * const AttainNewFriend;
extern NSString * const CancelReserveRecord;
extern NSString * const UpdateReserveRecord;
extern NSString * const InsertReserveRecord;


@class SysMessageModel;
@interface SysMessageCell : UITableViewCell

@property (nonatomic, strong)SysMessageModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeightWithModel:(SysMessageModel *)model;

@end
