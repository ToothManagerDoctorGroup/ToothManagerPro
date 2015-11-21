//
//  ClinicCell.h
//  CRM
//
//  Created by Argo Zhang on 15/11/11.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClinicModel;
@interface ClinicCell : UITableViewCell

//数据模型
@property (nonatomic, strong)ClinicModel *model;


//根据tableView的重用机制创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
