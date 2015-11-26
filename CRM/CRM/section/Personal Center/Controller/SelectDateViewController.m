//
//  SelectDateViewController.m
//  CRM
//
//  Created by doctor on 15/3/11.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "SelectDateViewController.h"
#import "SelectDateCell.h"
#import "AddReminderViewController.h"
#import "LocalNotificationCenter.h"
#import "DBManager+Patients.h"
#import "DBTableMode.h"


@interface SelectDateViewController ()
@property (nonatomic,retain) NSArray *remindArray;
@end

@implementation SelectDateViewController

-(void)viewWillAppear:(BOOL)animated{
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startDateString = [dateFormatter stringFromDate:[NSDate date]];
    dateString = startDateString;
    self.remindArray = [[LocalNotificationCenter shareInstance] localNotificationListWithString:startDateString];
    [m_tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"日程选择";
    self.view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back.png"]];
    
    timeArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i < 22; i++) {
        if (i%2 == 0) {
            if (8+i/2 < 10) {
                [timeArray addObject:[NSString stringWithFormat:@"0%d:00",8+i/2]];
            } else {
                [timeArray addObject:[NSString stringWithFormat:@"%d:00",8+i/2]];
            }
        }
        else {
            if (8+i/2 < 10) {
                [timeArray addObject:[NSString stringWithFormat:@"0%d:30",8+i/2]];
            } else {
                [timeArray addObject:[NSString stringWithFormat:@"%d:30",8+i/2]];
            }
        }
    }
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startDateString = [dateFormatter stringFromDate:[NSDate date]];
    dateString = startDateString;
    self.remindArray = [[LocalNotificationCenter shareInstance] localNotificationListWithString:startDateString];
    
    m_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.backgroundColor = [UIColor clearColor];
    m_tableView.backgroundView = nil;
    [self.view addSubview:m_tableView];
}

#pragma VRGCalendar delegate -mark

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {

    NSString *startDateString = [dateFormatter stringFromDate:calendarView.currentMonth];
    NSLog(@"calendarView.currentMonth = %@",calendarView.currentMonth);
    dateString = startDateString;
    NSLog(@"startDateString = %@",startDateString);
    
    headerHeight = targetHeight;
    [m_tableView reloadData];
    
//    NSDate *date = [NSDate date];//这个是NSDate类型的日期，所要获取的年月日都放在这里；
//    
//    unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|
//    NSDayCalendarUnit;//这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
//    
//    NSDateComponents *d = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:calendarView.currentMonth];
//    comps.day = 01;
//    NSDate *firstDay = [cal dateFromComponents:comps];
//    NSString *firstDateString = [dateFormatter stringFromDate:firstDay];
//    NSLog(@"firstDateString = %@",firstDateString);
//    NSArray *tmpRemindArray = [[LocalNotificationCenter shareInstance] localNotificationListWithString:firstDateString];
//    
//    NSLog(@"count = %d",tmpRemindArray.count);
//    
//    NSMutableArray *dates = [[NSMutableArray alloc]initWithCapacity:0];
//    for (LocalNotification *localNotification in tmpRemindArray) {
//        NSLog(@"localNotification.reserve_time = %@",localNotification.reserve_time);
//        NSDate *tmpDate = [dateFormatter dateFromString:localNotification.reserve_time];
//        NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:tmpDate];
//        [dates addObject:[NSNumber numberWithInteger:comps.day]];
//    }
//    [calendarView markDates:dates];//添加有提醒的下标
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date
{
    NSString *startDateString = [dateFormatter stringFromDate:date];
    dateString = startDateString;
    NSLog(@"%@",startDateString);
    self.remindArray = [[LocalNotificationCenter shareInstance] localNotificationListWithString:startDateString];
    [m_tableView reloadData];
}

#pragma tableView delegate&dataSource - mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return headerHeight;
            break;
            
        default:
            return 40.0f;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
            
        default:
            return 22;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sectionOne"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sectionOne"];
                m_calendar = [[VRGCalendarView alloc]init];
                m_calendar.delegate=self;
                [cell addSubview:m_calendar];
            }
            return cell;
        }
            break;
        default:
        {
            SelectDateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectDateCell"];
            if (!cell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"SelectDateCell" bundle:nil] forCellReuseIdentifier:@"selectDateCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"selectDateCell"];
            }
            cell.eventLabel.text = @"";
            NSString *string = [timeArray objectAtIndex:indexPath.row];
            for (LocalNotification *localnotifi in self.remindArray) {
                if ([localnotifi.reserve_time hasSuffix:string]) {
                    Patient *tpatient = [[DBManager shareInstance] getPatientWithPatientCkeyid:localnotifi.patient_id];
                    cell.eventLabel.text = [NSString stringWithFormat:@"患者 %@ %@",tpatient.patient_name,localnotifi.reserve_type];
                    
                }
            }
            cell.timeLabel.text = string;
            return cell;
        }
            break;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = [timeArray objectAtIndex:indexPath.row];
    for (LocalNotification *localnotifi in self.remindArray) {
        if ([localnotifi.reserve_time hasSuffix:string]) {
            return nil;
        }
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
//        AddReminderViewController *addReminderVC = [storyboard instantiateViewControllerWithIdentifier:@"AddReminderViewController"];
//        addReminderVC.selectDateString = [NSString stringWithFormat:@"%@ %@",dateString,[timeArray objectAtIndex:indexPath.row]];
//        NSLog(@"time = %@",[NSString stringWithFormat:@"%@ %@",dateString,[timeArray objectAtIndex:indexPath.row]]);
//    
//        
//        [self.delegate didSelectTime:[NSString stringWithFormat:@"%@ %@",dateString,[timeArray objectAtIndex:indexPath.row]]  from:self.from];
//        
//        if (self.delegate && self.reservedPatientId.length > 0) {
//            addReminderVC.reservedPatiendId = self.reservedPatientId;
//            
//            [self.delegate didSelectTime:[NSString stringWithFormat:@"%@ %@",dateString,[timeArray objectAtIndex:indexPath.row]]  from:self.from];
//            addReminderVC.isNextReserve = YES;
//    }
//     [self pushViewController:addReminderVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
