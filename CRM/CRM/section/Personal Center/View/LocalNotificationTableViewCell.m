//
//  LocalNotificationTableViewCell.m
//  CRM
//
//  Created by TimTiger on 14-8-30.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "LocalNotificationTableViewCell.h"

@implementation LocalNotificationTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    [self.editButton addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCell:selected:)]) {
        [self.delegate didSelectCell:self selected:selected];
    }
    // Configure the view for the selected state
}


- (void)editButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editButtonSelected:)]) {
        [self.delegate editButtonSelected:self];
    }
}

@end
