//
//  PatientDetailTableViewCell.m
//  CRM
//
//  Created by TimTiger on 6/6/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "PatientDetailTableViewCell.h"

@implementation PatientDetailTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.ctImageView.layer.cornerRadius = 3.0f;
    self.ctImageView.clipsToBounds = YES;
    self.ctImageView.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
