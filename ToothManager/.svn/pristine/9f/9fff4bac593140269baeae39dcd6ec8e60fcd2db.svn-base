

#import "TTMCompleteAppointmentLineView.h"

#define kFontSize 14.f
#define kViewH 80.f

@interface TTMCompleteAppointmentLineView ()

@property (nonatomic, weak)   UIControl *contentControl;
@property (nonatomic, weak)   UILabel *timeLabel; // 时间
@property (nonatomic, weak)   UILabel *chairLabel; // 椅位号
@property (nonatomic, weak)   UILabel *doctorLabel; // 医生
@property (nonatomic, weak)   UILabel *contentLabel; // 内容
@property (nonatomic, weak)   UILabel *moneyLabel; // 实付款
@property (nonatomic, weak)   UIButton *detailButton; // 收费详情按钮
@property (nonatomic, weak)   UIView *separatorView; // 分隔线

@end

@implementation TTMCompleteAppointmentLineView

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
    UIControl *contentControl = [[UIControl alloc] init];
    contentControl.tag = 2;
    [contentControl addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:contentControl];
    self.contentControl = contentControl;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:kFontSize];
    timeLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UILabel *chairLabel = [[UILabel alloc] init];
    chairLabel.font = [UIFont systemFontOfSize:kFontSize];
    chairLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:chairLabel];
    self.chairLabel = chairLabel;
    
    UILabel *doctorLabel = [[UILabel alloc] init];
    doctorLabel.font = [UIFont systemFontOfSize:kFontSize];
    doctorLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:doctorLabel];
    self.doctorLabel = doctorLabel;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:kFontSize];
    contentLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.font = [UIFont systemFontOfSize:kFontSize];
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    moneyLabel.textColor = [UIColor redColor];
    [self addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailButton setTitle:@"收费详情" forState:UIControlStateNormal];
    [detailButton setTitleColor:MainColor forState:UIControlStateNormal];
    detailButton.layer.borderColor = MainColor.CGColor;
    detailButton.layer.borderWidth = TableViewCellSeparatorHeight;
    detailButton.layer.cornerRadius = 3.f;
    detailButton.clipsToBounds = YES;
    detailButton.titleLabel.font = [UIFont systemFontOfSize:kFontSize];
    [detailButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:detailButton];
    self.detailButton = detailButton;
    
    UIView *separatorView = [UIView createLineView];
    [self addSubview:separatorView];
    self.separatorView = separatorView;
}

- (void)buttonAction:(UIButton *)button {
    if (button.tag == 2) {
        if ([self.delegate respondsToSelector:@selector(completeAppointmentLineView:clickedLineWithModel:)]) {
            [self.delegate completeAppointmentLineView:self clickedLineWithModel:self.model];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(completeAppointmentLineView:model:)]) {
            [self.delegate completeAppointmentLineView:self model:self.model];
        }
    }
}

- (void)setModel:(TTMApointmentModel *)model {
    _model = model;
    self.timeLabel.text = [[model.appoint_time dateValue] fs_stringWithFormat:@"MM-dd hh:mm"];
    self.chairLabel.text = model.seat_name;
    self.doctorLabel.text = model.doctor_name;
    self.contentLabel.text = model.appoint_type;
    self.moneyLabel.text = [NSString stringWithFormat:@"实付款 %@元", @(model.appoint_money)];
}

- (void)setFrame:(CGRect)frame {
    frame.size.height = kViewH;
    
    CGFloat labelW = frame.size.width / 4;
    CGFloat margin = 10.f;
    CGFloat labelH = 30.f;
    CGFloat buttonH = 25.f;
    
    self.contentControl.frame = CGRectMake(0, 0, frame.size.width, labelH + margin);
    self.timeLabel.frame = CGRectMake(0, 0, labelW, labelH);
    self.chairLabel.frame = CGRectMake(self.timeLabel.right, 0, labelW - margin, labelH);
    self.doctorLabel.frame = CGRectMake(self.chairLabel.right, 0, labelW, labelH);
    self.contentLabel.frame = CGRectMake(self.doctorLabel.right, 0, labelW - margin + margin, labelH);
    
    self.moneyLabel.frame = CGRectMake(0, self.contentControl.bottom, labelW * 2, labelH);
    self.detailButton.frame = CGRectMake(self.contentLabel.left, self.moneyLabel.top,
                                         self.contentLabel.width, buttonH);
    self.separatorView.frame = CGRectMake(0, kViewH - TableViewCellSeparatorHeight,
                                          frame.size.width, TableViewCellSeparatorHeight);
    [super setFrame:frame];
}
@end
