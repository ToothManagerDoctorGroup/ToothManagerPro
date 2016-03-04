//
//  XLTreatPlanCell.h
//  CRM
//
//  Created by Argo Zhang on 16/3/2.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLTreatPlanCell : UITableViewCell

@property (nonatomic, copy)NSString *step;//步骤

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
