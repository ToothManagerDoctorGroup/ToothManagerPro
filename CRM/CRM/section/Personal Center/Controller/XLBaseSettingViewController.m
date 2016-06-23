//
//  XLBaseSettingViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/2/29.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLBaseSettingViewController.h"
#import "AboutProductViewController.h"
#import "XLAdviseFeedBackViewController.h"
#import "ServerPrivacyViewController.h"
#import "XLUserAssistenceViewController.h"
#import "ChangePasswdViewController.h"
#import "XLSettingViewController.h"
#import "AccountManager.h"
#import "XLLoginTool.h"
#import "CRMHttpRespondModel.h"

@interface XLBaseSettingViewController ()

@property (nonatomic, strong)NSArray *dataList;

@end

@implementation XLBaseSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
    self.dataList = @[@[@"更改密码",@"通用设置"],@[@"使用帮助",@"意见反馈"],@[@"服务和隐私条款",@"关于我们"],@[@"退出登录"]];
}

#pragma mark - UITableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dataList[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"baseSetting_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor blackColor];
        
        UILabel *loginout = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        loginout.tag = 100;
        loginout.hidden = YES;
        loginout.font = [UIFont systemFontOfSize:18];
        loginout.textColor = [UIColor redColor];
        loginout.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:loginout];
    }
    UILabel *loginOut = [cell.contentView viewWithTag:100];
    if (indexPath.section == 3) {
        loginOut.hidden = NO;
        loginOut.text = self.dataList[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        loginOut.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.dataList[indexPath.section][indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            ChangePasswdViewController *changepasswdVC = [storyBoard instantiateViewControllerWithIdentifier:@"ChangePasswdViewController"];
            
            changepasswdVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:changepasswdVC animated:YES];
        }else{
            //设置页面
            XLSettingViewController *settingVc = [[XLSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self pushViewController:settingVc animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            XLUserAssistenceViewController *assistence = [[XLUserAssistenceViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:assistence animated:YES];
        }else{
            XLAdviseFeedBackViewController *feedBackVc = [[XLAdviseFeedBackViewController alloc] init];
            feedBackVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:feedBackVc animated:YES];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            ServerPrivacyViewController *serverVC = [storyBoard instantiateViewControllerWithIdentifier:@"ServerPrivacyViewController"];
            serverVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:serverVC animated:YES];
        }else{
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            AboutProductViewController *aboutVC = [storyBoard instantiateViewControllerWithIdentifier:@"AboutProductViewController"];
            aboutVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
    }else if (indexPath.section == 3){
        TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"温馨提示" message:@"确认退出当前账号吗？" cancelHandler:^{
        } comfirmButtonHandlder:^{
            
            [SVProgressHUD showWithStatus:@"正在退出"];
            [XLLoginTool updateUserRegisterId:@"" success:^(CRMHttpRespondModel *respond) {
                if ([respond.code integerValue] == 200) {
                    [SVProgressHUD dismiss];
                    [[AccountManager shareInstance] logout];
                    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
                }else{
                    [SVProgressHUD showImage:nil status:@"退出失败，请检查您的网络设置"];
                }
            } failure:nil];
            
        }];
        [alertView show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
