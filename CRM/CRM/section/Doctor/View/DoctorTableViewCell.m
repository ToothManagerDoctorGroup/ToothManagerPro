//
//  DoctorTableViewCell.m
//  CRM
//
//  Created by fankejun on 14-9-26.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "DoctorTableViewCell.h"
#import "AvatarView.h"
#import "DBTableMode.h"
#import "UIColor+Extension.h"
#import "AccountManager.h"
#import "DBManager+Doctor.h"
#import "UIImageView+WebCache.h"
#import "DoctorInfoModel.h"
#import "XLAvatarBrowser.h"

@implementation DoctorTableViewCell
@synthesize professionalLable,doctorNameLable,departmentLable;

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    self.userInteractionEnabled = YES;
    self.contentView.userInteractionEnabled = YES;
    [self.avatarButton setUrlStr:@""];
    self.addButton.backgroundColor = [UIColor colorWithHex:0x01ac36];
    self.addButton.layer.cornerRadius = 5.0f;
    [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.refuseButton.backgroundColor = [UIColor redColor];
    self.refuseButton.layer.cornerRadius = 5.0f;
    [self.refuseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.approveButton.backgroundColor = [UIColor colorWithHex:0x01ac36];
    self.approveButton.layer.cornerRadius = 5.0f;
    [self.approveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.approveButton.hidden = YES;
    self.refuseButton.hidden = YES;
    
    self.iconImageView.layer.cornerRadius = 25;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.borderWidth = 1;
    self.iconImageView.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
    self.iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.iconImageView addGestureRecognizer:tap];
    
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] init];
//    gesture.numberOfTapsRequired = 1;
//    [gesture addTarget:self action:@selector(avatarButtonAction:)];
//    [self.avatarButton addGestureRecognizer:gesture];
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    [XLAvatarBrowser showImage:self.iconImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    //Configure the view for the selected state
}

- (IBAction)addDoctorAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addButtonDidSelected:)]) {
        [self.delegate addButtonDidSelected:self];
    }
}

- (IBAction)refuseIntroducerAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(approveButtonDidSelected:)]) {
        [self.delegate approveButtonDidSelected:self];
    }
}

- (IBAction)approveIntroducerAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(refuseButtonDidSelected:)]) {
        [self.delegate refuseButtonDidSelected:self];
    }
}

- (void)avatarButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerDidSelected:)]) {
        [self.delegate headerDidSelected:self];
    }
}


-(void)setCellWithSquareMode:(Doctor *)doctor{
    self.addButton.backgroundColor = [UIColor colorWithHex:0x01ac36];
    self.addButton.layer.cornerRadius = 5.0f;
    [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    
    self.doctorNameLable.text = doctor.doctor_name;
    //self.professionalLable.text = doctor.doctor_position;
    //self.departmentLable.text = doctor.doctor_hospital;
    self.addButton.enabled = doctor.isopen;
    
//    NSArray *array = [[DBManager shareInstance] getAllDoctor];
//    for(Doctor *doc in array){
//        if([doc.doctor_name isEqualToString:doctor.doctor_name]){
//            [self.addButton setBackgroundColor:[UIColor lightGrayColor]];
//            [self.addButton setTitle:@"已是好友" forState:UIControlStateNormal];
//            self.addButton.enabled = NO;
//        }
//    }
    
    if (doctor.isExist) {
        [self.addButton setBackgroundColor:[UIColor lightGrayColor]];
        [self.addButton setTitle:@"已是好友" forState:UIControlStateNormal];
        self.addButton.enabled = NO;
    }
    
    
    self.professionalLable.text = doctor.doctor_degree;
    self.departmentLable.text = [NSString stringWithFormat:@"%@ %@",doctor.doctor_hospital,doctor.doctor_position];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:doctor.doctor_image] placeholderImage:[UIImage imageNamed:@"user_icon"]];
}

- (void)setCellWithMode:(Doctor *)doctor {
    self.doctorNameLable.text = doctor.doctor_name;
    self.addButton.enabled = doctor.isopen;
    self.professionalLable.text = doctor.doctor_degree;
    self.departmentLable.text = [NSString stringWithFormat:@"%@ %@",doctor.doctor_hospital,doctor.doctor_position];

    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:doctor.doctor_image] placeholderImage:[UIImage imageNamed:@"user_icon"]];
}

- (void)setCellWithFrienNotifi:(FriendNotificationItem *)notifiItem {
    
    if ([notifiItem.receiver_id isEqualToString:[AccountManager currentUserid]]) {
        self.doctorNameLable.text = notifiItem.doctor_name;
        self.departmentLable.text = [NSString stringWithFormat:@"申请成为你的好友"];
        self.addButton.backgroundColor = [UIColor colorWithHex:0x01ac36];
        [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.iconImageView sd_setImageLoadingWithURL:[NSURL URLWithString:notifiItem.doctor_image] placeholderImage:[UIImage imageNamed:@"user_icon"]];
        self.addButton.enabled = YES;
//        if (notifiItem.notification_type.integerValue == 1) {
            if (notifiItem.notification_status.integerValue == 0) {
                [self.addButton setTitle:@"接受" forState:UIControlStateNormal];
            } else if (notifiItem.notification_status.integerValue == 1) {
                [self.addButton setTitle:@"已接受" forState:UIControlStateNormal];
                self.addButton.backgroundColor = [UIColor clearColor];
                [self.addButton setTitleColor:[UIColor colorWithHex:0x01ac36] forState:UIControlStateNormal];
                self.addButton.enabled = NO;
            } else if (notifiItem.notification_status.integerValue == 2) {
                [self.addButton setTitle:@"已拒绝" forState:UIControlStateNormal];
                self.addButton.backgroundColor = [UIColor clearColor];
                [self.addButton setTitleColor:[UIColor colorWithHex:0xc80202] forState:UIControlStateNormal];
                self.addButton.enabled = NO;
            }
//        }
    } else {
        self.doctorNameLable.text = notifiItem.receiver_name;
        self.departmentLable.text = [NSString stringWithFormat:@"你向%@发出的好友申请",notifiItem.receiver_name];
        self.addButton.backgroundColor = [UIColor colorWithHex:0x01ac36];
        [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.addButton.enabled = YES;

        [self.iconImageView sd_setImageLoadingWithURL:[NSURL URLWithString:notifiItem.receiver_image] placeholderImage:[UIImage imageNamed:@"user_icon"]];
//        if (notifiItem.notification_type.integerValue == 1) {
            if (notifiItem.notification_status.integerValue == 0) {
                [self.addButton setTitle:@"正在验证" forState:UIControlStateNormal];
                self.addButton.backgroundColor = [UIColor clearColor];
                [self.addButton setTitleColor:[UIColor colorWithHex:0x01ac36] forState:UIControlStateNormal];
                self.addButton.enabled = NO;
            } else if (notifiItem.notification_status.integerValue == 1) {
                [self.addButton setTitle:@"已通过" forState:UIControlStateNormal];
                self.addButton.backgroundColor = [UIColor clearColor];
                [self.addButton setTitleColor:[UIColor colorWithHex:0x01ac36] forState:UIControlStateNormal];
                self.addButton.enabled = NO;
            } else if (notifiItem.notification_status.integerValue == 2) {
                [self.addButton setTitle:@"被拒绝" forState:UIControlStateNormal];
                self.addButton.backgroundColor = [UIColor clearColor];
                [self.addButton setTitleColor:[UIColor colorWithHex:0xc80202] forState:UIControlStateNormal];
                self.addButton.enabled = NO;
            }
//        }
    }
}

@end
