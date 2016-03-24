//
//  XLContactCell.h
//  CRM
//
//  Created by Argo Zhang on 16/3/15.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NVMContact,XLContactCell;
@protocol  XLContactCellDelegate<NSObject>
@optional
- (void)ContactCell:(XLContactCell *)cell didclickAddButton:(UIButton *)button;

@end

@interface XLContactCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)fixedHeight;

@property (nonatomic, strong)NVMContact *contact;

@property (nonatomic, weak)id<XLContactCellDelegate> delegate;



@end

