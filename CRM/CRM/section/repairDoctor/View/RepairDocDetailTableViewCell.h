//
//  RepairDocDetailTableViewCell.h
//  CRM
//
//  Created by doctor on 15/4/24.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepairDocDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *repairStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *repairDoctorLabel;
@property (strong, nonatomic) IBOutlet UILabel *ToothNumLabel;

@end
