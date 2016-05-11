//
//  XLSearchRecordCell.h
//  CRM
//
//  Created by Argo Zhang on 16/5/5.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLChatModel;
@interface XLSearchRecordCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)XLChatModel *model;

- (void)setSearchText:(NSString *)seachText model:(XLChatModel *)model;

+ (CGFloat)contentMaxWidth;

@end
