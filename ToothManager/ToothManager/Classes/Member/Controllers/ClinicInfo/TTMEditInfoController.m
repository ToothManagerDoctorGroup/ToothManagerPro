

#import "TTMEditInfoController.h"
#import "TTMTextField.h"

@interface TTMEditInfoController ()

@property (nonatomic, weak) TTMTextField *textField;
@end

@implementation TTMEditInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupViews];
}

- (void)setupViews {
    TTMTextField *textField = [TTMTextField textFieldWithTitle:self.title];
    textField.frame = CGRectMake(0, 0, ScreenWidth, 0);
    [self.view addSubview:textField];
    self.textField = textField;
    [textField becomeFirstResponder];
    if ([self.title isEqualToString:@"诊所名称"]) {
        textField.text = self.model.clinic_name;
    } else if ([self.title isEqualToString:@"诊所简介"]) {
        textField.text = self.model.clinic_summary;
    } else if ([self.title isEqualToString:@"营业时间"]) {
        textField.text = self.model.business_hours;
    } else if ([self.title isEqualToString:@"客服电话"]) {
        textField.text = self.model.clinic_phone;
    }
    
    [self setupRightItem];
}

- (void)setupRightItem {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"保存"
                                                                     normalImageName:@"member_bar_item_bg"
                                                                              action:@selector(buttonAction:)
                                                                              target:self];
}


/**
 *  点击保存
 *
 */
- (void)buttonAction:(UIButton *)button {
    NSString *stringValue = [self.textField.text trim];
    
    if (![stringValue hasValue]) {
        [MBProgressHUD showToastWithText:@"请输入内容"];
        return;
    }
    TTMClinicModel *model = self.model;
    if ([self.title isEqualToString:@"诊所名称"]) {
        model.clinic_name = stringValue;
    } else if ([self.title isEqualToString:@"诊所简介"]) {
        model.clinic_summary = stringValue;
    } else if ([self.title isEqualToString:@"营业时间"]) {
        model.business_hours = stringValue;
    } else if ([self.title isEqualToString:@"客服电话"]) {
        model.clinic_phone = stringValue;
    }
    
    
    MBProgressHUD *loading = [MBProgressHUD showLoading];
    __weak __typeof(&*self) weakSelf = self;
    [TTMClinicModel updateWithClinic:model complete:^(id result) {
        [loading hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {

}

@end
