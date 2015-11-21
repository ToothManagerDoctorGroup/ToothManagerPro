
#import "TTMChairSettingTitleView.h"

@interface TTMChairSettingTitleView ()

@property (nonatomic, weak)   UILabel *titleLabel; // 标题
@property (nonatomic, weak)   UIView *separatorView; // 分隔线

@end

@implementation TTMChairSettingTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.titleLabel.text = title;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    frame.size.height = kChairSettingViewH;
    frame.size.width = ScreenWidth;
    [super setFrame:frame];
}

- (void)setupViews {
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = TableViewCellSeparatorColor;
    separatorView.alpha = TableViewCellSeparatorAlpha;
    [self addSubview:separatorView];
    self.separatorView = separatorView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat titleW = kChairSettingTitleW;
    CGFloat titleH = 20.f;
    CGFloat titleY = (kChairSettingViewH - titleH) / 2;
    
    self.titleLabel.frame = CGRectMake(0, titleY, titleW, titleH);
    self.separatorView.frame = CGRectMake(0, kChairSettingViewH - TableViewCellSeparatorHeight,
                                          ScreenWidth, TableViewCellSeparatorHeight);
}

@end
