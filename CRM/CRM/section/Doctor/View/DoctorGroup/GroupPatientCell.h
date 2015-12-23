//
//  GroupPatientCell.h
//  CRM
//
//  Created by Argo Zhang on 15/12/9.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupPatientModel,GroupPatientCell,GroupMemberModel;
@protocol GroupPatientCellDelegate <NSObject>

@optional
- (void)didChooseCell:(GroupPatientCell *)cell withChooseStatus:(BOOL)status;

@end

@interface GroupPatientCell : UITableViewCell

@property (nonatomic, strong)GroupMemberModel *model;

@property (nonatomic, assign)BOOL isManage;//是管理分组

@property (nonatomic, weak)id<GroupPatientCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
