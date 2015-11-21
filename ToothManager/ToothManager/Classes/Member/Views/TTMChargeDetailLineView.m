
#import "TTMChargeDetailLineView.h"

#define kFontSize 14
#define kViewH 44.f

@interface TTMChargeDetailLineView ()

@property (nonatomic, weak)   UILabel *titleLabel;

@property (nonatomic, weak)   UILabel *contentLabel;

@end

@implementation TTMChargeDetailLineView

+ (instancetype)lineWithTitle:(NSString *)title {
    TTMChargeDetailLineView *lineView = [TTMChargeDetailLineView new];
    lineView.title = title;
    return lineView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:kFontSize];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.font = [UIFont systemFontOfSize:kFontSize];
    contentLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    UIView *separatorView = [UIView createLineView];
    [self addSubview:separatorView];
    
    CGFloat margin = 10.f;
    CGFloat titleW = 80.f;
    CGFloat contentW = 150.f;
    CGFloat labelH = 20.f;
    
    
    titleLabel.frame = CGRectMake(margin, margin, titleW, labelH);
    contentLabel.frame = CGRectMake(titleLabel.right + margin, margin, contentW, labelH);
    separatorView.frame = CGRectMake(0, kViewH - TableViewCellSeparatorHeight, ScreenWidth, TableViewCellSeparatorHeight);
}

- (void)setFrame:(CGRect)frame {
    frame.size.height = kViewH;
    frame.size.width = ScreenWidth;
    [super setFrame:frame];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.contentLabel.text = content;
}

- (void)setRightView:(UIView *)rightView {
    _rightView = rightView;
    CGFloat rightViewX = self.width - rightView.width - 10.f;
    CGFloat rightViewY = (self.height - rightView.height) / 2;
    rightView.origin = CGPointMake(rightViewX, rightViewY);
    [self addSubview:rightView];
}

@end
