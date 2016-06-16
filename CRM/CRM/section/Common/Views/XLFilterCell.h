//
//  XLFilterCell.h
//  CRM
//
//  Created by Argo Zhang on 16/3/31.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLFilterCell : UITableViewCell

@property (nonatomic, strong)UILabel *buttonTitleLabel;

@property (nonatomic, copy)NSString *title;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
