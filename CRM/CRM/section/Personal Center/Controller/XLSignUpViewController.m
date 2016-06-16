//
//  XLSignUpViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/22.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLSignUpViewController.h"
#import "ServerPrivacyViewController.h"
#import "TimNavigationViewController.h"
#import "AccountManager.h"
#import "SVProgressHUD.h"
#import "NSString+Conversion.h"
#import "CRMMacro.h"
#import "CRMUserDefalut.h"
#import "NSDictionary+Extension.h"
#import "AccountViewController.h"
#import "XLPersonalStepOneViewController.h"
#import "XLLoginTool.h"
#import "CRMHttpRespondModel.h"
#import "DBManager.h"
#import "JKCountDownButton.h"
#import "UIColor+Extension.h"

@interface XLSignUpViewController ()<CRMHttpRequestPersonalCenterDelegate>

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@end

@implementation XLSignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"注册";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
    self.passwdTextField.secureTextEntry = YES;
    self.passwdTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.signUpButton.layer.cornerRadius = 5;
    self.signUpButton.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.passwdTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.validateTextField resignFirstResponder];
    [self.recommenderTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)signupAction:(id)sender {
    [self.view endEditing:YES];
    
    [[AccountManager shareInstance] registerWithNickName:self.phoneTextField.text passwd:self.passwdTextField.text phone:self.phoneTextField.text recommender:self.recommenderTextField.text validate:self.validateTextField.text successBlock:^{
        [SVProgressHUD showWithStatus:@"正在注册..."];
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showTextWithStatus:[error localizedDescription]];
    }];
}

- (IBAction)readlisenseAction:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    ServerPrivacyViewController *serverVC = [storyBoard instantiateViewControllerWithIdentifier:@"ServerPrivacyViewController"];
    serverVC.isPush = YES;
    [self pushViewController:serverVC animated:YES];
}

- (void)sendSMSTextToPhone:(NSString *)phone
{
    [[AccountManager shareInstance] sendValidateCodeToPhone:phone successBlock:^{
        [SVProgressHUD showWithStatus:@"正在发送验证码..."];
    } failedBlock:^(NSError *error){
        [SVProgressHUD showTextWithStatus:[error localizedDescription]];
    }];
}

- (BOOL)isAllNum:(NSString *)string{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}
- (IBAction)countButtonAction:(JKCountDownButton *)sender {
    
    if (self.phoneTextField.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"您未填写手机号码"];
    }else if (self.phoneTextField.text.length > 0 && self.phoneTextField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
    }else {
        if (![self isAllNum:self.phoneTextField.text]) {
            [SVProgressHUD showErrorWithStatus:@"手机号码含有异常字符"];
        }else {
            //获取验证码
            [self sendSMSTextToPhone:self.phoneTextField.text];
            
            //设置按钮不可点击
            sender.enabled = NO;
            sender.backgroundColor = [UIColor colorWithHex:0x888888];
            //button type要 设置成custom 否则会闪动
            [sender startWithSecond:60];
            [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
                NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
                return title;
            }];
            [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                countDownButton.enabled = YES;
                sender.backgroundColor = [UIColor colorWithHex:0x00a0ea];
                return @"获取验证码";
            }];
            
        }
    }
}

#pragma mark - Delegate
- (void)registerSucessWithResult:(NSDictionary *)result {
    [SVProgressHUD showWithStatus:@"注册成功，正在登陆"];
    [XLLoginTool newLoginWithNickName:self.phoneTextField.text password:self.passwdTextField.text success:^(CRMHttpRespondModel *respond) {
        if ([respond.code integerValue] == 200) {
            [self loginSucessWithResult:respond.result];
        }else{
            [SVProgressHUD showTextWithStatus:respond.result];
        }
        
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        }
        [SVProgressHUD showTextWithStatus:[error localizedDescription]];
    }];
}

- (void)loginSucessWithResult:(NSDictionary *)result {
    [SVProgressHUD dismiss];
    //登录成功，创建和当前登录人对应的数据库
    [[AccountManager shareInstance] setUserinfoWithDictionary:result];
    //将加密后的密码保存到本地
    [CRMUserDefalut setObject:result[@"Password"] forKey:LatestUserPassword];
    //环信账号登录
    //判断当前环信账号是否已登录
    if ([[EaseMob sharedInstance].chatManager isLoggedIn]) {
        //退出当前登录
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
    }
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[AccountManager currentUserid] password:result[@"Password"] completion:^(NSDictionary *loginInfo, EMError *error) {
            
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
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    XLPersonalStepOneViewController *oneVc = [storyBoard instantiateViewControllerWithIdentifier:@"XLPersonalStepOneViewController"];
    oneVc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:oneVc animated:YES];
        
}

#pragma  mark - 保存账号到本地
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

- (void)loginFailedWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}


- (void)registerFailedWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}

- (void)sendValidateSuccessWithResult:(NSDictionary *)result
{
    [SVProgressHUD showImage:nil status:@"短信已经发送"];
}

- (void)sendValidateFailedWithError:(NSError *)error
{
    //停止计时
    [self.validateButton stop];
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}

@end
