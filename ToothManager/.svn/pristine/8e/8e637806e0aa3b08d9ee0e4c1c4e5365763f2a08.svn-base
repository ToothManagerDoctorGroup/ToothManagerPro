//
//  TTMHandContractController.m
//  ToothManager
//

#import "TTMHandContractController.h"
#import "TTMContractHeaderView.h"
#import "TTMInfoView.h"
#import "TTMDoctorInfoView.h"
#import "TTMDoctorInfoModel.h"
#import "TTMShowTextView.h"
#import "TTMGTaskCellModel.h"
#import "TTMGTaskController.h"

#define kMarginTop 20.f
#define kButtonW 100.f
#define kButtonH 30.f
#define kButtonFontSize 15

@interface TTMHandContractController ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) TTMContractHeaderView *headerView; //头视图
@property (nonatomic, weak) TTMInfoView *doctorInfoView; // 医生资料
@property (nonatomic, weak) TTMInfoView *protocolInfoView; // 签约协议

@property (nonatomic, strong) TTMGTaskCellModel *pageModel; // 页面数据model

@end

@implementation TTMHandContractController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self queryData];
    [self setupScrollView];
}

/**
 *  加载所有的视图
 */
- (void)setupViews {
    [self setupHeaderView];
    [self setupDoctorInfoView];
    [self setupProtocolInfoView];
    if (self.currentStatus == 0) { // 未处理状态，需要加载底部
        [self setupBottomView];
        self.title = @"处理签约";
    } else {
        self.title = @"签约详情";
    }
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
 *  加载tableviewHeader视图
 */
- (void)setupHeaderView {
    TTMContractHeaderView *headerView = [[TTMContractHeaderView alloc] init];
    headerView.value = self.pageModel;
    headerView.showInfoView = YES;
    
    [self.scrollView addSubview:headerView];
    self.headerView = headerView;
}

/**
 *  医生资料
 */
- (void)setupDoctorInfoView {
    TTMDoctorInfoModel *model = [[TTMDoctorInfoModel alloc] init];
    model.sex = self.pageModel.doctor_gender ? @"男" : @"女";
    model.special = self.pageModel.main_project;
    model.introduce = self.pageModel.individual_resume;
    TTMDoctorInfoView *infoView = [[TTMDoctorInfoView alloc] initWithModel:model];
    
    TTMInfoView *doctorInfoView = [[TTMInfoView alloc] initWithIconName:@"gtask_doctor_info_icon"
                                                                  title:@"医生资料"
                                                            contentView:infoView];
    doctorInfoView.origin = CGPointMake(0, self.headerView.bottom + kMarginTop);
    [self.scrollView addSubview:doctorInfoView];
    self.doctorInfoView = doctorInfoView;
}

/**
 *  签约协议
 */
- (void)setupProtocolInfoView {
    NSString *protocolText = self.pageModel.protocol;
    
    TTMShowTextView *textView = [[TTMShowTextView alloc] initWithContent:protocolText];
    
    TTMInfoView *protocolInfoView = [[TTMInfoView alloc] initWithIconName:@"gtask_protocol_icon"
                                                                  title:@"签约协议"
                                                            contentView:textView];
    
    protocolInfoView.origin = CGPointMake(0, self.doctorInfoView.bottom + kMarginTop);
    [self.scrollView addSubview:protocolInfoView];
    self.protocolInfoView = protocolInfoView;
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, protocolInfoView.bottom + kMarginTop);
}

/**
 *  接受拒绝
 */
- (void)setupBottomView {
    UIView *bottomView = [[UIView alloc] init];
    [self.scrollView addSubview:bottomView];
    
    UIButton *receiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [receiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [receiveButton setBackgroundImage:[UIImage imageNamed:@"gtask_buttton_green_bg"] forState:UIControlStateNormal];
    [receiveButton setTitle:@"接受" forState:UIControlStateNormal];
    receiveButton.titleLabel.font = [UIFont systemFontOfSize:kButtonFontSize];
    receiveButton.tag = 0;
    [receiveButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:receiveButton];
    
    UIButton *refuseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refuseButton setBackgroundImage:[UIImage imageNamed:@"gtask_buttton_yellow_bg"] forState:UIControlStateNormal];
    [refuseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
    refuseButton.titleLabel.font = [UIFont systemFontOfSize:kButtonFontSize];
    refuseButton.tag = 1;
    [refuseButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:refuseButton];
    
    CGFloat buttonX = (ScreenWidth - 2 * kButtonW - kMarginTop) / 2;
    receiveButton.frame = CGRectMake(buttonX, kMarginTop, kButtonW, kButtonH);
    refuseButton.frame = CGRectMake(receiveButton.right + kMarginTop, kMarginTop, kButtonW, kButtonH);
    bottomView.frame = CGRectMake(0, self.protocolInfoView.bottom + kMarginTop, ScreenWidth,
                                  refuseButton.bottom + kMarginTop);
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, bottomView.bottom);
}
/**
 *  点击接受拒绝按钮事件
 *
 *  @param button button description
 */
- (void)buttonAction:(UIButton *)button {
    __weak __typeof(&*self) weakSelf = self;
    if (button.tag == 0) {
        [TTMGTaskCellModel agreeWithId:self.model.keyId complete:^(id result) {
            if ([result isKindOfClass:[NSString class]]) {
                [MBProgressHUD showToastWithText:result];
            } else {
                MBProgressHUD *hud = [MBProgressHUD showToastWithText:@"接受成功"];
                hud.completionBlock = ^(){
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:TTMGTaskControllerRefreshNotification object:nil];
                };
            }
        }];
    } else {
        [TTMGTaskCellModel disagreeWithId:self.model.keyId complete:^(id result) {
            if ([result isKindOfClass:[NSString class]]) {
                [MBProgressHUD showToastWithText:result];
            } else {
                MBProgressHUD *hud = [MBProgressHUD showToastWithText:@"拒绝成功"];
                hud.completionBlock = ^(){
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:TTMGTaskControllerRefreshNotification object:nil];
                };
            }
        }];
    }
}


/**
 *  查询详情数据
 */
- (void)queryData {
    __weak __typeof(&*self) weakSelf = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDWithView:self.view.window text:@"加载中..."];
    [TTMGTaskCellModel queryDetailWithId:self.model.keyId complete:^(id result) {
        [hud hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.pageModel = result;
            [weakSelf setupViews];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
