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
//    self.materialName.mode = TextFieldInputModeExternal;
//    self.materialName.borderStyle = UITextBorderStyleNone;
//    self.materialName.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.materialName addGestureRecognizer:tap];
    
//    self.materialNum.keyboardType = UIKeyboardTypeNumberPad;
//    self.materialNum.borderStyle = UITextBorderStyleNone;
//    self.materialNum.backgroundColor = [UIColor redColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
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
- (IBAction)deleteAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDeleteCell:)]) {
        [self.delegate didDeleteCell:self];
    }
}


- (NSString *)materialCount{
    return self.materialNum.text;
}

@end
