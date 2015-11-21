//
//  PickerTextTableViewCell.m
//  CRM
//
//  Created by TimTiger on 5/20/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "PickerTextTableViewCell.h"
#import "TimFramework.h"
#import "CRMMacro.h"

@interface PickerTextTableViewCell () <TimPickerTextFieldDelegate,TimPickerTextFieldDataSource,UITextFieldDelegate>

@end

@implementation PickerTextTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _pickerText = [[TimPickerTextField alloc]initWithFrame:CGRectMake(TEXTFIELD_EDGE_LEFT, 0,TEXTFIELD_WIDTH, TEXTFIELD_HEIGHT)];
    [_pickerText setRightViewMode:UITextFieldViewModeWhileEditing];
    _pickerText.placeholder = @"未设置";
    _pickerText.backgroundColor = [UIColor whiteColor];
    _pickerText.actiondelegate = self;
    _pickerText.delegate = self;
    [self.contentView addSubview:_pickerText];
}

- (void)layoutSubviews {
     _pickerText.frame = CGRectMake(TEXTFIELD_EDGE_LEFT,(self.bounds.size.height-TEXTFIELD_HEIGHT)/2,TEXTFIELD_WIDTH, TEXTFIELD_HEIGHT);
}

#pragma mark - Get / Set Func 
- (void)setPickerDataSource:(NSArray *)pickerDataSource {
    _pickerText.pickerDataSource = pickerDataSource;
    if (_pickerDataSource != pickerDataSource) {
        _pickerDataSource = nil;
    }
    _pickerDataSource = pickerDataSource;
}

- (void)setMode:(TextFieldInputMode)mode {
    [_pickerText setMode:mode];
}

- (TextFieldInputMode)mode {
    return _pickerText.mode;
}

- (void)setDelegate:(id<TimPickerTextFieldDelegate>)delegate {
    [_pickerText setActiondelegate:delegate];
}

-(id<TimPickerTextFieldDelegate>)delegate {
    return [_pickerText actiondelegate];
}

#pragma mark - TimPickerTextField Delegate

- (void)pickerView:(TimPickerView *)pickerView finishSelectWithRow:(NSInteger)row inComponent:(NSInteger)component {
    _pickerText.text = [self.pickerDataSource objectAtIndex:row];
}

- (void)pickerView:(TimPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _pickerText.text = [self.pickerDataSource objectAtIndex:row];
}

#pragma mark - UItextfield Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.responderdelegate && [self.responderdelegate respondsToSelector:@selector(didBecomeFirstResponder:)]) {
        [self.responderdelegate didBecomeFirstResponder:self];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

@end
