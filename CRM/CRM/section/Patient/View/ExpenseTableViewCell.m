//
//  ExpenseTableViewCell.m
//  CRM
//
//  Created by TimTiger on 5/24/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "ExpenseTableViewCell.h"
#import "TimFramework.h"
#import "DBTableMode.h"

@interface ExpenseTableViewCell() <UITextFieldDelegate>

@end

@implementation ExpenseTableViewCell
@synthesize nameTextField,countTextField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    nameTextField.frame =CGRectMake(60,(self.bounds.size.height-30)/2, 98, 30);
    countTextField.frame =CGRectMake(162,(self.bounds.size.height-30)/2, 98, 30);
}

- (void)setupView {
    nameTextField = [[TimPickerTextField alloc]initWithFrame:CGRectMake(60, 0, 98, 30)];
    nameTextField.placeholder = @"耗材名称";
    [nameTextField setBackgroundColor:[UIColor whiteColor]];
    nameTextField.delegate = self;
    [self.contentView addSubview:nameTextField];
    
    countTextField = [[TimPickerTextField alloc]initWithFrame:CGRectMake(162, 0, 98, 30)];
    countTextField.placeholder = @"耗材数量";
    [countTextField setBackgroundColor:[UIColor whiteColor]];
    countTextField.delegate = self;
    countTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:countTextField];
}

#pragma mark - UItextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == nameTextField) {
        if (self.pushdelegate && [self.pushdelegate respondsToSelector:@selector(didBeginEdit:)]) {
            [self.pushdelegate didBeginEdit:self];
        }
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(didBecomeFirstResponder:)]) {
        [self.delegate didBecomeFirstResponder:self];
    }
    return YES;
}

@end
