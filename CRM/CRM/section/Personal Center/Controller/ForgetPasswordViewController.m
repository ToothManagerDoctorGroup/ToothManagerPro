//
//  ForgetPasswordViewController.m
//  CRM
//
//  Created by lsz on 15/7/1.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "AccountManager.h"
#import "CRMHttpRequest+PersonalCenter.h"

@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"忘记密码";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    CALayer *layer = self.validateButton.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:8.0];
    [self.validateButton addTarget:self action:@selector(getValidateCode:) forControlEvents:UIControlEventTouchUpInside];
    
    self.passwdTextField.secureTextEntry = YES;
    self.passwdTextField.keyboardType = UIKeyboardTypeEmailAddress;
    
}
- (void)initData
{
    timeCount = 0;
}
- (void)getValidateCode:(UIButton *)sender {
    [self startTimer];
}
#pragma mark - getValidate
- (void)startTimer
{
    if (self.phoneTextField.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"您未填写手机号码"];
    }else {
        if (![NSString checkTelNumber:self.phoneTextField.text]) {
            [SVProgressHUD showErrorWithStatus:@"手机号码无效"];
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
    /*
    [[AccountManager shareInstance]sendForgetValidateCodeToPhone:phone successBlock:^{
            [SVProgressHUD showWithStatus:@"正在发送验证码..."];
        } failedBlock:^(NSError *error){
        [SVProgressHUD showTextWithStatus:[error localizedDescription]];
    }];*/
    
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
- (void)sendValidateSuccessWithResult:(NSDictionary *)result
{
    [SVProgressHUD showImage:nil status:@"短信已经发送"];
}

- (void)sendValidateFailedWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}
- (void)sendForgetValidateSuccessWithResult:(NSDictionary *)result{
    [SVProgressHUD showImage:nil status:@"短信已经发送"];
}
- (void)sendForgetValidateFailedWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}

- (void)forgetPasswordSucessWithResult:(NSDictionary *)result{
    [SVProgressHUD showSuccessWithStatus:@"已找回密码，请登录"];
    [self popViewControllerAnimated:YES]; 
}
- (void)forgetPasswordFailedWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}
- (IBAction)queren:(id)sender {
    [self.phoneTextField resignFirstResponder];
    [self.passwdTextField resignFirstResponder];
    [self.validateTextField resignFirstResponder];
    [[AccountManager shareInstance]forgetPasswordWithPhone:self.phoneTextField.text passwd:self.passwdTextField.text validate:self.validateTextField.text successBlock:^{
            [SVProgressHUD showWithStatus:@"正在找回密码..."];
        } failedBlock:^(NSError *error){
        [SVProgressHUD showTextWithStatus:[error localizedDescription]];
    }];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_passwdTextField resignFirstResponder];
    [_validateTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_passwdTextField resignFirstResponder];
    [_validateTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
