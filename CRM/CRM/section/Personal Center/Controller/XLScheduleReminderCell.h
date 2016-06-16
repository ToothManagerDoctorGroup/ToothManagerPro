//
//  XLScheduleReminderCell.h
//  CRM
//
//  Created by Argo Zhang on 16/2/17.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLScheduleReminderCell : UITableViewCell

@property (strong, nonatomic) UILabel *timeLabel;//时间
@property (strong, nonatomic) UILabel *patientNameLabel;//患者姓名
@property (strong, nonatomic) UILabel *toothLabel;//牙位
@property (strong, nonatomic) UILabel *reserveTypeLabel;//预约事项

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
