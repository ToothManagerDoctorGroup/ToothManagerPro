//
//  XLEditGroupCell.h
//  CRM
//
//  Created by Argo Zhang on 16/3/25.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLEditGroupCell,DoctorGroupModel;
@protocol XLEditGroupCellDelegate <NSObject>

@optional
- (void)editGroupCell:(XLEditGroupCell *)cell didSelect:(BOOL)isSelect;

@end

@interface XLEditGroupCell : UITableViewCell

@property (nonatomic, weak)id<XLEditGroupCellDelegate> delegate;

@property (nonatomic, strong)DoctorGroupModel *model;

+ (NSInteger)fixHeight;
- (void)selectOption;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
