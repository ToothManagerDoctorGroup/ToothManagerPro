//
//  UnSignClinicCell.h
//  CRM
//
//  Created by Argo Zhang on 15/11/12.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UnSignClinicModel;
@interface UnSignClinicCell : UITableViewCell

//数据模型
@property (nonatomic, strong)UnSignClinicModel *model;


//根据tableView的重用机制创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
