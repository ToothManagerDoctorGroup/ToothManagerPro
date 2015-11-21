//
//  TTMDoctorsController.m
//  ToothManager
//

#import "TTMDoctorsController.h"
#import "MJRefresh.h"
#import "TTMGTaskCell.h"
#import "TTMGTaskCellModel.h"
#import "TTMDoctorDetailController.h"

#define kRowHeight 100.f

@interface TTMDoctorsController ()<
    UITableViewDelegate,
    UITableViewDataSource,
    TTMGTaskCellDelegate>

@property (nonatomic, weak)   UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIWebView *phoneWebView;

@end

@implementation TTMDoctorsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"医生库";
    
    self.dataArray = [NSMutableArray array];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self queryData];
}

/**
 *  加载tableview
 */
- (void)setupTableView {
    CGFloat tableHeight = ScreenHeight;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tableHeight)
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
        model.type = TTMGTaskCellModelTypeDoctors;
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TTMDoctorDetailController *doctorDetailVC = [[TTMDoctorDetailController alloc] init];
    doctorDetailVC.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:doctorDetailVC animated:YES];
}

/**
 *  点击打电话按钮事件
 *
 *  @param cell  cell
 *  @param model model
 */
- (void)gtaskCell:(TTMGTaskCell *)cell model:(TTMGTaskCellModel *)model {
    if (!self.phoneWebView) {
        UIWebView *webView = [[UIWebView alloc] init];
        self.phoneWebView = webView;
    }
    NSString *tel = [NSString stringWithFormat:@"tel://%@", model.doctor_hospital];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: tel]];
    [self.phoneWebView loadRequest:request];
}
/**
 *  刷新数据
 */
- (void)queryData {
    __weak __typeof(&*self) weakSelf = self;
    [TTMGTaskCellModel queryDoctorListWithComplete:^(id result) {
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

@end
