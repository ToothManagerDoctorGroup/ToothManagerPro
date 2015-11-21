//
//  SignUpViewController.m
//  CRM
//
//  Created by TimTiger on 14-9-4.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "SignUpViewController.h"
#import "ServerPrivacyViewController.h"
#import "TimNavigationViewController.h"
#import "AccountManager.h"
#import "SVProgressHUD.h"
#import "NSString+Conversion.h"
#import "CRMMacro.h"
#import "CRMUserDefalut.h"
#import "NSDictionary+Extension.h"
#import "UserInfoViewController.h"
#import "AccountViewController.h"

@interface SignUpViewController () <CRMHttpRequestPersonalCenterDelegate>

@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    self.lisensebutton.selected = YES;
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
    CALayer *layer = self.validateButton.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:8.0];
    [self.validateButton addTarget:self action:@selector(getValidateCode:) forControlEvents:UIControlEventTouchUpInside];
    
    self.passwdTextField.secureTextEntry = YES;
    self.passwdTextField.keyboardType = UIKeyboardTypeEmailAddress;
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.passwdTextField resignFirstResponder];
    [self.nicknameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.validateTextField resignFirstResponder];
    [self.recommenderTextField resignFirstResponder];
}
- (void)initData
{
    timeCount = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signupAction:(id)sender {
    [self.nicknameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.passwdTextField resignFirstResponder];
    [self.recommenderTextField resignFirstResponder];
    [self.validateTextField resignFirstResponder];
    [[AccountManager shareInstance] registerWithNickName:self.nicknameTextField.text passwd:self.passwdTextField.text phone:self.phoneTextField.text recommender:self.recommenderTextField.text validate:self.validateTextField.text successBlock:^{
        [SVProgressHUD showWithStatus:@"正在注册..."];
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showTextWithStatus:[error localizedDescription]];
    }];
}

- (IBAction)lisenseAction:(id)sender {
    self.lisensebutton.selected = !self.lisensebutton.selected;
}

- (IBAction)readlisenseAction:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    ServerPrivacyViewController *serverVC = [storyBoard instantiateViewControllerWithIdentifier:@"ServerPrivacyViewController"];
    serverVC.isPush = YES;
    [self pushViewController:serverVC animated:YES];
}

- (void)getValidateCode:(UIButton *)sender {
    [self startTimer];
}

#pragma mark - getValidate
- (void)startTimer
{
    if (self.phoneTextField.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"您未填写手机号码"];
    }else if (self.phoneTextField.text.length > 0 && self.phoneTextField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
    }else {
        if (![self isAllNum:self.phoneTextField.text]) {
            [SVProgressHUD showErrorWithStatus:@"手机号码含有异常字符"];
        }else {
            myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshTime:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:myTimer forMode:NSDefaultRunLoopMode];
    
            [self.validateButton setUserInteractionEnabled:NO];
            [self.validateButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [self.validateButton setTitle:@"秒后重发" forState:UIControlStateNormal];
        
            //获取验证码
            [self sendSMSTextToPhone:self.phoneTextField.text];
        }
    }
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

#pragma mark -
#pragma mark NSTimer
- (void)refreshTime:(NSTimer *)timer
{
    timeCount ++;
    [_timeLabel setText:[NSString stringWithFormat:@"%d",60 - timeCount]];
    if (timeCount >= 60) {
        [timer invalidate];
        timer = nil;
        [self.validateButton setUserInteractionEnabled:YES];
        [self.validateButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.validateButton setTitle:@"重  发" forState:UIControlStateNormal];
        [_timeLabel setText:@""];
        timeCount = 0;
    }
}

#pragma mark - Delegate
- (void)registerSucessWithResult:(NSDictionary *)result {
    NSDictionary *resultDic = [result objectForKey:@"Result"];
    [[AccountManager shareInstance] setUserinfoWithDictionary:resultDic];
//    [SVProgressHUD showSuccessWithStatus:@"注册成功，请登录"];
//    [self popViewControllerAnimated:YES]; 注释了上面两行
    
//    [self postNotificationName:SignUpSuccessNotification object:nil];
    
    [[AccountManager shareInstance] loginWithNickName:self.nicknameTextField.text passwd:self.passwdTextField.text successBlock:^{
        
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showTextWithStatus:[error localizedDescription]];
    }];
}

- (void)loginSucessWithResult:(NSDictionary *)result {
    NSDictionary *resultDic = [result objectForKey:@"Result"];
    [[AccountManager shareInstance] setUserinfoWithDictionary:resultDic];
  // [self postNotificationName:SignInSuccessNotification object:nil];
    /*
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        UserInfoViewController *userInfoVC = [storyBoard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
        TimNavigationViewController *timNav = [[TimNavigationViewController alloc]initWithRootViewController:userInfoVC];
        [self presentViewController:timNav animated:YES completion:^{
        }];
     */
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UserInfoViewController *userInfoVC = [storyBoard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
    userInfoVC.hidesBottomBarWhenPushed = YES;
    userInfoVC.isZhuCe = YES;
    [self pushViewController:userInfoVC animated:YES];
    
    
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
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}

@end
