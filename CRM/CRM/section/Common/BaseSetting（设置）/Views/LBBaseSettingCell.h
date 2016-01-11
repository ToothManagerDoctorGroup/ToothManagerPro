//
//  LBBaseSettingCell.h
//  LBWeiBo
//
//  Created by apple on 15/10/5.
//  Copyright (c) 2015年 徐晓龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LBSettingItem;
@interface LBBaseSettingCell : UITableViewCell

@property (nonatomic, strong)LBSettingItem *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
