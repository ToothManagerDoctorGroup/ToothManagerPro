

#import "TTMWithdrawCell.h"

#define kFontSize 14

@interface TTMWithdrawCell ()

@property (nonatomic, weak)   UILabel *dateTimeLabel;
@property (nonatomic, weak)   UILabel *moneyLabel;
@property (nonatomic, weak)   UILabel *statusLabel;
@property (nonatomic, weak)   UIView *separatorView;
@end

@implementation TTMWithdrawCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"cellID";
    TTMWithdrawCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[TTMWithdrawCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
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
    UILabel *dateTimeLabel = [[UILabel alloc] init];
    dateTimeLabel.font = [UIFont systemFontOfSize:kFontSize];
    dateTimeLabel.textColor = [UIColor darkGrayColor];
    dateTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:dateTimeLabel];
    self.dateTimeLabel = dateTimeLabel;
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.font = [UIFont systemFontOfSize:kFontSize];
    moneyLabel.textColor = [UIColor darkGrayColor];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.font = [UIFont systemFontOfSize:kFontSize];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:statusLabel];
    self.statusLabel = statusLabel;
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = TableViewCellSeparatorColor;
    separatorView.alpha = TableViewCellSeparatorAlpha;
    [self.contentView addSubview:separatorView];
    self.separatorView = separatorView;
}

- (void)setModel:(TTMWithdrawModel *)model {
    _model = model;
    self.dateTimeLabel.text = [[model.withdraw_time dateValue] fs_stringWithFormat:@"yyyy-MM-dd hh:mm"];
    self.moneyLabel.text = model.money;
    
    if (model.status == 0) {
        self.statusLabel.text = @"审核中";
        self.statusLabel.textColor = [UIColor redColor];
    } else if (model.status == 1) {
        self.statusLabel.text = @"已到账";
        self.statusLabel.textColor = MainColor;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat labelW = ScreenWidth / 3;
    CGFloat labelH = self.height;
    self.dateTimeLabel.frame = CGRectMake(0, 0, labelW, labelH);
    self.moneyLabel.frame = CGRectMake(self.dateTimeLabel.right, 0, labelW, labelH);
    self.statusLabel.frame = CGRectMake(self.moneyLabel.right, 0, labelW, labelH);
    self.separatorView.frame = CGRectMake(0, self.height - TableViewCellSeparatorHeight,
                                          ScreenWidth, TableViewCellSeparatorHeight);
}

@end
