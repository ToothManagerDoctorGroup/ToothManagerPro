//
//  XLSeniorStatisticCell.h
//  CRM
//
//  Created by Argo Zhang on 16/1/22.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLSeniorStatisticCell : UITableViewCell

@property (nonatomic, strong)NSArray *dataList;
@property (nonatomic, copy)NSString *title;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
