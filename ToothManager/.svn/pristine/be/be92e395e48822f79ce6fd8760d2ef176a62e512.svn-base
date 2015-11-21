
#import "TTMChargeDetailController.h"
#import "TTMChargeDetailModel.h"
#import "TTMChargeDetailLineView.h"
#import "NIAttributedLabel.h"
#import "UIBarButtonItem+TTMAddtion.h"
#import "TTMChargeConfirmController.h"

#define kFontSize 14

@interface TTMChargeDetailController ()

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UILabel *timeLabel; // 总时长，总费用
@property (nonatomic, weak) UILabel *detailTitleLabel; // 收费明细

@property (nonatomic, weak)   TTMChargeDetailLineView *chairLine; // 椅位费
@property (nonatomic, weak)   TTMChargeDetailLineView *assistLine; // 助手
@property (nonatomic, weak)   TTMChargeDetailLineView *plantLine; // 种植体

@property (nonatomic, weak) UILabel *otherTitleLabel; // 其他费用
@property (nonatomic, weak) UIButton *addButton; // 添加按钮
@property (nonatomic, weak)   TTMChargeDetailLineView *periostLine; // 骨膜

@property (nonatomic, weak)   UIButton *statusButton; // 状态

@property (nonatomic, strong) TTMChargeDetailModel *detailModel; // 详情model
@end

@implementation TTMChargeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收费详情";
    
    [self setup];
    [self queryDetail];
//    [self setupRightItem];

}

- (void)setupRightItem {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"编辑"
                                                                     normalImageName:@"member_bar_item_bg"
                                                                              action:@selector(buttonAction:)
                                                                              target:self];
}

- (void)setup {
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.delaysContentTouches = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 时间，费用
    UILabel *timeLabel = [UILabel new];
    timeLabel.font = [UIFont systemFontOfSize:kFontSize];
    timeLabel.textColor = [UIColor darkGrayColor];
    [scrollView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UILabel *detailTitleLabel = [UILabel new];
    detailTitleLabel.font = [UIFont systemFontOfSize:kFontSize];
    detailTitleLabel.textColor = [UIColor darkGrayColor];
    detailTitleLabel.text = @"收费明细";
    [scrollView addSubview:detailTitleLabel];
    self.detailTitleLabel = detailTitleLabel;

    // 椅位费，助手，种植体
    TTMChargeDetailLineView *chairLine = [TTMChargeDetailLineView lineWithTitle:@"椅位费"];
    [scrollView addSubview:chairLine];
    self.chairLine = chairLine;
    
    TTMChargeDetailLineView *assistLine = [TTMChargeDetailLineView lineWithTitle:@"助手"];
    [scrollView addSubview:assistLine];
    self.assistLine = assistLine;
    
    TTMChargeDetailLineView *plantLine = [TTMChargeDetailLineView lineWithTitle:@"种植体"];
    [scrollView addSubview:plantLine];
    self.plantLine = plantLine;
    
    // 其他费用
    UILabel *otherTitleLabel = [UILabel new];
    otherTitleLabel.font = [UIFont systemFontOfSize:kFontSize];
    otherTitleLabel.textColor = [UIColor darkGrayColor];
    otherTitleLabel.text = @"其他费用";
    [scrollView addSubview:otherTitleLabel];
    self.otherTitleLabel = otherTitleLabel;
    
    TTMChargeDetailLineView *periostLine = [TTMChargeDetailLineView lineWithTitle:@"其他"];
    [scrollView addSubview:periostLine];
    self.periostLine = periostLine;
    
    
    UIButton *statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    statusButton.titleLabel.font = [UIFont systemFontOfSize:kFontSize];
    [scrollView addSubview:statusButton];
    self.statusButton = statusButton;
    
    CGFloat margin = 10.f;
    CGFloat labelH = 20.f;
    CGFloat statusButtonW = 100.f;
    CGFloat statusButtonH = 44.f;
    CGFloat statusButtonX = (ScreenWidth - statusButtonW) / 2;
    
    timeLabel.frame = CGRectMake(margin, margin, ScreenWidth - 2 * margin, labelH);
    detailTitleLabel.frame = CGRectMake(margin, timeLabel.bottom + margin, 100.f, labelH);
    chairLine.top = detailTitleLabel.bottom + margin;
    assistLine.top = chairLine.bottom;
    plantLine.top = assistLine.bottom;
    
    otherTitleLabel.frame = CGRectMake(margin, plantLine.bottom + margin, 100.f, labelH);
    periostLine.top = otherTitleLabel.bottom + margin;
    
    statusButton.frame = CGRectMake(statusButtonX, periostLine.bottom + 2 * margin, statusButtonW, statusButtonH);
    
    
    scrollView.frame = self.view.frame;
    CGFloat minHeight = statusButton.bottom + margin;
    CGFloat minHeight2 = ScreenHeight;
    if (minHeight < minHeight2) {
        scrollView.contentSize = CGSizeMake(ScreenWidth, minHeight2);
    } else {
        scrollView.contentSize = CGSizeMake(ScreenWidth, minHeight);
    }
}

/**
 *  查询收费详情
 */
- (void)queryDetail {
    MBProgressHUD *loading = [MBProgressHUD showLoading];
    __weak __typeof(&*self) weakSelf = self;
    [TTMChargeDetailModel queryChargeDetailWithAppointmentId:[NSString stringWithFormat:@"%@", @(self.model.KeyId)]
                                                    complete:^(id result) {
                                                        [loading hide:YES];
                                                        if ([result isKindOfClass:[NSString class]]) {
                                                            [MBProgressHUD showToastWithText:result];
                                                        } else {
                                                            [weakSelf setupViewWithModel:result];
                                                        }
    }];
}

/**
 *  加载页面信息
 *
 *  @param model 信息model
 */
- (void)setupViewWithModel:(TTMChargeDetailModel *)model {
    _detailModel = model;
    
    NSString *timeString = [NSString stringWithFormat:@"总时长:%@\t\t总费用:%@元", [model.used_time hourMinutesTimeFormat], model.appoint_money];
    NSMutableAttributedString *timeAttributeString = [[NSMutableAttributedString alloc] initWithString:timeString];
    [timeAttributeString addAttribute:NSForegroundColorAttributeName
                                value:[UIColor redColor]
                                range:[timeString rangeOfString:[NSString stringWithFormat:@"%@元", model.appoint_money]]];
    self.timeLabel.attributedText = timeAttributeString;
    
    self.chairLine.content = [NSString stringWithFormat:@"%@元", model.seat_money];
    self.assistLine.content = [NSString stringWithFormat:@"%@元", model.assistant_money];
    self.plantLine.content = [NSString stringWithFormat:@"%@元", model.material_money];
    self.periostLine.content = [NSString stringWithFormat:@"%@元", model.extra_money];
    
    switch (model.status) {
        case TTMApointmentStatusNotStart: {
            break;
        }
        case TTMApointmentStatusStarting: {
            break;
        }
        case TTMApointmentStatusWaitPay: {
            [self.statusButton setTitle:@"等待付款" forState:UIControlStateNormal];
            [self.statusButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.statusButton setImage:[UIImage imageNamed:@"member_time_icon"] forState:UIControlStateNormal];
            self.statusButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            [self setupRightItem];
            break;
        }
        case TTMApointmentStatusEnded: {
            [self.statusButton setTitle:@"等待付款" forState:UIControlStateNormal];
            [self.statusButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.statusButton setImage:[UIImage imageNamed:@"member_time_icon"] forState:UIControlStateNormal];
            self.statusButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            [self setupRightItem];
            break;
        }
        case TTMApointmentStatusComplete: {
            [self.statusButton setTitle:@"已收款" forState:UIControlStateNormal];
            [self.statusButton setTitleColor:MainColor forState:UIControlStateNormal];
            [self.statusButton setImage:[UIImage imageNamed:@"member_right_icon"] forState:UIControlStateNormal];
            self.statusButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            break;
        }
        default: {
            break;
        }
    }
}

- (void)buttonAction:(UIButton *)button {
    TTMChargeConfirmController *confimVC = [TTMChargeConfirmController new];
    confimVC.model = self.model;
    [self.navigationController pushViewController:confimVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
