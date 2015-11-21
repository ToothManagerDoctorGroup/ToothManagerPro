//
//  TTMUpdatePasswordController.m
//  ToothManager
//

#import "TTMUpdatePasswordController.h"
#import "TTMTextField.h"
#import "TTMGreenButton.h"

#define kMargin 10.f
#define kMarginTop 20.f
#define kViewW (ScreenWidth - 2 * kMargin)

@interface TTMUpdatePasswordController ()<UITextFieldDelegate>

@property (nonatomic, weak)   TTMTextField *oldPasswordTextField;
@property (nonatomic, weak)   TTMTextField *freshPasswordTextField;
@property (nonatomic, weak)   TTMTextField *rePasswordTextField;
@property (nonatomic, weak)   TTMGreenButton *submitButton;
@end

@implementation TTMUpdatePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改登录密码";
    
    [self setupViews];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.oldPasswordTextField becomeFirstResponder];
}
/**
 *  加载输入框和按钮
 */
- (void)setupViews {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    
    TTMTextField *oldPasswordTextField = [[TTMTextField alloc] initWithTitle:@"当前密码"];
    oldPasswordTextField.secureTextEntry = YES;
    oldPasswordTextField.delegate = self;
    oldPasswordTextField.returnKeyType = UIReturnKeyNext;
    [scrollView addSubview:oldPasswordTextField];
    self.oldPasswordTextField = oldPasswordTextField;
    
    TTMTextField *freshPasswordTextField = [[TTMTextField alloc] initWithTitle:@"新密码"];
    freshPasswordTextField.secureTextEntry = YES;
    freshPasswordTextField.delegate = self;
    freshPasswordTextField.returnKeyType = UIReturnKeyNext;
    [scrollView addSubview:freshPasswordTextField];
    self.freshPasswordTextField = freshPasswordTextField;
    
    TTMTextField *rePasswordTextField = [[TTMTextField alloc] initWithTitle:@"确认密码"];
    rePasswordTextField.secureTextEntry = YES;
    rePasswordTextField.delegate = self;
    rePasswordTextField.returnKeyType = UIReturnKeyDone;
    [scrollView addSubview:rePasswordTextField];
    self.rePasswordTextField = rePasswordTextField;
    
    TTMGreenButton *submitButton = [[TTMGreenButton alloc] init];
    [submitButton setTitle:@"确认" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.enabled = NO;
    [scrollView addSubview:submitButton];
    self.submitButton = submitButton;
    
    scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
    oldPasswordTextField.frame = CGRectMake(kMargin, kMarginTop, kViewW, 0);
    freshPasswordTextField.frame = CGRectMake(kMargin, oldPasswordTextField.bottom + kMarginTop, kViewW, 0);
    rePasswordTextField.frame = CGRectMake(kMargin, freshPasswordTextField.bottom + kMarginTop, kViewW, 0);
    submitButton.origin = CGPointMake(kMargin, rePasswordTextField.bottom + 2 * kMarginTop);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.oldPasswordTextField]) {
        [self.freshPasswordTextField becomeFirstResponder];
    } else if ([textField isEqual:self.freshPasswordTextField]) {
        [self.rePasswordTextField becomeFirstResponder];
    } else if ([textField isEqual:self.rePasswordTextField]) {
        [self buttonAction:nil];
    }
    return YES;
}

/**
 *  监听输入框内容修改
 *
 *  @param notification 通知
 */
- (void)textChange:(NSNotification *)notification {
    if ([NSString isEmpty:self.oldPasswordTextField.text] ||
        [NSString isEmpty:self.freshPasswordTextField.text] ||
        [NSString isEmpty:self.rePasswordTextField.text] ) {
        self.submitButton.enabled = NO;
    } else {
        self.submitButton.enabled = YES;
    }
}
/**
 *  点击提交按钮事件
 *
 *  @param button 按钮
 */
- (void)buttonAction:(UIButton *)button {
    if ([NSString isEmpty:self.oldPasswordTextField.text] ||
        [NSString isEmpty:self.freshPasswordTextField.text] ||
        [NSString isEmpty:self.rePasswordTextField.text]) {
        [MBProgressHUD showToastWithText:@"请输入密码"];
        return;
    }
    if (![self.freshPasswordTextField.text isEqualToString:self.rePasswordTextField.text]) {
        [MBProgressHUD showToastWithText:@"两次输入的密码不相同"];
        return;
    }
    __weak __typeof(&*self) weakSelf = self;
    [TTMUser updatePassword:self.oldPasswordTextField.text
                        new:self.freshPasswordTextField.text
                   Complete:^(id result) {
                       if ([result isKindOfClass:[NSString class]]) {
                           [MBProgressHUD showToastWithText:result];
                       } else {
                           MBProgressHUD *hud = [MBProgressHUD showToastWithText:@"修改成功"];
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
