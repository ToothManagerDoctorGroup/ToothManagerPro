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
#import "NSString+TTMAddtion.h"

@interface XLCommonEditViewController ()<UITextFieldDelegate>{
    UIView *_editSuperView;
    UITextField *_editField;
    UIButton *_editBtn;
    UITextField *_addressField;//地址选择
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
    
    CGFloat fieldH = 44;
    CGFloat margin = 10;
    
    _editSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, margin * 2, kScreenWidth, fieldH)];
    _editSuperView.layer.borderColor = [UIColor colorWithHex:0xcccccc].CGColor;
    _editSuperView.backgroundColor = [UIColor whiteColor];
    _editSuperView.layer.borderWidth = 0.5;
    [self.view addSubview:_editSuperView];
    
    _editField = [[UITextField alloc] initWithFrame:CGRectMake(margin, 0, _editSuperView.width - margin * 2, fieldH)];
    _editField.textColor = [UIColor colorWithHex:0x333333];
    _editField.font = [UIFont systemFontOfSize:15];
    _editField.placeholder = self.placeHolder;
    _editField.text = self.content;
    _editField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _editField.returnKeyType = UIReturnKeyDone;
    _editField.delegate = self;
    _editField.keyboardType = self.keyboardType;
    _editField.tag = 100;
    [_editSuperView addSubview:_editField];
    
    if (self.showBtn) {
        UIView *addressSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, margin * 2, kScreenWidth, fieldH)];
        addressSuperView.layer.borderColor = [UIColor colorWithHex:0xcccccc].CGColor;
        addressSuperView.backgroundColor = [UIColor whiteColor];
        addressSuperView.layer.borderWidth = 0.5;
        [self.view addSubview:addressSuperView];
        
        _addressField = [[UITextField alloc] initWithFrame:CGRectMake(margin, 0, _editSuperView.width - margin * 2, fieldH)];
        _addressField.textColor = [UIColor colorWithHex:0x333333];
        _addressField.font = [UIFont systemFontOfSize:15];
        _addressField.placeholder = @"请选择地址";
        _addressField.delegate = self;
        _addressField.clearButtonMode = UITextFieldViewModeAlways;
        _addressField.tag = 200;
        [addressSuperView addSubview:_addressField];
        
        _editSuperView.frame = CGRectMake(0, addressSuperView.bottom + margin * 2, kScreenWidth, fieldH);
        _editField.frame = CGRectMake(margin, 0, _editSuperView.width - margin * 2, fieldH);
        
        //判断地址格式
        if ([self.content isNotEmpty]) {
            if ([self.content isContainsString:@"-"]) {
                _addressField.text = [self.content componentsSeparatedByString:@"-"][0];
                _editField.text = [self.content componentsSeparatedByString:@"-"][1];
            }else{
                _editField.text = self.content;
            }
        }
    }
}

#pragma mark - 完成按钮点击事件
- (void)onRightButtonAction:(id)sender{
    
    NSString *title;
    if (self.showBtn) {
        if ([_editField.text isNotEmpty]) {
            title = [NSString stringWithFormat:@"%@-%@",_addressField.text,_editField.text];
        }else{
            title = [NSString stringWithFormat:@"%@",_addressField.text];
        }
        
    }else{
        title = _editField.text;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(commonEditViewController:content:title:)]) {
        [self.delegate commonEditViewController:self content:title title:self.title];
    }
    [self popViewControllerAnimated:YES];
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 200) {
        [_editField resignFirstResponder];
        
        AddressChoicePickerView *addressPickerView = [[AddressChoicePickerView alloc] init];
        addressPickerView.block = ^(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate){
            _addressField.text = [NSString stringWithFormat:@"%@",locate];
        };
        [addressPickerView show];
        
        return NO;
    }else{
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
