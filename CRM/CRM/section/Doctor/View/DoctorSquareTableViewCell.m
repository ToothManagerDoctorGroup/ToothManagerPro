//
//  DoctorSquareTableViewCell.m
//  CRM
//
//  Created by fankejun on 14-9-28.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "DoctorSquareTableViewCell.h"

@implementation DoctorSquareTableViewCell
@synthesize addButton,nameLable,professionaLable,departmanetLable,headImage;

- (void)awakeFromNib
{
    // Initialization code
    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.layer.borderColor = [[UIColor grayColor]CGColor];
    
    addButton.layer.cornerRadius = 25.0f;
    addButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
