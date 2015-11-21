//
//  PickerTextTableViewCell.h
//  CRM
//
//  Created by TimTiger on 5/20/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimFramework.h"

@interface PickerTextTableViewCell : UITableViewCell
//设置cell上的输入框输入模式
@property (nonatomic,readwrite) TextFieldInputMode mode;
@property (nonatomic,assign) id <FirstResponderDelegate> responderdelegate;

#pragma mark - Picker
//数组里只能放NSString类型
@property (nonatomic,retain) NSArray *pickerDataSource;

#pragma mark - CustomPicker input
@property (nonatomic,assign) id <TimPickerTextFieldDataSource> dataSource;
@property (nonatomic,assign) id <TimPickerTextFieldDelegate> delegate;
@property (nonatomic,readonly) TimPickerTextField *pickerText;

#pragma mark - Date Picker


@end
