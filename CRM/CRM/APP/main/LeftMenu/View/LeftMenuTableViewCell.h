//
//  LeftMenuTableViewCell.h
//  CRM
//
//  Created by doctor on 14-6-26.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuTableViewCell : UITableViewCell
{
    UIImageView *_leftImageView;
    UILabel *_rightLabel;
}
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UILabel *rightLabel;
@end
