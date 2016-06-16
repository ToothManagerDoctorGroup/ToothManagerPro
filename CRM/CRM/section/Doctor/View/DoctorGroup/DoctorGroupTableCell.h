//
//  DoctorGroupTableCell.h
//  CRM
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorGroupModel.h"

@interface DoctorGroupTableCell : UITableViewCell

@property (nonatomic, strong)DoctorGroupModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
