//
//  XLClinicCell.h
//  CRM
//
//  Created by Argo Zhang on 16/5/17.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLClinicModel;
@interface XLClinicCell : UITableViewCell

@property (nonatomic, strong)XLClinicModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

@end

