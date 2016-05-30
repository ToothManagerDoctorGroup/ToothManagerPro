//
//  XLClinicAppointmentViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/5/13.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLClinicAppointmentViewController.h"
#import "FSCalendar.h"
#import "XLClinicAppointmentModel.h"
#import "XLAppointDateCell.h"
#import "XLAppointContentCell.h"
#import "CustomCollectionViewLayout.h"
#import "XLAddClinicReminderViewController.h"
#import "UIColor+Extension.h"
#import "MyClinicTool.h"
#import "XLClinicModel.h"
#import "MyDateTool.h"
#import "XLOperationStatusModel.h"
#import "NSDate+convenience.h"

#define CollectionViewDateCellIdentifier @"CollectionViewDateCellIdentifier"
#define CollectionViewContentCellIdentifier @"CollectionViewContentCellIdentifier"
static const CGFloat ClinicAppointmentViewControllerCalendarHeight = 200;

@interface XLClinicAppointmentViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,FSCalendarDataSource,FSCalendarDelegate,UIActionSheetDelegate> {
    NSArray *_data;
}

@property (nonatomic, strong)UICollectionView *appointTable;//预约视图
@property (nonatomic, strong)FSCalendar *calendar;//日历
@property (nonatomic, strong)UIView *lineView;//分割线

@property (nonatomic, strong)NSMutableArray *dataList;//数据集合
@property (nonatomic, strong)NSMutableArray *occupyTimeIndexPaths;//占用的时间集合
@property (nonatomic, strong)NSMutableArray *seats;//椅位数
@property (nonatomic, strong)NSArray *times;//时间

@property (nonatomic, copy)NSDate *currentDate;//当前选中的时间
@property (nonatomic, strong)NSIndexPath *selectIndexPath;//当前选中的模型

@end

@implementation XLClinicAppointmentViewController
#pragma mark - ********************* Life Method ***********************
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化子视图
    [self setUpSubViews];
    
    //加载数据
    self.currentDate = [NSDate date];
    [self getOperationStatusWithDate:[MyDateTool stringWithDateNoTime:[NSDate date]] showStatus:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)dealloc{
    [self removeNotificationObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ********************* Private Method ***********************
#pragma mark 初始化子视图
- (void)setUpSubViews{
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.title = @"预约诊所";
    
    [self addNotificationObserver];
    
    [self.view addSubview:self.calendar];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.appointTable];
}

- (void)addNotificationObserver{
    [self addObserveNotificationWithName:NotificationCreated];
}

- (void)removeNotificationObserver{
    [self removeObserverNotificationWithName:NotificationCreated];
}

- (void)handNotification:(NSNotification *)notifacation{
    if ([notifacation.name isEqualToString:NotificationCreated]) {
        [self.dataList removeAllObjects];
        self.dataList = nil;
        [self getOperationStatusWithDate:[MyDateTool stringWithDateNoTime:self.currentDate] showStatus:NO];
    }
}

#pragma mark 根据诊所id查找指定时间内的营业状态
- (void)getOperationStatusWithDate:(NSString *)dateStr showStatus:(BOOL)showStatus{
    if (showStatus) {
        [SVProgressHUD showWithStatus:@"正在加载数据"];
    }
    WS(weakSelf);
    [MyClinicTool getOperatingStatusWithClinicId:self.clinicModel.clinic_id curDateStr:dateStr success:^(XLOperationStatusModel *statusModel) {
        if (showStatus) {
            [SVProgressHUD dismiss];
        }
        //获取椅位模型
        if (weakSelf.seats.count > 0) {
            [weakSelf.seats removeAllObjects];
        }
        [weakSelf.seats addObjectsFromArray:statusModel.seatList];
        //获取当前诊所的营业时间，计算出诊所的时间点的个数
        weakSelf.times = [weakSelf calculateTimeStatusWithTime:statusModel.business.businessHours];
        //判断是否存在被占用的时间段
        [weakSelf getSourceListWithStatusModel:statusModel];
        //刷新视图
        [weakSelf.appointTable reloadData];
        
        
    } failure:^(NSError *error) {
        if (showStatus) {
            [SVProgressHUD showImage:nil status:error.localizedDescription];
        }
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark 获取数据源
- (void)getSourceListWithStatusModel:(XLOperationStatusModel *)statusModel{
    
    //判断当前时间是否是营业时间
    NSString *currentDateStr = [@([MyDateTool getDayIntWeekWithDate:self.currentDate]) stringValue];
    NSArray *businessWeeks = [statusModel.business.businessWeek componentsSeparatedByString:@","];
    if (![businessWeeks containsObject:currentDateStr]) {
        //表明不在营业时间内
        for (int i = 0; i < self.times.count; i++) {
            for (XLClinicAppointmentModel *model in self.dataList[i]) {
                model.takeUp = YES;
            }
        }
        return;
    }
    
    if (self.occupyTimeIndexPaths.count > 0) {
        [self.occupyTimeIndexPaths removeAllObjects];
    }
    
    for (XLOccupyTime *ocyTime in statusModel.timeList) {
        int indexPathCount = (int)([ocyTime.reserveDuration floatValue] / 0.5);
        NSString *startTime = [MyDateTool stringWithDateFormatterStr:@"HH:mm" dateStr:ocyTime.reserveTime];
        //判断是否包含此时间
        NSInteger section = 0;
        if ([self.times containsObject:startTime]) {
            section = [self.times indexOfObject:startTime] + 1;
        }else{
            continue;
        }
        NSInteger item = 0;
        for (int i = 0; i < self.seats.count; i++) {
            XLSeatInfo *seat = self.seats[i];
            if ([seat.seat_id isEqualToString:ocyTime.seatId]) {
                item = i + 1;
                break;
            }
        }
        for (int i = 0; i < indexPathCount; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section + i];
            [self.occupyTimeIndexPaths addObject:indexPath];
        }
    }
    
    //判断当前时间是否存在
    for (int i = 0; i < self.times.count; i++) {
        for (XLClinicAppointmentModel *model in self.dataList[i]) {
            if ([self.occupyTimeIndexPaths containsObject:model.indexPath]) {
                model.takeUp = YES;
            }
        }
    }
    
}

#pragma mark 计算出当前诊所的时间周期
- (NSArray *)calculateTimeStatusWithTime:(NSString *)time{
    //时间格式9:30-19:30 = 21
    //9:30 19:30
    NSArray *timeArray = [time componentsSeparatedByString:@"-"];
    NSArray *startTimeArray = [timeArray[0] componentsSeparatedByString:@":"];
    NSArray *endTimeArray = [timeArray[1] componentsSeparatedByString:@":"];
    int count = 0;
    //如果开始时间和结束时间的分钟数一样
    if ([[startTimeArray lastObject] isEqualToString:[endTimeArray lastObject]]) {
        count = ([[endTimeArray firstObject] intValue] - [[startTimeArray firstObject] intValue]) * 2 + 1;
    }else{
        count = ([[endTimeArray firstObject] intValue] - [[startTimeArray firstObject] intValue]) * 2;
    }
    
    NSMutableArray *arrayM = [NSMutableArray array];
    int startInt = [[startTimeArray firstObject] intValue];
    int index = 0;
    if ([[startTimeArray lastObject] isEqualToString:@"30"]) {
        index = 1;
        count++;
    }
    for (int i = index; i < count; i++) {
        if (i%2 == 0) {
            if (startInt+i/2 < 10) {
                [arrayM addObject:[NSString stringWithFormat:@"0%d:00",startInt+i/2]];
            } else {
                [arrayM addObject:[NSString stringWithFormat:@"%d:00",startInt+i/2]];
            }
        }else {
            if (startInt+i/2 < 10) {
                [arrayM addObject:[NSString stringWithFormat:@"0%d:30",startInt+i/2]];
            } else {
                [arrayM addObject:[NSString stringWithFormat:@"%d:30",startInt+i/2]];
            }
        }
    }
    return arrayM;
}

#pragma mark 判断所选时间是否被占用
- (BOOL)selectTimeIsOccupyWithStartTime:(NSString *)startTime duration:(float)duration{
    int indexPathCount = (int)(duration / 0.5);
    BOOL exist = NO;
    for (int i = 0; i < indexPathCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.selectIndexPath.item inSection:self.selectIndexPath.section + i];
        if ([self.occupyTimeIndexPaths containsObject:indexPath]) {
            exist = YES;
            break;
        }
    }
    return exist;
}

#pragma mark - ****************** Delegate / DataSource ********************
#pragma mark UICollectionViewDataSource / UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.times.count > 0 ? self.times.count + 1 : 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.seats.count > 0 ? self.seats.count + 1 : 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //交叉视图
            XLAppointDateCell *dateCell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewDateCellIdentifier forIndexPath:indexPath];
            dateCell.dateLabel.backgroundColor = [UIColor colorWithHex:0x00a0ea];
            dateCell.dateLabel.textColor = [UIColor whiteColor];
            dateCell.contentView.backgroundColor = [UIColor whiteColor];
            
            dateCell.dateLabel.text = @"排班表";
            
            return dateCell;
        }else{
            XLAppointContentCell *contentCell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewContentCellIdentifier forIndexPath:indexPath];
            contentCell.contentLabel.backgroundColor = [UIColor colorWithHex:0x00a0ea];
            contentCell.contentLabel.font = [UIFont systemFontOfSize:15];
            contentCell.contentLabel.textColor = [UIColor whiteColor];
            contentCell.contentView.backgroundColor = [UIColor whiteColor];
            
            //获取椅位模型
            XLSeatInfo *seatInfo = self.seats[indexPath.item - 1];
            contentCell.contentLabel.text = seatInfo.seat_name;
            
            return contentCell;
        }
    }else{
        if (indexPath.row == 0) {
            //交叉视图
            XLAppointDateCell *dateCell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewDateCellIdentifier forIndexPath:indexPath];
            dateCell.dateLabel.backgroundColor = [UIColor whiteColor];
            dateCell.dateLabel.textColor = [UIColor colorWithHex:0x333333];
            dateCell.contentView.backgroundColor = [UIColor colorWithHex:0xcccccc];
            dateCell.dateLabel.text = self.times[indexPath.section - 1];
            
            return dateCell;
        }else{
            
            XLAppointContentCell *contentCell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewContentCellIdentifier forIndexPath:indexPath];
            contentCell.contentLabel.textColor = [UIColor colorWithHex:0x888888];
            contentCell.contentLabel.font = [UIFont systemFontOfSize:12];
            contentCell.contentView.backgroundColor = [UIColor colorWithHex:0xcccccc];
            
            XLClinicAppointmentModel *model = self.dataList[indexPath.section - 1][indexPath.row - 1];
            if (model.isTakeUp) {
                contentCell.contentLabel.text = @"已占用";
                contentCell.contentLabel.backgroundColor = [UIColor colorWithHex:0xdddddd];
            }else{
                contentCell.contentLabel.text = @"";
                contentCell.contentLabel.backgroundColor = [UIColor whiteColor];
            }
            
            return contentCell;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section > 0 && indexPath.row > 0) {
        XLClinicAppointmentModel *model = self.dataList[indexPath.section - 1][indexPath.row - 1];
        self.selectIndexPath = indexPath;
        if (model.isTakeUp) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前椅位的当前时间已被占用，请选择其它时间" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        //跳转到添加预约界面
        NSString *title = [NSString stringWithFormat:@"您选择了%@ %@,请选择时长",[MyDateTool stringWithDateNoTime:self.currentDate],model.visibleTime];
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:title
                                                                delegate:self
                                                       cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:@"30分钟"
                                                       otherButtonTitles:@"1小时",@"90分钟",@"2小时", nil];
        [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
        [actionSheet showInView:self.view];
    }
}

#pragma mark -ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    XLClinicAppointmentModel *model = self.dataList[self.selectIndexPath.section - 1][self.selectIndexPath.row - 1];
    NSString *reserveTime = [NSString stringWithFormat:@"%@ %@:00",[MyDateTool stringWithDateNoTime:self.currentDate],model.visibleTime];
    model.appointTime = reserveTime;
    if (buttonIndex > 3) return;
    switch (buttonIndex) {
        case 0:
            //30分钟(不需要判断)
            model.duration = 0.5;
            break;
        case 1:
            model.duration = 1;
            break;
        case 2:
            model.duration = 1.5;
            break;
        case 3:
            model.duration = 2;
            break;
    }
    //获取当前选择的时间的位置，判断所选时间是否被占用
    if ([self selectTimeIsOccupyWithStartTime:model.visibleTime duration:model.duration]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"可用时间不足【预约时长】，请重新选择" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    //跳转到添加预约页面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    XLAddClinicReminderViewController *clinicAppointVc = [storyboard instantiateViewControllerWithIdentifier:@"XLAddClinicReminderViewController"];
    if (self.patient) {
        clinicAppointVc.patient = self.patient;
    }
    clinicAppointVc.appointModel = model;
    [self pushViewController:clinicAppointVc animated:YES];
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark FSCalendarDelegate / FSCalendarDataSource
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    self.currentDate = date;
    [self.dataList removeAllObjects];
    self.dataList = nil;
    [self getOperationStatusWithDate:[MyDateTool stringWithDateNoTime:date]showStatus:YES];

    NSLog(@"选中了:%@----当前时间-%d",[MyDateTool stringWithDateWithSec:date],[date weakDay]);
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
        NSMutableArray *mArray = [NSMutableArray array];
        for (int i = 0; i < self.times.count; i++) {
            NSMutableArray *subArray = [NSMutableArray array];
            for (int j = 0; j < self.seats.count; j++) {
                XLClinicAppointmentModel *model = [[XLClinicAppointmentModel alloc] init];
                model.indexPath = [NSIndexPath indexPathForItem:j + 1 inSection:i + 1];
                model.clinicId = self.clinicModel.clinic_id;
                model.clinicName = self.clinicModel.clinic_name;
                model.visibleTime = self.times[i];
                XLSeatInfo *seatInfo = self.seats[j];
                model.seatId = seatInfo.seat_id;
                model.seatPrice = [seatInfo.seat_price floatValue];
                [subArray addObject:model];
            }
            [mArray addObject:subArray];
        }
        _dataList = mArray;
    }
    return _dataList;
}

- (NSMutableArray *)occupyTimeIndexPaths{
    if (!_occupyTimeIndexPaths) {
        _occupyTimeIndexPaths = [NSMutableArray array];
    }
    return _occupyTimeIndexPaths;
}

- (NSMutableArray *)seats{
    if (!_seats) {
        _seats = [NSMutableArray array];
    }
    return _seats;
}

- (UICollectionView *)appointTable{
    if (!_appointTable) {
        CustomCollectionViewLayout *flowLayout = [[CustomCollectionViewLayout alloc] init];
        _appointTable = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ClinicAppointmentViewControllerCalendarHeight + 1, kScreenWidth, kScreenHeight - 64 - ClinicAppointmentViewControllerCalendarHeight) collectionViewLayout:flowLayout];
        _appointTable.backgroundColor = [UIColor whiteColor];
        _appointTable.dataSource = self;
        _appointTable.delegate = self;
        _appointTable.bounces = NO;
        [_appointTable registerClass:[XLAppointDateCell class] forCellWithReuseIdentifier:CollectionViewDateCellIdentifier];
        [_appointTable registerClass:[XLAppointContentCell class] forCellWithReuseIdentifier:CollectionViewContentCellIdentifier];
    }
    return _appointTable;
}

- (FSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ClinicAppointmentViewControllerCalendarHeight)];
        _calendar.dataSource = self;
        _calendar.delegate = self;
    }
    return _calendar;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, ClinicAppointmentViewControllerCalendarHeight, kScreenWidth, 1)];
        _lineView.backgroundColor = [UIColor colorWithHex:0xcccccc];
    }
    return _lineView;
}

@end