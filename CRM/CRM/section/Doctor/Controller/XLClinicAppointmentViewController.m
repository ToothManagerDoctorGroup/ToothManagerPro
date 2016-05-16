//
//  XLClinicAppointmentViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/5/13.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLClinicAppointmentViewController.h"
#import "FormScrollView.h"
#import "FSCalendar.h"
#import "XLClinicAppointmentModel.h"

@interface XLClinicAppointmentViewController ()<FDelegate, FDataSource,UIScrollViewDelegate> {
    NSArray *_data;
}

@property (nonatomic, strong)FormScrollView *appointTable;//预约视图
@property (nonatomic, strong)FSCalendar *calendar;//日历

@property (nonatomic, strong)NSMutableArray *dataList;//数据集合
@property (nonatomic, strong)NSMutableArray *seats;//椅位数
@property (nonatomic, strong)NSMutableArray *times;//时间

@property (nonatomic, strong)CustomScrollView *scrollView;

@end

@implementation XLClinicAppointmentViewController
#pragma mark - ********************* Life Method ***********************
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化子视图
    [self setUpSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ********************* Private Method ***********************
#pragma mark 初始化子视图
- (void)setUpSubViews{
//    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.title = @"预约诊所";
//    [self setRightBarButtonWithTitle:@"测试"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.autoresizingMask = UIViewAutoresizingNone;
    
    _scrollView = [[CustomScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 2, 200);
    
    for (int i = 0; i < 20; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.userInteractionEnabled = NO;
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"hello" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor redColor];
        button.frame = CGRectMake(i * 40, 0, 40, 200);
        NSLog(@"buttonSubViews:%@",button.subviews);
        if (i == 0) {
            button.backgroundColor = [UIColor yellowColor];
        }else if (i == 1){
            button.backgroundColor = [UIColor greenColor];
        }
        [_scrollView addSubview:button];
    }
    [self.view addSubview:_scrollView];
    
//    [self.view addSubview:self.calendar];
    FormScrollView *table = [[FormScrollView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height)];
    table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    table.fDelegate = self;
    table.fDataSource = self;
    table.userInteractionEnabled = YES;
    table.scrollEnabled = YES;
    [self.view addSubview:table];
    
    [self times];
    [self seats];
    [table reloadData];
}
- (void)buttonAction{
    NSLog(@"11111");
}
- (void)onRightButtonAction:(id)sender{
    NSLog(@"subviews:%@",self.view.subviews);
}

#pragma mark - ****************** Delegate / DataSource ********************
#pragma mark FDataSource / FDelegate
- (FTopLeftHeaderView *)topLeftHeadViewForForm:(FormScrollView *)formScrollView {
    FTopLeftHeaderView *view = [formScrollView dequeueReusableTopLeftView];
    if (view == NULL) {
        view = [[FTopLeftHeaderView alloc] initWithSectionTitle:@"时间" columnTitle:@"椅位"];
    }
    return view;
}

- (NSInteger)numberOfSection:(FormScrollView *)formScrollView {
    return self.times.count;
}
- (NSInteger)numberOfColumn:(FormScrollView *)formScrollView {
    return self.seats.count;
}
- (CGFloat)heightForSection:(FormScrollView *)formScrollView {
    return 44;
}
- (CGFloat)widthForColumn:(FormScrollView *)formScrollView {
    return 80;
}
- (FormSectionHeaderView *)form:(FormScrollView *)formScrollView sectionHeaderAtSection:(NSInteger)section {
    FormSectionHeaderView *header = [formScrollView dequeueReusableSectionWithIdentifier:@"Form_Section"];
    if (header == NULL) {
        header = [[FormSectionHeaderView alloc] initWithIdentifier:@"Form_Section"];
    }
    [header setTitle:self.times[section] forState:UIControlStateNormal];
    [header setBackgroundColor:[UIColor redColor]];
    [header setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    return header;
}
- (FormColumnHeaderView *)form:(FormScrollView *)formScrollView columnHeaderAtColumn:(NSInteger)column {
    FormColumnHeaderView *header = [formScrollView dequeueReusableColumnWithIdentifier:@"Form_Column"];
    if (header == NULL) {
        header = [[FormColumnHeaderView alloc] initWithIdentifier:@"Form_Column"];
    }
    [header setTitle:self.seats[column] forState:UIControlStateNormal];
    [header setBackgroundColor:[UIColor greenColor]];
    [header setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    return header;
}
- (FormCell *)form:(FormScrollView *)formScrollView cellForColumnAtIndexPath:(FIndexPath *)indexPath {
    FormCell *cell = [formScrollView dequeueReusableCellWithIdentifier:@"Form_Cell"];
    NSLog(@"%@", cell);
    if (cell == NULL) {
        cell = [[FormCell alloc] initWithIdentifier:@"Form_Cell"];
        static int i=0;
        i++;
        NSLog(@"%d--%ld", i, (long)indexPath.section);
    }
//    [cell setTitle:@"dasfas" forState:UIControlStateNormal];
//    [cell setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cell setBackgroundColor:[UIColor whiteColor]];
    return cell;
}
- (void)form:(FormScrollView *)formScrollView didSelectSectionAtIndex:(NSInteger)section {
    NSLog(@"Click Section At Index:%ld", (long)section);
}
- (void)form:(FormScrollView *)formScrollView didSelectColumnAtIndex:(NSInteger)column {
    NSLog(@"Click Cloumn At Index:%ld", (long)column);
}
- (void)form:(FormScrollView *)formScrollView didSelectCellAtIndexPath:(FIndexPath *)indexPath {
    NSLog(@"Click Cell At IndexPath:%ld,%ld", (long)indexPath.section, (long)indexPath.column);
}

#pragma mark FSCalendarDelegate / FSCalendarDataSource
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    NSLog(@"选择了:%@",date);
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"did change to page %@",[calendar stringFromDate:calendar.currentPage format:@"MMMM YYYY"]);
}

- (BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate *)date
{
    return NO;
}

#pragma mark - ********************* Lazy Method ***********************
- (NSMutableArray *)dataList{
    if (!_dataList) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0; i < 31; i++) {
            if (i%2 == 0) {
                if (8+i/2 < 10) {
                    [arrayM addObject:[NSString stringWithFormat:@"0%d:00",8+i/2]];
                } else {
                    [arrayM addObject:[NSString stringWithFormat:@"%d:00",8+i/2]];
                }
            }
            else {
                if (8+i/2 < 10) {
                    [arrayM addObject:[NSString stringWithFormat:@"0%d:30",8+i/2]];
                } else {
                    [arrayM addObject:[NSString stringWithFormat:@"%d:30",8+i/2]];
                }
            }
        }
        NSMutableArray *datas = [NSMutableArray array];
        for (int i = 0; i < self.seats.count; i++) {
            NSMutableArray *subSeats = [NSMutableArray array];
            for (int j = 0; j < arrayM.count; j++) {
                XLClinicAppointmentModel *model = [[XLClinicAppointmentModel alloc] init];
                model.indexPath = [FIndexPath indexPathForSection:j inColumn:i];
                model.takeUp = YES;
                model.seat = self.seats[i];
                model.appointTime = @"";
                model.duration = 2.0;
                model.visiableTime = arrayM[j];
                [subSeats addObject:model];
            }
            [datas addObject:subSeats];
        }
        _dataList = datas;
    }
    return _dataList;
}

- (NSMutableArray *)seats{
    if (!_seats) {
        _seats = [NSMutableArray arrayWithObjects:@"一号椅位",@"二号椅位",@"三号椅位",@"四号椅位",@"五号椅位", nil];
    }
    return _seats;
}
- (NSMutableArray *)times{
    if (_seats) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0; i < 31; i++) {
            if (i%2 == 0) {
                if (8+i/2 < 10) {
                    [arrayM addObject:[NSString stringWithFormat:@"0%d:00",8+i/2]];
                } else {
                    [arrayM addObject:[NSString stringWithFormat:@"%d:00",8+i/2]];
                }
            }
            else {
                if (8+i/2 < 10) {
                    [arrayM addObject:[NSString stringWithFormat:@"0%d:30",8+i/2]];
                } else {
                    [arrayM addObject:[NSString stringWithFormat:@"%d:30",8+i/2]];
                }
            }
        }
        _times = arrayM;
    }
    return _times;
}

- (FormScrollView *)appointTable{
    if (!_appointTable) {
        _appointTable = [[FormScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _appointTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _appointTable.fDelegate = self;
        _appointTable.fDataSource = self;
    }
    return _appointTable;
}

- (FSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        _calendar.dataSource = self;
        _calendar.delegate = self;
    }
    return _calendar;
}

@end


@implementation CustomScrollView

- (BOOL)touchesShouldCancelInContentView{
    return YES;
}


@end
