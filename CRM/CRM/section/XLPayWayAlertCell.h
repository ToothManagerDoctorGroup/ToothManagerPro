//
//  XLPayWayAlertCell.h
//  CRM
//
//  Created by Argo Zhang on 16/6/23.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLPayWayAlertCell : UITableViewCell

@property (nonatomic, strong)UIImageView *logoImageView;
@property (nonatomic, strong)UILabel *contentLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
