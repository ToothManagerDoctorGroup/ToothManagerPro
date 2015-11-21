//
//  PeopleInfoCell.m
//  CRM
//
//  Created by fankejun on 14-5-13.
//  Copyright (c) 2014年 mifeo. All rights reserved.
//

#import "PeopleInfoCell.h"

@implementation PeopleInfoCell
@synthesize imageView,name_lable,tele_lable,info_lable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self loadCellView];
    }
    return self;
}

- (void)loadCellView{
    float width = 100.0f;
    float height = 30.0f;
    float mag_x = 10.0f;
    float mag_y = 7.0f;
    UIColor * color = [UIColor whiteColor];
    NSTextAlignment alignment = NSTextAlignmentLeft;
    
    imageView = [[UIImageView alloc]init];
    [imageView setFrame:CGRectMake(mag_x, mag_y, height, height)];
    [self addSubview:imageView];
    
    name_lable = [[UILabel alloc]init];
    [name_lable setFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 10,
                                    imageView.frame.origin.y,
                                    width - 20,
                                    height)];
    [name_lable setBackgroundColor:[UIColor clearColor]];
    [name_lable setTextColor:color];
    [name_lable setTextAlignment:alignment];
    [self addSubview:name_lable];
    
    info_lable = [[UILabel alloc]init];
    [info_lable setFrame:CGRectMake(name_lable.frame.origin.x + name_lable.frame.size.width,
                                    imageView.frame.origin.y,
                                    width - 20,
                                    height)];
    [info_lable setBackgroundColor:[UIColor clearColor]];
    [info_lable setTextColor:color];
    [info_lable setTextAlignment:alignment];
    [self addSubview:info_lable];
    
    tele_lable = [[UILabel alloc]init];
    [tele_lable setFrame:CGRectMake(info_lable.frame.size.width + info_lable.frame.origin.x,
                                    imageView.frame.origin.y,
                                    width + 20,
                                    height)];
    [tele_lable setBackgroundColor:[UIColor clearColor]];
    [tele_lable setTextColor:color];
    [tele_lable setTextAlignment:alignment];
    [self addSubview:tele_lable];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
