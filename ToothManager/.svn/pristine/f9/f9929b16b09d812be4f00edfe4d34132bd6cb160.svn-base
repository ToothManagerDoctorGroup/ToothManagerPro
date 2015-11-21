
#import "TTMChairSettingUnitTextField.h"

@interface TTMChairSettingUnitTextField ()

@property (nonatomic, weak)   UITextField *textField;
@property (nonatomic, weak)   UILabel *unitLabel;
@end

@implementation TTMChairSettingUnitTextField

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
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:textField];
    self.textField = textField;
    
    UILabel *unitLabel = [UILabel new];
    unitLabel.textColor = [UIColor darkGrayColor];
    unitLabel.font = [UIFont systemFontOfSize:14];
    unitLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:unitLabel];
    self.unitLabel = unitLabel;
}

- (NSString *)text {
    return self.textField.text;
}

- (void)setText:(NSString *)text {
    self.textField.text = text;
}

- (void)setUnitText:(NSString *)unitText {
    _unitText = unitText;
    self.unitLabel.text = unitText;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat unitLabelW = 80.f;
    CGFloat unitLabelH = 20.f;
    CGFloat unitLabelX = (ScreenWidth - unitLabelW - kChairSettingMargin);
    CGFloat unitLabelY = (self.height - unitLabelH) / 2;
    
    CGFloat textFieldH = 30.f;
    CGFloat textFieldW = (ScreenWidth - 3 * kChairSettingMargin - kChairSettingTitleW - unitLabelW);
    CGFloat textFieldX = kChairSettingTitleW + kChairSettingMargin;
    CGFloat textFieldY = (kChairSettingViewH - textFieldH) / 2;
    
    self.textField.frame = CGRectMake(textFieldX, textFieldY, textFieldW, textFieldH);
    self.unitLabel.frame = CGRectMake(unitLabelX, unitLabelY, unitLabelW, unitLabelH);
}

@end
