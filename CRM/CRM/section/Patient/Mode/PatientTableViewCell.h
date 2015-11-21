//
//  PatientTableViewCell.h
//  CRM
//
//  Created by mac on 14-5-13.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientTableViewCell : UITableViewCell
{
    float cellHeight;
}

@property (nonatomic, retain) UILabel * year_lable;
@property (nonatomic, retain) UILabel * month_lable;
@property (nonatomic, retain) UILabel * day_lable;
@property (nonatomic, retain) UIImageView * CTImageView;
@property (nonatomic, retain) UILabel * CTInfo_View;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withHeight:(float)height;
@end
