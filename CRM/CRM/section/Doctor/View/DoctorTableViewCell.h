//
//  DoctorTableViewCell.h
//  CRM
//
//  Created by fankejun on 14-9-26.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendNotification.h"

@class AvatarView,Doctor,FriendNotification,DoctorInfoModel;
@protocol DoctorTableViewCellDelegate;
@interface DoctorTableViewCell : UITableViewCell

@property (nonatomic,assign) id <DoctorTableViewCellDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel *doctorNameLable;
@property (retain, nonatomic) IBOutlet UILabel *professionalLable;
@property (retain, nonatomic) IBOutlet UILabel *departmentLable;
@property (weak, nonatomic) IBOutlet AvatarView *avatarButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *refuseButton;
@property (weak, nonatomic) IBOutlet UIButton *approveButton;
- (IBAction)addDoctorAction:(id)sender;
- (IBAction)refuseIntroducerAction:(id)sender;
- (IBAction)approveIntroducerAction:(id)sender;

- (void)setCellWithMode:(Doctor *)doctor;
- (void)setCellWithSquareMode:(Doctor *)doctor;
- (void)setCellWithFrienNotifi:(FriendNotificationItem *)notifiItem;
@end

@protocol DoctorTableViewCellDelegate  <NSObject>

@optional
- (void)addButtonDidSelected:(id)sender;
- (void)approveButtonDidSelected:(id)sender;
- (void)refuseButtonDidSelected:(id)sender;
- (void)headerDidSelected:(id)sender;

@end