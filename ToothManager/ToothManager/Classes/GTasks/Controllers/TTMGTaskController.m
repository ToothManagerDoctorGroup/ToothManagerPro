//
//  TTMGTaskController.m
//  ToothManager
//

#import "TTMGTaskController.h"
#import "MJRefresh.h"
#import "TTMGTaskCell.h"
#import "TTMGTaskCellModel.h"
#import "TTMHandContractController.h"
#import "TTMSegmentedView.h"

#define kRowHeight 100.f
#define kSegmentH 40.f
#define kMarginTop 20.f

NSString *const TTMGTaskControllerRefreshNotification = @"TTMGTaskControllerRefreshNotification";

@interface TTMGTaskController ()<
    UITableViewDelegate,
    UITableViewDataSource,
    TTMGTaskCellDelegate,
    TTMSegmentedViewDelegate>

@property (nonatomic, weak)   TTMSegmentedView *segmentView;
@property (nonatomic, weak)   UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger currentStatus;
@end

@implementation TTMGTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"待办事项";
    self.dataArray = [NSMutableArray array];
    
    [self setupSegmentView];
    [self setupTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryData)
                                                 name:TTMGTaskControllerRefreshNotification
                                               object:nil];
}
/**
 *  加载segment视图
 */
- (void)setupSegmentView {
    CGRect frame = CGRectMake(0, NavigationHeight, ScreenWidth, kSegmentH);
    TTMSegmentedView *segmentView = [[TTMSegmentedView alloc] initWithFrame:frame];
    segmentView.segmentedTitles = @[@"待处理", @"已处理"];
    segmentView.delegate = self;
    [self.view addSubview:segmentView];
    self.segmentView = segmentView;
    
}
/**
 *  加载tableview视图
 */
- (void)setupTableView {
    CGFloat tableHeight = ScreenHeight - NavigationHeight - kSegmentH - TabbarHeight;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.segmentView.bottom, ScreenWidth, tableHeight)
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = kRowHeight;
    tableView.delaysContentTouches = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    
    __weak __typeof(&*self) weakSelf = self;
    [tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf queryData];
    }];
    [tableView.header beginRefreshing];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma maek - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTMGTaskCell *cell = [TTMGTaskCell taskCellWithTableView:tableView];
    cell.delegate = self;
    if (self.dataArray.count > 0) {
        TTMGTaskCellModel *model = self.dataArray[indexPath.row];
        model.type = TTMGTaskCellModelTypeGTask;
        model.currentStatus = self.currentStatus;
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TTMGTaskCellModel *model = self.dataArray[indexPath.row];
    TTMHandContractController *handVC = [[TTMHandContractController alloc] init];
    handVC.model = model;
    handVC.currentStatus = self.currentStatus;
    [self.navigationController pushViewController:handVC animated:YES];
}
/**
 *  点击处理预约事件
 *
 *  @param cell  cell description
 *  @param model model description
 */
- (void)gtaskCell:(TTMGTaskCell *)cell model:(TTMGTaskCellModel *)model {
    TTMHandContractController *handVC = [[TTMHandContractController alloc] init];
    handVC.model = model;
    handVC.currentStatus = self.currentStatus;
    [self.navigationController pushViewController:handVC animated:YES];
}
/**
 *  点击segment事件
 *
 *  @param segmentedView segmentedView description
 *  @param from          from description
 *  @param to            to description
 */
- (void)segmentedViewDidSelected:(TTMSegmentedView *)segmentedView fromIndex:(NSUInteger)from toIndex:(NSUInteger)to {
    self.currentStatus = to;
    [self queryData];
}
/**
 *  刷新数据
 */
- (void)queryData {
    __weak __typeof(&*self) weakSelf = self;
    [TTMGTaskCellModel queryListWithStatus:self.currentStatus complete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.dataArray = result;
            [weakSelf.tableView reloadData];
        }
        [weakSelf.tableView.header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
