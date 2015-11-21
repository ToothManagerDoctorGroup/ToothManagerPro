//
//  RepairDoctorTableViewCell.h
//  CRM
//
//  Created by doctor on 15/4/24.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepairDoctorTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *repairDoctorIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *repairDoctorNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *repairDoctorPhoneNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *patienNumLabel;

@end
