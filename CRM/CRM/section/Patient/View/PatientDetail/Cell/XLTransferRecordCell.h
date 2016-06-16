//
//  XLTransferRecordCell.h
//  CRM
//
//  Created by Argo Zhang on 16/6/14.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLTransferRecordModel;
@interface XLTransferRecordCell : UITableViewCell

@property (nonatomic, strong)XLTransferRecordModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

@end
