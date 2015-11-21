//
//  TTMForgetPasswordController.m
//  ToothManager
//

#import "TTMForgetPasswordController.h"
#import "TTMTextField.h"
#import "TTMTimeButton.h"
#import "TTMValidateTool.h"
#import "TTMGreenButton.h"

#define kMarginTop 40.f
#define kMargin 10.f

#define kTimeButtonW 100.f
#define kTextFieldW (ScreenWidth - 2 * kMargin)
#define kPhoneTextW (kTextFieldW - kTimeButtonW)

@interface TTMForgetPasswordController ()<
    TTMTimeButtonDelegate,
    UITextFieldDelegate>

@property (nonatomic, weak)   TTMTextField *phoneTextField; // 手机输入框
@property (nonatomic, weak)   TTMTimeButton *timeBuntton; // 发送验证码按钮
@property (nonatomic, weak)   TTMTextField *validateTextField; // 验证码
@property (nonatomic, weak)   TTMTextField *freshPasswordTextField; // 新密码
@property (nonatomic, weak)   TTMTextField *rePasswordTextField; // 确认密码
@property (nonatomic, weak)   TTMGreenButton *submitButton; // 提交按钮
@end

@implementation TTMForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    
    [self setupViews];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.timeBuntton openTimer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.phoneTextField becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timeBuntton closeTimer];
}
/**
 *  加载输入框和按钮视图
 */
- (void)setupViews {
    TTMTextField *phoneTextField = [[TTMTextField alloc] initWithTitle:@"手机号"];
    phoneTextField.delegate = self;
    phoneTextField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:phoneTextField];
    self.phoneTextField = phoneTextField;
    
    TTMTimeButton *timeButton = [[TTMTimeButton alloc] init];
    [timeButton setBackgroundColor:MainColor];
    [timeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    timeButton.againTitle = @"重新发送";
    timeButton.startTime = 60;
    timeButton.delegate = self;
    timeButton.enabled = NO;
    [self.view addSubview:timeButton];
    self.timeBuntton = timeButton;
    
    TTMTextField *validateTextField = [[TTMTextField alloc] initWithTitle:@"验证码"];
    validateTextField.delegate = self;
    validateTextField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:validateTextField];
    self.validateTextField = validateTextField;
    
    TTMTextField *freshPasswordTextField = [[TTMTextField alloc] initWithTitle:@"新密码"];
    freshPasswordTextField.secureTextEntry = YES;
    freshPasswordTextField.delegate = self;
    freshPasswordTextField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:freshPasswordTextField];
    self.freshPasswordTextField = freshPasswordTextField;
    
    TTMTextField *rePasswordTextField = [[TTMTextField alloc] initWithTitle:@"确认密码"];
    rePasswordTextField.secureTextEntry = YES;
    rePasswordTextField.delegate = self;
    rePasswordTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:rePasswordTextField];
    self.rePasswordTextField = rePasswordTextField;
    
    TTMGreenButton *submitButton = [[TTMGreenButton alloc] init];
    [submitButton setTitle:@"确认" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    submitButton.enabled = NO;
    [self.view addSubview:submitButton];
    self.submitButton = submitButton;
    
    phoneTextField.frame = CGRectMake(kMargin, kMarginTop + NavigationHeight, kPhoneTextW, 0);
    timeButton.frame = CGRectMake(self.phoneTextField.right + 5, kMarginTop + NavigationHeight,
                                  kTimeButtonW, phoneTextField.height);
    validateTextField.frame = CGRectMake(kMargin, phoneTextField.bottom + kMargin, kTextFieldW, 0);
    freshPasswordTextField.frame = CGRectMake(kMargin, validateTextField.bottom + kMargin, kTextFieldW, 0);
    rePasswordTextField.frame = CGRectMake(kMargin, freshPasswordTextField.bottom + kMargin, kTextFieldW, 0);
    submitButton.origin = CGPointMake(kMargin, rePasswordTextField.bottom + kMargin);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.phoneTextField]) {
        [self.validateTextField becomeFirstResponder];
    } else if ([textField isEqual:self.validateTextField]) {
        [self.freshPasswordTextField becomeFirstResponder];
    } else if ([textField isEqual:self.freshPasswordTextField]) {
        [self.rePasswordTextField becomeFirstResponder];
    } else if ([textField isEqual:self.rePasswordTextField]) {
        [self submit];
    }
    return YES;
}

/**
 *  获取按钮码按钮事件
 *
 *  @param timeButton 时间按钮
 */
- (void)timeButtonDidClick:(TTMTimeButton *)timeButton {
    NSString *phone = [self.phoneTextField.text trim];
    if ([TTMValidateTool isMobileNumber:phone] == MobileNubmerTypeNone) {
        [MBProgressHUD showToastWithText:@"请输入正确的手机号"];
        [timeButton resetButtonWithTitle:@"获取验证码"];
        return;
    }
    [TTMUser sendValidateCodeWithMobile:phone Complete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
            [timeButton resetButtonWithTitle:@"获取验证码"];
        } else {
            [MBProgressHUD showToastWithText:@"获取成功"];
        }
    }];
}
/**
 *  监听文本改变
 *
 *  @param notification 通知
 */
- (void)textChange:(NSNotification *)notification {
    if ([NSString isEmpty:self.phoneTextField.text]) {
        self.timeBuntton.enabled = NO;
    } else {
        self.timeBuntton.enabled = YES;
    }
    if ([NSString isEmpty:self.phoneTextField.text] ||
        [NSString isEmpty:self.validateTextField.text] ||
        [NSString isEmpty:self.freshPasswordTextField.text] ||
        [NSString isEmpty:self.rePasswordTextField.text] ) {
        self.submitButton.enabled = NO;
    } else {
        self.submitButton.enabled = YES;
    }
}
/**
 *  确认按钮事件
 */
- (void)submit {
    if ([NSString isEmpty:self.phoneTextField.text] ||
        [NSString isEmpty:self.validateTextField.text] ||
        [NSString isEmpty:self.freshPasswordTextField.text] ||
        [NSString isEmpty:self.rePasswordTextField.text]) {
        [MBProgressHUD showToastWithText:@"请填写信息"];
        return;
    }
    if ([TTMValidateTool isMobileNumber:self.phoneTextField.text] == MobileNubmerTypeNone) {
        [MBProgressHUD showToastWithText:@"请输入正确的手机号"];
        return;
    }
    if (![self.freshPasswordTextField.text isEqualToString:self.rePasswordTextField.text]) {
        [MBProgressHUD showToastWithText:@"两次输入的密码不相同"];
        return;
    }
    
    __weak __typeof(&*self) weakSelf = self;
    [TTMUser forgetPasswordWithMobile:self.phoneTextField.text
                         validatecode:self.validateTextField.text
                              passNew:self.freshPasswordTextField.text
                             Complete:^(id result) {
                                 if ([result isKindOfClass:[NSString class]]) {
                                     [MBProgressHUD showToastWithText:result];
                                 } else {
                                     MBProgressHUD *hud = [MBProgressHUD showToastWithText:@"找回密码成功"];
                                     hud.completionBlock = ^(){
                                         [weakSelf.navigationController popViewControllerAnimated:YES];
                                     };
                                 }
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
