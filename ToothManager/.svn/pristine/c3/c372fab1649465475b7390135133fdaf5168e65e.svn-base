

#import "TTMChargeConfirmController.h"
#import "TTMUpdateAssistController.h"
#import "TTMAddOtherController.h"
#import "TTMUpdateChairController.h"
#import "TTMChargeDetailModel.h"
#import "TTMChargeDetailLineView.h"
#import "NIAttributedLabel.h"
#import "TTMGreenButton.h"
#import "TTMTextField.h"
#import "TTMMaterialModel.h"

#define kFontSize 14

@interface TTMChargeConfirmController ()<
    TTMUpdateAssistControllerDelegate,
    TTMAddOtherControllerDelegate,
    TTMUpdateChairControllerDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UILabel *timeLabel; // 总时长，总费用
@property (nonatomic, weak) UILabel *detailTitleLabel; // 收费明细

@property (nonatomic, weak)   TTMChargeDetailLineView *chairLine; // 椅位费
@property (nonatomic, weak)   TTMChargeDetailLineView *assistLine; // 助手
@property (nonatomic, weak)   TTMChargeDetailLineView *plantLine; // 种植体

@property (nonatomic, weak) UILabel *otherTitleLabel; // 其他费用
@property (nonatomic, weak) UIButton *addButton; // 添加按钮
@property (nonatomic, weak)   UIView *otherContentView; // 其他费用的内容视图

@property (nonatomic, weak)   TTMGreenButton *submitButton; // 确认button

@property (nonatomic, strong) TTMChargeDetailModel *detailModel; // 详情model

@property (nonatomic, assign) CGFloat allMoney; // 总额

@end

@implementation TTMChargeConfirmController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收费确认";
    [self setup];
    [self queryDetail];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.assistLine becomeFirstResponder];
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
    
    // 椅位费，助手，种植体,其他
    TTMChargeDetailLineView *chairLine = [TTMChargeDetailLineView lineWithTitle:@"椅位费"];
    UIButton *chairRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chairRightButton.tag = 5;
    [chairRightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [chairRightButton setBackgroundImage:[UIImage imageNamed:@"member_charge_edit"] forState:UIControlStateNormal];
    chairRightButton.size = CGSizeMake(22.f, 23.f);
    chairLine.rightView = chairRightButton;
    [scrollView addSubview:chairLine];
    self.chairLine = chairLine;
    
    TTMChargeDetailLineView *assistLine = [TTMChargeDetailLineView lineWithTitle:@"助手"];
    UIButton *assistRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    assistRightButton.tag = 1;
    [assistRightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [assistRightButton setBackgroundImage:[UIImage imageNamed:@"member_charge_edit"] forState:UIControlStateNormal];
    assistRightButton.size = CGSizeMake(22.f, 23.f);
    assistLine.rightView = assistRightButton;
    [scrollView addSubview:assistLine];
    self.assistLine = assistLine;
    
    TTMChargeDetailLineView *plantLine = [TTMChargeDetailLineView lineWithTitle:@"种植体"];
    UIButton *plantRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    plantRightButton.tag = 2;
    [plantRightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [plantRightButton setBackgroundImage:[UIImage imageNamed:@"member_charge_edit"] forState:UIControlStateNormal];
    plantRightButton.size = CGSizeMake(22.f, 23.f);
    plantLine.rightView = plantRightButton;
    [scrollView addSubview:plantLine];
    self.plantLine = plantLine;
    
    // 其他费用
    UILabel *otherTitleLabel = [UILabel new];
    otherTitleLabel.font = [UIFont systemFontOfSize:kFontSize];
    otherTitleLabel.textColor = [UIColor darkGrayColor];
    otherTitleLabel.text = @"其他费用";
    [scrollView addSubview:otherTitleLabel];
    self.otherTitleLabel = otherTitleLabel;
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.tag = 3;
    [addButton setBackgroundImage:[UIImage imageNamed:@"member_charge_add"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    addButton.size = CGSizeMake(19.f, 19.f);
    [scrollView addSubview:addButton];
    
    UIView *otherContentView = [UIView new];
    [scrollView addSubview:otherContentView];
    self.otherContentView = otherContentView;
    
    TTMGreenButton *submitButton = [TTMGreenButton buttonWithType:UIButtonTypeCustom];
    submitButton.tag = 4;
    [submitButton setTitle:@"确认" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:submitButton];
    self.submitButton = submitButton;
    
    CGFloat margin = 10.f;
    CGFloat labelH = 20.f;
    
    timeLabel.frame = CGRectMake(margin, margin, ScreenWidth - 2 * margin, labelH);
    detailTitleLabel.frame = CGRectMake(margin, timeLabel.bottom + margin, 100.f, labelH);
    chairLine.top = detailTitleLabel.bottom + margin;
    assistLine.top = chairLine.bottom;
    plantLine.top = assistLine.bottom;
    
    otherTitleLabel.frame = CGRectMake(margin, plantLine.bottom + margin, 100.f, labelH);
    addButton.origin = CGPointMake(ScreenWidth - margin - addButton.width, otherTitleLabel.top);
    otherContentView.frame = CGRectMake(0, otherTitleLabel.bottom + margin, ScreenWidth, 0);
    
    submitButton.origin = CGPointMake(margin, otherContentView.bottom + 2 * margin);
    
    scrollView.frame = self.view.frame;
    CGFloat minHeight = submitButton.bottom + margin;
    CGFloat minHeight2 = ScreenHeight;
    if (minHeight < minHeight2) {
        scrollView.contentSize = CGSizeMake(ScreenWidth, minHeight2);
    } else {
        scrollView.contentSize = CGSizeMake(ScreenWidth, minHeight);
    }
}

- (void)setupViewWithModel:(TTMChargeDetailModel *)model {
    _detailModel = model;
    // 计算椅位费和总费用
    NSNumber *seat_money = @([model.seat_price integerValue] * [model.used_time integerValue] / 60);
    NSNumber *appoint_money = @([seat_money integerValue] + [model.assistant_money integerValue]
    + [model.material_money integerValue] + [model.extra_money integerValue]);
    
    model.seat_money = [NSString stringwithNumber:seat_money];
    model.appoint_money = [NSString stringwithNumber:appoint_money];
    
    NSString *timeString = [NSString stringWithFormat:@"总时长:%@\t\t总费用:%@元", [model.used_time hourMinutesTimeFormat], model.appoint_money];
    NSMutableAttributedString *timeAttributeString = [[NSMutableAttributedString alloc] initWithString:timeString];
    [timeAttributeString addAttribute:NSForegroundColorAttributeName
                                value:[UIColor redColor]
                                range:[timeString rangeOfString:[NSString stringWithFormat:@"%@元", model.appoint_money]]];
    self.timeLabel.attributedText = timeAttributeString;
    
    self.chairLine.content = [NSString stringWithFormat:@"%@元", model.seat_money];
    self.assistLine.content = [NSString stringWithFormat:@"%@元", model.assistant_money];
    self.plantLine.content = [NSString stringWithFormat:@"%@元", model.material_money];
    
    [self setupOtherContentViewWithData:model.extra_detail];
}

- (void)setupOtherContentViewWithData:(NSArray *)data {
    NSArray *subViews = self.otherContentView.subviews;
    for (TTMChargeDetailLineView *line in subViews) {
        [line removeFromSuperview];
    }
    
    for (NSUInteger i = 0; i < data.count; i ++) {
        TTMMaterialModel *temp = data[i];
        
        TTMChargeDetailLineView *lineView = [TTMChargeDetailLineView lineWithTitle:temp.mat_name];
        if (temp.countPrice) {
            temp.actual_money = temp.countPrice;
        }
        lineView.content = [NSString stringWithFormat:@"%@元", temp.actual_money];
        lineView.top = i * NormalLineH;
        [self.otherContentView addSubview:lineView];
        self.otherContentView.height = lineView.bottom;
    }
    self.submitButton.top = self.otherContentView.bottom + 2 * NormalMargin;
}

#pragma mark - TTMUpdateAssistControllerDelegate
- (void)updateAssistController:(TTMUpdateAssistController *)updateAssistController
                    countMoney:(NSUInteger)countMoney
                   assistArray:(NSArray *)assistArray {
    self.detailModel.assist_detail = assistArray;
    self.detailModel.assistant_money = [NSString stringwithNumber:@(countMoney)];
    self.assistLine.content = [NSString stringWithFormat:@"%@元", self.detailModel.assistant_money];
    [self countMoney];
}

- (void)updateAssistController:(TTMUpdateAssistController *)updateAssistController
                    countMoney:(NSUInteger)countMoney
                    plantArray:(NSArray *)plantArray {
    
    self.detailModel.material_detail = plantArray;
    self.detailModel.material_money = [NSString stringwithNumber:@(countMoney)];
    self.plantLine.content = [NSString stringWithFormat:@"%@元", self.detailModel.material_money];
    [self countMoney];
}

#pragma mark - TTMUpdateChairControllerDelegate
- (void)updateChairController:(TTMUpdateChairController *)updateChairController chariMoney:(NSString *)chariMoney {
    self.detailModel.seat_money = chariMoney;
    self.chairLine.content = [NSString stringWithFormat:@"%@元", self.detailModel.seat_money];
    [self countMoney];
}

#pragma mark - TTMAddOtherControllerDelegate
- (void)addOtherController:(TTMAddOtherController *)addOtherController
                countMoney:(NSUInteger)countMoney
             materialArray:(NSArray *)materialArray {
    self.detailModel.extra_detail = [materialArray copy];
    self.detailModel.extra_money = [NSString stringwithNumber:@(countMoney)];
    [self countMoney];
    [self setupOtherContentViewWithData:materialArray];
}

/**
 *  计算总价
 */
- (void)countMoney {
    NSUInteger countMoney = [self.detailModel.seat_money integerValue] +
    [self.detailModel.assistant_money integerValue] +
    [self.detailModel.material_money integerValue] +
    [self.detailModel.extra_money integerValue];
    
    self.detailModel.appoint_money = [NSString stringwithNumber:@(countMoney)];
    
    NSString *timeString = [NSString stringWithFormat:@"总时长:%@\t\t总费用:%@元",
                            [self.detailModel.used_time hourMinutesTimeFormat], self.detailModel.appoint_money];
    
    NSMutableAttributedString *timeAttributeString = [[NSMutableAttributedString alloc] initWithString:timeString];
    [timeAttributeString addAttribute:NSForegroundColorAttributeName
                                value:[UIColor redColor]
                                range:[timeString rangeOfString:[NSString stringWithFormat:@"%@元", self.detailModel.appoint_money]]];
    self.timeLabel.attributedText = timeAttributeString;
    
}

/**
 *  按钮点击
 *
 *  @param button button description
 */
- (void)buttonAction:(UIButton *)button {
    if (button.tag == 1) {
        TTMUpdateAssistController *assitController = [TTMUpdateAssistController new];
        assitController.detailModel = self.detailModel;
        assitController.delegate = self;
        assitController.type = TTMUpdateAssistControllerTypeAssist;
        [self.navigationController pushViewController:assitController animated:YES];
    } else if (button.tag == 2) {
        TTMUpdateAssistController *plantController = [TTMUpdateAssistController new];
        plantController.detailModel = self.detailModel;
        plantController.type = TTMUpdateAssistControllerTypePlant;
        plantController.delegate = self;
        [self.navigationController pushViewController:plantController animated:YES];
    } else if (button.tag == 3) { // 其他费用加号
        TTMAddOtherController *addOtherController = [TTMAddOtherController new];
        addOtherController.detailModel = self.detailModel;
        addOtherController.delegate = self;
        [self.navigationController pushViewController:addOtherController animated:YES];
    } else if (button.tag == 4) { // 确认
        __weak __typeof(&*self) weakSelf = self;
        MBProgressHUD *hud = [MBProgressHUD showLoading];
        [TTMApointmentModel editPayDetailWithModel:self.detailModel complete:^(id result) {
            [hud hide:YES];
            if ([result isKindOfClass:[NSString class]]) {
                [MBProgressHUD showToastWithText:result];
            } else {
                MBProgressHUD *hud = [MBProgressHUD showToastWithText:@"提交成功"];
                hud.completionBlock = ^(){
                    NSArray *viewControllers = weakSelf.navigationController.viewControllers;
                    [weakSelf.navigationController popToViewController:viewControllers[1] animated:YES];
                };
            }
        }];
    } else if (button.tag == 5) {
        TTMUpdateChairController *chairController = [[TTMUpdateChairController alloc] init];
        chairController.chairMoney = self.detailModel.seat_money;
        chairController.delegate = self;
        [self.navigationController pushViewController:chairController animated:YES];
    }
}

/**
 *  查询详情
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
