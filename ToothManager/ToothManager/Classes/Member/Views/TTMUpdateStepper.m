

#import "TTMUpdateStepper.h"
#import "TTMStepView.h"

#define kFontSize 14
#define kLineHeight 44.f

@interface TTMUpdateStepper ()<TTMStepViewDelegate>

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *contentLabel;

@property (nonatomic, weak) UIView *separatorView;

@property (nonatomic, weak) TTMStepView *stepper;
@end

@implementation TTMUpdateStepper

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
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:kFontSize];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.textColor = [UIColor darkGrayColor];
    contentLabel.font = [UIFont systemFontOfSize:kFontSize];
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    TTMStepView *stepper = [[TTMStepView alloc] initWithFrame:CGRectZero];
    stepper.addEnable = YES;
    stepper.minusEnable = YES;
    stepper.delegate = self;
    [self addSubview:stepper];
    self.stepper = stepper;
    
    UIView *separatorView = [UIView createLineView];
    [self addSubview:separatorView];
    self.separatorView = separatorView;
    
}

- (void)setAssistModel:(TTMAssistModel *)assistModel {
    _assistModel = assistModel;
    self.titleLabel.text = assistModel.assist_name;
    self.contentLabel.text = [NSString stringWithFormat:@"￥%@", assistModel.assist_price];
    self.stepper.currentNumber = assistModel.number;
    if (self.stepper.currentNumber == 0) {
        self.stepper.minusEnable = NO;
    }
}

- (void)setMaterialModel:(TTMMaterialModel *)materialModel {
    _materialModel = materialModel;
    self.titleLabel.text = materialModel.mat_name;
    self.contentLabel.text = [NSString stringWithFormat:@"￥%@", materialModel.mat_price];
    self.stepper.currentNumber = materialModel.number;
    if (self.stepper.currentNumber == 0) {
        self.stepper.minusEnable = NO;
    }
}

- (void)setFrame:(CGRect)frame {
    frame.size.width = ScreenWidth;
    frame.size.height = kLineHeight;
    [super setFrame:frame];
}

#pragma mark - PFStepViewDelegate
- (void)stepView:(TTMStepView *)stepView currentNumber:(NSInteger)currentNumber {
    if (self.assistModel) {
        if ([self.delegate respondsToSelector:@selector(updateSteper:model:)]) {
            self.assistModel.number = currentNumber;
            NSString *value = [NSString stringWithFormat:@"%@", @([self.assistModel.assist_price integerValue] * currentNumber)];
            self.assistModel.countPrice = value;
            self.assistModel.actual_num = [NSString stringwithNumber:@(currentNumber)];
            self.assistModel.actual_money = value;
            [self.delegate updateSteper:self model:self.assistModel];
        }
    }
    
    if (self.materialModel) {
        if ([self.delegate respondsToSelector:@selector(updateSteper:materialModel:)]) {
            self.materialModel.number = currentNumber;
            NSString *value = [NSString stringWithFormat:@"%@", @([self.materialModel.mat_price integerValue] * currentNumber)];
            self.materialModel.countPrice = value;
            self.assistModel.actual_num = [NSString stringwithNumber:@(currentNumber)];
            self.assistModel.actual_money = value;
            [self.delegate updateSteper:self materialModel:self.materialModel];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat labelH = 20.f;
    CGFloat labelY = (kLineHeight - labelH) / 2;
    CGFloat margin = 10.f;
    CGFloat titleW = 80.f;
    CGFloat contentW = 80.f;
    CGFloat stepperX = ScreenWidth - self.stepper.width - margin;
    
    
    self.titleLabel.frame = CGRectMake(margin, labelY, titleW, labelH);
    self.contentLabel.frame = CGRectMake(titleW, labelY, contentW, labelH);
    self.stepper.origin = CGPointMake(stepperX, 0);
    self.separatorView.frame = CGRectMake(0, kLineHeight - TableViewCellSeparatorHeight, ScreenWidth, TableViewCellSeparatorHeight);
}


@end
