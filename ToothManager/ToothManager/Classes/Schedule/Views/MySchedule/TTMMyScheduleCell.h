//
//  TTMMyScheduleCell.h
//  ToothManager
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMScheduleCellModel.h"
/**
 *  日程表cell
 */
@interface TTMMyScheduleCell : UITableViewCell
/**
 *  cell工厂发发
 *
 *  @param tableView tableView description
 *
 *  @return return value description
 */
+ (instancetype)scheduleCellWithTableView:(UITableView *)tableView;
/**
 *  数据model
 */
@property (nonatomic, strong) TTMScheduleCellModel *model;
@end
