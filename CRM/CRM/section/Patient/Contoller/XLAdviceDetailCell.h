//
//  XLAdviceDetailCell.h
//  CRM
//
//  Created by Argo Zhang on 16/4/26.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
/**
 *  医嘱详情cell
 */
@class XLAdviceDetailModel;
@interface XLAdviceDetailCell : MGSwipeTableCell

@property (nonatomic, strong)XLAdviceDetailModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)contentMaxWidth;

@end
