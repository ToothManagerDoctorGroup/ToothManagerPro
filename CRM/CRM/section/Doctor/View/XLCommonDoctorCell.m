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

#define BUTTON_TITLE_SELECT @"已接受"
#define BUTTON_TITLE_NORMAL @"接受"
#define BUTTON_TITLT_FONT [UIFont systemFontOfSize:14]
#define BUTTON_TITLE_COLOR MyColor(15, 166, 255)
#define TEXT_COLOR MyColor(15, 166, 255)
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
    _nameLabel.textColor = TEXT_COLOR;
    [self.contentView addSubview:_nameLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = CONTENT_FONT;
    _contentLabel.textColor = TEXT_COLOR;
    [self.contentView addSubview:_contentLabel];
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addButton setTitle:BUTTON_TITLE_NORMAL forState:UIControlStateNormal];
    [_addButton setTitle:BUTTON_TITLE_SELECT forState:UIControlStateSelected];
    [_addButton setTitleColor:BUTTON_TITLE_COLOR forState:UIControlStateNormal];
    _addButton.titleLabel.font = BUTTON_TITLT_FONT;
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
    .widthIs(100)
    .heightIs(25)
    .leftSpaceToView(_iconImageView,margin)
    .topEqualToView(_iconImageView);
    
    _addButton.sd_layout
    .widthIs(65)
    .heightIs(35)
    .rightSpaceToView(self.contentView,margin)
    .centerYEqualToView(self.contentView);
    
    _contentLabel.sd_layout
    .heightIs(25)
    .topSpaceToView(_nameLabel,0)
    .leftEqualToView(_nameLabel)
    .rightSpaceToView(_addButton,margin);
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

@end
