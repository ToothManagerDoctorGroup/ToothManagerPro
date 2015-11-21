

#import "TTMWithdrawController.h"
#import "TTMTextField.h"
#import "UIBarButtonItem+TTMAddtion.h"
#import "TTMGreenButton.h"
#import "TTMClinicModel.h"
#import "TTMWithdrawRecordController.h"
#import "IQKeyboardManager.h"

@interface TTMWithdrawController ()

@property (nonatomic, weak)   TTMTextField *textField;

@end

@implementation TTMWithdrawController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    
    [self setupRightItem];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)setupRightItem {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"提现记录"
                                                                     normalImageName:@"member_bar_item_bg"
                                                                              action:@selector(buttonAction:)
                                                                              target:self];
}

- (void)setupViews {
    UILabel *bankTitleLabel = [UILabel new];
    bankTitleLabel.text = @"银行卡";
    bankTitleLabel.textColor = [UIColor darkGrayColor];
    bankTitleLabel.font = [UIFont systemFontOfSize:15];
    bankTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bankTitleLabel];
    
    UILabel *bankCardLabel = [UILabel new];
    bankCardLabel.text = self.bankModel.bank_card;
    bankCardLabel.textColor = [UIColor blackColor];
    bankCardLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:bankCardLabel];
    
    UILabel *moneyTitleLabel = [UILabel new];
    moneyTitleLabel.text = @"金额";
    moneyTitleLabel.textColor = [UIColor darkGrayColor];
    moneyTitleLabel.font = [UIFont systemFontOfSize:15];
    moneyTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:moneyTitleLabel];
    
    TTMTextField *textField = [[TTMTextField alloc] initWithTitle:@""];
    textField.placeholder = [NSString stringWithFormat:@"当前可用余额%@元", @(self.accountModel.paid)];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:textField];
    self.textField = textField;
    
    TTMGreenButton *nextButton = [TTMGreenButton new];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.tag = 1;
    [self.view addSubview:nextButton];
    
    
    CGFloat margin = 10.f;
    CGFloat titleW = 100.f;
    CGFloat titleH = 40.f;
    CGFloat contentW = ScreenWidth - titleW - margin;
    
    bankTitleLabel.frame = CGRectMake(0, NavigationHeight + margin, titleW, titleH);
    bankCardLabel.frame = CGRectMake(titleW, bankTitleLabel.top, contentW, titleH);
    moneyTitleLabel.frame = CGRectMake(0, bankTitleLabel.bottom + margin, titleW, titleH);
    textField.frame = CGRectMake(titleW, moneyTitleLabel.top, contentW, titleH);
    nextButton.origin = CGPointMake(margin, textField.bottom + margin);
}

- (void)buttonAction:(UIButton *)button {
    if (button.tag == 1) { // 点击下一步
        NSString *money = [self.textField.text trim];
        if (![money hasValue]) {
            [MBProgressHUD showToastWithText:@"请输入金额"];
            return;
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入支付密码"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        __weak __typeof(&*self) weakSelf = self;
        UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"确定"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                                                 UITextField *textField = alert.textFields.firstObject;
                                                                 [weakSelf withdrawWithPayPassword:textField.text];
        }];
        [alert addAction:cancelAction];
        [alert addAction:submitAction];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入支付密码";
            textField.secureTextEntry = YES;
        }];
        [self presentViewController:alert animated:YES completion:nil];
    } else { // 提现记录
        TTMWithdrawRecordController *recordVC = [TTMWithdrawRecordController new];
        [self.navigationController pushViewController:recordVC animated:YES];
    }
}

/**
 *  提现
 */
- (void)withdrawWithPayPassword:(NSString *)payPassword {
    NSString *money = [self.textField.text trim];

    __weak __typeof(&*self) weakSelf = self;
    MBProgressHUD *loading = [MBProgressHUD showLoading];
    
    [TTMClinicModel getCashWithMoney:money payPassword:payPassword complete:^(id result) {
        [loading hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            MBProgressHUD *hub = [MBProgressHUD showToastWithText:@"提现成功"];
            hub.completionBlock = ^(){
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
