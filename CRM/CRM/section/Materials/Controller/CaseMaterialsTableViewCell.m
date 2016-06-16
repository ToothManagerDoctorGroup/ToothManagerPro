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
#import "UIColor+Extension.h"

@interface CaseMaterialsTableViewCell () <TimPickerTextFieldDelegate,UITextFieldDelegate>

@end

@implementation CaseMaterialsTableViewCell

- (void)awakeFromNib{
    [self.materialNum addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setCell:(NSArray *)array {
    
    self.materialName.layer.cornerRadius = 5;
    self.materialName.layer.masksToBounds = YES;
    self.materialName.layer.borderWidth = 1;
    self.materialName.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
    
    self.materialNum.layer.cornerRadius = 5;
    self.materialNum.layer.masksToBounds = YES;
    self.materialNum.layer.borderWidth = 1;
    self.materialNum.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.materialName addGestureRecognizer:tap];

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

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField == self.materialNum) {
        if ([textField.text integerValue] > 100) {
            textField.text = @"100";
        }
    }
}

- (NSString *)materialCount{
    return self.materialNum.text;
}

@end
