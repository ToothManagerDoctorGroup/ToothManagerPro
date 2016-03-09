//
//  XLTreatPlanCell.h
//  CRM
//
//  Created by Argo Zhang on 16/3/2.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLCureProjectModel;
@interface XLTreatPlanCell : UITableViewCell

@property (nonatomic, strong)XLCureProjectModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
