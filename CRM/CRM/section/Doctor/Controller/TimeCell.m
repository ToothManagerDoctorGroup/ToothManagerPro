//
//  TimeCell.m
//  表格
//
//  Created by zzy on 14-5-7.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import "TimeCell.h"
#import "MyLabel.h"

@implementation TimeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.timeLabel=[[MyLabel alloc]initWithFrame:CGRectMake(17, -1, self.frame.size.width, self.frame.size.height*0.3)];
        [self.timeLabel setVerticalAlignment:VerticalAlignmentTop];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
