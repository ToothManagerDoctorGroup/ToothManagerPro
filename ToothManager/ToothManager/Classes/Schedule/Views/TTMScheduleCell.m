//
//  TTMScheduleCell.m
//  ToothManager
//

#import "TTMScheduleCell.h"

#define kFontSize 14
#define kTextColor [UIColor blackColor]
#define kContentTextColor [UIColor redColor]

#define kTimeImageW 15.f
#define kMargin 10.f
#define kContenWidth ((ScreenWidth - 5 * kMargin) / 4)
#define kRowHeight 44.0f

@interface TTMScheduleCell ()

@property (nonatomic, weak) UIImageView *timeImageView;
@property (nonatomic, weak) UILabel *timeLabel; // 时间
@property (nonatomic, weak) UILabel *chairLabel; // 椅位
@property (nonatomic, weak) UILabel *doctorLabel; // 医生
@property (nonatomic, weak) UILabel *contentLabel; // 内容
@property (nonatomic, weak) UIView *separatorView; // 分隔线

@end

@implementation TTMScheduleCell

+ (instancetype)scheduleCellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"CellID";
    TTMScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[TTMScheduleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
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
    UIImageView *timeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schedule_icon_time"]];
    [self.contentView addSubview:timeImageView];
    self.timeImageView = timeImageView;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:kFontSize];
    timeLabel.adjustsFontSizeToFitWidth = YES;
    timeLabel.textColor = kTextColor;
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UILabel *chairLabel = [[UILabel alloc] init];
    chairLabel.adjustsFontSizeToFitWidth = YES;
    chairLabel.font = [UIFont systemFontOfSize:kFontSize];
    chairLabel.textColor = kTextColor;
    [self.contentView addSubview:chairLabel];
    self.chairLabel = chairLabel;
    
    UILabel *doctorLabel = [[UILabel alloc] init];
    doctorLabel.adjustsFontSizeToFitWidth = YES;
    doctorLabel.font = [UIFont systemFontOfSize:kFontSize];
    doctorLabel.textColor = kTextColor;
    [self.contentView addSubview:doctorLabel];
    self.doctorLabel = doctorLabel;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:kFontSize];
    contentLabel.textColor = kContentTextColor;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = TableViewCellSeparatorColor;
    separatorView.alpha = TableViewCellSeparatorAlpha;
    [self.contentView addSubview:separatorView];
    self.separatorView = separatorView;
}
/**
 *  设置model
 *
 *  @param model model description
 */
- (void)setModel:(TTMScheduleCellModel *)model {
    self.timeLabel.text = [model.appoint_time substringWithRange:NSMakeRange(10, 6)];
    self.chairLabel.text = model.seat_name;
    self.doctorLabel.text = model.doctor_name;
    self.contentLabel.text = model.appoint_type;
}

- (void)layoutSubviews {
    self.timeImageView.frame = CGRectMake(kMargin, (kRowHeight - kTimeImageW) / 2, kTimeImageW, kTimeImageW);
    self.timeLabel.frame = CGRectMake(self.timeImageView.right + kMargin, 0,
                                      kContenWidth - kTimeImageW - kMargin, kRowHeight);
    self.chairLabel.frame = CGRectMake(self.timeLabel.right + kMargin, 0, kContenWidth, kRowHeight);
    self.doctorLabel.frame = CGRectMake(self.chairLabel.right + kMargin, 0, kContenWidth, kRowHeight);
    self.contentLabel.frame = CGRectMake(self.doctorLabel.right + kMargin, 0, kContenWidth, kRowHeight);
    self.separatorView.frame = CGRectMake(0, kRowHeight - TableViewCellSeparatorHeight, ScreenWidth, TableViewCellSeparatorHeight);
}

@end
