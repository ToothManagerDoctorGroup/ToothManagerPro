//
//  MaterialTableViewCell.m
//  CRM
//
//  Created by mac on 14-5-14.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "MaterialTableViewCell.h"

@implementation MaterialTableViewCell
@synthesize imageView,info_lable,price_label,type_label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadCellView];
    }
    return self;
}

- (void)loadCellView{
    float width = 120.0f;
    float height = 30.0f;
    float mag_x = 10.0f;
    float mag_y = 7.0f;
    UIColor * color = [UIColor blackColor];
    
    imageView = [[UIImageView alloc]init];
    [imageView setFrame:CGRectMake(mag_x, mag_y, height, height)];
    [self addSubview:imageView];
    
    info_lable = [[UILabel alloc]init];
    [info_lable setFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 5,
                                    imageView.frame.origin.y,
                                    100,
                                    height)];
    [info_lable setBackgroundColor:[UIColor clearColor]];
    [info_lable setTextColor:color];
    [self addSubview:info_lable];
    
    price_label = [[UILabel alloc]init];
    [price_label setFrame:CGRectMake(info_lable.frame.origin.x + info_lable.frame.size.width + 30,
                                    imageView.frame.origin.y,
                                    80,
                                    height)];
    [price_label setBackgroundColor:[UIColor clearColor]];
    [price_label setTextColor:color];
    [self addSubview:price_label];
    
    type_label = [[UILabel alloc]init];
    [type_label setFrame:CGRectMake(price_label.frame.origin.x + price_label.frame.size.width + 5,
                                     imageView.frame.origin.y,
                                     70,
                                     height)];
    [type_label setBackgroundColor:[UIColor clearColor]];
    [type_label setTextColor:color];
    [self addSubview:type_label];
    
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
