//
//  XLClinicImagesCell.h
//  CRM
//
//  Created by Argo Zhang on 16/5/24.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClinicDetailModel;
@interface XLClinicImagesCell : UITableViewCell

@property (nonatomic, copy)ClinicDetailModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
