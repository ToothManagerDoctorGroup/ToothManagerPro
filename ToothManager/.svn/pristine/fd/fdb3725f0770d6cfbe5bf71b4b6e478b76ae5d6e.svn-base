//
//  TTMLoginController.m
//  ToothManager
//

#import "TTMLoginController.h"
#import "TTMTextField.h"
#import "TTMTabBarController.h"
#import "TTMForgetPasswordController.h"

#define kMargin 20.f
#define kMarginTop 20.f
#define kIntroduceFontSize 15
#define kForgetButtonFontSize 14
#define kHeaderViewH 210.f
#define kLogoW 60.f
#define kLogoH kLogoW
#define kLogoMarinTop 40.f
#define kTextImageViewW 157.f
#define kTextImageViewH 22.f
#define kLabelH 20.f

@interface TTMLoginController ()<UITextFieldDelegate>

@property (nonatomic, weak)   UIScrollView *scrollView;
@property (nonatomic, weak)   UIView *headerView;
@property (nonatomic, weak)   TTMTextField *accountTextField;
@property (nonatomic, weak)   TTMTextField *passwordTextField;
@property (nonatomic, weak)   UIButton *loginButton;
@end

@implementation TTMLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    [self setupScrollView];
    [self setupHeaderView];
    [self setupViews];
    
    TTMUser *user = [TTMUser unArchiveUser];
    if (user) {
        self.accountTextField.text = user.username;
        self.passwordTextField.text = user.password;
        self.loginButton.enabled = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.accountTextField becomeFirstResponder];
}

/**
 *  加载滚动背景视图
 */
- (void)setupScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    scrollView.delaysContentTouches = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}
/**
 *  加载logo视图
 */
- (void)setupHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = MainColor;
    [self.scrollView addSubview:headerView];
    self.headerView = headerView;
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [UIImage imageNamed:@"member_logo"];
    [headerView addSubview:logoImageView];
    
    UIImageView *textImageView = [[UIImageView alloc] init];
    textImageView.image = [UIImage imageNamed:@"member_login_text"];
    [headerView addSubview:textImageView];
    
    UILabel *introduceLabel = [[UILabel alloc] init];
    introduceLabel.textColor = [UIColor whiteColor];
    introduceLabel.font = [UIFont systemFontOfSize:kIntroduceFontSize];
    introduceLabel.textAlignment = NSTextAlignmentCenter;
    introduceLabel.text = @"患者-医生-护士-诊位一站式管理";
    [headerView addSubview:introduceLabel];
    
    headerView.frame = CGRectMake(0, 0, ScreenWidth, kHeaderViewH);
    logoImageView.frame = CGRectMake((ScreenWidth - kLogoW) / 2, kLogoMarinTop, kLogoW, kLogoH);
    textImageView.frame = CGRectMake((ScreenWidth - kTextImageViewW) / 2,
                                     logoImageView.bottom + kMarginTop, kTextImageViewW, kTextImageViewH);
    introduceLabel.frame = CGRectMake(0, textImageView.bottom + kMarginTop, ScreenWidth, kLabelH);
}
/**
 *  加载输入框和按钮
 */
- (void)setupViews {
    TTMTextField *accountTextField = [[TTMTextField alloc] initWithTitle:@"账户"];
    accountTextField.returnKeyType = UIReturnKeyNext;
    accountTextField.delegate = self;
    [self.scrollView addSubview:accountTextField];
    self.accountTextField = accountTextField;
    
    TTMTextField *passworTextField = [[TTMTextField alloc] initWithTitle:@"密码"];
    passworTextField.secureTextEntry = YES;
    passworTextField.returnKeyType = UIReturnKeyDone;
    passworTextField.delegate = self;
    [self.scrollView addSubview:passworTextField];
    self.passwordTextField = passworTextField;
    
    // 忘记密码
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [forgetButton setTitleColor:MainColor forState:UIControlStateHighlighted];
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:kForgetButtonFontSize];
    forgetButton.tag = 0;
    [forgetButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:forgetButton];
    
    // 登录
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"member_login_button_bg"] forState:UIControlStateNormal];
    loginButton.tag = 1;
    [loginButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.enabled = NO;
    [self.scrollView addSubview:loginButton];
    self.loginButton = loginButton;
    
    CGFloat kTextFieldW = (ScreenWidth - 2 * kMargin);
    CGFloat kForgetButtonW = 80.f;
    CGFloat kForgetButtonH = 40.f;
    CGFloat kLoginButtonH = 35.f;
    
    accountTextField.frame = CGRectMake(kMargin, self.headerView.bottom + kMargin, kTextFieldW, 0);
    passworTextField.frame = CGRectMake(kMargin, accountTextField.bottom + kMargin, kTextFieldW, 0);
    forgetButton.frame = CGRectMake(ScreenWidth - kMargin - kForgetButtonW, passworTextField.bottom,
                                    kForgetButtonW, kForgetButtonH);
    loginButton.frame = CGRectMake(kMargin, forgetButton.bottom, kTextFieldW, kLoginButtonH);
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, loginButton.bottom + kMargin);
}

/**
 *  忘记密码，和登录按钮点击时间
 *
 *  @param button 按钮
 */
- (void)buttonAction:(UIButton *)button {
    if (button.tag == 0) {
        TTMForgetPasswordController *forgetVC = [[TTMForgetPasswordController alloc] init];
        [self.navigationController pushViewController:forgetVC animated:YES];
    } else {
        [self login];
    }
}
/**
 *  点击下一步的操作
 *
 *  @param textField 输入框
 *
 *  @return BOOl
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.accountTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self login];
    }
    return YES;
}

/**
 *  登录请求
 */
- (void)login {
    if ([NSString isEmpty:self.accountTextField.text] || [NSString isEmpty:self.passwordTextField.text]) {
        [MBProgressHUD showToastWithText:@"请输入账户或密码"];
        return;
    }
    
    __weak __typeof(&*self) weakSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDWithView:self.view.window text:@"登录中..."];
    [TTMUser loginWithUserName:self.accountTextField.text
                      password:self.passwordTextField.text
                      Complete:^(id result) {
                          [hud hide:YES];
                          if ([result isKindOfClass:[NSString class]]) {
                              [MBProgressHUD showToastWithText:result];
                          } else {
                              MBProgressHUD *hud = [MBProgressHUD showToastWithText:@"登录成功"];
                              hud.completionBlock = ^(){
                                  weakSelf.view.window.rootViewController = [[TTMTabBarController alloc] init];
                              };
                          }
                      }];
}
/**
 *  监听输入框文本内容改变
 *
 *  @param notification 通知推向
 */
- (void)textChange:(NSNotification *)notification {
    if ([NSString isEmpty:self.accountTextField.text] || [NSString isEmpty:self.passwordTextField.text]) {
        self.loginButton.enabled = NO;
    } else {
        self.loginButton.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
