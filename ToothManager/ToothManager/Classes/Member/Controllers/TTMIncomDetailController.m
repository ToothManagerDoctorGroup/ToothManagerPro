

#import "TTMIncomDetailController.h"
#import "TTMScheduleCellModel.h"
#import "TTMContractHeaderView.h"
#import "TTMInfoView.h"
#import "TTMShowTextView.h"
#import "TTMScheduleDetailInfoView.h"
#import "TTMGTaskCellModel.h"

#define kMarginTop 20.f

@interface TTMIncomDetailController ()

@property (nonatomic, weak)     UIScrollView *scrollView;
@property (nonatomic, weak)     TTMContractHeaderView *headerView; //头视图
@property (nonatomic, weak)     TTMInfoView *detailInfoView; //详细信息
@property (nonatomic, weak)     TTMInfoView *seggustionInfoView; // 专家建议


@property (nonatomic, strong)   TTMScheduleCellModel *pageModel; // 页面model
@end

@implementation TTMIncomDetailController

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
    [self setupHeaderView];
    [self setupDetailInfoView];
//    [self setupSegguestion];
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
 *  专家建议
 */
- (void)setupSegguestion {
    NSString *segguestText = self.pageModel.expert_suggestion;
    
    TTMShowTextView *textView = [[TTMShowTextView alloc] initWithContent:segguestText];
    
    TTMInfoView *seggustionInfoView = [[TTMInfoView alloc] initWithIconName:@"gtask_protocol_icon"
                                                                      title:@"专家建议"
                                                                contentView:textView];
    
    seggustionInfoView.origin = CGPointMake(0, self.detailInfoView.bottom + kMarginTop);
    [self.scrollView addSubview:seggustionInfoView];
    self.seggustionInfoView = seggustionInfoView;
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, seggustionInfoView.bottom);
}

/**
 *  查询数据
 */
- (void)queryData {
    __weak __typeof(&*self) weakSelf = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDWithView:self.view.window text:@"加载中..."];
    [TTMScheduleCellModel queryScheduleDetailWithAppointId:self.model.appoint_id complete:^(id result) {
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
