//
//  XLStarSelectCell.h
//  CRM
//
//  Created by Argo Zhang on 16/2/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLStarSelectCell : UITableViewCell

@property (nonatomic, assign)NSInteger level;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
