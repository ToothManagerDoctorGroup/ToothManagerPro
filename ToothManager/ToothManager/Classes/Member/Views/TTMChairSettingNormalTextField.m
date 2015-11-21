
#import "TTMChairSettingNormalTextField.h"

@interface TTMChairSettingNormalTextField ()

@property (nonatomic, weak)   UITextField *textField;

@end

@implementation TTMChairSettingNormalTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UITextField *textField = [UITextField new];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font = [UIFont systemFontOfSize:14];
    [self addSubview:textField];
    self.textField = textField;
}

- (NSString *)text {
    return self.textField.text;
}

- (void)setText:(NSString *)text {
    self.textField.text = text;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat textFieldH = 30.f;
    CGFloat textFieldW = (ScreenWidth - 2 * kChairSettingMargin - kChairSettingTitleW);
    CGFloat textFieldX = kChairSettingTitleW + kChairSettingMargin;
    CGFloat textFieldY = (kChairSettingViewH - textFieldH) / 2;
    self.textField.frame = CGRectMake(textFieldX, textFieldY, textFieldW, textFieldH);
}
@end
