//
//  TTMAppointmentController.m
//  ToothManager
//

#import "TTMAppointmentController.h"
#import "TTMSegmentedView.h"
#import "TTMSegmentedButton.h"
#import "TTMIncomeCell.h"
#import "TTMIncomeModel.h"
#import "MJRefresh.h"
#import "TTMScheduleRequestModel.h"
#import "TTMScheduleCellModel.h"
#import "TTMPopoverView.h"
#import "TTMChairModel.h"
#import "TTMScheduleDetailController.h"

#define kSegmentH 40.f
#define kSegmentItemW (ScreenWidth / 4)
#define kSegmentW kSegmentItemW * 3
#define kTitleFontSize 15
#define kMargin 20.f
#define kSectionH 30.f

@interface TTMAppointmentController ()<
    TTMSegmentedViewDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    TTMIncomeCellDelegate>

@property (nonatomic, weak)   TTMSegmentedView *segmentView;
@property (nonatomic, weak)   UITableView *tableView;

@property (nonatomic, strong) NSArray *chairArray; // 椅位数组
@property (nonatomic, strong) NSMutableArray *chairTitles; // 椅位title
@property (nonatomic, strong) TTMChairModel *currentChair; // 当前椅位
@property (nonatomic, assign) NSInteger currentStatus; // 当前状态(0/1/2)进行中，已完成,全部

@property (nonatomic, strong) NSArray *sections; // 分组 , 存放nsdictionary ，key:(title,data)
@property (nonatomic, strong) NSArray *dataArray; // 数据，准备废弃

@end

@implementation TTMAppointmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的预约";
    
    [self setupSegmentView];
    [self setupTableView];
    self.currentStatus = 2; // 初始查询全部
    
    [self queryChairsData];
}
/**
 *  加载segment视图
 */
- (void)setupSegmentView {
    CGRect frame = CGRectMake(0, NavigationHeight, kSegmentW, kSegmentH);
    TTMSegmentedView *segmentView = [[TTMSegmentedView alloc] initWithFrame:frame];
    segmentView.segmentedTitles = @[@"全部", @"进行中", @"已完成"];
    segmentView.delegate = self;
    [self.view addSubview:segmentView];
    self.segmentView = segmentView;
    
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
/**
 *  加载tableview
 */
- (void)setupTableView {
    CGFloat tableHeight = ScreenHeight - self.segmentView.bottom;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.segmentView.bottom,
                                                                           ScreenWidth, tableHeight)
                                                          style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sectionDict = self.sections[section];
    NSArray *sectionArray = sectionDict[@"data"];
    return sectionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kSectionH)];
    yearLabel.backgroundColor = [UIColor clearColor];
    yearLabel.textAlignment = NSTextAlignmentCenter;
    yearLabel.font = [UIFont systemFontOfSize:15];
    NSDictionary *sectionDict = self.sections[section];
    yearLabel.text = sectionDict[@"title"];
    return yearLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionDict = self.sections[indexPath.section];
    NSArray *sectionArray = sectionDict[@"data"];
    TTMIncomeCellModel *model = sectionArray[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTMIncomeCell *cell = [ TTMIncomeCell cellWithTableView:tableView];
    cell.delegate = self;
    NSDictionary *sectionDict = self.sections[indexPath.section];
    NSArray *sectionArray = sectionDict[@"data"];
    TTMIncomeCellModel *model = sectionArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 自定义事件
- (void)segmentedViewDidSelected:(TTMSegmentedView *)segmentedView fromIndex:(NSUInteger)from toIndex:(NSUInteger)to {
    if (to == 0) { // 全部
        self.currentStatus = 2;
    } else if (to == 1) { // 进行中
        self.currentStatus = 0;
    } else if (to == 2) { // 已完成
        self.currentStatus = 1;
    }
}
/**
 *  点击行事件，进入详情
 *
 *  @param cell        cell
 *  @param incomeModel 预约model
 */
- (void)incomeCell:(TTMIncomeCell *)cell incomModel:(TTMIncomeModel *)incomeModel {
    TTMScheduleDetailController *detailVC = [[TTMScheduleDetailController alloc] init];
    TTMScheduleCellModel *cellModel = [[TTMScheduleCellModel alloc] init];
    cellModel.keyId = incomeModel.keyId;
    detailVC.model = cellModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}
/**
 *  设置当前状态，并刷新数据
 *
 *  @param currentStatus 当前状态
 */
- (void)setCurrentStatus:(NSInteger)currentStatus {
    _currentStatus = currentStatus;
    [self queryData:TTMScheduleRequestTypeStatus];
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
        [weakSelf queryData:TTMScheduleRequestTypeChair];
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

/**
 *  查询预约
 *
 *  @param requestType 请求类型
 */
- (void)queryData:(TTMScheduleRequestType)requestType {
    __weak __typeof(&*self) weakSelf = self;
    TTMScheduleRequestModel *requestModel = [[TTMScheduleRequestModel alloc] init];
    requestModel.requestType = requestType;
    requestModel.chair = self.currentChair;
    requestModel.status = self.currentStatus;
    requestModel.controlType = TTMScheduleRequestModelControlTypeAppointment;
    
    [TTMScheduleCellModel querySchedulesWithRequest:requestModel complete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.sections = [weakSelf sortArrayByYear:result];
            [weakSelf.tableView reloadData];
        }
    }];
}

/**
 *  按年分组排序
 *
 *  @param array 返回的结果数组
 *
 *  @return TTMIncomeCellModel 数组
 */
- (NSArray *)sortArrayByYear:(NSArray *)array {
    NSMutableArray *yearArray = [NSMutableArray array];
    NSDate *lastDate = nil; // 上一次date
    
    for (NSUInteger i = 0; i < array.count; i ++) {
        TTMScheduleCellModel *scheduleModel = array[i];
        TTMIncomeModel *incomeModel = [scheduleModel incomeModelAdapter]; // 转换位incomeModel
        incomeModel.person = incomeModel.person; // 椅位号
        NSDate *dateTime = [incomeModel.time dateValue]; // 这一条数据的时间
        
        if ([dateTime fs_year] != [lastDate fs_year]) { // 与前一条数据的年份不相同
            NSMutableArray *monthArray = [NSMutableArray array];
            [monthArray addObject:incomeModel];
            [yearArray addObject:monthArray];
        } else { // 相同则继续添加
            NSMutableArray *monthArray = [yearArray lastObject];
            [monthArray addObject:incomeModel];
        }
        lastDate = [dateTime copy];
    }
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSMutableArray *yearsMonth in yearArray) {
        NSArray *monthArray = [self sortArrayByMonth:yearsMonth]; // 得到月份数组
        TTMIncomeCellModel *cellModel = monthArray[0];
        NSDictionary *dict = @{@"title": [cellModel.year stringByAppendingString:@"年"],
                               @"data": monthArray};
        [tempArray addObject:dict];
    }
    return tempArray;
}

/**
 *  按月分组排序
 *
 *  @param array 返回的结果数组
 *
 *  @return TTMIncomeCellModel 数组
 */
- (NSArray *)sortArrayByMonth:(NSArray *)array {
    NSMutableArray *mutArray = [NSMutableArray array];
    NSDate *lastDate = nil;
    
    for (NSUInteger i = 0; i < array.count; i ++) {
        TTMIncomeModel *incomeModel = array[i];
        NSDate *dateTime = [incomeModel.time dateValue]; // 这一条数据的时间
        
        if ([dateTime fs_month] != [lastDate fs_month]) { // 与前一条数据的月份不相同
            TTMIncomeCellModel *incomeCellModel = [[TTMIncomeCellModel alloc] init];
            incomeCellModel.month = [NSString stringWithFormat:@"%@", @([dateTime fs_month])];
            incomeCellModel.year = [NSString stringWithFormat:@"%@", @([dateTime fs_year])];
            [incomeCellModel.infoList addObject:incomeModel];
            [mutArray addObject:incomeCellModel];
        } else { // 相同则继续添加
            TTMIncomeCellModel *incomeCellModel = [mutArray lastObject];
            [incomeCellModel.infoList addObject:incomeModel];
        }
        lastDate = [dateTime copy];
    }
    return mutArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
