//
//  XLScheduleReminderCell.m
//  CRM
//
//  Created by Argo Zhang on 16/2/17.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLScheduleReminderCell.h"

@implementation XLScheduleReminderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"schedule_cell";
    XLScheduleReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    CGFloat timeW = 50;
    CGFloat commonH = 50;
    CGFloat commonW = (kScreenWidth - 20 * 2 - 50 - 10 * 3) / 3;
    CGFloat margin = 10;
    
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin * 2, 0, timeW, commonH)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_timeLabel];
    
    _patientNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_timeLabel.right + margin, 0, commonW, commonH)];
    _patientNameLabel.backgroundColor = [UIColor clearColor];
    _patientNameLabel.textAlignment = NSTextAlignmentCenter;
    _patientNameLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:_patientNameLabel];
    
    _toothLabel = [[UILabel alloc]initWithFrame:CGRectMake(_patientNameLabel.right + margin, 0, commonW, commonH)];
    _toothLabel.backgroundColor = [UIColor clearColor];
    _toothLabel.textAlignment = NSTextAlignmentCenter;
    _toothLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:_toothLabel];
    
    _reserveTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_toothLabel.right + margin, 0, commonW, commonH)];
    _reserveTypeLabel.backgroundColor = [UIColor clearColor];
    _reserveTypeLabel.textAlignment = NSTextAlignmentCenter;
    _reserveTypeLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:_reserveTypeLabel];
}

@end
