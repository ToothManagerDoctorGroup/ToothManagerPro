//
//  XLCommonDoctorCell.m
//  CRM
//
//  Created by Argo Zhang on 16/3/18.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLCommonDoctorCell.h"
#import "UIView+SDAutoLayout.h"
#import "XLAvatarView.h"
#import "FriendNotification.h"
#import "AccountManager.h"
#import "UIColor+Extension.h"
#import "DBManager+Doctor.h"

#define BUTTON_TITLT_FONT [UIFont systemFontOfSize:14]
#define BUTTON_TITLE_COLOR MyColor(15, 166, 255)
#define NAME_TEXT_COLOR MyColor(15, 166, 255)
#define CONTENT_TEXT_COLOR [UIColor colorWithHex:0x888888]
#define NAME_FONT [UIFont systemFontOfSize:17]
#define CONTENT_FONT [UIFont systemFontOfSize:14]
#define DESC_FONT [UIFont systemFontOfSize:15]
#define DESC_COLOR [UIColor blackColor]

@interface XLCommonDoctorCell (){
    XLAvatarView *_iconImageView; //头像
    UILabel *_nameLabel; //名称
    UILabel *_contentLabel;//内容
    UIButton *_addButton;//添加按钮
    UILabel *_descLabel;//描述
}

@end

@implementation XLCommonDoctorCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"common_doctor_cell";
    XLCommonDoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}
#pragma mark - 初始化
- (void)setUp{
    _iconImageView = [[XLAvatarView alloc] init];
    [self.contentView addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = NAME_FONT;
    _nameLabel.textColor = NAME_TEXT_COLOR;
    [self.contentView addSubview:_nameLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = CONTENT_FONT;
    _contentLabel.textColor = CONTENT_TEXT_COLOR;
    [self.contentView addSubview:_contentLabel];
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.layer.cornerRadius = 5;
    _addButton.layer.masksToBounds = YES;
    [_addButton setTitle:@"接受" forState:UIControlStateNormal];
    [_addButton setTitle:@"已接受" forState:UIControlStateSelected];
    [_addButton setTitleColor:BUTTON_TITLE_COLOR forState:UIControlStateNormal];
    _addButton.titleLabel.font = BUTTON_TITLT_FONT;
    [_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_addButton];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.font = DESC_FONT;
    _descLabel.textColor = DESC_COLOR;
    [self.contentView addSubview:_descLabel];
    
    CGFloat margin = 10;
    //自动布局
    _iconImageView.sd_layout
    .widthIs(50)
    .heightIs(50)
    .leftSpaceToView(self.contentView,margin)
    .centerYEqualToView(self.contentView);
    
    _nameLabel.sd_layout
    .widthIs(120)
    .heightIs(25)
    .leftSpaceToView(_iconImageView,margin)
    .topEqualToView(_iconImageView);
    
    _addButton.sd_layout
    .widthIs(65)
    .heightIs(35)
    .rightSpaceToView(self.contentView,margin)
    .centerYEqualToView(self.contentView);
    
    _contentLabel.sd_layout
    .heightIs(20)
    .topSpaceToView(_nameLabel,5)
    .leftEqualToView(_nameLabel)
    .rightSpaceToView(_addButton,margin);
    
    _descLabel.sd_layout
    .heightIs(25)
    .widthIs(100)
    .leftSpaceToView(_nameLabel,0)
    .topEqualToView(_nameLabel);
}

+ (CGFloat)fixHeight{
    return 68.0f;
}

- (void)setNewFriendCellWithFrienNotifi:(FriendNotificationItem *)notifiItem{
    if ([notifiItem.receiver_id isEqualToString:[AccountManager currentUserid]]) {
        _nameLabel.text = notifiItem.doctor_name;
        _contentLabel.text = [NSString stringWithFormat:@"申请成为你的好友"];
        _addButton.backgroundColor = [UIColor colorWithHex:0x01ac36];
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _iconImageView.urlStr = notifiItem.doctor_image;
        _addButton.enabled = YES;
        
        if (notifiItem.notification_status.integerValue == 0) {
            [_addButton setTitle:@"接受" forState:UIControlStateNormal];
        } else if (notifiItem.notification_status.integerValue == 1) {
            [_addButton setTitle:@"已接受" forState:UIControlStateNormal];
            _addButton.backgroundColor = [UIColor clearColor];
            [_addButton setTitleColor:[UIColor colorWithHex:0x01ac36] forState:UIControlStateNormal];
            _addButton.enabled = NO;
        } else if (notifiItem.notification_status.integerValue == 2) {
            [_addButton setTitle:@"已拒绝" forState:UIControlStateNormal];
            _addButton.backgroundColor = [UIColor clearColor];
            [_addButton setTitleColor:[UIColor colorWithHex:0xc80202] forState:UIControlStateNormal];
            _addButton.enabled = NO;
        }
    } else {
        _nameLabel.text = notifiItem.receiver_name;
        _contentLabel.text = [NSString stringWithFormat:@"你向%@发出的好友申请",notifiItem.receiver_name];
        _addButton.backgroundColor = [UIColor colorWithHex:0x01ac36];
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addButton.enabled = YES;
        _iconImageView.urlStr = notifiItem.receiver_image;

        if (notifiItem.notification_status.integerValue == 0) {
            [_addButton setTitle:@"正在验证" forState:UIControlStateNormal];
            _addButton.backgroundColor = [UIColor clearColor];
            [_addButton setTitleColor:[UIColor colorWithHex:0x01ac36] forState:UIControlStateNormal];
            _addButton.enabled = NO;
        } else if (notifiItem.notification_status.integerValue == 1) {
            [_addButton setTitle:@"已通过" forState:UIControlStateNormal];
            _addButton.backgroundColor = [UIColor clearColor];
            [_addButton setTitleColor:[UIColor colorWithHex:0x01ac36] forState:UIControlStateNormal];
            _addButton.enabled = NO;
        } else if (notifiItem.notification_status.integerValue == 2) {
            [_addButton setTitle:@"被拒绝" forState:UIControlStateNormal];
            _addButton.backgroundColor = [UIColor clearColor];
            [_addButton setTitleColor:[UIColor colorWithHex:0xc80202] forState:UIControlStateNormal];
            _addButton.enabled = NO;
        }
    }
}

- (void)setFriendListCellWithModel:(Doctor *)doctor{
    _addButton.hidden = YES;
    _nameLabel.text = doctor.doctor_name;
    _descLabel.text = doctor.doctor_degree;
    _contentLabel.text = [NSString stringWithFormat:@"%@ %@",doctor.doctor_hospital,doctor.doctor_position];
    
    _iconImageView.urlStr = doctor.doctor_image;
}

- (void)setDoctorSquareCellWithModel:(Doctor *)doctor{
    _addButton.backgroundColor = [UIColor colorWithHex:0x01ac36];
    _addButton.layer.cornerRadius = 5.0f;
    [_addButton setTitle:@"添加" forState:UIControlStateNormal];
    [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _nameLabel.text = doctor.doctor_name;
    _addButton.enabled = doctor.isopen;
    
    if (doctor.isExist) {
        [_addButton setBackgroundColor:[UIColor lightGrayColor]];
        [_addButton setTitle:@"已是好友" forState:UIControlStateNormal];
        _addButton.enabled = NO;
    }
    
    _descLabel.text = doctor.doctor_degree;
    _contentLabel.text = [NSString stringWithFormat:@"%@ %@",doctor.doctor_hospital,doctor.doctor_position];
    _iconImageView.urlStr = doctor.doctor_image;
}

#pragma mark - addButtonAction
- (void)addButtonAction:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(commonDoctorCell:addButtonDidSelect:)]) {
        [self.delegate commonDoctorCell:self addButtonDidSelect:button];
    }
}

- (void)setButtonEnable:(BOOL)buttonEnable{
    _buttonEnable = buttonEnable;
    
    if (!buttonEnable) {
        [_addButton setTitle:@"正在验证" forState:UIControlStateNormal];
        [_addButton setBackgroundColor:[UIColor lightGrayColor]];
        _addButton.enabled = NO;
    }
}

@end
