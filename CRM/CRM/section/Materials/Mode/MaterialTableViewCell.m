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
    
    CGFloat commonW = kScreenWidth / 3;
    
    float height = 30.0f;
    float mag_x = 10.0f;
    float mag_y = 7.0f;
    UIColor * color = [UIColor blackColor];
    
    imageView = [[UIImageView alloc]init];
    [imageView setFrame:CGRectMake(mag_x, mag_y, height, height)];
    [self addSubview:imageView];
    
    info_lable = [[UILabel alloc]init];
    [info_lable setFrame:CGRectMake(imageView.right + 5,
                                    imageView.frame.origin.y,
                                    commonW - height - mag_x - 5,
                                    height)];
    [info_lable setBackgroundColor:[UIColor clearColor]];
    [info_lable setTextColor:color];
    [self addSubview:info_lable];
    
    price_label = [[UILabel alloc]init];
    [price_label setFrame:CGRectMake(info_lable.right,
                                    imageView.frame.origin.y,
                                    commonW,
                                    height)];
    [price_label setBackgroundColor:[UIColor clearColor]];
    [price_label setTextColor:color];
    price_label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:price_label];
    
    type_label = [[UILabel alloc]init];
    [type_label setFrame:CGRectMake(price_label.right,
                                     imageView.frame.origin.y,
                                     commonW,
                                     height)];
    type_label.textAlignment = NSTextAlignmentCenter;
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
