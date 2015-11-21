//
//  TTMTextField.m
//  ToothManager
//

#import "TTMTextField.h"
#import "UIImage+TTMAddtion.h"

#define kFontSize 14
#define kTitleColor [UIColor darkGrayColor]
#define kMargin 10.f
#define kViewH 40.f
#define kMaxTitleW 150.f

@interface TTMTextField ()

@property (nonatomic, copy)   NSString *title;
@property (nonatomic, weak)   UILabel *titleLabel;
@end

@implementation TTMTextField

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = title;
        [self setup];
    }
    return self;
}

+ (instancetype)textFieldWithTitle:(NSString *)title {
    return [[TTMTextField alloc] initWithTitle:title];
}

- (void)setup {
    // 背景图片
    UIImage *bgImage = [UIImage resizedImageWithName:@"member_textfield_bg"];
    self.background  = bgImage;
    self.font = [UIFont systemFontOfSize:kFontSize];
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:kFontSize];
    titleLabel.textColor = kTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = titleLabel;
    if ([NSString isEmpty:self.title]) {
        self.titleLabel.text = @"";
    } else {
        self.titleLabel.text = [NSString stringWithFormat:@"%@:", self.title];
    }
    
    CGSize titleSize = [self.titleLabel.text measureFrameWithFont:[UIFont systemFontOfSize:kFontSize]
                                                             size:CGSizeMake(kMaxTitleW, kViewH)].size;
    titleLabel.frame = CGRectMake(0, 0, titleSize.width + 2 * kMargin, kViewH);
    [self leftViewRectForBounds:titleLabel.frame];
    self.leftView = titleLabel;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setFrame:(CGRect)frame {
    frame.size.height = kViewH;
    [super setFrame:frame];
}

@end
