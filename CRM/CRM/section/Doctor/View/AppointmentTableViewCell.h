//
//  AppointmentTableViewCell.h
//  CRM
//
//  Created by Argo Zhang on 15/12/21.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentTableViewCell : UITableViewCell
@property (nonatomic, copy)NSString *time;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
