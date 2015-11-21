//
//  TTMUpdatePayPasswordController.m
//  ToothManager
//

#import "TTMUpdatePayPasswordController.h"
#import "TTMGreenButton.h"
#import "TTMTextField.h"
#import "TTMUpdatePayPasswordNextController.h"

#define kMargin 10.f
#define kFontSize 14
#define kLabelH 30.f
#define kViewW (ScreenWidth - 2 * kMargin)
@interface TTMUpdatePayPasswordController ()
@property (nonatomic, weak)   TTMTextField *oldPasswordTextField;
@property (nonatomic, weak)   TTMGreenButton *nextButton;
@end

@implementation TTMUpdatePayPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改支付密码";
    
    [self setupViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.oldPasswordTextField becomeFirstResponder];
}
/**
 *  加载输入框和按钮
 */
- (void)setupViews {
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.text = @"输入旧密码验证身份";
    noticeLabel.textColor = [UIColor darkGrayColor];
    noticeLabel.font = [UIFont systemFontOfSize:kFontSize];
    [self.view addSubview:noticeLabel];
    
    TTMTextField *oldPasswordTextField = [[TTMTextField alloc] initWithTitle:@""];
    oldPasswordTextField.secureTextEntry = YES;
    [self.view addSubview:oldPasswordTextField];
    self.oldPasswordTextField = oldPasswordTextField;
    
    TTMGreenButton *nextButton = [[TTMGreenButton alloc] init];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    self.nextButton = nextButton;
    
    noticeLabel.frame = CGRectMake(kMargin, kMargin + NavigationHeight, kViewW, kLabelH);
    oldPasswordTextField.frame = CGRectMake(kMargin, noticeLabel.bottom + kMargin, kViewW, 0);
    nextButton.origin = CGPointMake(kMargin, oldPasswordTextField.bottom + 2 * kMargin);
}
/**
 *  点击下一步事件
 *
 *  @param button  按钮
 */
- (void)buttonAction:(UIButton *)button {
    if ([NSString isEmpty:self.oldPasswordTextField.text]) {
        [MBProgressHUD showToastWithText:@"请输入旧密码"];
        return;
    }
    __weak __typeof(self) weakSelf = self;
    [TTMUser updatePayPassword:self.oldPasswordTextField.text Complete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            TTMUpdatePayPasswordNextController *nextVC = [[TTMUpdatePayPasswordNextController alloc] init];
            [weakSelf.navigationController pushViewController:nextVC animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
