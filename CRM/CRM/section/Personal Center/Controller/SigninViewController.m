//
//  SigninViewController.m
//  CRM
//
//  Created by TimTiger on 14-9-4.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "SigninViewController.h"
#import "SignUpViewController.h"
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

@interface SigninViewController () <CRMHttpRequestPersonalCenterDelegate>{
    BOOL check;
}
@end

@implementation SigninViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Life Cicle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    self.storepasswdButton.selected = YES;
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.headerImageView.layer.cornerRadius = self.headerImageView.bounds.size.height/2;
    self.headerImageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.headerImageView.layer.shadowOffset =  CGSizeMake(10, 10);
    self.headerImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.headerImageView.layer.borderWidth = 3;
    self.headerImageView.clipsToBounds = YES;
    self.passwdTextField.secureTextEntry = YES;
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.passwdTextField resignFirstResponder];
    [self.nicknameTextField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.nicknameTextField.text = [CRMUserDefalut objectForKey:LatestUserName];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if(self.storepasswdButton.selected == YES){
        check = YES;
    }else{
        check = NO;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if([user objectForKey:@"Password"]!=nil){
        self.passwdTextField.text = [user objectForKey:@"Password"];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  IBActions

- (IBAction)signinAction:(id)sender {
    [[AccountManager shareInstance] loginWithNickName:self.nicknameTextField.text passwd:self.passwdTextField.text successBlock:^{
        [SVProgressHUD showWithStatus:@"正在登录..."];
        
        if (!check)
        {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:nil forKey:@"Name"];
            [user setObject:nil forKey:@"Password"];
            
            [user removeObjectForKey:@"Name"];
            [user removeObjectForKey:@"Password"];
            
        }else
        {
            
            NSString *name = self.nicknameTextField.text;
            NSString *password = self.passwdTextField.text;
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:name forKey:@"Name"];
            [user setObject:password forKey:@"Password"];
            [user synchronize];
        }
        
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showTextWithStatus:[error localizedDescription]];
    }];
    
    //环信账号登录
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:@"xuxiaolong" password:@"123456" completion:^(NSDictionary *loginInfo, EMError *error) {
        
        if (loginInfo && !error) {
            //设置是否自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            
            //获取数据库中数据
            [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
            
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
#pragma  mark - private
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

- (IBAction)misspasswdAction:(id)sender {
    ForgetPasswordViewController * forgetVC = [[ForgetPasswordViewController alloc]initWithNibName:@"ForgetPasswordViewController" bundle:nil];
    [self pushViewController:forgetVC animated:YES];
}

- (IBAction)registerAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    SignUpViewController *signupVC = [storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self pushViewController:signupVC animated:YES];
}

- (IBAction)storepasswdAction:(id)sender {
    self.storepasswdButton.selected = !self.storepasswdButton.selected;
    check = !check;
}

- (void)onBackButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
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
@end
