//
//  TTMDoctorDetailController.m
//  ToothManager
//

#import "TTMDoctorDetailController.h"
#import "TTMContractHeaderView.h"
#import "TTMInfoView.h"
#import "TTMDoctorInfoView.h"
#import "TTMDoctorInfoModel.h"
#import "TTMPlantNumView.h"
#import "TTMOperationNumView.h"
#import "TTMLoseNumView.h"
#import "TTMGTaskCellModel.h"

#define kMarginTop 20.f
#define kButtonW 100.f
#define kButtonH 30.f
#define kButtonFontSize 15

@interface TTMDoctorDetailController ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) TTMContractHeaderView *headerView; //头视图
@property (nonatomic, weak) TTMInfoView *doctorInfoView; // 医生资料
@property (nonatomic, weak) TTMInfoView *plantNumInfoView; // 种植量
@property (nonatomic, weak) TTMInfoView *operationNumInfoView; // 手术量
@property (nonatomic, weak) TTMInfoView *loseNumInfoView; // 失败率

@property (nonatomic, strong) TTMGTaskCellModel *pageModel; // 页面数据model

@end

@implementation TTMDoctorDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"医生详情";
    
    [self queryData];
    [self setupScrollView];
}

/**
 *  加载所有视图
 */
- (void)setupViews {
    [self setupHeaderView];
    [self setupDoctorInfoView];
//    [self setupPlantNumInfoView];
//    [self setupOperationNumInfoView];
    [self setupLoseNumInfoView];
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
 *  加载tableviewHeader
 */
- (void)setupHeaderView {
    TTMContractHeaderView *headerView = [[TTMContractHeaderView alloc] init];
    headerView.value = self.pageModel;
    headerView.showInfoView = YES;
    
    [self.scrollView addSubview:headerView];
    self.headerView = headerView;
}
/**
 *  专家资料视图
 */
- (void)setupDoctorInfoView {
    TTMDoctorInfoModel *model = [[TTMDoctorInfoModel alloc] init];
    model.sex = self.pageModel.doctor_gender ? @"男" : @"女";
    model.special = self.pageModel.main_project;
    model.introduce = self.pageModel.individual_resume;
    TTMDoctorInfoView *infoView = [[TTMDoctorInfoView alloc] initWithModel:model];
    
    TTMInfoView *doctorInfoView = [[TTMInfoView alloc] initWithIconName:@"gtask_doctor_info_icon"
                                                                  title:@"专家资料"
                                                            contentView:infoView];
    doctorInfoView.origin = CGPointMake(0, self.headerView.bottom + kMarginTop);
    [self.scrollView addSubview:doctorInfoView];
    self.doctorInfoView = doctorInfoView;
}

/**
 *  种植量
 */
- (void)setupPlantNumInfoView {
    TTMPlantNumView *plantNumView = [[TTMPlantNumView alloc] initWithModel:self.pageModel];
    TTMInfoView *plantNumInfoView = [[TTMInfoView alloc] initWithIconName:@"gtask_doctor_another_info_icon"
                                                                  title:@"种植量"
                                                            contentView:plantNumView];
    plantNumInfoView.origin = CGPointMake(0, self.doctorInfoView.bottom + kMarginTop);
    [self.scrollView addSubview:plantNumInfoView];
    self.plantNumInfoView = plantNumInfoView;
}

/**
 *  手术量
 */
- (void)setupOperationNumInfoView {
    TTMOperationNumView *operationNumView = [[TTMOperationNumView alloc] initWithModel:self.pageModel];
    TTMInfoView *operationNumInfoView = [[TTMInfoView alloc] initWithIconName:@"gtask_doctor_another_info_icon"
                                                                    title:@"手术量"
                                                              contentView:operationNumView];
    operationNumInfoView.origin = CGPointMake(0, self.plantNumInfoView.bottom + kMarginTop);
    [self.scrollView addSubview:operationNumInfoView];
    self.operationNumInfoView = operationNumInfoView;
}

/**
 *  失败率
 */
- (void)setupLoseNumInfoView {
    TTMLoseNumView *loseNumView = [[TTMLoseNumView alloc] initWithModel:self.pageModel];
    TTMInfoView *loseNumInfoView = [[TTMInfoView alloc] initWithIconName:@"gtask_doctor_another_info_icon"
                                                                        title:@"失败率"
                                                                  contentView:loseNumView];
    loseNumInfoView.origin = CGPointMake(0, self.doctorInfoView.bottom + kMarginTop);
    [self.scrollView addSubview:loseNumInfoView];
    self.loseNumInfoView = loseNumInfoView;
    
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, loseNumInfoView.bottom);
}

/**
 *  查询详情数据
 */
- (void)queryData {
    __weak __typeof(&*self) weakSelf = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDWithView:self.view.window text:@"加载中..."];
    [TTMGTaskCellModel queryDoctorDetailWithId:self.model.doctor_id complete:^(id result) {
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
