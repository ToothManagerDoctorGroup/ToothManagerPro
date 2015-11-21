
#import "TTMStepView.h"

#define kButtonWH 30.0f

#define kHeight 44.0f

@interface TTMStepView ()

@property (nonatomic, weak) UIButton *minusButton;

@property (nonatomic, weak) UIButton *addButton;

@property (nonatomic, weak) UILabel *numberLabel;

@end

@implementation TTMStepView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.backgroundColor = [UIColor clearColor];
    
    self.min = 0;
    self.max = 100;
    self.currentNumber = 0;
    self.step = 1;
    
    self.numberLabelColor = [UIColor blackColor];
    self.zeroNumberLabelColor = [UIColor blackColor];
    self.negativeNumberLabelColor = MainColor;
    self.minusEnable = NO;
    self.addEnable = YES;
    
    UIButton *minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [minusButton setBackgroundImage:[UIImage imageNamed:@"step_button_minus_normal"] forState:UIControlStateNormal];
    [minusButton setBackgroundImage:[UIImage imageNamed:@"step_button_minus_pressed"] forState:UIControlStateHighlighted];
    [minusButton setBackgroundImage:[UIImage imageNamed:@"step_button_minus_disable"] forState:UIControlStateDisabled];
    [minusButton addTarget:self action:@selector(stepAction:) forControlEvents:UIControlEventTouchUpInside];
    minusButton.enabled = NO;
    [self addSubview:minusButton];
    self.minusButton = minusButton;
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setBackgroundImage:[UIImage imageNamed:@"step_button_add_normal"] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"step_button_add_pressed"] forState:UIControlStateHighlighted];
    [addButton setBackgroundImage:[UIImage imageNamed:@"step_button_add_disable"] forState:UIControlStateDisabled];
    [addButton addTarget:self action:@selector(stepAction:) forControlEvents:UIControlEventTouchUpInside];
    addButton.enabled = NO;
    [self addSubview:addButton];
    self.addButton = addButton;
    
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.font = [UIFont systemFontOfSize:16.0f];
    numberLabel.numberOfLines = 1;
    numberLabel.adjustsFontSizeToFitWidth = YES;
    numberLabel.text = [NSString stringWithFormat:@"%@", @(self.currentNumber)];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.textColor = self.numberLabelColor;
    [self addSubview:numberLabel];
    self.numberLabel = numberLabel;
}

- (void)setFrame:(CGRect)frame {
    frame.size.width = kButtonWH * 3;
    frame.size.height = kHeight;
    [super setFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat buttonY = (kHeight - kButtonWH) * 0.5;
    
    self.minusButton.frame = CGRectMake(0.0f, buttonY, kButtonWH, kButtonWH);
    self.numberLabel.frame = CGRectMake(CGRectGetMaxX(self.minusButton.frame), 0.0f, kButtonWH * 1.2f, kHeight);
    self.addButton.frame = CGRectMake(CGRectGetMaxX(self.numberLabel.frame), buttonY, kButtonWH, kButtonWH);
}

- (void)stepAction:(UIButton *)button {
    NSInteger number = [self.numberLabel.text integerValue];
    if ((number - 1) >= 0) {
        self.minusEnable = YES;
    } else {
        self.minusEnable = NO;
    }
    if ((number + 1) <= self.max) {
        self.addEnable = YES;
    } else {
        self.addEnable = NO;
    }
    if (button == self.minusButton) {
        
        if (number == (self.step * 0.5) && self.isAddHalfStepFromZero) {
            number -= self.step * 0.5;
        } else {
            number -= self.step;
        }
        
        if (number > self.min) {
            self.minusButton.enabled = YES;
            self.addButton.enabled = YES;
        } else {
            self.minusButton.enabled = NO;
        }

        if (number < 0) {
            self.numberLabel.textColor = self.negativeNumberLabelColor;
        } else if (number == 0) {
            self.numberLabel.textColor = self.zeroNumberLabelColor;
        } else {
            self.numberLabel.textColor = self.numberLabelColor;
        }
        self.currentNumber = number;
        self.numberLabel.text = [NSString stringWithFormat:@"%@", @(number)];
        
    } else if (button == self.addButton) {
        
        if (number == 0 && self.isAddHalfStepFromZero) {
            number += self.step * 0.5;
        }else {
            number += self.step;
        }
        
        if (number < self.max) {
            self.addButton.enabled = YES;
            self.minusButton.enabled = YES;
        } else {
            self.addButton.enabled = NO;
        }

        if (number < 0) {
            self.numberLabel.textColor = self.negativeNumberLabelColor;
        } else if (number == 0) {
            self.numberLabel.textColor = self.zeroNumberLabelColor;
        } else {
            self.numberLabel.textColor = self.numberLabelColor;
        }
        self.currentNumber = number;
        self.numberLabel.text = [NSString stringWithFormat:@"%@", @(number)];
    }
    
    if ([self.delegate respondsToSelector:@selector(stepView:currentNumber:)]) {
        [self.delegate stepView:self currentNumber:self.currentNumber];
    }
}

- (void)setNumberLabelColor:(UIColor *)numberLabelColor {
    _numberLabelColor = numberLabelColor;
    self.numberLabel.textColor = numberLabelColor;
}

- (void)setZeroNumberLabelColor:(UIColor *)zeroNumberLabelColor {
    _zeroNumberLabelColor = zeroNumberLabelColor;
    self.numberLabel.textColor = zeroNumberLabelColor;
}

- (void)setNegativeNumberLabelColor:(UIColor *)negativeNumberLabelColor {
    _negativeNumberLabelColor = negativeNumberLabelColor;
    self.numberLabel.textColor = negativeNumberLabelColor;
}

- (void)setCurrentNumber:(NSInteger)currentNumber {
    _currentNumber = currentNumber;
    self.numberLabel.text = [NSString stringWithFormat:@"%@", @(currentNumber)];
}

- (void)setAddEnable:(BOOL)addEnable {
    _addEnable = addEnable;
    self.addButton.enabled = addEnable;
}

- (void)setMinusEnable:(BOOL)minusEnable {
    _minusEnable = minusEnable;
    self.minusButton.enabled = minusEnable;
}

@end
