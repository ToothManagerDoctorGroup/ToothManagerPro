//
//  XLForgetPasswordViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/22.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLForgetPasswordViewController.h"
#import "AccountManager.h"
#import "CRMHttpRequest+PersonalCenter.h"
#import "JKCountDownButton.h"
#import "UIColor+Extension.h"

@interface XLForgetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *certainPassWord;

@end

@implementation XLForgetPasswordViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.passwdTextField.secureTextEntry = YES;
    self.passwdTextField.keyboardType = UIKeyboardTypeEmailAddress;

    self.submitButton.layer.cornerRadius = 5;
    self.submitButton.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.phoneTextField resignFirstResponder];
    [self.validateTextField resignFirstResponder];
    [self.passwdTextField resignFirstResponder];
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
            //背景置灰
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

- (void)sendValidateSuccessWithResult:(NSDictionary *)result
{
    [SVProgressHUD showImage:nil status:@"短信已经发送"];
}

- (void)sendValidateFailedWithError:(NSError *)error
{
    [self.validateButton stop];
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}
- (void)sendForgetValidateSuccessWithResult:(NSDictionary *)result{
    [SVProgressHUD showImage:nil status:@"短信已经发送"];
}
- (void)sendForgetValidateFailedWithError:(NSError *)error{
    [self.validateButton stop];
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}

- (void)forgetPasswordSucessWithResult:(NSDictionary *)result{
    [SVProgressHUD showSuccessWithStatus:@"密码已修改，请登录"];
    [self popViewControllerAnimated:YES];
}
- (void)forgetPasswordFailedWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}
- (IBAction)queren:(id)sender {
    [self.phoneTextField resignFirstResponder];
    [self.passwdTextField resignFirstResponder];
    [self.validateTextField resignFirstResponder];
    
    if (self.passwdTextField.text.length == 0) {
        [SVProgressHUD showImage:nil status:@"请输入新密码"];
        return;
    }
    if (self.certainPassWord.text.length == 0) {
        [SVProgressHUD showImage:nil status:@"请再次输入新密码"];
        return;
    }
    
    if (![self.passwdTextField.text isEqualToString:self.certainPassWord.text]) {
        [SVProgressHUD showImage:nil status:@"两次输入的密码不相同"];
        return;
    }
    
    [[AccountManager shareInstance]forgetPasswordWithPhone:self.phoneTextField.text passwd:self.passwdTextField.text validate:self.validateTextField.text successBlock:^{
        [SVProgressHUD showWithStatus:@"正在修改密码..."];
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
}
@end
