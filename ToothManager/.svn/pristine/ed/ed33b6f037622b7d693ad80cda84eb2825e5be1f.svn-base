//
//  TTMUpdateChairController.m
//  ToothManager
//
//  Created by roger wu on 15/11/11.
//  Copyright © 2015年 roger. All rights reserved.
//

#import "TTMUpdateChairController.h"
#import "TTMTextField.h"

@interface TTMUpdateChairController ()

@property (nonatomic, weak) TTMTextField *textField;
@end

@implementation TTMUpdateChairController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改椅位费";
    [self setupViews];
}

- (void)setupViews {
    TTMTextField *textField = [TTMTextField textFieldWithTitle:@"椅位费"];
    textField.frame = CGRectMake(0, NavigationHeight + 20.f, ScreenWidth, 0);
    [self.view addSubview:textField];
    self.textField = textField;
    [textField becomeFirstResponder];
    textField.text = self.chairMoney;
    
    [self setupRightItem];
}

- (void)setupRightItem {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"确定"
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
    
    if ([self.delegate respondsToSelector:@selector(updateChairController:chariMoney:)]) {
        [self.delegate updateChairController:self chariMoney:stringValue];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
