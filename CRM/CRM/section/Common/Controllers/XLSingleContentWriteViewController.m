//
//  XLSingleContentWriteViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/8.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLSingleContentWriteViewController.h"
#import "UUDatePicker.h"
#import "MyDateTool.h"
#import "CRMUserDefalut.h"
#import "DBManager.h"
#import "AutoSync.h"

#define Patient_AutoSync_Time_Key [NSString stringWithFormat:@"syncDataGet%@%@", PatientTableName, [AccountManager currentUserid]]
#define Doctor_AutoSync_Time_Key [NSString stringWithFormat:@"syncDataGet%@%@", DoctorTableName, [AccountManager currentUserid]]
#define Material_AutoSync_Time_Key [NSString stringWithFormat:@"syncDataGet%@%@", MaterialTableName, [AccountManager currentUserid]]
#define Introducer_AutoSync_Time_Key [NSString stringWithFormat:@"syncDataGet%@%@", IntroducerTableName, [AccountManager currentUserid]]
#define CTLib_AutoSync_Time_Key [NSString stringWithFormat:@"syncDataGet%@%@", CTLibTableName, [AccountManager currentUserid]]
#define MedicalCase_AutoSync_Time_Key [NSString stringWithFormat:@"syncDataGet%@%@", MedicalCaseTableName, [AccountManager currentUserid]]
#define MedicalExpense_AutoSync_Time_Key [NSString stringWithFormat:@"syncDataGet%@%@", MedicalExpenseTableName, [AccountManager currentUserid]]
#define MedicalRecord_AutoSync_Time_Key [NSString stringWithFormat:@"syncDataGet%@%@", MedicalRecordableName, [AccountManager currentUserid]]
#define MedicalReserve_AutoSync_Time_Key [NSString stringWithFormat:@"syncDataGet%@%@", MedicalReserveTableName, [AccountManager currentUserid]]
#define LocalNotification_AutoSync_Time_Key [NSString stringWithFormat:@"syncDataGet%@%@", LocalNotificationTableName, [AccountManager currentUserid]]
#define PatIntrMap_AutoSync_Time_Key [NSString stringWithFormat:@"syncDataGet%@%@", PatIntrMapTableName, [AccountManager currentUserid]]
#define RepairDoc_AutoSync_Time_Key [NSString stringWithFormat:@"syncDataGet%@%@", RepairDocTableName, [AccountManager currentUserid]]
#define PatientConsultation_AutoSync_Time_Key [NSString stringWithFormat:@"syncDataGet%@%@", PatientConsultationTableName, [AccountManager currentUserid]]


@interface XLSingleContentWriteViewController ()<UUDatePickerDelegate>

@property (nonatomic, weak)UITextField *timeField;

@property (nonatomic, strong)NSArray *dataList;

@end

@implementation XLSingleContentWriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setUpNav];
    
    //设置子视图
    [self setUpSubViews];
    
    self.dataList = @[Patient_AutoSync_Time_Key,Doctor_AutoSync_Time_Key,Material_AutoSync_Time_Key,Introducer_AutoSync_Time_Key,CTLib_AutoSync_Time_Key,MedicalCase_AutoSync_Time_Key,MedicalExpense_AutoSync_Time_Key,MedicalRecord_AutoSync_Time_Key,MedicalReserve_AutoSync_Time_Key,LocalNotification_AutoSync_Time_Key,PatIntrMap_AutoSync_Time_Key,PatientConsultation_AutoSync_Time_Key,RepairDoc_AutoSync_Time_Key];
}
#pragma mark - 设置导航栏
- (void)setUpNav{
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"重置"];
    self.title = @"重置同步时间";
}

- (void)setUpSubViews{
    UITextField *timeField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 44)];
    timeField.borderStyle = UITextBorderStyleRoundedRect;
    timeField.text = self.currentTime;
    timeField.placeholder = @"请选择同步时间";
    timeField.backgroundColor = [UIColor whiteColor];
    self.timeField = timeField;
    UUDatePicker *datePicker = [[UUDatePicker alloc] initWithframe:CGRectMake(0, 0, kScreenWidth, 260) Delegate:self PickerStyle:UUDateStyle_YearMonthDayHourMinute];
    self.timeField.inputView = datePicker;
    [self.view addSubview:timeField];
}

- (void)onRightButtonAction:(id)sender{
    //重置所有的同步时间
    NSString *currentSyncTime = self.timeField.text;
    
    for (NSString *key in self.dataList) {
        [CRMUserDefalut setObject:currentSyncTime forKey:key];
    }
    
    [self popViewControllerAnimated:YES];
    
    if ([self.delegate respondsToSelector:@selector(singleContentViewController:didChangeSyncTime:)]) {
        [self.delegate singleContentViewController:self didChangeSyncTime:currentSyncTime];
    }
    
    
}

+ (void)resetSyncTime{
    NSArray *dataList = @[Patient_AutoSync_Time_Key,Doctor_AutoSync_Time_Key,Material_AutoSync_Time_Key,Introducer_AutoSync_Time_Key,CTLib_AutoSync_Time_Key,MedicalCase_AutoSync_Time_Key,MedicalExpense_AutoSync_Time_Key,MedicalRecord_AutoSync_Time_Key,MedicalReserve_AutoSync_Time_Key,LocalNotification_AutoSync_Time_Key,PatIntrMap_AutoSync_Time_Key,PatientConsultation_AutoSync_Time_Key,RepairDoc_AutoSync_Time_Key];
    for (NSString *key in dataList) {
        [CRMUserDefalut setObject:[NSString defaultDateString] forKey:key];
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:AutoSync_Behaviour_SyncTime];
    [userDefault synchronize];
}

#pragma mark - UUDatePickerDelegate
- (void)uuDatePicker:(UUDatePicker *)datePicker year:(NSString *)year month:(NSString *)month day:(NSString *)day hour:(NSString *)hour minute:(NSString *)minute weekDay:(NSString *)weekDay{
    self.timeField.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00",year,month,day,hour,minute];
}

- (void)uuDatePicker:(UUDatePicker *)datePicker didClickBtn:(UIButton *)btn{
    [self.timeField resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
