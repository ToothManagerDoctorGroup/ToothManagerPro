//
//  DoctorSquareTableViewCell.h
//  CRM
//
//  Created by fankejun on 14-9-28.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorSquareTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *professionaLable;
@property (weak, nonatomic) IBOutlet UILabel *departmanetLable;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end
