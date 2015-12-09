//
//  TTMMyScheduleCell.m
//  ToothManager
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 roger. All rights reserved.
//

#import "TTMMyScheduleCell.h"

#define kFontSize 14
#define kTextColor [UIColor blackColor]
#define kContentTextColor [UIColor redColor]

#define kTimeImageW 15.f
#define kMargin 10.f
#define kContenWidth ((ScreenWidth - 5 * kMargin) / 4)
#define kRowHeight 44.0f

@interface TTMMyScheduleCell ()
@property (nonatomic, weak)UILabel *timeLabel;//时间
@property (nonatomic, weak)UIImageView *doctorIconView;//默认头像
@property (nonatomic, weak)UILabel *doctorNameLabel;//医生姓名
@property (nonatomic, weak)UILabel *chairNameLabel;//椅位名称
@property (nonatomic, weak)UILabel *patientNameLabel;//患者姓名
@property (nonatomic, weak)UILabel *contentLabel;//内容
@property (nonatomic, weak)UIView *separatorView; // 分隔线


@end

@implementation TTMMyScheduleCell

+ (instancetype)scheduleCellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"CellID";
    TTMMyScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

/**
 *  加载视图
 */
- (void)setup {
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:kFontSize];
    timeLabel.adjustsFontSizeToFitWidth = YES;
    timeLabel.textColor = kTextColor;
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    //默认头像
    UIImageView *doctorIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doctor"]];
    [self.contentView addSubview:doctorIconView];
    self.doctorIconView = doctorIconView;
    
    //医生姓名
    UILabel *doctorNameLabel = [[UILabel alloc] init];
    doctorNameLabel.adjustsFontSizeToFitWidth = YES;
    doctorNameLabel.font = [UIFont systemFontOfSize:kFontSize];
    doctorNameLabel.textColor = kTextColor;
    [self.contentView addSubview:doctorNameLabel];
    self.doctorNameLabel = doctorNameLabel;
    
    //椅位名称
    UILabel *chairNameLabel = [[UILabel alloc] init];
    chairNameLabel.adjustsFontSizeToFitWidth = YES;
    chairNameLabel.font = [UIFont systemFontOfSize:kFontSize];
    chairNameLabel.textColor = kTextColor;
    [self.contentView addSubview:chairNameLabel];
    self.chairNameLabel = chairNameLabel;
    
    //患者姓名
    UILabel *patientNameLabel = [[UILabel alloc] init];
    patientNameLabel.adjustsFontSizeToFitWidth = YES;
    patientNameLabel.font = [UIFont systemFontOfSize:kFontSize];
    patientNameLabel.textColor = kTextColor;
    [self.contentView addSubview:patientNameLabel];
    self.patientNameLabel = patientNameLabel;
    
    //内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:kFontSize];
    contentLabel.textColor = kContentTextColor;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    // 分隔线
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = TableViewCellSeparatorColor;
    separatorView.alpha = TableViewCellSeparatorAlpha;
    [self.contentView addSubview:separatorView];
    self.separatorView = separatorView;
    
}

- (void)setModel:(TTMScheduleCellModel *)model{
    _model = model;
    self.timeLabel.text = [model.appoint_time substringWithRange:NSMakeRange(10, 6)];
    self.doctorNameLabel.text = model.doctor_name;
    self.chairNameLabel.text = [NSString stringWithFormat:@"%@号椅位",model.seat_name];
    self.patientNameLabel.text = model.patient_name;
    self.contentLabel.text = model.appoint_type;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSString *time = [self.model.appoint_time substringWithRange:NSMakeRange(10, 6)];
    NSString *chairName = [NSString stringWithFormat:@"%@号椅位",self.model.seat_name];
    CGSize timeSize = [time sizeWithFont:[UIFont systemFontOfSize:kFontSize]];
    CGSize doctorNameSize = [self.model.doctor_name sizeWithFont:[UIFont systemFontOfSize:kFontSize]];
    CGSize chairNameSize = [chairName sizeWithFont:[UIFont systemFontOfSize:kFontSize]];
    CGSize patientNameSize = [self.model.patient_name sizeWithFont:[UIFont systemFontOfSize:kFontSize]];
    CGSize contentSize = [self.model.appoint_type sizeWithFont:[UIFont systemFontOfSize:kFontSize]];
    
    //计算间隔
    CGFloat margin = (ScreenWidth - kMargin * 2 - timeSize.width - kTimeImageW - doctorNameSize.width - chairNameSize.width - patientNameSize.width - contentSize.width) / 4;
    //设置所有的frame
    self.timeLabel.frame = CGRectMake(kMargin, 0, timeSize.width, kRowHeight);
    self.doctorIconView.frame = CGRectMake(self.timeLabel.right + margin, (kRowHeight - kTimeImageW) / 2, kTimeImageW, kTimeImageW);
    self.doctorNameLabel.frame = CGRectMake(self.doctorIconView.right, 0, doctorNameSize.width, kRowHeight);
    self.chairNameLabel.frame = CGRectMake(self.doctorNameLabel.right + margin, 0, chairNameSize.width, kRowHeight);
    self.patientNameLabel.frame = CGRectMake(self.chairNameLabel.right + margin, 0, patientNameSize.width, kRowHeight);
    self.contentLabel.frame = CGRectMake(self.patientNameLabel.right + margin, 0, contentSize.width, kRowHeight);
}

@end
