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

@interface XLSettingViewController ()<XLSingleContentWriteViewControllerDelegate>

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
    self.view.backgroundColor = MyColor(238, 238, 238);
    
    
    self.dataList = @[@[@"自动同步",@"同步间隔时间"],@[@"显示提醒内容"],@[@"同步日程到系统日历"],@[@"重置同步时间"]];
    
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return indexPath;
        }else{
            return nil;
        }
    }else if(indexPath.section == 3){
        return indexPath;
    }else{
        return nil;
    }
    return indexPath;
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
            [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            
            NSString *isOpen = [CRMUserDefalut objectForKey:AutoSyncOpenKey];
            if (isOpen == nil) {
                switchView.on = YES;
                [CRMUserDefalut setObject:Auto_Action_Open forKey:AutoSyncOpenKey];
                
            }else{
                if ([isOpen isEqualToString:Auto_Action_Close]) {
                    switchView.on = NO;
                }else{
                    switchView.on = YES;
                }
            }
            cell.accessoryView = switchView;
            cell.detailTextLabel.text = @"";
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            NSString *autoTime = [CRMUserDefalut objectForKey:AutoSyncTimeKey];
            if (autoTime == nil) {
                cell.detailTextLabel.text = AutoSyncTime_Five;
                [CRMUserDefalut setObject:autoTime forKey:AutoSyncTimeKey];
            }else{
                cell.detailTextLabel.text = autoTime;
            }
            
        }
    }else if (indexPath.section == 1){
        cell.textLabel.text = self.dataList[indexPath.section][indexPath.row];
        if (indexPath.row == 0) {
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
    }else if (indexPath.section == 2){
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
        }
    }else if (indexPath.section == 3){
        cell.textLabel.text = self.dataList[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            NSString *resetAutoSyncTime = [CRMUserDefalut objectForKey:[NSString stringWithFormat:@"syncDataGet%@%@", PatientTableName, [AccountManager currentUserid]]];
            if (resetAutoSyncTime == nil) {
                resetAutoSyncTime = @"1970-01-01 08:00:00";
                
                [CRMUserDefalut setObject:resetAutoSyncTime forKey:[CRMUserDefalut objectForKey:[NSString stringWithFormat:@"syncDataGet%@%@", PatientTableName, [AccountManager currentUserid]]]];
            }
            cell.detailTextLabel.text = resetAutoSyncTime;
        }
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            //跳转到时间选择页面
            XLTimeSelectViewController *timeVC = [[XLTimeSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self pushViewController:timeVC animated:YES];
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            NSString *resetAutoSyncTimeKey = [CRMUserDefalut objectForKey:[NSString stringWithFormat:@"syncDataGet%@%@", PatientTableName, [AccountManager currentUserid]]];
            XLSingleContentWriteViewController *singleVc = [[XLSingleContentWriteViewController alloc] init];
            singleVc.delegate = self;
            singleVc.currentTime = resetAutoSyncTimeKey;
            [self pushViewController:singleVc animated:YES];
        }
    }
    
}


- (void)switchAction:(UISwitch *)switchBtn{
    if (switchBtn.isOn) {
        [CRMUserDefalut setObject:Auto_Action_Open forKey:AutoSyncOpenKey];
    }else{
        [CRMUserDefalut setObject:Auto_Action_Close forKey:AutoSyncOpenKey];
    }
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:AutoSyncStateChangeNotification object:nil];
}

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

#pragma mark - XLSingleContentWriteViewControllerDelegate
- (void)singleContentViewController:(XLSingleContentWriteViewController *)singleVC didChangeSyncTime:(NSString *)syncTime{
    [self.tableView reloadData];
}

@end
