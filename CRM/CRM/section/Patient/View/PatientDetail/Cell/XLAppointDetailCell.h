//
//  XLAppointDetailCell.h
//  CRM
//
//  Created by Argo Zhang on 16/1/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLAppointDetailModel;
@interface XLAppointDetailCell : UITableViewCell

@property (nonatomic, strong)XLAppointDetailModel *model;
@property (nonatomic, assign)BOOL ShowAccessoryView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
