

#import "TTMAppointmentingController.h"
#import "TTMSegmentedView.h"
#import "TTMApointmentingCell.h"
#import "TTMChargeDetailController.h"
#import "TTMChargeConfirmController.h"
#import "TTMApointmentSegmentController.h"
#import "TTMChargeConfirmController.h"
#import "TTMChairModel.h"
#import "TTMScheduleDetailController.h"
#import "TTMScheduleCellModel.h"

#define kMargin 10.f
#define kSegmentH 40.f
#define kSectionH 30.f

@interface TTMAppointmentingController ()<
    UITableViewDelegate,
    UITableViewDataSource,
    TTMSegmentedViewDelegate,
    TTMApointmentingCellDelegate>

@property (nonatomic, weak)   TTMSegmentedView *segmentView;

@property (nonatomic, weak)   UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray; // 展示的数组

@property (nonatomic, copy) NSArray *allDataArray; // 所有数组

@end

@implementation TTMAppointmentingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSegmentView];
    [self setupTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sortByNotification:)
                                                 name:TTMApointmentSegmentControllerSortByChair
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self queryWithTimeType:self.segmentView.selectedIndex];
}

/**
 *  加载segment视图
 */
- (void)setupSegmentView {
    CGFloat segmentW = 240.f;
    CGRect frame = CGRectMake((ScreenWidth - segmentW) / 2, kMargin, segmentW, kSegmentH);
    TTMSegmentedView *segmentView = [[TTMSegmentedView alloc] initWithFrame:frame];
    segmentView.delegate = self;
    segmentView.segmentedTitles = @[@"今日", @"本周", @"本月"];
    segmentView.bottomLine.width = segmentW;
    [self.view addSubview:segmentView];
    self.segmentView = segmentView;
}

/**
 *  加载tableview
 */
- (void)setupTableView {
    CGFloat tableHeight = ScreenHeight - 2 * kSegmentH - 2 * kMargin - NavigationHeight;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.segmentView.bottom + kMargin,
                                                                           ScreenWidth, tableHeight)
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTMAppointmentingCellModel *model = self.dataArray[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTMApointmentingCell *cell = [TTMApointmentingCell cellWithTableView:tableView];
    if (self.dataArray.count > 0) {
        cell.model = self.dataArray[indexPath.row];
        cell.delegate = self;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TTMSegmentedViewDelegate
- (void)segmentedViewDidSelected:(TTMSegmentedView *)segmentedView fromIndex:(NSUInteger)from toIndex:(NSUInteger)to {
    [self queryWithTimeType:to];
}

#pragma mark - TTMApointmentingCellDelegate
- (void)apointmentingCell:(TTMApointmentingCell *)apointmentingCell model:(TTMApointmentModel *)model {
    if (model.status == TTMApointmentStatusNotStart) { // 开始计时
        __weak __typeof(&*self) weakSelf = self;
        CYAlertView * alert = [[CYAlertView alloc] initWithTitle:@"确定要开始计时"
                                                         message:nil
                                                    clickedBlock:^(CYAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                                                        if (buttonIndex == 1) {
                                                            [weakSelf startWithModel:model];
                                                        }
                                                    }
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
        [alert show];
    } else if (model.status == TTMApointmentStatusStarting) { // 结束计时
        __weak __typeof(&*self) weakSelf = self;
        CYAlertView * alert = [[CYAlertView alloc] initWithTitle:@"确定要结束计时"
                                                         message:nil
                                                    clickedBlock:^(CYAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                                                        if (buttonIndex == 1) {
                                                            [weakSelf endWithModel:model];
                                                        }
                                                    }
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
        [alert show];
    } else if (model.status == TTMApointmentStatusWaitPay) { // 等待付款
        TTMChargeDetailController *chargeVC = [TTMChargeDetailController new];
        chargeVC.model = model;
        [self.navigationController pushViewController:chargeVC animated:YES];
    } else if ( model.status == TTMApointmentStatusEnded) { // 收费确认
        TTMChargeConfirmController *confirmVC = [TTMChargeConfirmController new];
        confirmVC.model = model;
        [self.navigationController pushViewController:confirmVC animated:YES];
    }
}

- (void)apointmentingCell:(TTMApointmentingCell *)apointmentingCell clickedLineWithModel:(TTMApointmentModel *)model {
    TTMScheduleCellModel *temp = [[TTMScheduleCellModel alloc] init];
    temp.keyId = model.KeyId;
    TTMScheduleDetailController *detailVC = [[TTMScheduleDetailController alloc] init];
    detailVC.model = temp;
    [self.navigationController pushViewController:detailVC animated:YES];
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
            [weakSelf queryWithTimeType:weakSelf.segmentView.selectedIndex];
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
 *  按时间段查询预约列表
 *
 *  @param timeType 时间类型
 */
- (void)queryWithTimeType:(NSUInteger)timeType {
    __weak __typeof(&*self) weakSelf = self;
    [TTMApointmentModel queryAppointmentListWithTimeType:timeType complete:^(id result) {
        if([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            self.allDataArray = result; // 原始的所有数据
            weakSelf.dataArray = [weakSelf sortArrayByDay:result];
            [weakSelf.tableView reloadData];
        }
    }];
}

/**
 *  按天排序
 *
 *  @param array 数组
 *
 *  @return 数组
 */
- (NSArray *)sortArrayByDay:(NSArray *)array {
    NSMutableArray *mutArray = [NSMutableArray array];
    NSDate *lastDate = nil;
    
    for (NSUInteger i = 0; i < array.count; i ++) {
        TTMApointmentModel *appointmentModel = array[i];
        NSDate *dateTime = [appointmentModel.appoint_time dateValue]; // 这一条数据的时间
        
        if ([dateTime fs_day] != [lastDate fs_day]) { // 与前一条数据的天不相同
            TTMAppointmentingCellModel *appointmentCellModel = [[TTMAppointmentingCellModel alloc] init];
            appointmentCellModel.day = [dateTime fs_stringWithFormat:@"MM月dd日"];
            [appointmentCellModel.infoList addObject:appointmentModel];
            [mutArray addObject:appointmentCellModel];
        } else { // 相同则继续添加
            TTMAppointmentingCellModel *appointmentCellModel = [mutArray lastObject];
            [appointmentCellModel.infoList addObject:appointmentModel];
        }
        lastDate = [dateTime copy];
    }
    return mutArray;
}


/**
 *  通知根据椅位排序
 *
 *  @param notification 通知信息
 */
- (void)sortByNotification:(NSNotification *)notification {
    TTMChairModel *chairModel = notification.object;
    NSArray *tempArray = [self.allDataArray copy];
    
    NSMutableArray *chairArray = [NSMutableArray array];
    if (!chairModel.seat_id) { // 表示查询全部
        [chairArray addObjectsFromArray:tempArray];
    } else {
        for (TTMApointmentModel *model in tempArray) {
            if ([model.seat_id isEqualToString:chairModel.seat_id]) {
                [chairArray addObject:model];
            }
        }
    }
    self.dataArray = [self sortArrayByDay:chairArray];
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
