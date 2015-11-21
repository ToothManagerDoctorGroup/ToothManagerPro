

#import "TTMAddBankCardController.h"
#import "TTMTextField.h"
#import "TTMGreenButton.h"
#import "TTMBankModel.h"


@interface TTMAddBankCardController ()

@property (nonatomic, weak)   TTMTextField *userNameTextField; // 持卡人
@property (nonatomic, weak)   TTMTextField *cardTextField; // 卡号
@property (nonatomic, weak)   TTMTextField *bankTextField; // 开户行
@property (nonatomic, weak)   TTMTextField *subBankTextField; // 开户支行

@end

@implementation TTMAddBankCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    if (self.type == TTMAddBankCardControllerTypeAdd) {
        self.title = @"添加银行卡";
    } else {
        self.title = @"修改银行卡";
        // 修改时，设置参数
        [self queryBankData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.userNameTextField becomeFirstResponder];
}

- (void)setup {
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    
    TTMTextField *userNameTextField = [TTMTextField textFieldWithTitle:@"持卡人"];
    [scrollView addSubview:userNameTextField];
    self.userNameTextField = userNameTextField;
    
    TTMTextField *cardTextField = [TTMTextField textFieldWithTitle:@"卡号"];
    cardTextField.keyboardType = UIKeyboardTypeNumberPad;
    [scrollView addSubview:cardTextField];
    self.cardTextField = cardTextField;
    
    TTMTextField *bankTextField = [TTMTextField textFieldWithTitle:@"开户行"];
    [scrollView addSubview:bankTextField];
    self.bankTextField = bankTextField;
    
    TTMTextField *subBankTextField = [TTMTextField textFieldWithTitle:@"开户支行"];
    [scrollView addSubview:subBankTextField];
    self.subBankTextField = subBankTextField;
    
    TTMGreenButton *addButton = [TTMGreenButton new];
    [addButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:addButton];
    
    if (self.type == TTMAddBankCardControllerTypeAdd) {
        [addButton setTitle:@"添加" forState:UIControlStateNormal];
    } else {
        [addButton setTitle:@"修改" forState:UIControlStateNormal];
    }
    
    CGFloat margin = 10.f;
    CGFloat width = ScreenWidth - 2 * margin;
    
    scrollView.frame = self.view.bounds;
    userNameTextField.frame = CGRectMake(margin, margin, width, 0);
    cardTextField.frame = CGRectMake(margin, userNameTextField.bottom + margin, width, 0);
    bankTextField.frame = CGRectMake(margin, cardTextField.bottom + margin, width, 0);
    subBankTextField.frame = CGRectMake(margin, bankTextField.bottom + margin, width, 0);
    addButton.origin = CGPointMake(margin, subBankTextField.bottom + margin);
    
}

/**
 *  查询银行卡信息
 */
- (void)queryBankData {
    __weak __typeof(&*self) weakSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showLoading];
    [TTMClinicModel queryClinicBankWithComplete:^(id result) {
        [hud hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.bankModel = result;
            [weakSelf updateViewData];
        }
    }];
    
}

- (void)updateViewData {
    self.userNameTextField.text = self.bankModel.cardholder;
    self.cardTextField.text = self.bankModel.bank_card;
    self.bankTextField.text = self.bankModel.bank_name;
    self.subBankTextField.text = self.bankModel.subbranch_name;
}

- (void)buttonAction:(UIButton *)button {
    NSString *userName = self.userNameTextField.text;
    NSString *card = self.cardTextField.text;
    NSString *bank = self.bankTextField.text;
    NSString *subBank = self.subBankTextField.text;
    
    if (![userName hasValue] ||
        ![card hasValue] ||
        ![bank hasValue] ||
        ![subBank hasValue]) {
        [MBProgressHUD showToastWithText:@"所有字段都要填写"];
        return;
    }
    TTMBankModel *model = [TTMBankModel new];
    model.keyId = self.bankModel.keyId;
    model.cardholder = userName;
    model.bank_card = card;
    model.bank_name = bank;
    model.subbranch_name = subBank;
    
    __weak __typeof(&*self) weakSelf = self;
    if (self.type == TTMAddBankCardControllerTypeAdd) {
        MBProgressHUD *loading = [MBProgressHUD showLoading];
        [TTMBankModel addBankWithModel:model complete:^(id result) {
            [loading hide:YES];
            if ([result isKindOfClass:[NSString class]]) {
                [MBProgressHUD showToastWithText:result];
            } else {
                MBProgressHUD *hub = [MBProgressHUD showToastWithText:@"添加成功"];
                hub.completionBlock = ^(){
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                };
            }
        }];
    } else if (self.type == TTMAddBankCardControllerTypeUpdate) {
        MBProgressHUD *loading = [MBProgressHUD showLoading];
        [TTMBankModel updateBankWithModel:model complete:^(id result) {
            [loading hide:YES];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
