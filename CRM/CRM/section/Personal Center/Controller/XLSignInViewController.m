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
#import "DoctorInfoModel.h"
#import "XLSignUpViewController.h"
#import "XLPersonalStepOneViewController.h"
#import "XLForgetPasswordViewController.h"
#import "UserProfileManager.h"
#import "AFNetworking.h"
#import "CRMHttpRespondModel.h"
#import "XLLoginTool.h"
#import "DoctorTool.h"
#import <Masonry.h>

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

- (void)dealloc{
    NSLog(@"登录界面被销毁");
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
    XLForgetPasswordViewController *forgetVC = [storboard instantiateViewControllerWithIdentifier:@"XLForgetPasswordViewController"];
    [self pushViewController:forgetVC animated:YES];
}
//登录
- (IBAction)loginInAction:(id)sender {
    WS(weakSelf);
    [SVProgressHUD showWithStatus:@"正在登录"];
    [XLLoginTool newLoginWithNickName:self.userNameField.text password:self.passwordField.text success:^(CRMHttpRespondModel *respond) {
        
        if ([respond.code integerValue] == 200) {
            NSDictionary *resultDic = respond.result;
            [[AccountManager shareInstance] setUserinfoWithDictionary:resultDic];
            UserObject *userobj = [[AccountManager shareInstance] currentUser];
            //获取用户信息
            [weakSelf requestUserInfoWithUserId:userobj.userid];
            //将加密后的密码保存到本地
            [CRMUserDefalut setObject:resultDic[@"Password"] forKey:LatestUserPassword];
            //环信登录
            [weakSelf easeMobLoginWithUserName:userobj.userid password:resultDic[@"Password"]];
        }else{
            if ([respond.code integerValue] == 203) {
                [SVProgressHUD dismiss];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:respond.result delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alertView show];
            }else{
                [SVProgressHUD showImage:nil status:respond.result];
            }
        }

    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        }
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 获取用户信息
- (void)requestUserInfoWithUserId:(NSString *)userId{

    [DoctorTool getDoctorListWithUserid:userId success:^(CRMHttpRespondModel *respond) {
        if ([respond.code integerValue] == 200) {
            //登录成功
            DoctorInfoModel *doctorInfo = [DoctorInfoModel objectWithKeyValues:respond.result[0]];
            //设置当前的签约状态
            NSString *signKey = kUserIsSignKey(doctorInfo.doctor_id);
            [CRMUserDefalut setObject:doctorInfo.is_sign forKey:signKey];
            
            UserObject *obj = [UserObject userobjectFromDic:respond.result[0]];
            [[DBManager shareInstance] updateUserWithUserObject:obj];
            [[AccountManager shareInstance] refreshCurrentUserInfo];
            
            //判断当前用户是否填写了医院名称
            if (![respond.result[0][@"doctor_hospital"] isNotEmpty]) {
                //跳转到信息完善界面
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                XLPersonalStepOneViewController *oneVc = [storyBoard instantiateViewControllerWithIdentifier:@"XLPersonalStepOneViewController"];
                oneVc.hidesBottomBarWhenPushed = YES;
                [self pushViewController:oneVc animated:YES];
                
            }else{
                if(self.navigationController.topViewController == self){
                    [self postNotificationName:SignInSuccessNotification object:nil];
                }
            }
        }else{
            [SVProgressHUD showImage:nil status:respond.result];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - 环信用户登录
- (void)easeMobLoginWithUserName:(NSString *)userName password:(NSString *)password{
    //环信账号登录
    //判断当前环信账号是否已登录
    if ([[EaseMob sharedInstance].chatManager isLoggedIn]) {
        //退出当前登录
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
    }
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName password:password completion:^(NSDictionary *loginInfo, EMError *error) {
        
        if (loginInfo && !error) {
            //设置是否自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            
            //获取数据库中数据
            [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
            
            EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
            //设置离线推送的样式
            options.displayStyle = ePushNotificationDisplayStyle_simpleBanner;
            [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];
            //发送自动登陆状态通知
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
            
            //保存最近一次登录用户名
            [self saveLastLoginUsername];
        }
    } onQueue:nil];
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
    } onQueue:nil];
}

//获取用户的医生列表
- (void)getDoctorListSuccessWithResult:(NSDictionary *)result {
    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
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
            break;
        }
    }
    //判断当前用户是否填写了医院名称
    if (![dicArray[0][@"doctor_hospital"] isNotEmpty]) {
        //跳转到信息完善界面
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        XLPersonalStepOneViewController *oneVc = [storyBoard instantiateViewControllerWithIdentifier:@"XLPersonalStepOneViewController"];
        oneVc.hidesBottomBarWhenPushed = YES;
        [self pushViewController:oneVc animated:YES];
        
    }else{
        if(self.navigationController.topViewController == self){
            [self postNotificationName:SignInSuccessNotification object:nil];
        }
    }
}
- (void)getDoctorListFailedWithError:(NSError *)error {
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}

- (void)loginFailedWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
