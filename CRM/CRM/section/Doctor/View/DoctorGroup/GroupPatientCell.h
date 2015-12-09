//
//  GroupPatientCell.h
//  CRM
//
//  Created by Argo Zhang on 15/12/9.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupPatientCell : UITableViewCell


@property (nonatomic, strong)PatientsCellMode *model;

@property (nonatomic, assign)BOOL isChoose;

@property (nonatomic, assign)BOOL isManage;//是管理分组

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
