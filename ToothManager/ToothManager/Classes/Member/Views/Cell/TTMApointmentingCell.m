
#import "TTMApointmentingCell.h"
#import "TTMAppointmentingLineView.h"

#define kFontSize 14.f
#define kTitleH 44.f

@interface TTMApointmentingCell ()<TTMAppointmentingLineViewDelegate>

@property (nonatomic, weak)   UILabel *dayLabel; // 日
@property (nonatomic, weak)   UIImageView *bgImageView; // 背景白色图片

@end

@implementation TTMApointmentingCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"cellID";
    TTMApointmentingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[TTMApointmentingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *bgImageView = [UIImageView new];
    bgImageView.image = [UIImage imageNamed:@"white_alpha_bg"];
    bgImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    UILabel *dayLabel = [UILabel new];
    dayLabel.font = [UIFont systemFontOfSize:kFontSize];
    dayLabel.layer.borderColor = TableViewCellSeparatorColor.CGColor;
    dayLabel.layer.borderWidth = TableViewCellSeparatorHeight;
    dayLabel.alpha = TableViewCellSeparatorAlpha;
    dayLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:dayLabel];
    self.dayLabel = dayLabel;
    
    bgImageView.frame = CGRectMake(0, 0, ScreenWidth, kTitleH);
    dayLabel.frame = CGRectMake(0, 0, ScreenWidth, kTitleH);

}

- (void)setModel:(TTMAppointmentingCellModel *)model {
    _model = model;
    self.dayLabel.text = [NSString stringWithFormat:@"   %@", model.day];
    
    for (UIView *subView in self.bgImageView.subviews) {
        [subView removeFromSuperview];
    }
    
    NSArray *list = model.infoList;
    NSUInteger count = model.infoList.count;
    CGFloat lineH = 80.f;
    for (NSUInteger i = 0; i < count; i ++) {
        TTMApointmentModel *model = list[i];
        TTMAppointmentingLineView *lineView = [[TTMAppointmentingLineView alloc] init];
        lineView.model = model;
        lineView.delegate = self;
        lineView.frame = CGRectMake(0, kTitleH + i * lineH, ScreenWidth, lineH);
        [self.bgImageView addSubview:lineView];
    }
    
    self.bgImageView.height = kTitleH + count * lineH;
}

- (void)appointmentingLineView:(TTMAppointmentingLineView *)appointmentingLineView
                         model:(TTMApointmentModel *)model {
    if ([self.delegate respondsToSelector:@selector(apointmentingCell:model:)]) {
        [self.delegate apointmentingCell:self model:model];
    }
}

- (void)appointmentingLineView:(TTMAppointmentingLineView *)appointmentingLineView
          clickedLineWithModel:(TTMApointmentModel *)model {
    if ([self.delegate respondsToSelector:@selector(apointmentingCell:clickedLineWithModel:)]) {
        [self.delegate apointmentingCell:self clickedLineWithModel:model];
    }
}

@end
