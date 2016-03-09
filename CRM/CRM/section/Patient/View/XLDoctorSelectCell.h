//
//  XLDoctorSelectCell.h
//  CRM
//
//  Created by Argo Zhang on 16/3/8.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLDoctorSelectViewController.h"

@class Doctor,XLDoctorSelectCell;
@protocol XLDoctorSelectCell <NSObject>

@optional
- (void)doctorSelectCell:(XLDoctorSelectCell *)cell withChooseStatus:(BOOL)status;

@end

@interface XLDoctorSelectCell : UITableViewCell

@property (nonatomic, strong)Doctor *doctor;

@property (nonatomic, weak)id<XLDoctorSelectCell> delegate;

@property (nonatomic, assign)DoctorSelectType type;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
