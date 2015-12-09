//
//  DoctorGroupTableCell.h
//  CRM
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorGroupTableCell : UITableViewCell

@property (nonatomic, copy)NSString *name;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
