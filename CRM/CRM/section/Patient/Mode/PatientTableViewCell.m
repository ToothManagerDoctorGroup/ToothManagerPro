//
//  PatientTableViewCell.m
//  CRM
//
//  Created by mac on 14-5-13.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "PatientTableViewCell.h"

@implementation PatientTableViewCell
@synthesize year_lable,month_lable,day_lable,CTImageView,CTInfo_View;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        [self initView];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withHeight:(float)height
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        cellHeight = height;
        [self initView];
    }
    return self;
}

- (void)initView
{
    //contentView是整个cell的最下面一层
    UIView * contentView = [[UIView alloc]init];
    [contentView setFrame:CGRectMake(0, 0, self.frame.size.width, cellHeight)];
    [contentView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:contentView];
    
    float mag_x = 10.0;
    float mag_y = 12.0;
    float lable_height = 18.0f;
    float lable_width = 50 - mag_x;
    UIColor * textColor = [UIColor whiteColor];
    
    day_lable = [[UILabel alloc]init];
    [day_lable setFrame:CGRectMake(mag_x, mag_y, lable_width, lable_height)];
    [day_lable setBackgroundColor:[UIColor clearColor]];
    [day_lable setTextAlignment:NSTextAlignmentCenter];
    [day_lable setTextColor:textColor];
    [day_lable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0f]];
    [contentView addSubview:day_lable];
    
    UILabel * line1_lable = [[UILabel alloc]init];
    [line1_lable setFrame:CGRectMake(day_lable.frame.origin.x,
                                     day_lable.frame.size.height + day_lable.frame.origin.y,
                                     lable_width,
                                     lable_height)];
    [line1_lable setBackgroundColor:[UIColor clearColor]];
    [line1_lable setTextAlignment:NSTextAlignmentCenter];
    [line1_lable setText:@"/"];
    [line1_lable setTextColor:textColor];
    [line1_lable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0f]];
    [contentView addSubview:line1_lable];
    
    month_lable = [[UILabel alloc]init];
    [month_lable setFrame:CGRectMake(day_lable.frame.origin.x,
                                     line1_lable.frame.size.height + line1_lable.frame.origin.y,
                                     lable_width,
                                     lable_height)];
    [month_lable setBackgroundColor:[UIColor clearColor]];
    [month_lable setTextAlignment:NSTextAlignmentCenter];
    [month_lable setTextColor:textColor];
    [month_lable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0f]];
    [contentView addSubview:month_lable];
    
    UILabel * line2_lable = [[UILabel alloc]init];
    [line2_lable setFrame:CGRectMake(day_lable.frame.origin.x,
                                     month_lable.frame.size.height + month_lable.frame.origin.y,
                                     lable_width,
                                     lable_height)];
    [line2_lable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0f]];
    [line2_lable setBackgroundColor:[UIColor clearColor]];
    [line2_lable setTextAlignment:NSTextAlignmentCenter];
    [line2_lable setText:@"/"];
    [line2_lable setTextColor:textColor];
    [contentView addSubview:line2_lable];
    
    year_lable = [[UILabel alloc]init];
    [year_lable setFrame:CGRectMake(day_lable.frame.origin.x,
                                     line2_lable.frame.size.height + line2_lable.frame.origin.y,
                                     lable_width,
                                     lable_height)];
    [year_lable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0f]];
    [year_lable setBackgroundColor:[UIColor clearColor]];
    [year_lable setTextColor:textColor];
    [contentView addSubview:year_lable];
    
    float right_width = 250.0f;
    float right_mag_x = 10.0f;
    float right_height = lable_height * 5;
    
    //此处的意思是直接设置rightView的边框，使之看上去有效果图的效果，就不用Quartz去画了
    UIView * rightView = [[UIView alloc]init];
    [rightView setFrame:CGRectMake(50, mag_y, right_width, right_height)];
    [rightView setBackgroundColor:[UIColor clearColor]];
    //设置边框
    [rightView.layer setBorderWidth:1.0f];
    [rightView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [rightView.layer setMasksToBounds:YES];
    [contentView addSubview:rightView];
    
    CTImageView = [[UIImageView alloc]init];
    [CTImageView setFrame:CGRectMake(right_mag_x,
                                     right_mag_x,
                                     right_height - 2*right_mag_x,
                                     right_height - 2*right_mag_x)];  //110 -20
    [CTImageView setBackgroundColor:[UIColor blackColor]];
    [rightView addSubview:CTImageView];
    
    float CTInfo_width = CTImageView.frame.size.width + CTImageView.frame.origin.x + 5;
    CTInfo_View = [[UILabel alloc]init];
    [CTInfo_View setFrame:CGRectMake(CTImageView.frame.size.width + CTImageView.frame.origin.x + 5,
                                     CTImageView.frame.origin.y,
                                     right_width - CTInfo_width - 5,
                                     right_height - 2*right_mag_x)];
    [CTInfo_View setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
    [CTInfo_View setNumberOfLines:0];
    [CTInfo_View setLineBreakMode:NSLineBreakByCharWrapping];
    [CTInfo_View setTextColor:textColor];
    [CTInfo_View setBackgroundColor:[UIColor clearColor]];
    [rightView addSubview:CTInfo_View];
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
