//
//  XLClinicCell.m
//  CRM
//
//  Created by Argo Zhang on 16/5/17.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLClinicCell.h"
#import "UIColor+Extension.h"
#import "XLClinicModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+WXViewController.h"
#import "XLClinicAppointmentViewController.h"
#import "XLClinicsDisplayViewController.h"
#import <Masonry.h>

#define IconHeight 70
#define IconWidth IconHeight
#define CellHeight 90
#define Margin 10
#define ButtonHeight 15

#define Name_TextFont [UIFont systemFontOfSize:18]
#define Name_TextColor [UIColor colorWithHex:0x333333]
#define Address_TextFont [UIFont systemFontOfSize:14]
#define Address_TextColor Name_TextColor
#define Time_TextFont Address_TextFont
#define Time_TextColor Address_TextColor
#define Appoint_TextFont [UIFont systemFontOfSize:15]
#define Appoint_TextColor [UIColor colorWithHex:0xffffff]
#define Appoint_BackgroundColor [UIColor colorWithHex:0x00a0ea]

@interface XLClinicCell ()

@property (nonatomic, strong)UIImageView *iconImageView;//头像
@property (nonatomic, strong)UILabel *nameLabel;//诊所名称
@property (nonatomic, strong)UIButton *addressButton;//诊所地址图标
@property (nonatomic, strong)UIButton *timeButton;//营业时间图标
@property (nonatomic, strong)UIButton *appointButton;//预约时间

@property (nonatomic, strong)UILabel *timeLabel;//营业时间
@property (nonatomic, strong)UILabel *addressLabel;//诊所地址

@end

@implementation XLClinicCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"clinic_cell";
    XLClinicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化
        [self setUp];
    }
    return self;
}
#pragma mark - 初始化
- (void)setUp{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.addressButton];
    [self.contentView addSubview:self.timeButton];
    [self.contentView addSubview:self.appointButton];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.timeLabel];
    
    //设置约束
    [self setUpConstrains];
}

#pragma mark - 设置约束
- (void)setUpConstrains{
    WS(weakSelf);
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(weakSelf.contentView).with.offset(Margin);
        make.size.mas_equalTo(CGSizeMake(IconWidth, IconHeight));
    }];
    
    [self.appointButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.right.mas_equalTo(weakSelf.contentView).with.offset(-Margin);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView.mas_top);
        make.left.equalTo(weakSelf.iconImageView.mas_right).with.offset(Margin);
        make.right.equalTo(weakSelf.appointButton.mas_left).with.offset(-Margin);
        make.height.mas_equalTo(@20);
    }];
    
    [self.addressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).with.offset(Margin);
        make.left.equalTo(weakSelf.iconImageView.mas_right).with.offset(Margin);
        make.size.mas_equalTo(CGSizeMake(ButtonHeight, ButtonHeight));
    }];
    
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.addressButton.mas_bottom).with.offset(Margin / 2);
        make.left.equalTo(weakSelf.iconImageView.mas_right).with.offset(Margin);
        make.size.mas_equalTo(CGSizeMake(ButtonHeight, ButtonHeight));
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.addressButton.mas_top);
        make.left.equalTo(weakSelf.addressButton.mas_right).with.offset(Margin / 2);
        make.right.equalTo(weakSelf.appointButton.mas_left).with.offset(-Margin / 2);
        make.height.mas_equalTo(@ButtonHeight);
    }];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.timeButton.mas_top);
        make.left.equalTo(weakSelf.timeButton.mas_right).with.offset(Margin / 2);
        make.right.equalTo(weakSelf.appointButton.mas_left).with.offset(-Margin / 2);
        make.height.mas_equalTo(@ButtonHeight);
    }];
}

+ (CGFloat)cellHeight{
    return CellHeight;
}

#pragma mark  设置控件内容
- (void)setModel:(XLClinicModel *)model{
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.clinic_img] placeholderImage:[UIImage imageNamed:@"user_icon"]];
    self.nameLabel.text = model.clinic_name;
    self.addressLabel.text = model.clinic_location;
    self.timeLabel.text = model.business_hours;
}

#pragma mark  预约按钮点击事件
- (void)appointButtonAction{
    XLClinicAppointmentViewController *appointVc = [[XLClinicAppointmentViewController alloc] init];
    XLClinicsDisplayViewController *displayVc = (XLClinicsDisplayViewController *)self.viewController;
    if (displayVc.patient) {
        appointVc.patient = displayVc.patient;
    }
    appointVc.clinicModel = self.model;
    appointVc.hidesBottomBarWhenPushed = YES;
    [displayVc.navigationController pushViewController:appointVc animated:YES];
}

#pragma mark - ********************* Lazy Method ***********************
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = IconWidth / 2;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.borderWidth = 1;
        _iconImageView.layer.borderColor = [UIColor colorWithHex:0xcccccc].CGColor;
    }
    return _iconImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = Name_TextFont;
        _nameLabel.textColor = Name_TextColor;
    }
    return _nameLabel;
}

- (UIButton *)addressButton{
    if (!_addressButton) {
        _addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addressButton setImage:[UIImage imageNamed:@"clinic_map"] forState:UIControlStateNormal];
    }
    return _addressButton;
}

- (UIButton *)timeButton{
    if (!_timeButton) {
        _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_timeButton setImage:[UIImage imageNamed:@"clinic_clock"] forState:UIControlStateNormal];;
    }
    return _timeButton;
}

- (UIButton *)appointButton{
    if (!_appointButton) {
        _appointButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_appointButton setTitle:@"预约" forState:UIControlStateNormal];
        [_appointButton setTitleColor:Appoint_TextColor forState:UIControlStateNormal];
        _appointButton.titleLabel.font = Appoint_TextFont;
        _appointButton.backgroundColor = Appoint_BackgroundColor;
        _appointButton.layer.cornerRadius = 5;
        _appointButton.layer.masksToBounds = YES;
        [_appointButton addTarget:self action:@selector(appointButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _appointButton;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = Time_TextFont;
        _timeLabel.textColor = Time_TextColor;
    }
    return _timeLabel;
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = Address_TextFont;
        _addressLabel.textColor = Address_TextColor;
    }
    return _addressLabel;
}

@end
