//
//  CaseMaterialsTableViewCell.m
//  CRM
//
//  Created by TimTiger on 2/3/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "CaseMaterialsTableViewCell.h"
#import "TimPickerTextField.h"
#import "DBTableMode.h"

@interface CaseMaterialsTableViewCell () <TimPickerTextFieldDelegate,UITextFieldDelegate>

@end

@implementation CaseMaterialsTableViewCell

- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setCell:(NSArray *)array {
    // Initialization code
//    self.materialName.mode = TextFieldInputModeExternal;
//    self.materialName.borderStyle = UITextBorderStyleNone;
//    self.materialName.delegate = self;
    
    //添加通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangedAction:) name:UITextFieldTextDidChangeNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.materialName addGestureRecognizer:tap];
    
    self.materialNum.keyboardType = UIKeyboardTypeNumberPad;
    self.materialNum.borderStyle = UITextBorderStyleNone;
    self.materialNum.actiondelegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self.delegate didBeginEdit:self];
}

//完成按钮点击的回调
- (void)pickerViewFinish:(UIPickerView *)pickerView {
    [self.delegate tableViewCell:self materialNum:[self.materialNum.text integerValue]];
}

//取消按钮点击的回调
- (void)pickerViewCancel:(UIPickerView *)pickerView{
    [self.delegate tableViewCell:self materialNum:[self.materialNum.text integerValue]];
}

//完成按钮点击回调
- (void)pickerView:(UIPickerView *)pickerView finishSelectWithRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.delegate tableViewCell:self materialNum:[self.materialNum.text integerValue]];
}

@end
