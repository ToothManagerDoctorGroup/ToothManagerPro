

#import "TTMApointmentSegmentController.h"
#import "TTMSegmentedView.h"
#import "TTMSegmentedButton.h"
#import "MJRefresh.h"
#import "TTMPopoverView.h"
#import "TTMChairModel.h"
#import "TTMAppointmentingController.h"
#import "TTMAppointmentedController.h"

#define kSegmentH 40.f
#define kSegmentItemW (ScreenWidth / 4)
#define kSegmentW kSegmentItemW * 3
#define kTitleFontSize 15
#define kMargin 20.f
#define kSectionH 30.f

NSString *const TTMApointmentSegmentControllerSortByChair = @"TTMApointmentSegmentControllerSortByChair";

@interface TTMApointmentSegmentController ()<TTMSegmentedViewDelegate>

@property (nonatomic, weak)   TTMSegmentedView *segmentView;
@property (nonatomic, weak)   UIView *contentView; // 内容视图

@property (nonatomic, strong) NSArray *chairArray; // 椅位数组
@property (nonatomic, strong) NSMutableArray *chairTitles; // 椅位title
@property (nonatomic, strong) TTMChairModel *currentChair; // 当前椅位

@end

@implementation TTMApointmentSegmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的预约";
    
    [self setupSegmentView];
    [self queryChairsData];
}

/**
 *  加载segment视图
 */
- (void)setupSegmentView {
    CGRect frame = CGRectMake(0, NavigationHeight, kSegmentW, kSegmentH);
    TTMSegmentedView *segmentView = [[TTMSegmentedView alloc] initWithFrame:frame];
    segmentView.delegate = self;
    [self.view addSubview:segmentView];
    self.segmentView = segmentView;
    
    // 设置页面
    TTMAppointmentingController *appointmenting = [TTMAppointmentingController new];
    appointmenting.title = @"进行中";
    TTMAppointmentedController *appointmented = [TTMAppointmentedController new];
    appointmented.title = @"已完成";
    [self addChildViewController:appointmenting];
    [self addChildViewController:appointmented];
    
    segmentView.segmentControllers = @[appointmenting, appointmented];
    
    UIView *contentView = [[UIView alloc] init];
    [contentView addSubview:appointmenting.view];
    [self.view addSubview:contentView];
    CGFloat contentHeight = ScreenHeight - NavigationHeight - kSegmentH;
    contentView.frame = CGRectMake(0, segmentView.bottom, ScreenWidth, contentHeight);
    self.contentView = contentView;
    
    
    UIButton *chairButton = [[UIButton alloc] init];
    chairButton.titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    [chairButton setTitle:@"椅位" forState:UIControlStateNormal];
    [chairButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [chairButton setTitleColor:MainColor forState:UIControlStateSelected];
    [chairButton setImage:[UIImage imageNamed:@"member_down_arrow"] forState:UIControlStateNormal];
    [chairButton addTarget:self action:@selector(chairButtonAction:) forControlEvents:UIControlEventTouchDown];
    
    chairButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    chairButton.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:chairButton];
    
    chairButton.frame = CGRectMake(segmentView.right, NavigationHeight, kSegmentItemW, kSegmentH);
}

#pragma mark - 自定义事件
- (void)segmentedViewDidSelected:(TTMSegmentedView *)segmentedView fromIndex:(NSUInteger)from toIndex:(NSUInteger)to {
    UIViewController *fromVC = self.childViewControllers[from];
    UIViewController *toVC = self.childViewControllers[to];
    
    [fromVC.view removeFromSuperview];
    [self.contentView addSubview:toVC.view];
}

- (void)setCurrentChair:(TTMChairModel *)currentChair {
    // 通知椅位i排序
    [[NSNotificationCenter defaultCenter] postNotificationName:TTMApointmentSegmentControllerSortByChair
                                                        object:currentChair];
}

/**
 *  椅位按钮点击事件
 *
 */
- (void)chairButtonAction:(UIButton *)sender {
    CGPoint point = CGPointMake(sender.left + sender.width/2,
                                sender.bottom);
    TTMPopoverView *pop = [[TTMPopoverView alloc] initWithPoint:point titles:self.chairTitles images:nil];
    __weak __typeof(&*self) weakSelf = self;
    pop.selectRowAtIndex = ^(NSInteger index){
        weakSelf.currentChair = weakSelf.chairArray[index];
    };
    [pop show];
}

/**
 *  查询椅位信息
 */
- (void)queryChairsData {
    __weak __typeof(&*self) weakSelf = self;
    [TTMChairModel queryChairsWithComplete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.chairArray = result;
            weakSelf.chairTitles = [NSMutableArray array];
            for (TTMChairModel *chair in weakSelf.chairArray) {
                [weakSelf.chairTitles addObject:chair.seat_name];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
