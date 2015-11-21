//
//  LocalNotificationTableViewCell.h
//  CRM
//
//  Created by TimTiger on 14-8-30.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LocalNotificationTableViewCellDelegate;
@interface LocalNotificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *firedateLabel;
@property (nonatomic,assign) id <LocalNotificationTableViewCellDelegate> delegate;
@end

@protocol LocalNotificationTableViewCellDelegate <NSObject>

- (void)editButtonSelected:(UITableViewCell *)cell;
- (void)didSelectCell:(UITableViewCell *)cell selected:(BOOL)selected;
@end
