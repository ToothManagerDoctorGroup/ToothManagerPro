//
//  TTMScheduleDetailController.m
//  ToothManager
//

#import "TTMScheduleDetailController.h"
#import "TTMScheduleCellModel.h"
#import "TTMContractHeaderView.h"
#import "TTMInfoView.h"
#import "TTMShowTextView.h"
#import "TTMScheduleDetailInfoView.h"
#import "TTMGTaskCellModel.h"
#import "UIImage+TTMAddtion.h"
#import "TTMChargeConfirmController.h"
#import "TTMChargeDetailController.h"

#define kMarginTop 20.f

@interface TTMScheduleDetailController ()

@property (nonatomic, weak)     UIScrollView *scrollView;
@property (nonatomic, weak)     TTMContractHeaderView *headerView; //头视图
@property (nonatomic, weak)     TTMInfoView *detailInfoView; //详细信息
@property (nonatomic, weak)     UIView *timeView; // 用时计费
@property (nonatomic, weak)     UIButton *button; // 开始计时，结束计时，等待付款，按钮

@property (nonatomic, strong)   TTMScheduleCellModel *pageModel; // 页面model

@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, strong) NSTimer *timer; // 倒计时
@end

@implementation TTMScheduleDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约详情";
    
    
    [self queryData];
    [self setupScrollView];
}
/**
 *  加载滚动背景
 */
- (void)setupScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.size = CGSizeMake(ScreenWidth, ScreenHeight);
    scrollView.delaysContentTouches = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}
/**
 *  加载所有视图
 */
- (void)setupViews {
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    [self setupHeaderView];
    [self setupDetailInfoView];
    [self setupTime];
    [self setupButton];
}
/**
 *  加载tableviewHeader
 */
- (void)setupHeaderView {
    TTMContractHeaderView *headerView = [[TTMContractHeaderView alloc] init];
    TTMGTaskCellModel *model = [[TTMGTaskCellModel alloc] init];
    model.doctor_image = self.pageModel.doctor_image;
    model.doctor_name = self.pageModel.doctor_name;
    model.doctor_position = self.pageModel.doctor_position;
    model.doctor_hospital = self.pageModel.doctor_hospital;
    model.doctor_dept = self.pageModel.doctor_dept;
    model.planting_quantity = self.pageModel.planting_quantity;
    model.star_level = self.pageModel.star_level;
    
    headerView.value = model;
    headerView.showInfoView = YES;
    
    [self.scrollView addSubview:headerView];
    self.headerView = headerView;
}

/**
 *  详情信息
 */
- (void)setupDetailInfoView {
    TTMScheduleDetailInfoView *infoView = [[TTMScheduleDetailInfoView alloc] initWithModel:self.pageModel];
    TTMInfoView *detailInfoView = [[TTMInfoView alloc] initWithIconName:@"gtask_doctor_another_info_icon"
                                                                  title:@"详情信息"
                                                            contentView:infoView];
    detailInfoView.origin = CGPointMake(0, self.headerView.bottom + kMarginTop);
    [self.scrollView addSubview:detailInfoView];
    self.detailInfoView = detailInfoView;
}

/**
 *  用时，总费用
 */
- (void)setupTime {
    UIView *timeView = [UIView new];
    [self.scrollView addSubview:timeView];
    self.timeView = timeView;
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = MainColor;
    [timeView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UILabel *moneyLabel = [UILabel new];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.font = [UIFont systemFontOfSize:12];
    moneyLabel.textColor = [UIColor redColor];
    [timeView addSubview:moneyLabel];
    
    CGFloat timeLabelW = 150.f;
    
    timeView.frame = CGRectMake(0, self.detailInfoView.bottom + kMarginTop, ScreenWidth, 20.f);
    timeLabel.frame = CGRectMake(kMarginTop, 0, timeLabelW, 20.f);
    moneyLabel.frame = CGRectMake(ScreenWidth - kMarginTop - timeLabelW, 0, timeLabelW, 20.f);
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, timeView.bottom);
    
    switch (self.pageModel.reserve_status) {
        case TTMApointmentStatusNotStart: {
            break;
        }
        case TTMApointmentStatusStarting: {
            timeLabel.text = [NSString stringWithFormat:@"已用时：%@", [self.pageModel.actual_start_time timeToNow]];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                          target:self
                                                        selector:@selector(updateTimeLabel)
                                                        userInfo:nil
                                                         repeats:YES];
            timeLabel.left = 0;
            timeLabel.width = ScreenWidth;
            timeLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case TTMApointmentStatusWaitPay: {
            timeLabel.text = [NSString stringWithFormat:@"共用时：%@", [self.pageModel.used_time hourMinutesTimeFormat]];
            moneyLabel.text = [NSString stringWithFormat:@"总费用：￥%@元", self.pageModel.total_money];
            break;
        }
        case TTMApointmentStatusEnded: {
            timeLabel.text = [NSString stringWithFormat:@"共用时：%@", [self.pageModel.used_time hourMinutesTimeFormat]];
            moneyLabel.text = [NSString stringWithFormat:@"总费用：￥%@元", self.pageModel.total_money];
            break;
        }
        case TTMApointmentStatusComplete: {
            timeLabel.text = [NSString stringWithFormat:@"共用时：%@", [self.pageModel.used_time hourMinutesTimeFormat]];
            moneyLabel.text = [NSString stringWithFormat:@"总费用：￥%@元", self.pageModel.total_money];
            break;
        }
        default: {
            break;
        }
    }

}

- (void)setupButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    switch (self.pageModel.reserve_status) {
        case TTMApointmentStatusNotStart: {
            [button setTitle:@"开始计时" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage resizedImageWithName:@"schedule_start_button_bg"] forState:UIControlStateNormal];
            break;
        }
        case TTMApointmentStatusStarting: {
            [button setTitle:@"结束计时" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage resizedImageWithName:@"schedule_end_button_bg"] forState:UIControlStateNormal];
            break;
        }
        case TTMApointmentStatusWaitPay: {
            [button setTitle:@"等待付款" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage resizedImageWithName:@"schedule_start_button_bg"] forState:UIControlStateNormal];
            break;
        }
        case TTMApointmentStatusEnded: {
            [button setTitle:@"收费确认" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage resizedImageWithName:@"schedule_start_button_bg"] forState:UIControlStateNormal];
            break;
        }
        case TTMApointmentStatusComplete: {
            [button setTitle:@"已完成" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage resizedImageWithName:@"schedule_start_button_bg"] forState:UIControlStateNormal];
            break;
        }
        default: {
            break;
        }
    }
    CGFloat buttonX = 30.f;
    CGFloat buttonW = ScreenWidth - 2 * buttonX;
    CGFloat buttonH = 40.f;
    CGFloat buttonY = self.timeView.bottom + 2 * kMarginTop;
    
    button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    
    [self.scrollView addSubview:button];
    self.button = button;
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, button.bottom + kMarginTop);
}

- (void)updateTimeLabel {
    self.timeLabel.text = [NSString stringWithFormat:@"已用时 %@", [self.pageModel.actual_start_time timeToNow]];
}

- (void)buttonAction:(UIButton *)button {
    TTMScheduleCellModel *model = self.pageModel;
    if (model.reserve_status == TTMApointmentStatusNotStart) { // 开始计时
        __weak __typeof(&*self) weakSelf = self;
        CYAlertView * alert = [[CYAlertView alloc] initWithTitle:@"确定要开始计时"
                                                         message:nil
                                                    clickedBlock:^(CYAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                                                        if (buttonIndex == 1) {
                                                            TTMApointmentModel *submitModel = [[TTMApointmentModel alloc] init];
                                                            submitModel.KeyId = model.keyId;
                                                            [weakSelf startWithModel:submitModel];
                                                        }
                                                    }
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
        [alert show];
    } else if (model.reserve_status == TTMApointmentStatusStarting) { // 结束计时
        __weak __typeof(&*self) weakSelf = self;
        CYAlertView * alert = [[CYAlertView alloc] initWithTitle:@"确定要结束计时"
                                                         message:nil
                                                    clickedBlock:^(CYAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                                                        if (buttonIndex == 1) {
                                                            TTMApointmentModel *submitModel = [[TTMApointmentModel alloc] init];
                                                            submitModel.KeyId = model.keyId;
                                                            [weakSelf endWithModel:submitModel];
                                                        }
                                                    }
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
        [alert show];
    } else if (model.reserve_status == TTMApointmentStatusWaitPay) { // 等待付款
        TTMChargeDetailController *chargeVC = [TTMChargeDetailController new];
        TTMApointmentModel *submitModel = [[TTMApointmentModel alloc] init];
        submitModel.KeyId = model.keyId;
        chargeVC.model = submitModel;
        [self.navigationController pushViewController:chargeVC animated:YES];
    } else if ( model.reserve_status == TTMApointmentStatusEnded) { // 收费确认
        TTMChargeConfirmController *confirmVC = [TTMChargeConfirmController new];
        TTMApointmentModel *submitModel = [[TTMApointmentModel alloc] init];
        submitModel.KeyId = model.keyId;
        confirmVC.model = submitModel;
        [self.navigationController pushViewController:confirmVC animated:YES];
    }
}


/**
 *  开始计时
 */
- (void)startWithModel:(TTMApointmentModel *)model {
    __weak __typeof(&*self) weakSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showLoading];
    [TTMApointmentModel startTimeWithModel:model complete:^(id result) {
        [hud hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            // 成功
//            [weakSelf.navigationController popViewControllerAnimated:YES];
            [weakSelf queryData];
        }
    }];
}

/**
 *  结束计时
 */
- (void)endWithModel:(TTMApointmentModel *)model {
    __weak __typeof(&*self) weakSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showLoading];
    [TTMApointmentModel endTimeWithModel:model complete:^(id result) {
        [hud hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            TTMChargeConfirmController *confimVC = [TTMChargeConfirmController new];
            confimVC.model = model;
            [weakSelf.navigationController pushViewController:confimVC animated:YES];
        }
    }];
}

/**
 *  查询数据
 */
- (void)queryData {
    __weak __typeof(&*self) weakSelf = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDWithView:self.view.window text:@"加载中..."];
    [TTMScheduleCellModel queryScheduleDetailWithId:self.model.keyId complete:^(id result) {
        [hud hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.pageModel = result;
            [TTMScheduleCellModel queryScheduleOtherDetailWithId:weakSelf.model.keyId complete:^(id result) {
                if ([result isKindOfClass:[NSString class]]) {
                    [MBProgressHUD showToastWithText:result];
                } else {
                    TTMScheduleCellModel *otherModel = result;
                    weakSelf.pageModel.doctor_image = otherModel.doctor_image;
                    weakSelf.pageModel.doctor_name = otherModel.doctor_name;
                    weakSelf.pageModel.doctor_position = otherModel.doctor_position;
                    weakSelf.pageModel.doctor_hospital = otherModel.doctor_hospital;
                    weakSelf.pageModel.doctor_dept = otherModel.doctor_dept;
                    weakSelf.pageModel.planting_quantity = otherModel.planting_quantity;
                    weakSelf.pageModel.star_level = otherModel.star_level;
                    weakSelf.pageModel.remark = otherModel.remark;
                    
                    [weakSelf setupViews];
                }
            }];
        }
    }];
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

@end
