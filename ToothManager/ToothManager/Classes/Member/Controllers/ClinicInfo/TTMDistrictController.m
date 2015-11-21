

#import "TTMDistrictController.h"

#define kRowH 44.f

@interface TTMDistrictController ()<
    UITableViewDelegate,
    UITableViewDataSource>

@property (nonatomic, weak)   UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation TTMDistrictController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择地区";
    
    [self setupTableView];
}

/**
 *  加载tableview
 */
- (void)setupTableView {
    CGFloat tableHeight = ScreenHeight;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tableHeight)
                                                          style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = kRowH;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}


- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"北京", @"上海", @"广州", @"重庆"];
    }
    return _dataArray;
}


#pragma maek - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = TableViewCellSeparatorColor;
        separatorView.alpha = TableViewCellSeparatorAlpha;
        separatorView.frame = CGRectMake(0, kRowH - TableViewCellSeparatorHeight, ScreenWidth, TableViewCellSeparatorHeight);
        [cell.contentView addSubview:separatorView];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
