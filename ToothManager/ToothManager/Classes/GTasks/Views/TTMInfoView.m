//
//  TTMInfoView.m
//  ToothManager
//

#import "TTMInfoView.h"

#define kTitleFontSize 14
#define kMargin 10.f
#define kTitleH 44.f
#define kTitleW 200.f

@interface TTMInfoView ()

@property (nonatomic, weak) UIImageView *iconImageView; // 图标
@property (nonatomic, weak) UILabel *titleLabel; // 标题
@property (nonatomic, weak) UIView *vSeparatorView; // 分隔线

@property (nonatomic, copy)   NSString *iconName;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation TTMInfoView

- (instancetype)initWithIconName:(NSString *)iconName
                           title:(NSString *)title
                     contentView:(UIView *)contentView {
    if (self = [super init]) {
        self.iconName = iconName;
        self.title = title;
        self.contentView = contentView;
        [self setup];
    }
    return self;
}
/**
 *  加载视图
 */
- (void)setup {
    UIView *titleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kTitleH)];
    titleBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:titleBgView];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    UIImage *iconImage = [UIImage imageNamed:self.iconName];
    iconImageView.image = iconImage;
    CGFloat imageW = iconImage.size.width;
    CGFloat imageH = iconImage.size.height;
    iconImageView.frame = CGRectMake(kMargin, (kTitleH - imageH) / 2, imageW, imageH);
    [titleBgView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    titleLabel.textColor = MainColor;
    titleLabel.text = self.title;
    titleLabel.frame = CGRectMake(iconImageView.right + kMargin, 0, kTitleW, kTitleH);
    [titleBgView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIView *vSeparatorView = [[UIView alloc] init];
    vSeparatorView.backgroundColor = TableViewCellSeparatorColor;
    vSeparatorView.frame = CGRectMake(kMargin, kTitleH - TableViewCellSeparatorHeight,
                                      ScreenWidth - kMargin, TableViewCellSeparatorHeight);
    [titleBgView addSubview:vSeparatorView];
    self.vSeparatorView = vSeparatorView;
    
    self.contentView.top = kTitleH;
    [self addSubview:self.contentView];
    self.size = CGSizeMake(ScreenWidth, self.contentView.bottom);
}

@end
