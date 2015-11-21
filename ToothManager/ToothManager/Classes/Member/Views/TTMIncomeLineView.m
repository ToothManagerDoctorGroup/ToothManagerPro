//
//  TTMIncomeLineView.m
//  ToothManager
//

#import "TTMIncomeLineView.h"

#define kFontSize 14.f
#define kViewH 35.f

@interface TTMIncomeLineView ()

@property (nonatomic, weak)   UILabel *timeLabel; // 时间
@property (nonatomic, weak)   UILabel *personLabel; // 付款人
@property (nonatomic, weak)   UILabel *moneyLabel; // 多少钱
@property (nonatomic, weak)   UILabel *stateLabel; // 收款状态
@end

@implementation TTMIncomeLineView

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
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:kFontSize];
    timeLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UILabel *personLabel = [[UILabel alloc] init];
    personLabel.font = [UIFont systemFontOfSize:kFontSize];
    personLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:personLabel];
    self.personLabel = personLabel;
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.font = [UIFont systemFontOfSize:kFontSize];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    
    UILabel *stateLabel = [[UILabel alloc] init];
    stateLabel.font = [UIFont systemFontOfSize:kFontSize];
    stateLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:stateLabel];
    self.stateLabel = stateLabel;
}

- (void)setModel:(TTMIncomeModel *)model {
    _model = model;
    self.timeLabel.text = [[model.time dateValue] fs_stringWithFormat:@"MM-dd hh:mm"];
    self.personLabel.text = model.person;
    self.moneyLabel.text = model.mony;
    if (model.appoint_type) {
        self.stateLabel.text = model.appoint_type;
        self.stateLabel.textColor = MainColor;
    } else {
        if (model.state == TTMIncomeModelStateReceived) {
            self.stateLabel.text = @"已收款";
            self.stateLabel.textColor = MainColor;
        } else if(model.state == TTMIncomeModelStateStay) {
            self.stateLabel.text = @"待收款";
            self.stateLabel.textColor = [UIColor redColor];
        }
    }
}

- (void)setFrame:(CGRect)frame {
    frame.size.height = kViewH;
    CGFloat labelW = frame.size.width / 4;
    self.timeLabel.frame = CGRectMake(0, 0, labelW, kViewH);
    self.personLabel.frame = CGRectMake(labelW, 0, labelW, kViewH);
    self.moneyLabel.frame = CGRectMake(2 * labelW, 0, labelW, kViewH);
    self.stateLabel.frame = CGRectMake(3 * labelW, 0, labelW - 10.f, kViewH);
    [super setFrame:frame];
}



@end
