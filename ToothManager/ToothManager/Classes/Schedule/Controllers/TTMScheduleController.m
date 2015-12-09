//
//  TTMScheduleController.m
//  ToothManager
//

#import "TTMScheduleController.h"
#import "TTMScheduleHeaderView.h"
#import "MJRefresh.h"
#import "TTMLoginController.h"
#import "TTMNavigationController.h"
#import "TTMChairModel.h"
#import "TTMScheduleDetailController.h"
#import "TTMCalendarController.h"
#import "TTMMessageController.h"
#import "TTMMessageCellModel.h"
#import "TTMMyScheduleCell.h"
#import "SchedulePopMenu.h"
#import "LewPopupViewAnimationFade.h"
#import "TTMDoctorTool.h"
#import "TTMDoctorModel.h"
#import "TTMPatientTool.h"
#import "TTMPatientModel.h"
#import "TTMPatientDetailController.h"

#define kMargin 20.f
#define kRowHeight 44.0f

@interface TTMScheduleController ()<
    UITableViewDelegate,
    UITableViewDataSource,
    TTMScheduleHeaderViewDelegate,
    TTMCalendarControllerDelegate>

@property (nonatomic, weak)   TTMScheduleHeaderView *headerView;
@property (nonatomic, weak)   UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSDate *selectedDate; // 当前日期
@property (nonatomic, strong) TTMChairModel *selectedChair;
// 当前椅位
@property (nonatomic, assign) NSUInteger notReadCount;


@property (nonatomic, strong)TTMDoctorModel *selectDoctor;
@property (nonatomic, strong)TTMPatientModel *selectPatient;

@end

@implementation TTMScheduleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"种牙管家";
    self.dataArray = [NSMutableArray array];
    
    [self setupTableView];
    [self setupHeaderView];
    
    // 自动登录
    [self autoLogin];
    
    // 初始化全部数据
    self.selectedDate = [NSDate date];
    TTMChairModel *chair = [[TTMChairModel alloc] init];
    chair.seat_name = @"全部";
    self.selectedChair = chair;
    [self setupRightItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self queryMessage];
}

- (void)setupRightItem {
    UIBarButtonItem *rightItem = [UIBarButtonItem barButtonItemWithTitle:@"消息"
                                                                  number:@(self.notReadCount)
                                                                  action:@selector(rightButtonAction:)
                                                                  target:self];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

/**
 *  加载tableViewHeader
 */
- (void)setupHeaderView {
    TTMScheduleHeaderView *headerView = [[TTMScheduleHeaderView alloc] init];
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
}
/**
 *  加载tableView
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
    tableView.delaysContentTouches = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)rightButtonAction:(UIButton *)button {
    TTMMessageController *messageController = [[TTMMessageController alloc] init];
    [self.navigationController pushViewController:messageController animated:YES];
}

#pragma maek - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTMMyScheduleCell *cell = [TTMMyScheduleCell scheduleCellWithTableView:tableView];
    if (self.dataArray.count > 0) {
        TTMScheduleCellModel *model = self.dataArray[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SchedulePopMenu *menuView = [SchedulePopMenu defaultPopupView];
    menuView.parentVC = self;
    
    __weak typeof(self) weakSelf = self;
    [self lew_presentPopupView:menuView animation:[LewPopupViewAnimationFade new] dismissed:^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        switch (menuView.type) {
            case SchedulePopMenuType1:
                //预约详情
                [weakSelf jumpToAppointDetailWithIndexPath:indexPath];

                break;
            case SchedulePopMenuType2:
                //患者详情
                [self jumpToPatientDetailWithIndexPath:indexPath];
                break;
            case SchedulePopMenuType3:
                //联系医生
                [weakSelf jumpToPhoneWithIndexPath:indexPath withType:@"0"];
                
                break;
            case SchedulePopMenuType4:
                //联系患者
                [weakSelf jumpToPhoneWithIndexPath:indexPath withType:@"1"];
                
                break;
            default:
                break;
        }
    }];
}
#pragma mark - 跳转到预约详情页面
- (void)jumpToAppointDetailWithIndexPath:(NSIndexPath *)indexPath{
    TTMScheduleCellModel *model = self.dataArray[indexPath.row];
    TTMScheduleDetailController *detailVC = [[TTMScheduleDetailController alloc] init];
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)jumpToPatientDetailWithIndexPath:(NSIndexPath *)indexPath{
    TTMScheduleCellModel *model = self.dataArray[indexPath.row];
    TTMPatientDetailController *detailVc = [[TTMPatientDetailController alloc] init];
    detailVc.patientId = model.patient_id;
    [self.navigationController pushViewController:detailVc animated:YES];
}
#pragma mark - 打电话
- (void)jumpToPhoneWithIndexPath:(NSIndexPath *)indexPath withType:(NSString *)type{
    TTMScheduleCellModel *model = self.dataArray[indexPath.row];
    if ([type isEqualToString:@"0"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDWithView:self.view.window text:@"获取医生电话..."];
        //查询医生的电话
        [TTMDoctorTool requestDoctorInfoWithDoctorId:model.doctor_id success:^(TTMDoctorModel *dcotorInfo) {
            [hud hide:YES];
            self.selectDoctor = dcotorInfo;
            if(dcotorInfo.doctor_phone.length > 0 && dcotorInfo.doctor_phone != nil){
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"拨打电话%@",dcotorInfo.doctor_phone] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 101;
                [alertView show];
            }else{
                [MBProgressHUD showToastWithText:@"医生未留电话!"];
            }
        } failure:^(NSError *error) {
            [hud hide:YES];
            [MBProgressHUD showToastWithText:@"医生电话获取失败！"];
        }];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDWithView:self.view.window text:@"获取患者电话..."];
        [TTMPatientTool requestPatientInfoWithpatientId:model.patient_id success:^(TTMPatientModel *result) {
            [hud hide:YES];
            self.selectPatient = result;
            if(result.patient_phone.length > 0 && result.patient_phone != nil){
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"拨打电话%@",result.patient_phone] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 102;
                [alertView show];
            }else{
                [MBProgressHUD showToastWithText:@"患者未留电话!"];
            }
        } failure:^(NSError *error) {
            [hud hide:YES];
            [MBProgressHUD showToastWithText:@"患者电话获取失败！"];
        }];
    }
    
}
//打电话
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 101){
        if(buttonIndex == 1){
            NSString *number = self.selectDoctor.doctor_phone;
            NSString *num = [[NSString alloc]initWithFormat:@"tel://%@",number];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }
    }else if(alertView.tag == 102){
        if(buttonIndex == 1){
            NSString *number = self.selectPatient.patient_phone;
            NSString *num = [[NSString alloc]initWithFormat:@"tel://%@",number];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }
    }
}

#pragma mark - 代理方法
/**
 *  改变日期事件
 *
 *  @param headerView headerView description
 *  @param date       改变到的日期
 */
- (void)headerView:(TTMScheduleHeaderView *)headerView changeToDate:(NSDate *)date {
    self.selectedDate = date;
}
/**
 *  改变椅位事件
 *
 *  @param headerView headerView description
 *  @param chair      椅位model
 */
- (void)headerView:(TTMScheduleHeaderView *)headerView changeToChair:(TTMChairModel *)chair {
    self.selectedChair = chair;
}
/**
 *  点击半圆
 *
 *  @param headerView headerView description
 */
- (void)clickSemicircleWithHeaderView:(TTMScheduleHeaderView *)headerView {
    TTMCalendarController *calendarVC = [[TTMCalendarController alloc] init];
    calendarVC.delegate = self;
    [self.navigationController pushViewController:calendarVC animated:YES];
}

/**
 *  日历返回的选中日期
 */
- (void)calendarController:(TTMCalendarController *)calendarController selectedDate:(NSDate *)selectedDate {
    self.headerView.currentDate = selectedDate;
    self.selectedDate = selectedDate;
}

#pragma mark - 自定义事件
/**
 *  设置当前选中日期
 *
 *  @param selectedDate selectedDate description
 */
- (void)setSelectedDate:(NSDate *)selectedDate {
    _selectedDate = selectedDate;
    [self queryScheduleData];
}
/**
 *  设置当前选中椅位
 *
 *  @param selectedChair selectedChair description
 */
- (void)setSelectedChair:(TTMChairModel *)selectedChair {
    _selectedChair = selectedChair;
    [self queryScheduleData];
}

- (void)setNotReadCount:(NSUInteger)notReadCount {
    _notReadCount = notReadCount;
    [self setupRightItem];
}

/**
 *  刷新日程数据
 */
- (void)queryScheduleData {
    __weak __typeof(&*self) weakSelf = self;
    
    TTMScheduleRequestModel *request = [[TTMScheduleRequestModel alloc] init];
    request.date = self.selectedDate;
    request.chair = self.selectedChair;
    request.controlType = TTMScheduleRequestModelControlTypeSchedule;
    
    [TTMScheduleCellModel querySchedulesWithRequest:request
                                        complete:^(id result) {
                                            if ([result isKindOfClass:[NSString class]]) {
                                                [MBProgressHUD showToastWithText:result];
                                            } else {
                                                weakSelf.dataArray = result;
                                                [weakSelf.tableView reloadData];
                                            }
                                            [weakSelf.tableView.header endRefreshing];
    }];
}

/**
 *  验证登录
 */
- (void)autoLogin {
    TTMUser *user = [TTMUser unArchiveUser];
    __weak __typeof(&*self) weakSelf = self;
    [TTMUser loginWithUserName:user.username password:user.password Complete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            // 失败，就跳转到登录页面
            TTMLoginController *loginVC = [[TTMLoginController alloc] init];
            TTMNavigationController *nav = [[TTMNavigationController alloc] initWithRootViewController:loginVC];
            weakSelf.view.window.rootViewController = nav;
        } else {
            // 成功
            weakSelf.selectedDate = [NSDate date]; // 默认选中今天
        }
    }];
}

/**
 *  查询消息
 */
- (void)queryMessage {
    __weak __typeof(&*self) weakSelf = self;
    [TTMMessageCellModel queryNotReadCountWithComplete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            weakSelf.notReadCount = 0;
        } else {
            weakSelf.notReadCount = [result integerValue];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
