//
//  LeftMenuTableViewCell.m
//  CRM
//
//  Created by doctor on 14-6-26.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "LeftMenuTableViewCell.h"

@implementation LeftMenuTableViewCell
@synthesize leftImageView = _leftImageView;
@synthesize rightLabel = _rightLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20,10, 20, 20)];
        _leftImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_leftImageView];
        
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(60,0, 120, 40)];
        _rightLabel.textAlignment = NSTextAlignmentLeft;
        _rightLabel.textColor = [UIColor whiteColor];
        _rightLabel.font = [UIFont systemFontOfSize:16.0f];
        _rightLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_rightLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
