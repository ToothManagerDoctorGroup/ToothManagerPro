//
//  TTMUpdatePayPasswordNextController.m
//  ToothManager
//

#import "TTMUpdatePayPasswordNextController.h"
#import "TTMTextField.h"
#import "TTMGreenButton.h"

#define kMargin 10.f
#define kMarginTop 20.f
#define kViewW (ScreenWidth - 2 * kMargin)

@interface TTMUpdatePayPasswordNextController ()

@property (nonatomic, weak)   TTMTextField *freshPasswordTextField;
@property (nonatomic, weak)   TTMTextField *rePasswordTextField;
@property (nonatomic, weak)   TTMGreenButton *submitButton;

@end

@implementation TTMUpdatePayPasswordNextController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改支付密码";
    [self setupViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.freshPasswordTextField becomeFirstResponder];
}
/**
 *  加载输入框和按钮
 */
- (void)setupViews {
    
    TTMTextField *freshPasswordTextField = [[TTMTextField alloc] initWithTitle:@"新支付密码"];
    freshPasswordTextField.secureTextEntry = YES;
    [self.view addSubview:freshPasswordTextField];
    self.freshPasswordTextField = freshPasswordTextField;
    
    TTMTextField *rePasswordTextField = [[TTMTextField alloc] initWithTitle:@"确认密码"];
    rePasswordTextField.secureTextEntry = YES;
    [self.view addSubview:rePasswordTextField];
    self.rePasswordTextField = rePasswordTextField;
    
    TTMGreenButton *submitButton = [[TTMGreenButton alloc] init];
    [submitButton setTitle:@"确认" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    self.submitButton = submitButton;
    
    freshPasswordTextField.frame = CGRectMake(kMargin, kMarginTop + NavigationHeight, kViewW, 0);
    rePasswordTextField.frame = CGRectMake(kMargin, freshPasswordTextField.bottom + kMarginTop, kViewW, 0);
    submitButton.origin = CGPointMake(kMargin, rePasswordTextField.bottom + kMarginTop);
}
/**
 *  点击提交事件
 *
 *  @param button 按钮
 */
- (void)buttonAction:(UIButton *)button {
    NSString *pass = self.freshPasswordTextField.text;
    NSString *rePass = self.rePasswordTextField.text;
    if (![pass isEqualToString:rePass]) {
        [MBProgressHUD showToastWithText:@"两次输入的密码不相同"];
        return;
    }
    __weak __typeof(self) weakSelf = self;
    [TTMUser updatePayPasswordNew:pass Complete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showToastWithText:result];
            hud.completionBlock = ^(){
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            };
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
