//
//  XLSettingViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/31.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLSettingViewController.h"
#import "AccountManager.h"
#import "CRMUserDefalut.h"
#import "XLTimeSelectViewController.h"
#import "UIColor+Extension.h"
#import "DBManager.h"
#import "XLSingleContentWriteViewController.h"
#import "AddressBoolTool.h"
#import "DBManager+Patients.h"
#import "DBTableMode.h"
#import "MBProgressHUD+Add.h"

#define Patient_AutoSync_Time_Key [NSString stringWithFormat:@"syncDataGet%@%@", PatientTableName, [AccountManager currentUserid]]
@interface XLSettingViewController ()<XLSingleContentWriteViewControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong)NSArray *dataList;

@end

@implementation XLSettingViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通用设置";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
    self.dataList = @[@[@"同步预约日程到系统日历",@"添加预约时显示提醒内容"],@[@"同步所有患者到通讯录",@"同步手工录入患者到通讯录"],@[@"重置同步时间",@"清除缓存"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:AutoSyncTimeChangeNotification object:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)refreshData{
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate /dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"setting_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithHex:0x333333];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.dataList[indexPath.section][indexPath.row];
        if (indexPath.row == 0) {
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
            [switchView addTarget:self action:@selector(switchReserveAction:) forControlEvents:UIControlEventValueChanged];
            
            NSString *autoReserve = [CRMUserDefalut objectForKey:AutoReserveRecordKey];
            if (autoReserve == nil) {
                switchView.on = NO;
                [CRMUserDefalut setObject:Auto_Action_Close forKey:AutoReserveRecordKey];
            }else{
                if ([autoReserve isEqualToString:Auto_Action_Open]) {
                    switchView.on = YES;
                }else {
                    switchView.on = NO;
                }
            }
            cell.accessoryView = switchView;
            cell.detailTextLabel.text = @"";
        }else{
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
            [switchView addTarget:self action:@selector(switchAlertAction:) forControlEvents:UIControlEventValueChanged];
            
            NSString *autoAlert = [CRMUserDefalut objectForKey:AutoAlertKey];
            if (autoAlert == nil) {
                switchView.on = YES;
                [CRMUserDefalut setObject:Auto_Action_Open forKey:AutoAlertKey];
            }else{
                if ([autoAlert isEqualToString:Auto_Action_Open]) {
                    switchView.on = YES;
                }else {
                    switchView.on = NO;
                }
            }
            cell.accessoryView = switchView;
            cell.detailTextLabel.text = @"";
        }
        
    }else if (indexPath.section == 1){
        cell.textLabel.text = self.dataList[indexPath.section][indexPath.row];
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = @"";
        }else{
            //将患者插入通讯录
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
            [switchView addTarget:self action:@selector(switchAddressAction:) forControlEvents:UIControlEventValueChanged];
            NSString *patientToAddress = [CRMUserDefalut objectForKey:PatientToAddressBookKey];
            if (patientToAddress == nil) {
                switchView.on = YES;
                [CRMUserDefalut setObject:Auto_Action_Open forKey:PatientToAddressBookKey];
            }else{
                if ([patientToAddress isEqualToString:Auto_Action_Open]) {
                    switchView.on = YES;
                }else {
                    switchView.on = NO;
                }
            }
            cell.accessoryView = switchView;
            cell.detailTextLabel.text = @"";
        }
    }else if (indexPath.section == 2){
        cell.textLabel.text = self.dataList[indexPath.section][indexPath.row];
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSString *resetAutoSyncTime = [CRMUserDefalut objectForKey:Patient_AutoSync_Time_Key];
            if (resetAutoSyncTime == nil) {
                resetAutoSyncTime = @"1970-01-01 08:00:00";
                
                [CRMUserDefalut setObject:resetAutoSyncTime forKey:Patient_AutoSync_Time_Key];
            }
            cell.detailTextLabel.text = resetAutoSyncTime;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = @"";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self addPatientToAddressBook];
        }
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            NSString *resetAutoSyncTimeKey = [CRMUserDefalut objectForKey:[NSString stringWithFormat:@"syncDataGet%@%@", PatientTableName, [AccountManager currentUserid]]];
            XLSingleContentWriteViewController *singleVc = [[XLSingleContentWriteViewController alloc] init];
            singleVc.delegate = self;
            singleVc.currentTime = resetAutoSyncTimeKey;
            [self pushViewController:singleVc animated:YES];
        }else{
            //清空本地数据
            [self clearLocalData];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"预约";
    }else if(section == 1){
        return @"通讯录";
    }
    return @"同步";
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return @"关闭后，新建预约保存时将不再弹窗显示提醒内容";
    }else if (section == 1){
        return @"关闭后，手工录入患者将不再插入到手机通讯录";
    }
    return nil;
}


#pragma mark - Switch Action
- (void)switchAlertAction:(UISwitch *)switchBtn{
    if (switchBtn.isOn) {
        [CRMUserDefalut setObject:Auto_Action_Open forKey:AutoAlertKey];
    }else{
        [CRMUserDefalut setObject:Auto_Action_Close forKey:AutoAlertKey];
    }
}

- (void)switchReserveAction:(UISwitch *)switchBtn{
    if (switchBtn.isOn) {
        [CRMUserDefalut setObject:Auto_Action_Open forKey:AutoReserveRecordKey];
    }else{
        [CRMUserDefalut setObject:Auto_Action_Close forKey:AutoReserveRecordKey];
    }
}

- (void)switchAddressAction:(UISwitch *)switchBtn{
    if (switchBtn.isOn) {
        [CRMUserDefalut setObject:Auto_Action_Open forKey:PatientToAddressBookKey];
    }else{
        [CRMUserDefalut setObject:Auto_Action_Close forKey:PatientToAddressBookKey];
    }
}

#pragma mark - XLSingleContentWriteViewControllerDelegate
- (void)singleContentViewController:(XLSingleContentWriteViewController *)singleVC didChangeSyncTime:(NSString *)syncTime{
    [self.tableView reloadData];
}

#pragma mark - 将患者导入通讯录
- (void)addPatientToAddressBook{
    if(![[AddressBoolTool shareInstance] userAllowToAddress]){
        //关闭了权限
        TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"温馨提示" message:@"种牙管家没有访问手机通讯录的权限，请到系统设置->隐私->通讯录中开启" cancel:@"取消" certain:@"前往设置" cancelHandler:^{
        } comfirmButtonHandlder:^{
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        [alertView show];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在加载患者数据"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //获取所有患者的个数
        NSArray *patients = [[DBManager shareInstance] getAllPatientWithID:[AccountManager currentUserid]];
        NSInteger existsCount = 0;
        NSMutableArray *needPostPatients = [NSMutableArray array];
        for (Patient *tmpP in patients) {
            //判断患者是否存在于通讯录
            BOOL exist = [[AddressBoolTool shareInstance] getContactsWithName:tmpP.patient_name phone:tmpP.patient_phone];
            if (exist) {
                existsCount++;
            }else{
                [needPostPatients addObject:tmpP];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (existsCount == patients.count) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showImage:nil status:@"暂时没有需要同步的患者"];
                });
            }else{
                [SVProgressHUD dismiss];
                NSString *message = [NSString stringWithFormat:@"已有%lu个患者存在于通讯录，是否将剩余%lu个患者导入通讯录?",(unsigned long)existsCount,(unsigned long)needPostPatients.count];
                TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"导入患者" message:message cancelHandler:^{
                } comfirmButtonHandlder:^{
                    //完成通讯录导入
                    [SVProgressHUD showWithStatus:@"正在导入"];
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        for (Patient *p in needPostPatients) {
                            //如果不存在，将患者导入通讯录
                            [[AddressBoolTool shareInstance] addContactToAddressBook:p];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD showSuccessWithStatus:@"导入完成"];
                        });
                    });
                }];
                [alertView show];
            }
        });
    });
    
}

#pragma mark - 清空本地数据
- (void)clearLocalData{
    WS(weakSelf);
    TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"确定清除本地缓存数据?" message:nil cancelHandler:^{
    } comfirmButtonHandlder:^{
       //清空本地数据
        BOOL ret = [[DBManager shareInstance] clearLocalData];
        if (ret) {
            [SVProgressHUD showImage:nil status:@"本地数据已被清空"];
            //重置同步时间
            [XLSingleContentWriteViewController resetSyncTime];
            
            [weakSelf.tableView reloadData];
            
            //通知所有页面刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:SyncGetSuccessNotification object:nil];
        }else{
            [SVProgressHUD showImage:nil status:@"本地数据清空失败"];
        }
    }];
    [alertView show];
}

@end
