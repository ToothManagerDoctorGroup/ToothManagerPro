

#import "TTMChairSettingController.h"
#import "UIBarButtonItem+TTMAddtion.h"
#import "TTMChairModel.h"
#import "TTMSegmentedView.h"
#import "TTMChairSettingContentController.h"

#define kSegmentH 40.f

@interface TTMChairSettingController ()<TTMSegmentedViewDelegate>

@property (nonatomic, strong) NSArray *chairArray; // 椅位数组
@property (nonatomic, strong) NSArray *controllerArray; // 子控制器数组

@property (nonatomic, weak)   TTMSegmentedView *segmentView; // segment视图
@property (nonatomic, weak)   UIView *contentView; // 内容视图
@end

@implementation TTMChairSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"椅位配置";
    
    [self setupRightItem];
    [self queryChairs];
}

- (void)setupRightItem {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"保存"
                                                                     normalImageName:@"member_bar_item_bg"
                                                                              action:@selector(buttonAction:)
                                                                              target:self];
}

- (void)setupSegmentView {
    CGRect frame = CGRectMake(0, NavigationHeight, ScreenWidth, kSegmentH);
    TTMSegmentedView *segmentView = [[TTMSegmentedView alloc] initWithFrame:frame];
    segmentView.delegate = self;
    [self.view addSubview:segmentView];
    self.segmentView = segmentView;
    
    
    // 设置页面
    NSMutableArray *tempControllers = [NSMutableArray array];
    for (TTMChairModel *chairModel in self.chairArray) {
        TTMChairSettingContentController *contentVC = [TTMChairSettingContentController new];
        contentVC.title = chairModel.seat_name;
        contentVC.chairModel = chairModel;
        
        [self addChildViewController:contentVC];
        [tempControllers addObject:contentVC];
    }
    self.controllerArray = tempControllers;
    segmentView.segmentControllers = tempControllers;
    
    UIView *contentView = [[UIView alloc] init];
    TTMChairSettingContentController *contentVC = tempControllers[0];
    [contentView addSubview:contentVC.view];
    [self.view addSubview:contentView];
    CGFloat contentHeight = ScreenHeight - NavigationHeight - kSegmentH;
    contentView.frame = CGRectMake(0, segmentView.bottom, ScreenWidth, contentHeight);
    self.contentView = contentView;

}

#pragma mark - segmentView代理
- (void)segmentedViewDidSelected:(TTMSegmentedView *)segmentedView fromIndex:(NSUInteger)from toIndex:(NSUInteger)to {
    UIViewController *fromVC = self.childViewControllers[from];
    UIViewController *toVC = self.childViewControllers[to];
    
    [fromVC.view removeFromSuperview];
    [self.contentView addSubview:toVC.view];
}

- (void)buttonAction:(UIButton *)button {
    [[NSNotificationCenter defaultCenter] postNotificationName:TTMChairSettingContentControllerSave object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  查询椅位信息
 */
- (void)queryChairs {
    __weak __typeof(&*self) weakSelf = self;
    [TTMChairModel queryChairsForSettingWithComplete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.chairArray = result;
            [weakSelf setupSegmentView];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
