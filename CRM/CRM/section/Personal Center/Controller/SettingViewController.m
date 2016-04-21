//
//  SettingViewController.m
//  CRM
//
//  Created by lsz on 15/9/12.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutProductViewController.h"
#import "ServerPrivacyViewController.h"
#import "ChangePasswdViewController.h"
#import "AccountManager.h"
#import "TimNavigationViewController.h"
#import "CRMUserDefalut.h"
#import "XLSettingViewController.h"
#import "XLAdviseFeedBackViewController.h"
#import "XLUserAssistenceViewController.h"

@interface SettingViewController (){
    
    IBOutlet UITableViewCell *_userAssistence;
    IBOutlet UITableViewCell *_settingCell;
    __weak IBOutlet UITableView *_tableView;
    IBOutlet UITableViewCell *_guanyuwomenCell;
    IBOutlet UITableViewCell *_yijianfankuiCell;
    IBOutlet UITableViewCell *_fuwuCell;
    __weak IBOutlet UILabel *_versionLabel;
    IBOutlet UITableViewCell *_genggaimimaCell;
    IBOutlet UITableViewCell *_tuichuCell;
}

@property (nonatomic, assign)BOOL isOpen;//提醒是否打开

@end

@implementation SettingViewController

- (void)initView{
    
}

- (void)initData{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
    _versionLabel.text = [NSString stringWithFormat:@"v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = MyColor(238, 238, 238);
}

- (void)viewWillAppear:(BOOL)animated
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 4;
    }else{
        return 3;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1];
    return view;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0){
        if(indexPath.row == 0){
            return _guanyuwomenCell;
        }else if (indexPath.row == 1){
            return _yijianfankuiCell;
        }else if (indexPath.row == 2){
            return _fuwuCell;
        }else if (indexPath.row == 3){
            return _userAssistence;
        }
    }else if (indexPath.section == 1){
        if(indexPath.row == 0){
            return _genggaimimaCell;
        }else if(indexPath.row == 1){
            return _settingCell;
        }else {
            return _tuichuCell;
        }
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        if(indexPath.row == 0){
                      UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                            AboutProductViewController *aboutVC = [storyBoard instantiateViewControllerWithIdentifier:@"AboutProductViewController"];
            aboutVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutVC animated:YES];
            
        }
        else if (indexPath.row == 1){
            XLAdviseFeedBackViewController *feedBackVc = [[XLAdviseFeedBackViewController alloc] init];
            feedBackVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:feedBackVc animated:YES];
            
        }else if (indexPath.row == 2){
                     UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                        ServerPrivacyViewController *serverVC = [storyBoard instantiateViewControllerWithIdentifier:@"ServerPrivacyViewController"];
            serverVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:serverVC animated:YES];
        }else if (indexPath.row == 3){
            XLUserAssistenceViewController *assistence = [[XLUserAssistenceViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:assistence animated:YES];
        }
    }
    
    if(indexPath.section == 1){
        if(indexPath.row == 0){
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        ChangePasswdViewController *changepasswdVC = [storyBoard instantiateViewControllerWithIdentifier:@"ChangePasswdViewController"];
            
            changepasswdVC.hidesBottomBarWhenPushed = YES;
            
         [self.navigationController pushViewController:changepasswdVC animated:YES];
        }else if (indexPath.row == 1){
            //设置页面
            XLSettingViewController *settingVc = [[XLSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self pushViewController:settingVc animated:YES];
            
        }else{
            [SVProgressHUD showWithStatus:@"正在退出"];
            [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
                if (error && error.errorCode != EMErrorServerNotLogin) {
                    if (error && error.errorCode != EMErrorServerNotLogin) {
                        [SVProgressHUD showImage:nil status:@"网络连接失败"];
                    }
                }
                else{
                    [SVProgressHUD dismiss];
                    [[AccountManager shareInstance] logout];
//                    [[ApplyViewController shareController] clear];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                }
            } onQueue:nil];

//            [[AccountManager shareInstance] logout];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
