

#import "TTMSelectValueView.h"

#define kRowH 44.f
#define kTableViewW 200.f

@interface TTMSelectValueView ()<
    UITableViewDelegate,
    UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation TTMSelectValueView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIControl *blackView = [[UIControl alloc] initWithFrame:self.frame];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.5f;
    [blackView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:blackView];
    
    [self setupTableView];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    self.tableView.height = dataArray.count * kRowH;
    [self.tableView reloadData];
}

- (void)setupTableView {
    CGRect frame = CGRectMake(0, 0, kTableViewW, self.dataArray.count * kRowH);
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.center = self.center;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = kRowH;
    [self addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - UITableView datasouce delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    TTMMaterialModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.mat_name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(selectValueView:selectedModel:)]) {
        [self.delegate selectValueView:self selectedModel:self.dataArray[indexPath.row]];
        [self dismiss];
    }
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}
@end
