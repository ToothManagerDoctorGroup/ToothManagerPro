

#import "TTMWithdrawRecordController.h"
#import "TTMWithdrawCell.h"

#define kRowH 44.f

@interface TTMWithdrawRecordController ()<
    UITableViewDelegate,
    UITableViewDataSource>

@property (nonatomic, weak)   UIView *headView;
@property (nonatomic, weak)   UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation TTMWithdrawRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现记录";
    
    [self setupHeadView];
    [self setupTableView];
}

- (void)setupHeadView {
    UIView *bgView = [UIView new];
    [self.view addSubview:bgView];
    self.headView = bgView;
    
    NSUInteger count = 3;
    CGFloat titleW = ScreenWidth / count;
    CGFloat titleH = 44.f;
    
    bgView.frame = CGRectMake(0, NavigationHeight, ScreenWidth, titleH);
    for (NSUInteger i = 0; i < count; i ++) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.frame = CGRectMake(i * titleW, 0, titleW, titleH);
        [bgView addSubview:titleLabel];
        if (i == 0) {
            titleLabel.text = @"时间";
        } else if (i == 1) {
            titleLabel.text = @"金额";
        } else if (i == 2) {
            titleLabel.text = @"状态";
        }
    }
}

- (void)setupTableView {
    CGFloat tableHeight = ScreenHeight - NavigationHeight- self.headView.height;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headView.bottom,
                                                                           ScreenWidth, tableHeight)
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = kRowH;
    
    __weak __typeof(&*self) weakSelf = self;
    [tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf queryInfo];
    }];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self.tableView.header beginRefreshing];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTMWithdrawCell *cell = [TTMWithdrawCell cellWithTableView:tableView];
    if (self.dataArray.count > 0) {
        TTMWithdrawModel *model = self.dataArray[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 *  查询提现记录
 */
- (void)queryInfo {
    __weak __typeof(&*self) weakSelf = self;
    
    [TTMWithdrawModel queryWithdrawRecordWithComplete:^(id result) {
        [weakSelf.tableView.header endRefreshing];
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
