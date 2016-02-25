//
//  XLCommonEditViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/2/16.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLCommonEditViewController.h"
#import "UIColor+Extension.h"
#import "AddressChoicePickerView.h"

@interface XLCommonEditViewController ()<UITextFieldDelegate>{
    UIView *_editSuperView;
    UITextField *_editField;
    UIButton *_editBtn;
}

@end

@implementation XLCommonEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏样式
    [self setUpNav];
    
    //设置子视图
    [self setUpSubViews];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [_editField becomeFirstResponder];
}

#pragma mark - 设置导航栏样式
- (void)setUpNav{
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
//    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_complet"]];
    if (self.rightButtonTitle) {
        [self setRightBarButtonWithTitle:self.rightButtonTitle];
    }else{
        [self setRightBarButtonWithTitle:@"保存"];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
}


#pragma mark - 设置子视图
- (void)setUpSubViews{
    _editSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    _editSuperView.layer.borderColor = [UIColor colorWithHex:0xcccccc].CGColor;
    _editSuperView.backgroundColor = [UIColor whiteColor];
    _editSuperView.layer.borderWidth = 0.5;
    [self.view addSubview:_editSuperView];
    
    _editField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, _editSuperView.width - 20, 44)];
    _editField.textColor = [UIColor colorWithHex:0x333333];
    _editField.font = [UIFont systemFontOfSize:15];
    _editField.placeholder = self.placeHolder;
    _editField.text = self.content;
    _editField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _editField.returnKeyType = UIReturnKeyDone;
    _editField.delegate = self;
    _editField.keyboardType = self.keyboardType;
    [_editSuperView addSubview:_editField];
    
    if (self.showBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.frame = CGRectMake(kScreenWidth - 100 - 10, 64, 100, 40);
        [_editBtn setTitle:@"选择所在地区" forState:UIControlStateNormal];
        [_editBtn setTitleColor:[UIColor colorWithHex:0x00a0ea] forState:UIControlStateNormal];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_editBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_editBtn];
    }
}

#pragma mark - 完成按钮点击事件
- (void)onRightButtonAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(commonEditViewController:content:title:)]) {
        [self.delegate commonEditViewController:self content:_editField.text title:self.title];
    }
    [self popViewControllerAnimated:YES];
}

#pragma mark - 按钮点击事件
- (void)editBtnAction{
    if ([_editField isFirstResponder]) {
        [_editField resignFirstResponder];
    }
    AddressChoicePickerView *addressPickerView = [[AddressChoicePickerView alloc] init];
    addressPickerView.block = ^(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate){
        _editField.text = [NSString stringWithFormat:@"%@",locate];
    };
    [addressPickerView show];
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    if ([_editField isFirstResponder]) {
        [_editField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
