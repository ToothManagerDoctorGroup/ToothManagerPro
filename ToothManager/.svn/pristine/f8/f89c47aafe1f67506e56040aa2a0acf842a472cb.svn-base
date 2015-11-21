

#import "TTMAppointmentingLineView.h"

#define kFontSize 14.f
#define kViewH 80.f

@interface TTMAppointmentingLineView ()

@property (nonatomic, weak)   UIControl *contentControl; // 背景
@property (nonatomic, weak)   UILabel *timeLabel; // 时间
@property (nonatomic, weak)   UILabel *chairLabel; // 椅位号
@property (nonatomic, weak)   UILabel *doctorLabel; // 医生
@property (nonatomic, weak)   UILabel *contentLabel; // 内容

@property (nonatomic, weak)   UIImageView *timeImageView; // 用时icon
@property (nonatomic, weak)   UILabel *datetimeLabel; // 用时
@property (nonatomic, weak)   UIButton *actionButton; // 开始,结束,等待付款 按钮
@property (nonatomic, weak)   UIView *separatorView; // 分隔线

@property (nonatomic, strong) NSTimer *timer; // 倒计时

@end

@implementation TTMAppointmentingLineView

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
    [contentControl addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UILabel *chairLabel = [[UILabel alloc] init];
    chairLabel.font = [UIFont systemFontOfSize:kFontSize];
    chairLabel.textAlignment = NSTextAlignmentRight;
    [contentControl addSubview:chairLabel];
    self.chairLabel = chairLabel;
    
    UILabel *doctorLabel = [[UILabel alloc] init];
    doctorLabel.font = [UIFont systemFontOfSize:kFontSize];
    doctorLabel.textAlignment = NSTextAlignmentRight;
    [contentControl addSubview:doctorLabel];
    self.doctorLabel = doctorLabel;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:kFontSize];
    contentLabel.textAlignment = NSTextAlignmentRight;
    [contentControl addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    UIImageView *timeImageView = [UIImageView new];
    timeImageView.image = [UIImage imageNamed:@"schedule_icon_time"];
    [self addSubview:timeImageView];
    self.timeImageView = timeImageView;
    
    UILabel *datetimeLabel = [[UILabel alloc] init];
    datetimeLabel.font = [UIFont systemFontOfSize:kFontSize];
    datetimeLabel.textAlignment = NSTextAlignmentLeft;
    datetimeLabel.textColor = [UIColor darkGrayColor];
    datetimeLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:datetimeLabel];
    self.datetimeLabel = datetimeLabel;
    
    
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    actionButton.layer.borderWidth = TableViewCellSeparatorHeight;
    actionButton.layer.cornerRadius = 3.f;
    actionButton.titleLabel.font = [UIFont systemFontOfSize:kFontSize];
    [actionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:actionButton];
    self.actionButton = actionButton;
    
    UIView *separatorView = [UIView createLineView];
    [self addSubview:separatorView];
    self.separatorView = separatorView;
}

- (void)buttonAction:(UIButton *)button {
    if (button.tag == 2) {
        if ([self.delegate respondsToSelector:@selector(appointmentingLineView:clickedLineWithModel:)]) {
            [self.delegate appointmentingLineView:self clickedLineWithModel:self.model];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(appointmentingLineView:model:)]) {
            [self.delegate appointmentingLineView:self model:self.model];
        }
    }
}

- (void)setModel:(TTMApointmentModel *)model {
    _model = model;
    self.timeLabel.text = [[model.appoint_time dateValue] fs_stringWithFormat:@"HH:mm"];
    self.chairLabel.text = model.seat_name;
    self.doctorLabel.text = model.doctor_name;
    self.contentLabel.text = model.appoint_type;
    
    switch (model.status) {
        case TTMApointmentStatusNotStart: {
            [self.actionButton setTitle:@"开始计时" forState:UIControlStateNormal];
            [self.actionButton setTitleColor:RGBColor(0, 159, 168) forState:UIControlStateNormal];
            self.actionButton.layer.borderColor = RGBColor(0, 159, 168).CGColor;
            self.timeImageView.hidden = YES;
            break;
        }
        case TTMApointmentStatusStarting: {
            [self.actionButton setTitle:@"结束计时" forState:UIControlStateNormal];
            [self.actionButton setTitleColor:RGBColor(197, 70, 107) forState:UIControlStateNormal];
            self.actionButton.layer.borderColor = RGBColor(197, 70, 107).CGColor;
            self.timeImageView.hidden = NO;
            self.datetimeLabel.text = [NSString stringWithFormat:@"已用时 %@", [model.start_time timeToNow]];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                          target:self
                                                        selector:@selector(updateTimeLabel)
                                                        userInfo:nil
                                                         repeats:YES];
            break;
        }
        case TTMApointmentStatusWaitPay: {
            [self.actionButton setTitle:@"等待付款" forState:UIControlStateNormal];
            [self.actionButton setTitleColor:RGBColor(252, 152, 13) forState:UIControlStateNormal];
            self.actionButton.layer.borderColor = RGBColor(252, 152, 13).CGColor;
            self.datetimeLabel.text = [NSString stringWithFormat:@"共用时 %@", model.used_time];
            break;
        }
        case TTMApointmentStatusEnded: {
            [self.actionButton setTitle:@"收费确认" forState:UIControlStateNormal];
            [self.actionButton setTitleColor:RGBColor(252, 152, 13) forState:UIControlStateNormal];
            self.actionButton.layer.borderColor = RGBColor(252, 152, 13).CGColor;
            self.datetimeLabel.text = [NSString stringWithFormat:@"共用时 %@", model.used_time];
            break;
        }
        case TTMApointmentStatusComplete: {
            [self.actionButton setTitle:@"已完成" forState:UIControlStateNormal];
            [self.actionButton setTitleColor:MainColor forState:UIControlStateNormal];
            self.actionButton.layer.borderColor = MainColor.CGColor;
            self.datetimeLabel.text = [NSString stringWithFormat:@"共用时 %@", model.used_time];
            break;
        }
        default:{
            break;
        }
    }
}
                          
- (void)updateTimeLabel {
    self.datetimeLabel.text = [NSString stringWithFormat:@"已用时 %@", [self.model.start_time timeToNow]];
}
                          
- (void)setFrame:(CGRect)frame {
    frame.size.height = kViewH;
    
    CGFloat margin = 10.f;
    CGFloat timeLabelW = 100.f;
    CGFloat chariLabelW = 40.f;
    CGFloat doctorLabelW = 60.f;
    CGFloat contentLabelW = (ScreenWidth - 3 * margin - timeLabelW - doctorLabelW - chariLabelW);
    CGFloat labelH = 20.f;
    CGFloat timeImageWH = 20.f;
    CGFloat datetimeLabelW = ScreenWidth - 3 * margin - timeImageWH - 100.f;
    
    self.contentControl.frame = CGRectMake(0, 0, ScreenWidth, labelH + 2 * margin);
    self.timeLabel.frame = CGRectMake(2 * margin, margin, timeLabelW, labelH);
    self.chairLabel.frame = CGRectMake(self.timeLabel.right, self.timeLabel.top, chariLabelW, labelH);
    self.doctorLabel.frame = CGRectMake(self.chairLabel.right, self.timeLabel.top, doctorLabelW, labelH);
    self.contentLabel.frame = CGRectMake(self.doctorLabel.right, self.timeLabel.top, contentLabelW, labelH);
    
    self.timeImageView.frame = CGRectMake(self.timeLabel.left, self.contentControl.bottom , timeImageWH, timeImageWH);
    self.datetimeLabel.frame = CGRectMake(self.timeImageView.right + margin, self.timeImageView.top,
                                          datetimeLabelW, labelH);
    self.actionButton.frame = CGRectMake(0, self.timeImageView.top,
                                         70.f, labelH);
    self.actionButton.right = self.contentLabel.right;
    
    self.separatorView.frame = CGRectMake(0, kViewH - TableViewCellSeparatorHeight,
                                          frame.size.width, TableViewCellSeparatorHeight);
    
    [super setFrame:frame];
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

@end
