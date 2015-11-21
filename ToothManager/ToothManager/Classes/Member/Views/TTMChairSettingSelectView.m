
#import "TTMChairSettingSelectView.h"

@interface TTMChairSettingSelectView ()

@property (nonatomic, weak)   UIView *selectView;

@end

@implementation TTMChairSettingSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIView *selectView = [UIView new];
    [self addSubview:selectView];
    self.selectView = selectView;
    
    CGFloat selectViewW = ScreenWidth - 2 * kChairSettingMargin - kChairSettingTitleW;
    CGFloat selectViewX = kChairSettingTitleW + kChairSettingMargin;
    selectView.frame = CGRectMake(selectViewX, 0, selectViewW, kChairSettingViewH);
}

- (void)setOptions:(NSArray *)options {
    _options = options;
    self.buttonArray = [NSMutableArray array];
    
    CGFloat buttonW = 70.f;
    CGFloat buttonH = 30.f;
    CGFloat buttonY = (kChairSettingViewH - buttonH) / 2;
    
    for (NSUInteger i = 0; i < options.count; i ++) {
        UIButton *optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [optionButton setBackgroundImage:[UIImage imageNamed:@"clinic_option_selected"] forState:UIControlStateSelected];
        [optionButton setBackgroundImage:[UIImage imageNamed:@"clinic_option_normal"] forState:UIControlStateNormal];
        [optionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [optionButton setTitleColor:MainColor forState:UIControlStateSelected];
        [optionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        optionButton.titleLabel.font = [UIFont systemFontOfSize:12];
        optionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        [self.selectView addSubview:optionButton];
        [self.buttonArray addObject:optionButton];
        optionButton.frame = CGRectMake(i * (buttonW + kChairSettingMargin), buttonY, buttonW, buttonH);
        
        NSString *optionString = options[i];
        [optionButton setTitle:optionString forState:UIControlStateNormal];
    }
}

- (void)buttonSelectedWithIndex:(NSUInteger)index isSelected:(BOOL)isSelected {
    if (index < self.buttonArray.count) {
        UIButton *button = self.buttonArray[index];
        button.selected = isSelected;
        if (isSelected) {
            self.selectedButton = button;
        }
    }
}

- (void)buttonAction:(UIButton *)button {
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

@end
