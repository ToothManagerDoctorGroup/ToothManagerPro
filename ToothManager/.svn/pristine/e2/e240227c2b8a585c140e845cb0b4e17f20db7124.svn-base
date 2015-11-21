//
//  TTMMessageCell.m
//  ToothManager
//

#import "TTMMessageCell.h"

#define kFontSize 14
#define kTitleFontSize 17
#define kTitleColor [UIColor blackColor]
#define kMargin 10.f
#define kTitleLabelH 20.f
#define kLabelH 14.f
#define kImageW kLabelH
#define kLabelW (ScreenWidth - 3 * kMargin - kImageW) / 2
@interface TTMMessageCell ()

@property (nonatomic, weak)   UILabel *titleLabel;
@property (nonatomic, weak)   UILabel *timeLabel;
@property (nonatomic, weak)   UILabel *chairNoLabel;
@property (nonatomic, weak)   UIImageView *timeImageView;
@property (nonatomic, weak)   UIView *separatorView;
@end

@implementation TTMMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"CellID";
    TTMMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[TTMMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    titleLabel.textColor = kTitleColor;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:kFontSize];
    timeLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UILabel *chairNoLabel = [[UILabel alloc] init];
    chairNoLabel.font = [UIFont systemFontOfSize:kFontSize];
    [self.contentView addSubview:chairNoLabel];
    self.chairNoLabel = chairNoLabel;
    
    UIImageView *timeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schedule_icon_time"]];
    [self.contentView addSubview:timeImageView];
    self.timeImageView = timeImageView;
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = TableViewCellSeparatorColor;
    separatorView.alpha = TableViewCellSeparatorAlpha;
    [self.contentView addSubview:separatorView];
    self.separatorView = separatorView;
}

- (void)setModel:(TTMMessageCellModel *)model {
    _model = model;
    
//    self.titleLabel.text = model.title;
//    self.timeLabel.text = model.time;
//    self.chairNoLabel.text = model.chairNo;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(kMargin, 2 * kMargin, ScreenWidth - 2 * kMargin, kTitleLabelH);
    self.timeImageView.frame = CGRectMake(kMargin, self.titleLabel.bottom + kMargin, kImageW, kImageW);
    self.timeLabel.frame = CGRectMake(self.timeImageView.right + kMargin,
                                      self.titleLabel.bottom + kMargin, kLabelW, kLabelH);
    self.chairNoLabel.frame = CGRectMake(self.timeLabel.right,
                                      self.titleLabel.bottom + kMargin, kLabelW, kLabelH);
    self.separatorView.frame = CGRectMake(0, self.timeLabel.bottom + 2 * kMargin - TableViewCellSeparatorHeight,
                                          ScreenWidth, TableViewCellSeparatorHeight);
}

@end
