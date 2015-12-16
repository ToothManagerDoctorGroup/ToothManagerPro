//
//  SelectYuYueDetailViewController.m
//  CRM
//
//  Created by lsz on 15/11/18.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "SelectYuYueDetailViewController.h"
#import "SelectDateCell.h"
#import "AddReminderViewController.h"
#import "LocalNotificationCenter.h"
#import "DBManager+Patients.h"
#import "DBTableMode.h"
#import "MLKMenuPopover.h"
#import "MyYuyueTitleView.h"
#import "ClinicPopMenu.h"
#import "ClinicCover.h"
#import "MenuTitleViewController.h"
#import "MyDateTool.h"

@interface SelectYuYueDetailViewController ()<ClinicCoverDelegate,MenuTitleViewControllerDelegate>
@property (nonatomic,retain) NSArray *remindArray; //被预约的时间数组
@property (nonatomic,retain) NSMutableArray *remindTwoArray; //被占用的时间数组

@property (nonatomic,weak) MyYuyueTitleView *clinicTitleView; //诊所视图
@property (nonatomic,weak) MyYuyueTitleView *seatTitleView; //椅位视图

@property (nonatomic,strong) NSMutableArray *seatNameArray;//存放所有的椅位名称
@property (nonatomic,strong) NSMutableArray *seatIdArray; //存放所有的椅位id
@property (nonatomic,strong) NSMutableArray *seatPriceArray; //存放所有的椅位价格
@property (nonatomic,copy) NSString *currentSeatId; //当前选中的椅位id
@property (nonatomic,copy) NSString *currentSeatPrice; //当前选中的椅位价格
@property (nonatomic,assign) NSInteger actionSheetInt;
@property (nonatomic,copy) NSString *actionSheetTime;

@property (nonatomic, weak)ClinicCover *cover;//遮罩
@property (nonatomic, strong)MenuTitleViewController *menuTitleVc;//列表视图

@end

@implementation SelectYuYueDetailViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

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
    
    self.title = @"选择医院";
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
    
    m_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-50) style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.backgroundColor = [UIColor clearColor];
    m_tableView.backgroundView = nil;
    [self.view addSubview:m_tableView];
    
    //医院标题
    UILabel *clinicLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 40, 50)];
    [clinicLabel setText:@"医院"];
    [self.view addSubview:clinicLabel];

    self.seatNameArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.seatIdArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.seatPriceArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.remindTwoArray = [[NSMutableArray alloc]initWithCapacity:0];
   
    //创建医院内容
    MyYuyueTitleView *clinicTitleView = [[MyYuyueTitleView alloc] initWithFrame:CGRectMake(60, 0, 120, 50)];
    clinicTitleView.title = self.clinicNameArray[0];
    self.clinicTitleView = clinicTitleView;
    UITapGestureRecognizer *tapClinic = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clinicTitleAction:)];
    [clinicTitleView addGestureRecognizer:tapClinic];
    [self.view addSubview:clinicTitleView];
    
    //椅位标题
    UILabel *seatLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 0, 50, 50)];
    [seatLabel setText:@"椅位"];
    [self.view addSubview:seatLabel];
    
    //椅位内容视图
    MyYuyueTitleView *seatTitleView = [[MyYuyueTitleView alloc] initWithFrame:CGRectMake(250, 0, 100, 50)];
    UITapGestureRecognizer *tapSeat = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seatTitleAction:)];
    [seatTitleView addGestureRecognizer:tapSeat];
    seatTitleView.hidden = YES;
    self.seatTitleView = seatTitleView;
    [self.view addSubview:seatTitleView];

}


#pragma VRGCalendar delegate -mark
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    
    NSString *startDateString = [dateFormatter stringFromDate:calendarView.currentMonth];
    NSLog(@"calendarView.currentMonth = %@",calendarView.currentMonth);
    dateString = startDateString;
    NSLog(@"startDateString = %@",startDateString);
    
    headerHeight = targetHeight;
    [m_tableView reloadData];
    
}
-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date
{
    [self.remindTwoArray removeAllObjects];
    NSString *startDateString = [dateFormatter stringFromDate:date];
    dateString = startDateString;
    NSLog(@"%@",startDateString);
    self.remindArray = [[LocalNotificationCenter shareInstance] localNotificationListWithString:startDateString];
    
    [m_tableView reloadData];
    
    //选择了医院 椅位后，选择日期，然后去获取新列表信息
    NSString *clinicId = nil;
    for(NSInteger i =1;i<self.clinicNameArray.count;i++){
        if([self.clinicTitleView.currentTitle isEqualToString:self.clinicNameArray[i]]){
            clinicId = [self.clinicIdArray objectAtIndex:i-1];
        }
    }
    
    if(self.currentSeatId.length == 0){
        self.currentSeatId = @"";
    }
    if(clinicId){
        [self.remindTwoArray removeAllObjects];
        [[DoctorManager shareInstance]yuYueInfoByClinicSeatDate:clinicId withSeatId:self.currentSeatId withDate:dateString successBlock:^{

        } failedBlock:^(NSError *error){
            [SVProgressHUD showImage:nil status:error.localizedDescription];
        }];
    }
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
            
            if (self.remindArray.count > 0) {
                for (LocalNotification *localnotifi in self.remindArray) {
                    if ([localnotifi.reserve_time hasSuffix:string]) {
                        Patient *tpatient = [[DBManager shareInstance] getPatientWithPatientCkeyid:localnotifi.patient_id];
                        cell.eventLabel.text = [NSString stringWithFormat:@"已预约:%@ %@",tpatient.patient_name,localnotifi.reserve_type];
                         cell.contentView.backgroundColor = [UIColor redColor];
                        break;
                    }else{
                        cell.eventLabel.text = @"";
                        cell.contentView.backgroundColor = [UIColor whiteColor];
                    }
                }
            }else{
                cell.eventLabel.text = @"";
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
            
            if (self.remindTwoArray.count > 0) {
                if (![cell.eventLabel.text hasPrefix:@"已预约:"]) {
                    for(NSInteger i=0;i<self.remindTwoArray.count;i++){
                        NSString *string1 = [self.remindTwoArray[i] substringWithRange:NSMakeRange(11, 5)];
                        
                        if([string isEqualToString:string1]){
                            cell.eventLabel.text = @"已占用";
                            cell.contentView.backgroundColor = [UIColor yellowColor];
                            break;
                        }else{
                            cell.eventLabel.text = @"";
                            cell.contentView.backgroundColor = [UIColor whiteColor];
                        }
                    }
                }
            }else{
                if (![cell.eventLabel.text hasPrefix:@"已预约:"]) {
                    cell.eventLabel.text = @"";
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                }
            }
            cell.timeLabel.text = string;
            return cell;
        }
            break;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == m_tableView){
        NSString *string = [timeArray objectAtIndex:indexPath.row];
        for (LocalNotification *localnotifi in self.remindArray) {
            if ([localnotifi.reserve_time hasSuffix:string]) {
                return nil;
            }
        }
        for (NSString *temp in self.remindTwoArray) {
            if ([temp containsString:string]) {
                return nil;
            }
        }
        
        return indexPath;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    AddReminderViewController *addReminderVC = [storyboard instantiateViewControllerWithIdentifier:@"AddReminderViewController"];
    addReminderVC.selectDateString = [NSString stringWithFormat:@"%@ %@",dateString,[timeArray objectAtIndex:indexPath.row]];
    NSLog(@"time = %@",[NSString stringWithFormat:@"%@ %@",dateString,[timeArray objectAtIndex:indexPath.row]]);
    
    
    [self.delegate didSelectTime:[NSString stringWithFormat:@"%@ %@",dateString,[timeArray objectAtIndex:indexPath.row]]  from:self.from];
    
    if (self.delegate && self.reservedPatientId.length > 0) {
        addReminderVC.reservedPatiendId = self.reservedPatientId;
        
        [self.delegate didSelectTime:[NSString stringWithFormat:@"%@ %@",dateString,[timeArray objectAtIndex:indexPath.row]]  from:self.from];
        addReminderVC.ifNextReserve = YES;
    }
    [self pushViewController:addReminderVC animated:YES];
    */
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"设定时长"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"30分钟"
                                                   otherButtonTitles:@"1小时",@"90分钟",@"2小时", nil];
    self.actionSheetInt = indexPath.row;
    self.actionSheetTime = [NSString stringWithFormat:@"%@ %@",dateString,[timeArray objectAtIndex:indexPath.row]];
    [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
    [actionSheet showInView:self.view];
}
#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *clinicId = nil;
    for(NSInteger i =1;i<self.clinicNameArray.count;i++){
        if([self.clinicTitleView.currentTitle isEqualToString:self.clinicNameArray[i]]){
            clinicId = [self.clinicIdArray objectAtIndex:i-1];
        }
    }
    
    NSString *startStr = self.actionSheetTime;
    NSDate *startDate = [MyDateTool dateWithStringNoSec:startStr];
    
    switch (buttonIndex) {
        case 0:
        {
            
            NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
            dicM[@"time"] = self.actionSheetTime;
            dicM[@"duration"] = @"30分钟";
            dicM[@"durationFloat"] = @"0.5";
            if (([self.currentSeatId isEmpty] || self.currentSeatId == nil) && self.seatIdArray.count > 0) {
                dicM[@"seatId"] = self.seatIdArray[0];
            }else{
                dicM[@"seatId"] = self.currentSeatId;
            }
            dicM[@"clinicName"] = self.clinicTitleView.title;
            dicM[@"seatName"] = self.seatTitleView.title;
            dicM[@"seatPrice"] = self.currentSeatPrice;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YuYueTime" object:dicM];
            [self popViewControllerAnimated:YES];
        }
            break;
        case 1:
        {
            
            //获取1小时后的时间
            NSDate *endDate = [startDate dateByAddingTimeInterval:60 * 60];
            if ([self compareWithStartDate:startDate endDate:endDate]) {
                [SVProgressHUD showErrorWithStatus:@"有时间被占用，请重新选择"];
                return;
            }
            
            NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
            dicM[@"time"] = self.actionSheetTime;
            dicM[@"duration"] = @"1小时";
            dicM[@"durationFloat"] = @"1.0";
            if (([self.currentSeatId isEmpty] || self.currentSeatId == nil) && self.seatIdArray.count > 0) {
                dicM[@"seatId"] = self.seatIdArray[0];
            }else{
                dicM[@"seatId"] = self.currentSeatId;
            }
            dicM[@"clinicName"] = self.clinicTitleView.title;
            dicM[@"seatName"] = self.seatTitleView.title;
            dicM[@"seatPrice"] = self.currentSeatPrice;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YuYueTime" object:dicM];
            [self popViewControllerAnimated:YES];
        }
            break;
        case 2:
        {
            //获取1小时后的时间
            NSDate *endDate = [startDate dateByAddingTimeInterval:60 * 60 + 30 * 60];
            if ([self compareWithStartDate:startDate endDate:endDate]) {
                [SVProgressHUD showErrorWithStatus:@"有时间被占用，请重新选择"];
                return;
            }
            
            NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
            dicM[@"time"] = self.actionSheetTime;
            dicM[@"duration"] = @"90分钟";
            dicM[@"durationFloat"] = @"1.5";
            if (([self.currentSeatId isEmpty] || self.currentSeatId == nil) && self.seatIdArray.count > 0) {
                dicM[@"seatId"] = self.seatIdArray[0];
            }else{
                dicM[@"seatId"] = self.currentSeatId;
            }
            
            dicM[@"clinicName"] = self.clinicTitleView.title;
            dicM[@"seatName"] = self.seatTitleView.title;
            dicM[@"seatPrice"] = self.currentSeatPrice;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YuYueTime" object:dicM];
            [self popViewControllerAnimated:YES];
        }
            break;
        case 3:
        {
            //获取1小时后的时间
            NSDate *endDate = [startDate dateByAddingTimeInterval:60 * 60 + 60 * 60];
            if ([self compareWithStartDate:startDate endDate:endDate]) {
                [SVProgressHUD showErrorWithStatus:@"有时间被占用，请重新选择"];
                return;
            }
            
            NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
            dicM[@"time"] = self.actionSheetTime;
            dicM[@"duration"] = @"2小时";
            dicM[@"durationFloat"] = @"2.0";
            if (([self.currentSeatId isEmpty] || self.currentSeatId == nil) && self.seatIdArray.count > 0) {
                dicM[@"seatId"] = self.seatIdArray[0];
            }else{
                dicM[@"seatId"] = self.currentSeatId;
            }
            dicM[@"clinicName"] = self.clinicTitleView.title;
            dicM[@"seatName"] = self.seatTitleView.title;
            dicM[@"seatPrice"] = self.currentSeatPrice;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YuYueTime" object:dicM];
            [self popViewControllerAnimated:YES];
        }
        default:
            break;
    }

}

- (BOOL)compareWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    NSString *startStr = [MyDateTool stringWithDateNoSec:startDate];
    NSString *endStr = [MyDateTool stringWithDateNoSec:endDate];
    BOOL compareResult = NO;
    if (self.remindArray.count > 0) {
        for (LocalNotification *note in self.remindArray) {
            BOOL result = [MyDateTool timeInStartTime:startStr endTime:endStr targetTime:note.reserve_time];
            if (result) {
                compareResult = YES;
            }
        }
    }
    
    if (self.remindTwoArray.count > 0) {
        for (NSString *targetStr in self.remindTwoArray) {
            NSString *changeStr = [MyDateTool stringWithDateNoSec:[MyDateTool dateWithStringWithSec:targetStr]];
            BOOL result = [MyDateTool timeInStartTime:startStr endTime:endStr targetTime:changeStr];
            if (result) {
                compareResult = YES;
            }
        }
    }
    return compareResult;
}

#pragma mark - 诊所单击事件
- (void)clinicTitleAction:(UITapGestureRecognizer *)tap{
    //创建弹出视图
    CGFloat menuH = self.clinicNameArray.count * 44 + 30 >= 250 ? 250 : self.clinicNameArray.count * 44 + 30;
    [self creatTitleMenuWithArray:self.clinicNameArray rect:CGRectMake(30, 100, 200, menuH) type:MenuTitleViewControllerClinic];
}

#pragma mark -创建弹出视图
- (void)creatTitleMenuWithArray:(NSArray *)dataList rect:(CGRect)rect type:(MenuTitleViewControllerType)type{
    //显示遮罩
    ClinicCover *cover = [ClinicCover show];
    cover.delegate = self;
    cover.dimBackground = YES;
    self.cover = cover;
    
    //显示弹出菜单
    ClinicPopMenu *menu = [ClinicPopMenu showInRect:rect];
    MenuTitleViewController *menuTitleVc = [[MenuTitleViewController alloc] initWithStyle:UITableViewStylePlain dataList:dataList];
    menuTitleVc.delegate = self;
    menuTitleVc.type = type;
    self.menuTitleVc = menuTitleVc;
    //设置弹出菜单的内容视图
    menu.contentView = self.menuTitleVc.view;
}

#pragma mark - LBCoverDelegate
- (void)coverDidClickCover:(ClinicCover *)cover{
    //隐藏菜单
    [ClinicPopMenu hide];
}

#pragma mark - MenuTitleViewControllerDelegate
- (void)titleViewController:(MenuTitleViewController *)titleViewController didSelectTitle:(NSString *)title type:(MenuTitleViewControllerType)type{
    
    [ClinicPopMenu hide];
    [self.cover removeFromSuperview];
    self.menuTitleVc = nil;
    
    if (type == MenuTitleViewControllerClinic) {
        //设置视图内容
        self.clinicTitleView.title = title;
        //根据所选的诊所名称查询椅位名称
        NSString *clinicId = nil;
        for(NSInteger i = 1;i<self.clinicNameArray.count;i++){
            if([title isEqualToString:self.clinicNameArray[i]]){
                clinicId = [self.clinicIdArray objectAtIndex:i-1];
            }
        }
        if ([title isEqualToString:self.clinicNameArray[0]]) {
            self.seatTitleView.hidden = YES;
        }
        if(clinicId){
            [[DoctorManager shareInstance]clinicSeat:clinicId successBlock:^{
            } failedBlock:^(NSError *error){
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
        }
    }else{
        self.seatTitleView.title = title;
        
        NSString *clinicId = nil;
        for(NSInteger i = 1;i<self.clinicNameArray.count;i++){
            if([self.clinicTitleView.currentTitle isEqualToString:self.clinicNameArray[i]]){
                clinicId = [self.clinicIdArray objectAtIndex:i-1];
            }
        }
        if(clinicId){
            NSInteger index = [self.seatNameArray indexOfObject:title];
            [self.remindTwoArray removeAllObjects];
            [[DoctorManager shareInstance]yuYueInfoByClinicSeatDate:clinicId withSeatId:self.seatIdArray[index] withDate:dateString successBlock:^{
                self.currentSeatId = self.seatIdArray[index];
                self.currentSeatPrice = self.seatPriceArray[index];
            } failedBlock:^(NSError *error){
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
        }
    }
}

#pragma mark - 请求网络数据回调函数
#pragma mark -获取预约信息
- (void)yuYueInfoByClinicSeatDateSuccessWithResult:(NSDictionary *)result{
    
    NSArray *dicArray = [result objectForKey:@"Result"];
    if (dicArray && dicArray.count > 0) {
        for(NSInteger i =0;i<[dicArray count];i++){
            NSDictionary *dic = dicArray[i];
            NSString *string = [dic objectForKey:@"appoint_time"];
            float flo = [[dic objectForKey:@"duration"] floatValue];
            NSInteger timeInt = flo/0.5;
            for(NSInteger j=0;j<timeInt;j++){
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *def= [formatter dateFromString:string];
                NSDate* date1 = [[NSDate alloc] init];
                date1 = [def dateByAddingTimeInterval:+ j*1800];
                NSString *string1 =  [formatter stringFromDate:date1];
                [self.remindTwoArray addObject:string1];
            }
        }
        [m_tableView reloadData];
    }
}
- (void)yuYueInfoByClinicSeatDateFailedWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:@"请求失败"];
}
#pragma mark -获取椅位信息
-(void)clinicSeatSuccessWithResult:(NSDictionary *)result{
    NSArray *dicArray = [result objectForKey:@"Result"];
    if (dicArray && dicArray.count > 0) {
        [self.seatNameArray removeAllObjects];
        [self.seatIdArray removeAllObjects];
        [self.seatPriceArray removeAllObjects];
        
        for(NSInteger i =0;i<[dicArray count];i++){
            NSDictionary *dic = dicArray[i];
            NSString *string = [dic objectForKey:@"seat_name"];
            [self.seatNameArray addObject:string];
            
            NSString *string1 = [dic objectForKey:@"seat_id"];
            [self.seatIdArray addObject:string1];
            
            NSString *string2 = [dic objectForKey:@"seat_price"];
            [self.seatPriceArray addObject:string2];
        }
    }
    
    if(self.seatNameArray != nil && self.seatNameArray.count > 0){
        self.seatTitleView.title = self.seatNameArray[0];
        self.seatTitleView.hidden = NO;
    }
}
- (void)clinicSeatFailedWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:@"请求失败"];
}

#pragma mark -椅位单击事件
- (void)seatTitleAction:(UITapGestureRecognizer *)tap{
    if (self.seatNameArray.count > 0) {
        
        CGFloat menuH = self.seatNameArray.count * 44 + 30 >= 200 ? 200 : self.seatNameArray.count * 44 + 30;
        [self creatTitleMenuWithArray:self.seatNameArray rect:CGRectMake(220, 100, 100, menuH) type:MenuTitleViewControllerSeat];
    }
}
@end
