//
//  XLTimeSelectViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/31.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLTimeSelectViewController.h"
#import "CRMUserDefalut.h"
#import "AccountManager.h"

@interface XLTimeSelectViewController ()

@property (nonatomic, strong)NSArray *dataList;

@end

@implementation XLTimeSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //同步间隔时间
    self.title = @"同步间隔时间";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
    self.dataList = @[AutoSyncTime_Five,AutoSyncTime_Ten,AutoSyncTime_Twenty];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"time_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    cell.textLabel.text = self.dataList[indexPath.row];
    //获取
    NSString *autoSyncTime = [CRMUserDefalut objectForKey:AutoSyncTimeKey];
    if (autoSyncTime == nil) {
        if ([self.dataList[indexPath.row] isEqualToString:AutoSyncTime_Five]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        //保存到偏好设置
        [CRMUserDefalut setObject:AutoSyncTime_Five forKey:AutoSyncTimeKey];
        
    }else{
        if ([autoSyncTime isEqualToString:self.dataList[indexPath.row]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *content = self.dataList[indexPath.row];
    
    [CRMUserDefalut setObject:content forKey:AutoSyncTimeKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AutoSyncTimeChangeNotification object:nil];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
