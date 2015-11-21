//
//  PatientInfoCellTableViewCell.h
//  CRM
//
//  Created by fankejun on 15/5/7.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InPatientNotification.h"

@interface PatientInfoCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *syncLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTitleLabel;

- (void)setCellWithPatientNotifi:(InPatientNotificationItem *)notifiItem;

@end
