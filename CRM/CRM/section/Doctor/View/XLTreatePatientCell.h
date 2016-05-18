//
//  XLTreatePatientCell.h
//  CRM
//
//  Created by Argo Zhang on 16/3/8.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLTeamPatientModel;
@interface XLTreatePatientCell : UITableViewCell

@property (nonatomic, strong)XLTeamPatientModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
