//
//  TTMMessageController.m
//  ToothManager
//

#import "TTMMessageController.h"
#import "TTMSegmentedView.h"
#import "MJRefresh.h"
#import "TTMMessageCell.h"
#import "TTMMessageMCell.h"
#import "TTMScheduleCellModel.h"
#import "TTMScheduleDetailController.h"
#import "TTMIncomDetailController.h"
#import "TTMHandContractController.h"
#import "TTMGTaskCellModel.h"
#import "TTMChargeDetailController.h"

#define kSegmentH 40.f
#define kMarginTop 20.f
//#define kRowH 84.f
#define kRowH 44.f

@interface TTMMessageController ()<
    TTMSegmentedViewDelegate,
    UITableViewDelegate,
    UITableViewDataSource>

@property (nonatomic, weak)   TTMSegmentedView *segmentView;
@property (nonatomic, weak)   UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation TTMMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    
    [self setupSegmentView];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self queryDataWithStatus:self.segmentView.selectedIndex];
}

/**
 *  加载segment视图
 */
- (void)setupSegmentView {
    CGRect frame = CGRectMake(0, NavigationHeight + kMarginTop, ScreenWidth, kSegmentH);
    TTMSegmentedView *segmentView = [[TTMSegmentedView alloc] initWithFrame:frame];
    segmentView.segmentedTitles = @[@"未读", @"已读"];
    segmentView.delegate = self;
    [self.view addSubview:segmentView];
    self.segmentView = segmentView;
    
}
/**
 *  加载tableview
 */
- (void)setupTableView {
    CGFloat tableHeight = ScreenHeight - self.segmentView.bottom - kMarginTop;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.segmentView.bottom + kMarginTop,
                                                                           ScreenWidth, tableHeight)
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = kRowH;
    
    __weak __typeof(&*self) weakSelf = self;
    [tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf queryDataWithStatus:weakSelf.segmentView.selectedIndex];
    }];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTMMessageMCell *cell = [ TTMMessageMCell cellWithTableView:tableView];
    if (self.dataArray.count > 0) {
        TTMMessageCellModel *model = self.dataArray[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TTMMessageCellModel *messageModel = self.dataArray[indexPath.row];
    
    if ([messageModel.message_type isEqualToString:kMessageTypeReserve]) {
        TTMScheduleDetailController *scheduleVC = [[TTMScheduleDetailController alloc] init];
        TTMScheduleCellModel *model = [TTMScheduleCellModel new];
        model.keyId = messageModel.message_id;
        scheduleVC.model = model;
        [self.navigationController pushViewController:scheduleVC animated:YES];
    } else if ([messageModel.message_type isEqualToString:kMessageTypeSign]) {
        TTMHandContractController *handVC = [TTMHandContractController new];
        TTMGTaskCellModel *model = [TTMGTaskCellModel new];
        model.keyId = messageModel.message_id;
        handVC.model = model;
        [self.navigationController pushViewController:handVC animated:YES];
    } else if ([messageModel.message_type isEqualToString:kMessageTypePay]) {
        TTMChargeDetailController *incomeVC = [TTMChargeDetailController new];
        TTMApointmentModel *model = [TTMApointmentModel new];
        model.KeyId = messageModel.message_id;
        incomeVC.model =  model;
        [self.navigationController pushViewController:incomeVC animated:YES];
    }
    
    // 调用已读
    [TTMMessageCellModel changeNotReadMessageWithId:messageModel.keyId complete:^(id result) {
    }];
}
/**
 *  选中segment时间
 *
 *  @param segmentedView segmentedView description
 *  @param from          from description
 *  @param to            to description
 */
- (void)segmentedViewDidSelected:(TTMSegmentedView *)segmentedView fromIndex:(NSUInteger)from toIndex:(NSUInteger)to {
    [self queryDataWithStatus:to];
}

/**
 *  查询数据
 */
- (void)queryDataWithStatus:(TTMMessageStatusType)status {
    __weak __typeof(&*self) weakSelf = self;
    [TTMMessageCellModel queryMessageListWithStatus:status Complete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.dataArray = result;
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
