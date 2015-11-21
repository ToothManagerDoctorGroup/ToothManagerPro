//
//  PatientInfoCellTableViewCell.m
//  CRM
//
//  Created by fankejun on 15/5/7.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "PatientInfoCellTableViewCell.h"

@implementation PatientInfoCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithPatientNotifi:(InPatientNotificationItem *)notifiItem
{
    UIImage *defaultImage = [UIImage imageNamed:@""];
    //设置iamgeView圆角
    [self.imageView.layer setCornerRadius:8];
    [self.imageView.layer setMasksToBounds:YES];
    [self.imageView setImage:defaultImage];
    [self.imageView setContentMode:UIViewContentModeCenter];
    
    if (notifiItem != nil) {
        [self.nameLabel setText:notifiItem.doctor_info_name];
        [self.patientNameLabel setText:notifiItem.patient_name];
        NSString *timeString = notifiItem.intro_time;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:timeString];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        NSString *time = [formatter stringFromDate:date];
        [self.syncLabel setText:time];
    }
}

@end
