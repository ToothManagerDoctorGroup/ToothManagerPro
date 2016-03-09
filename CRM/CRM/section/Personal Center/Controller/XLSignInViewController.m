//
//  XLSignInViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/21.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLSignInViewController.h"
#import "UIColor+Extension.h"
#import "CommonMacro.h"
#import "AccountManager.h"
#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDictionary+Extension.h"
#import "CRMMacro.h"
#import "CRMUserDefalut.h"
#import "DBManager+User.h"
#import "ForgetPasswordViewController.h"
#import "UserInfoViewController.h"
#import "DoctorInfoModel.h"
#import "XLSignUpViewController.h"
#import "XLPersonalStepOneViewController.h"
#import "XLForgetPasswordViewController.h"
#import "UserProfileManager.h"
#import "AFNetworking.h"
#import "CRMHttpRespondModel.h"
#import "XLLoginTool.h"

@interface XLSignInViewController ()<CRMHttpRequestPersonalCenterDelegate>{
    BOOL check;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *remenberPwd;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *loginInButton;

@end

@implementation XLSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置控件属性
    [self initViewAttr];
    
}

- (void)awakeFromNib{
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithHex:0x00a0ea];
}


#pragma mark - 设置控件属性
- (void)initViewAttr{
    //设置占位字体颜色
    [_userNameField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _signInButton.layer.borderWidth = 1;
    _signInButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    _signInButton.layer.cornerRadius = 5;
    _signInButton.layer.masksToBounds = YES;
    _loginInButton.layer.cornerRadius = 5;
    _loginInButton.layer.masksToBounds = YES;
    
    self.passwordField.secureTextEntry = YES;
    self.title = @"登录";
    self.remenberPwd.selected = YES;
    
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.userNameField.text = [CRMUserDefalut objectForKey:LatestUserName];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if(self.remenberPwd.selected == YES){
        check = YES;
    }else{
        check = NO;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if([user objectForKey:@"Password"]!=nil){
        self.passwordField.text = [user objectForKey:@"Password"];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


//忘记密码
- (IBAction)forgatePwdAction:(id)sender {
    UIStoryboard *storboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    XLForgetPasswordViewController * forgetVC = [storboard instantiateViewControllerWithIdentifier:@"XLForgetPasswordViewController"];
    [self pushViewController:forgetVC animated:YES];
}
//登录
- (IBAction)loginInAction:(id)sender {
    
    [SVProgressHUD showWithStatus:@"正在登录"];
    [XLLoginTool loginWithNickName:self.userNameField.text password:self.passwordField.text success:^(CRMHttpRespondModel *respond) {
        
        if ([respond.code integerValue] == 200) {
            NSDictionary *resultDic = respond.result;
            //登录成功，创建和当前登录人对应的数据库
//            [[DBManager shareInstance] createdbFileWithUserId:[resultDic objectForKey:@"id"]];
//            [[DBManager shareInstance] createTables];
            
                [[AccountManager shareInstance] setUserinfoWithDictionary:resultDic];
                UserObject *userobj = [[AccountManager shareInstance] currentUser];
                [[DoctorManager shareInstance] getDoctorListWithUserId:userobj.userid successBlock:^{
                } failedBlock:^(NSError *error) {
                    [SVProgressHUD showImage:nil status:error.localizedDescription];
                }];

                //环信账号登录
                [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userobj.userid password:resultDic[@"Password"] completion:^(NSDictionary *loginInfo, EMError *error) {
                    
                    if (loginInfo && !error) {
                        //设置是否自动登录
                        [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                        
                        //获取数据库中数据
                        [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                        
                        EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
                        //设置离线推送的样式
                        options.displayStyle = ePushNotificationDisplayStyle_messageSummary;
                        [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];
                        
                        //发送自动登陆状态通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                        
                        //保存最近一次登录用户名
                        [self saveLastLoginUsername];
                    }
                } onQueue:nil];
            
        }else{
            [SVProgressHUD showErrorWithStatus:respond.result];
        }

    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        }
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}
#pragma  mark - 保存密码到本地
- (void)saveLastLoginUsername
{
    NSString *username = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
        [ud synchronize];
    }
}

- (NSString*)lastLoginUsername
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
    if (username && username.length > 0) {
        return username;
    }
    return nil;
}
//注册
- (IBAction)signInAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    XLSignUpViewController *signupVC = [storyboard instantiateViewControllerWithIdentifier:@"XLSignUpViewController"];
    [self pushViewController:signupVC animated:YES];
}

//记住密码
- (IBAction)rememberPwdAction:(id)sender {
    self.remenberPwd.selected = !self.remenberPwd.selected;
    check = !check;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

#pragma mark - Delgates
- (void)loginSucessWithResult:(NSDictionary *)result {
    
    NSDictionary *resultDic = [result objectForKey:@"Result"];
    [[AccountManager shareInstance] setUserinfoWithDictionary:resultDic];
    
    UserObject *userobj = [[AccountManager shareInstance] currentUser];
    [[DoctorManager shareInstance] getDoctorListWithUserId:userobj.userid successBlock:^{
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
    
    
    //环信账号登录
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userobj.userid password:resultDic[@"Password"] completion:^(NSDictionary *loginInfo, EMError *error) {
        
        if (loginInfo && !error) {
            //设置是否自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            
            //获取数据库中数据
            [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
            
            EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
            //设置离线推送的样式
            options.displayStyle = ePushNotificationDisplayStyle_messageSummary;
            [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];

            //发送自动登陆状态通知
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
            
            //保存最近一次登录用户名
            [self saveLastLoginUsername];
        }
        else
        {
            switch (error.errorCode)
            {
                case EMErrorNotFound:
                    TTAlertNoTitle(error.description);
                    break;
                case EMErrorNetworkNotConnected:
                    TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                    break;
                case EMErrorServerNotReachable:
                    TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                    break;
                case EMErrorServerAuthenticationFailure:
                    TTAlertNoTitle(error.description);
                    break;
                case EMErrorServerTimeout:
                    TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                    break;
                default:
                    TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Login failure"));
                    break;
            }
        }
        
    } onQueue:nil];
}

//获取用户的医生列表
- (void)getDoctorListSuccessWithResult:(NSDictionary *)result {
    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
    if(self.navigationController.topViewController == self){
        [self postNotificationName:SignInSuccessNotification object:nil];
    }
    NSArray *dicArray = [result objectForKey:@"Result"];
    if (dicArray && dicArray.count > 0) {
        for (NSDictionary *dic in dicArray) {
            DoctorInfoModel *doctorInfo = [DoctorInfoModel objectWithKeyValues:dic];
            //设置当前的签约状态
            NSString *signKey = [NSString stringWithFormat:@"%@isSign",doctorInfo.doctor_id];
            [CRMUserDefalut setObject:doctorInfo.is_sign forKey:signKey];
            
            UserObject *obj = [UserObject userobjectFromDic:dic];
            [[DBManager shareInstance] updateUserWithUserObject:obj];
            [[AccountManager shareInstance] refreshCurrentUserInfo];
            return;
        }
    }
    
}
- (void)getDoctorListFailedWithError:(NSError *)error {
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}

- (void)loginFailedWithError:(NSError *)error {
    //    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
