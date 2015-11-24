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

@interface SelectYuYueDetailViewController ()
@property (nonatomic,retain) NSArray *remindArray;
@property (nonatomic,retain) NSMutableArray *remindTwoArray;
@property (nonatomic,retain) TimPickerTextField *clinicTextField;
@property (nonatomic,retain) TimPickerTextField *seatTextField;
@property (nonatomic,strong) NSMutableArray *seatNameArray;
@property (nonatomic,strong) NSMutableArray *seatIdArray;
@property (nonatomic,strong) NSMutableArray *seatPriceArray;
@property (nonatomic,copy) NSString *currentSeatId;
@property (nonatomic,copy) NSString *currentSeatPrice;
@property (nonatomic,retain) UITableView *seatTableView;
@property (nonatomic,assign) NSInteger actionSheetInt;
@property (nonatomic,copy) NSString *actionSheetTime;
@end

@implementation SelectYuYueDetailViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startDateString = [dateFormatter stringFromDate:[NSDate date]];
    dateString = startDateString;
    self.remindArray = [[LocalNotificationCenter shareInstance] localNotificationListWithString:startDateString];
    [m_tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}
- (void)keyboardWillShow:(CGFloat)keyboardHeight {
     [self.seatNameArray removeAllObjects];
    [self.seatIdArray removeAllObjects];
    [self.seatPriceArray removeAllObjects];
    [self.seatTableView removeFromSuperview];
    self.seatTextField.text = @"";
    
    static BOOL flag = NO;
    if (flag == YES || self.navigationController.topViewController != self) {
        return;
    }
    flag = YES;
    if ([self.seatTextField isFirstResponder]){
        [self.seatTextField resignFirstResponder];
       
        NSString *clinicId = nil;
        for(NSInteger i =1;i<self.clinicNameArray.count;i++){
            if([self.clinicTextField.text isEqualToString:self.clinicNameArray[i]]){
                clinicId = [self.clinicIdArray objectAtIndex:i-1];
            }
        }
        if(clinicId){
            [[DoctorManager shareInstance]clinicSeat:clinicId successBlock:^{
            } failedBlock:^(NSError *error){
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
        }

    }
    flag = NO;
    
}
-(void)clinicSeatSuccessWithResult:(NSDictionary *)result{
    NSArray *dicArray = [result objectForKey:@"Result"];
    if (dicArray && dicArray.count > 0) {
    [self.seatNameArray removeAllObjects];
        [self.seatIdArray removeAllObjects];
        [self.seatPriceArray removeAllObjects];
    [self.seatTableView removeFromSuperview];
        
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
    
    if(self.seatNameArray != nil){
        self.seatTableView = [[UITableView alloc]initWithFrame:CGRectMake(250, 50, 50, 40*self.seatNameArray.count) style:UITableViewStylePlain];
        self.seatTableView.delegate = self;
        self.seatTableView.dataSource = self;
        self.seatTableView.backgroundColor = [UIColor lightGrayColor];
        
        [self.seatTableView reloadData];
        [self.view addSubview:self.seatTableView];
        
    }
}
- (void)clinicSeatFailedWithError:(NSError *)error{
    
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
    
    UILabel *clinicLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 40, 50)];
    [clinicLabel setText:@"医院"];
    [self.view addSubview:clinicLabel];

    self.seatNameArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.seatIdArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.seatPriceArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.clinicTextField = [[TimPickerTextField alloc]initWithFrame:CGRectMake(60, 0, 120, 50)];
    self.clinicTextField.text = [self.clinicNameArray objectAtIndex:0];
    self.clinicTextField.mode = TextFieldInputModePicker;
    self.clinicTextField.pickerDataSource = self.clinicNameArray;
    self.clinicTextField.font = [UIFont systemFontOfSize:14];
    self.clinicTextField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.clinicTextField];
    
    UILabel *seatLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 0, 50, 50)];
    [seatLabel setText:@"椅位"];
    [self.view addSubview:seatLabel];
    
    self.seatTextField = [[TimPickerTextField alloc]initWithFrame:CGRectMake(250, 0, 100, 50)];
    //self.seatTextField.mode = TextFieldInputModePicker;
    
    self.seatTextField.borderStyle = UITextBorderStyleNone;
    self.seatTextField.mode = TextFieldInputModeKeyBoard;
    [self.seatTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    [self.view addSubview:self.seatTextField];
    
    self.remindTwoArray = [[NSMutableArray alloc]initWithCapacity:0];
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
        if([self.clinicTextField.text isEqualToString:self.clinicNameArray[i]]){
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
    if(tableView == self.seatTableView){
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.seatTableView){
        return 40;
    }
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
    if(tableView == self.seatTableView){
        return self.seatNameArray.count;
    }
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
    if(tableView == self.seatTableView){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableviewcell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableviewcell"];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
            label.text = [self.seatNameArray objectAtIndex:indexPath.row];
            cell.backgroundColor = [UIColor lightGrayColor];
            [cell addSubview:label];
        }
        return cell;
    }
    
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
                    cell.eventLabel.text = [NSString stringWithFormat:@"已预约:%@ %@",tpatient.patient_name,localnotifi.reserve_type];
                     cell.contentView.backgroundColor = [UIColor redColor];
                    break;
                }else{
                    cell.eventLabel.text = @"";
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                }
            }
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
            //陈云7
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
        return indexPath;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(tableView == self.seatTableView){
        NSString *string = [self.seatNameArray objectAtIndex:indexPath.row];
        self.seatTextField.text = string;
        [self.seatTableView removeFromSuperview];
        
        
        NSString *clinicId = nil;
        for(NSInteger i =1;i<self.clinicNameArray.count;i++){
            if([self.clinicTextField.text isEqualToString:self.clinicNameArray[i]]){
                clinicId = [self.clinicIdArray objectAtIndex:i-1];
            }
        }
        if(clinicId){
            [self.remindTwoArray removeAllObjects];
            [[DoctorManager shareInstance]yuYueInfoByClinicSeatDate:clinicId withSeatId:self.seatIdArray[indexPath.row] withDate:dateString successBlock:^{
                self.currentSeatId = self.seatIdArray[indexPath.row];
                self.currentSeatPrice = self.seatPriceArray[indexPath.row];
            } failedBlock:^(NSError *error){
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
        }
        return;
    }
    
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
    
    
    if(tableView == m_tableView){
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
}
#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *clinicId = nil;
    for(NSInteger i =1;i<self.clinicNameArray.count;i++){
        if([self.clinicTextField.text isEqualToString:self.clinicNameArray[i]]){
            clinicId = [self.clinicIdArray objectAtIndex:i-1];
        }
    }
    
    switch (buttonIndex) {
        case 0:
        {
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.actionSheetTime,@"time",@"30分钟",@"duration",@"0.5",@"durationFloat",self.currentSeatId,@"seatId",self.clinicTextField.text,@"clinicName",self.seatTextField.text,@"seatName",self.currentSeatPrice,@"seatPrice",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YuYueTime" object:dic];
            [self popViewControllerAnimated:YES];
        }
            break;
        case 1:
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.actionSheetTime,@"time",@"1小时",@"duration",@"1.0",@"durationFloat",self.currentSeatId,@"seatId",self.clinicTextField.text,@"clinicName",self.seatTextField.text,@"seatName",self.currentSeatPrice,@"seatPrice", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YuYueTime" object:dic];
            [self popViewControllerAnimated:YES];
        }
            break;
        case 2:
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.actionSheetTime,@"time",@"90分钟",@"duration",@"1.5",@"durationFloat",self.currentSeatId,@"seatId",self.clinicTextField.text,@"clinicName",self.seatTextField.text,@"seatName",self.currentSeatPrice,@"seatPrice", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YuYueTime" object:dic];
            [self popViewControllerAnimated:YES];
        }
            break;
        case 3:
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.actionSheetTime,@"time",@"2小时",@"duration",@"2.0",@"durationFloat",self.currentSeatId,@"seatId",self.clinicTextField.text,@"clinicName",self.seatTextField.text,@"seatName",self.currentSeatPrice,@"seatPrice", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YuYueTime" object:dic];
            [self popViewControllerAnimated:YES];
        }
        default:
            break;
    }
}
- (void)yuYueInfoByClinicSeatDateSuccessWithResult:(NSDictionary *)result{
    
    NSArray *dicArray = [result objectForKey:@"Result"];
    if (dicArray && dicArray.count > 0) {
        for(NSInteger i =0;i<[dicArray count];i++){
            NSDictionary *dic = dicArray[i];
            NSString *string = [dic objectForKey:@"appoint_time"];
            float flo = [[dic objectForKey:@"duration"] floatValue];
            NSInteger timeInt = flo/0.5;
            for(NSInteger j=0;j<timeInt;j++){
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *def= [dateFormatter dateFromString:string];
                NSDate* date1 = [[NSDate alloc] init];
                date1 = [def dateByAddingTimeInterval:+j*1800];
                NSString *string1 =  [dateFormatter stringFromDate:date1];
                [self.remindTwoArray addObject:string1];
            }
        }
        [m_tableView reloadData];
    }
    
}
- (void)yuYueInfoByClinicSeatDateFailedWithError:(NSError *)error{
    
}
@end
