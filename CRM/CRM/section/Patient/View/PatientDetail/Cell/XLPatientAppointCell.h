//
//  XLPatientAppointCell.h
//  CRM
//
//  Created by Argo Zhang on 16/1/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocalNotification;
@interface XLPatientAppointCell : UITableViewCell

@property (nonatomic, strong)LocalNotification *localNoti;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
