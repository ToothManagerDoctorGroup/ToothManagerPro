//
//  ScheduleReminderCell.m
//  CRM
//
//  Created by doctor on 14/10/23.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "ScheduleReminderCell.h"

@implementation ScheduleReminderCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
        
        _personLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 50, 20)];
        _personLabel.backgroundColor = [UIColor clearColor];
        _personLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_personLabel];
        
        _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 80, 20)];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_statusLabel];
        
        _medical_chairLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 10, 100, 20)];
        _medical_chairLabel.backgroundColor = [UIColor clearColor];
        _medical_chairLabel.textAlignment = NSTextAlignmentCenter;
        _medical_chairLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_medical_chairLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 10, 65, 20)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_timeLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
