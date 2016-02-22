//
//  AppoinmentMenuViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/21.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "AppoinmentMenuViewController.h"
#import "JTCalendar.h"
#import "AppointmentTableViewCell.h"
#import "MyDateTool.h"

@interface AppoinmentMenuViewController ()<JTCalendarDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,JTCalendarDelegate>{
    
    UICollectionView *_collectionView;
    UITableView *_tableView;
}

@property (nonatomic, strong)JTCalendar *calendar;
@property (nonatomic, weak)JTCalendarMenuView *calendarMenuView;
@property (nonatomic, weak)JTCalendarContentView *contentView;

@property (nonatomic, strong)NSArray *dataList;

@property (nonatomic, strong)NSMutableArray *currentWeekDates;
@end

@implementation AppoinmentMenuViewController

- (NSMutableArray *)currentWeekDates{
    if (!_currentWeekDates) {
        _currentWeekDates = [NSMutableArray array];
    }
    return _currentWeekDates;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //去除多余的视图
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *view = keyWindow.subviews[1];
    [view removeFromSuperview];
    
    //设置导航栏视图
    [self setUpNav];
    //设置数据源
    [self setUpData];
    
    //创建日历视图
    [self setCalendarView];
    //创建时间视图
    [self setCollectionView];
    //设置时间间隔视图
    [self setTimeTableView];
    
}

#pragma mark - 初始化导航栏视图
- (void)setUpNav{
    self.title = @"我的预约本";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
}

#pragma mark - 设置起始数据
- (void)setUpData{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *mondayDate = [MyDateTool getMondayDateWithCurrentDate:[NSDate date]];
    for (int i = 0; i < 7; i++) {
        [self.currentWeekDates addObject:[dateFormatter stringFromDate:[mondayDate dateByAddingTimeInterval:24*60*60*i]]];
    }
    //设置数据源
    self.dataList = @[@"08:00",@"08:30",@"09:00",@"09:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00"];
}

#pragma mark - 创建时间间隔视图
- (void)setTimeTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 140, 60, kScreenHeight - 140) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor greenColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 61;
    _tableView.scrollEnabled = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark - 创建时间视图
- (void)setCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((kScreenWidth - 60) / 7 - 1, 60);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(60, 140, kScreenWidth - 60, kScreenHeight - 140) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor grayColor];
    _collectionView.bounces = NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collection_cell"];
    [self.view addSubview:_collectionView];
}

#pragma mark - 创建日历视图
- (void)setCalendarView{
    JTCalendarMenuView *calendarMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 50)];
    self.calendarMenuView = calendarMenuView;
    [self.view addSubview:calendarMenuView];
    JTCalendarContentView *contentView = [[JTCalendarContentView alloc] initWithFrame:CGRectMake(60, 60, kScreenWidth - 60, 75)];
    self.contentView = contentView;
    [self.view addSubview:contentView];
    
    self.calendar = [JTCalendar new];
    self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
    self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
    self.calendar.calendarAppearance.ratioContentMenu = 1.;
    self.calendar.calendarAppearance.isWeekMode = YES;
    
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.contentView];
    [self.calendar setDataSource:self];
    [self.calendar setDateDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.calendar reloadData]; // Must be call in viewDidAppear
    
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count * 7;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection_cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor yellowColor];
    cell.highlighted = YES;
    
    if (indexPath.row == 0) {
        
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //
    //    double cellY = cell.frame.origin.y - collectionView.contentOffset.y + 140;
    //
    //    CGRect cellF = CGRectMake(60 + cell.frame.origin.x, cellY, cell.frame.size.width, cell.frame.size.height);
    //    NSArray *menuItems =
    //    @[
    //      [KxMenuItem menuItem:@"Share this"
    //                     image:[UIImage imageNamed:@"action_icon"]
    //                    target:self
    //                    action:@selector(pushMenuItem:)],
    //      ];
    //
    //    KxMenuItem *first = menuItems[0];
    //    first.foreColor = [UIColor redColor];
    //    first.alignment = NSTextAlignmentCenter;
    //
    //    [KxMenu showMenuInView:self.view
    //                  fromRect:cellF
    //                 menuItems:menuItems];
    
    NSLog(@"选择了:%@,%@",[self.currentWeekDates[indexPath.row % 7] componentsSeparatedByString:@" "][0],self.dataList[(indexPath.row / 7)]);
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppointmentTableViewCell *cell = [AppointmentTableViewCell cellWithTableView:tableView];
    
    cell.time = self.dataList[indexPath.row];
    
    return cell;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //让tableView和collectionView一起滚动
    [_tableView setContentOffset:scrollView.contentOffset animated:NO];
}

#pragma mark - JTCalendarDataSource
- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date{
    NSLog(@"%@",date);
}

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date{
    return NO;
}

- (void) pushMenuItem:(id)sender
{
    NSLog(@"%@", sender);
}

#pragma mark - JTCalendarDelegate
- (void)calendar:(JTCalendar *)calendar startDateOfWeak:(NSDate *)startDate endDateOfWeak:(NSDate *)endDate{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认要刷新数据吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
    [self.currentWeekDates removeAllObjects];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    for (int i = 0; i < 7; i++) {
        [self.currentWeekDates addObject:[dateFormatter stringFromDate:[startDate dateByAddingTimeInterval:24*60*60*i]]];
    }
    for (NSString *dateStr in self.currentWeekDates) {
        NSLog(@"日期:%@",dateStr);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
