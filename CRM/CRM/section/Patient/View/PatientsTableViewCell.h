//
//  PatientsTableViewCell.h
//  CRM
//
//  Created by TimTiger on 10/21/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientsCellMode.h"

@interface PatientsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *countMaterial;
@property (weak, nonatomic) IBOutlet UILabel *transferLabel;
@property (weak, nonatomic) IBOutlet UIImageView *zhuanZhenImageview;


- (void)configCellWithCellMode:(PatientsCellMode *)mode;

@end
