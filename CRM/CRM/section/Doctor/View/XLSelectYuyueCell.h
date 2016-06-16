//
//  XLSelectYuyueCell.h
//  CRM
//
//  Created by Argo Zhang on 15/12/21.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLSelectYuyueCell : UITableViewCell


@property (nonatomic, copy)NSString *time;

@property (nonatomic, strong)NSArray *models;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
