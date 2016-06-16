//
//  XLPatientAppointCell.m
//  CRM
//
//  Created by Argo Zhang on 16/1/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLPatientAppointCell.h"
#import "UIColor+Extension.h"
#import "LocalNotificationCenter.h"
#import "MyDateTool.h"
#import "AccountManager.h"

#define CommonColor [UIColor colorWithHex:0x333333]
#define CommonFont [UIFont systemFontOfSize:15]
@interface XLPatientAppointCell ()

@property (nonatomic, weak)UIImageView *targetImageView;//标示图片
@property (nonatomic, weak)UILabel *timeLabel;//时间
@property (nonatomic, weak)UIButton *doctorNameButton;//医生姓名
@property (nonatomic, weak)UIButton *hospitalNameButton;//医院
@property (nonatomic, weak)UILabel *reserveTypeLabel;//预约事项
@property (nonatomic, weak)UIImageView *arrowImageView;//箭头图片

@property (nonatomic, weak)UIView *lineView;//分割线

@end

@implementation XLPatientAppointCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"appoint_cell";
    XLPatientAppointCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

//初始化
- (void)setUp{
    //标示图片
    UIImageView *targetImageView = [[UIImageView alloc] init];
    self.targetImageView = targetImageView;
    [self.contentView addSubview:targetImageView];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = CommonColor;
    timeLabel.font = CommonFont;
    self.timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    
    //医生姓名
    UIButton *doctorNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doctorNameButton.backgroundColor = [UIColor clearColor];
    [doctorNameButton setTitleColor:CommonColor forState:UIControlStateNormal];
    doctorNameButton.titleLabel.font = CommonFont;
    doctorNameButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    self.doctorNameButton = doctorNameButton;
    [self.contentView addSubview:doctorNameButton];
    
    //医院
    UIButton *hospitalNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hospitalNameButton.backgroundColor = [UIColor clearColor];
    [hospitalNameButton setTitleColor:CommonColor forState:UIControlStateNormal];
    hospitalNameButton.titleLabel.font = CommonFont;
    hospitalNameButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    self.hospitalNameButton = hospitalNameButton;
    [self.contentView addSubview:hospitalNameButton];
    
    //预约事项
    UILabel *reserveTypeLabel = [[UILabel alloc] init];
    reserveTypeLabel.textColor = CommonColor;
    reserveTypeLabel.font = CommonFont;
    self.reserveTypeLabel = reserveTypeLabel;
    [self.contentView addSubview:reserveTypeLabel];
    
    //箭头图片
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_crm"]];
    self.arrowImageView = arrowImageView;
    [self.contentView addSubview:arrowImageView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:VIEWCONTROLLER_BACKGROUNDCOLOR];
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat marginX = 10;
    CGFloat commonH = 20;
    
    
    self.targetImageView.frame = CGRectMake(marginX, 0, 10, self.height);
    
    CGSize timeSize = [self.localNoti.reserve_time sizeWithFont:CommonFont];
    self.timeLabel.frame = CGRectMake(marginX + self.targetImageView.right, marginX, timeSize.width, commonH);
    self.timeLabel.text = self.localNoti.reserve_time;
    
    
    NSString *name = [AccountManager shareInstance].currentUser.name;
    CGSize doctorNameSize = [name sizeWithFont:CommonFont];
    self.doctorNameButton.frame = CGRectMake(marginX + self.targetImageView.right, self.timeLabel.bottom + marginX, doctorNameSize.width + 20 + 15, commonH);
    [self.doctorNameButton setTitle:name forState:UIControlStateNormal];
    
    
    NSString *hospitalName = self.localNoti.medical_place;
    CGSize hospitalNameSize = [hospitalName sizeWithFont:CommonFont];
    self.hospitalNameButton.frame = CGRectMake(marginX + self.targetImageView.right, self.doctorNameButton.bottom + marginX, hospitalNameSize.width + 20 + 15, commonH);
    [self.hospitalNameButton setTitle:hospitalName forState:UIControlStateNormal];
    
    self.arrowImageView.frame = CGRectMake(kScreenWidth - 13 - marginX, (self.height - 18) / 2, 13, 18);
    
    NSString *type = self.localNoti.reserve_type;
    CGSize typeSize = [type sizeWithFont:CommonFont];
    self.reserveTypeLabel.frame = CGRectMake(kScreenWidth - typeSize.width - marginX * 2 - 13, (self.height - commonH) / 2, typeSize.width, commonH);
    self.reserveTypeLabel.text = self.localNoti.reserve_type;
    
    //添加两条分割线
    for (int i = 0; i < 2; i++) {
        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, i * (self.height - 10 - 0.5), kScreenWidth, 0.5)];
        divider.backgroundColor = [UIColor colorWithHex:0xCCCCCC];
        [self.contentView addSubview:divider];
    }
    
    self.lineView.frame = CGRectMake(0, self.height - 10, kScreenWidth, 10);
    
    if ([MyDateTool earlyThanToday:self.localNoti.reserve_time]) {
        //过期
        self.targetImageView.image = [UIImage imageNamed:@"patient_line_grey"];
        [self.doctorNameButton setImage:[UIImage imageNamed:@"patient_doctor_grey"] forState:UIControlStateNormal];
        [self.hospitalNameButton setImage:[UIImage imageNamed:@"patient_address_grey"] forState:UIControlStateNormal];
    }else{
        //未过期
        self.targetImageView.image = [UIImage imageNamed:@"patient_line_blue"];
        [self.doctorNameButton setImage:[UIImage imageNamed:@"patient_doctor_blue"] forState:UIControlStateNormal];
        [self.hospitalNameButton setImage:[UIImage imageNamed:@"patient_address_blue"] forState:UIControlStateNormal];
    }
    
}



@end
