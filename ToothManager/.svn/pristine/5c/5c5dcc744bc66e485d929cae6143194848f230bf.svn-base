

#import "TTMCompleteAppointmentCell.h"
#import "UIImage+TTMAddtion.h"
#import "TTMCompleteAppointmentLineView.h"

#define kFontSize 14
#define kMonthLabelW 40.f
#define kMonthLabelH kMonthLabelW
#define kMargin 10.f
#define kLineViewH 80.f
#define kBgImageViewW (ScreenWidth - 2 * kMargin - kMonthLabelW)
#define kLineViewW (kBgImageViewW - 2 * kMargin)

@interface TTMCompleteAppointmentCell ()<TTMCompleteAppointmentLineViewDelegate>

@property (nonatomic, weak)   UILabel *monthLabel; // 月份
@property (nonatomic, weak)   UIView *vView; // 垂直线view
@property (nonatomic, weak)   UIImageView *bgImageView; // 气泡view

@end

@implementation TTMCompleteAppointmentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"cellID";
    TTMCompleteAppointmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[TTMCompleteAppointmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *monthLabel = [[UILabel alloc] init];
    monthLabel.backgroundColor = [UIColor whiteColor];
    monthLabel.font = [UIFont systemFontOfSize:kFontSize];
    monthLabel.textColor = MainColor;
    monthLabel.layer.cornerRadius = kMonthLabelW / 2;
    monthLabel.layer.borderColor = MainColor.CGColor;
    monthLabel.layer.borderWidth = 1.f;
    monthLabel.clipsToBounds = YES;
    monthLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:monthLabel];
    self.monthLabel = monthLabel;
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    UIImage *bgImage = [UIImage resizedImageWithName:@"member_income_qipao"];
    bgImageView.image = bgImage;
    bgImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    UIView *vView = [[UIView alloc] init];
    vView.backgroundColor = MainColor;
    vView.alpha = TableViewCellSeparatorAlpha;
    [self.contentView addSubview:vView];
    self.vView = vView;
}

- (void)setModel:(TTMCompleteApointmentCellModel *)model {
    _model = model;
    
    self.monthLabel.text = model.month;
    
    for (UIView *subView in self.bgImageView.subviews) {
        [subView removeFromSuperview];
    }
    NSArray *list = model.infoList;
    for (NSUInteger i = 0 ; i < list.count; i ++) {
        TTMApointmentModel *model = list[i];
        TTMCompleteAppointmentLineView *lineView = [[TTMCompleteAppointmentLineView alloc] init];
        lineView.model = model;
        lineView.delegate = self;
        lineView.frame = CGRectMake(2 * kMargin, i * kLineViewH + 2 * kMargin, kLineViewW, kLineViewH);
        [self.bgImageView addSubview:lineView];
    }
    
    [self updateFrame];
}

- (void)updateFrame {
    self.monthLabel.frame = CGRectMake(kMargin, 0, kMonthLabelW, kMonthLabelH);
    
    CGFloat bgImageViewH = self.model.infoList.count * kLineViewH + 4 * kMargin;
    self.bgImageView.frame = CGRectMake(kMargin + kMonthLabelW, 0, kBgImageViewW, bgImageViewH);
    
    CGFloat vViewH = self.bgImageView.height + 2 * kMargin - kMonthLabelH;
    self.vView.frame = CGRectMake(self.monthLabel.center.x, self.monthLabel.bottom,
                                  TableViewCellSeparatorHeight, vViewH);
}

/**
 *  行点击事件
 *
 *  @param completeAppointmentLineView 视图
 *  @param model                       model
 */
- (void)completeAppointmentLineView:(TTMCompleteAppointmentLineView *)completeAppointmentLineView
                              model:(TTMApointmentModel *)model {
    if ([self.delegate respondsToSelector:@selector(completeAppointmentCell:model:)]) {
        [self.delegate completeAppointmentCell:self model:model];
    }
}

- (void)completeAppointmentLineView:(TTMCompleteAppointmentLineView *)completeAppointmentLineView
               clickedLineWithModel:(TTMApointmentModel *)model {
    if ([self.delegate respondsToSelector:@selector(completeAppointmentCell:clickedLineWithModel:)]) {
        [self.delegate completeAppointmentCell:self clickedLineWithModel:model];
    }

}

@end
