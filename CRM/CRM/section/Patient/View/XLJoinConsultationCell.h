//
//  XLJoinConsultationCell.h
//  CRM
//
//  Created by Argo Zhang on 16/3/8.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  参与会诊cell
 */
@class XLJoinTeamModel;
@interface XLJoinConsultationCell : UITableViewCell

@property (nonatomic, strong)XLJoinTeamModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
