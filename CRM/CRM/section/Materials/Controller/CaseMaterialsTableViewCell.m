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

- (void)setCell:(NSArray *)array {
    // Initialization code
    self.materialName.mode = TextFieldInputModeExternal;
    self.materialName.borderStyle = UITextBorderStyleNone;
    self.materialName.delegate = self;
    self.materialNum.keyboardType = UIKeyboardTypeNumberPad;
    self.materialNum.borderStyle = UITextBorderStyleNone;
    self.materialNum.actiondelegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.materialName) {
        [self.delegate didBeginEdit:self];
    }
    [textField resignFirstResponder];
}

- (void)pickerViewFinish:(UIPickerView *)pickerView {
    [self.delegate tableViewCell:self materialNum:[self.materialNum.text integerValue]];
}

- (void)pickerView:(UIPickerView *)pickerView finishSelectWithRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.delegate tableViewCell:self materialNum:[self.materialNum.text integerValue]];
}

@end
