//
//  TimPickerTextField.h
//  CRM
//
//  Created by TimTiger on 5/20/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

// NSString *const UIKeyboardHideNotification;

typedef NS_ENUM(NSInteger, TextFieldInputMode) {
    TextFieldInputModeKeyBoard = 1,     //键盘输入模式，普通的textfield
    TextFieldInputModePicker = 2,      //固定一列的选择器模式
    TextFieldInputModeCustomPicker = 3,  //自定义的选择器模式
    TextFieldInputModeDatePicker = 4,   //日期选择器模式
    TextFieldInputModeTable = 5,        //下拉列表模式
    TextFieldInputModeExternal = 6,     //跳转到其它界面选择
};
//如果是时间选择器，设置时间的获取格式
typedef NS_ENUM(NSInteger, TextFieldDateMode) {
    TextFieldDateModeTime = 1, //只显示时间
    TextFieldDateModeDate = 2, //只显示日期
    TextFieldDateModeDateAndTime = 3, //显示时间和日期
    TextFieldDateModeCountDownTimer = 4 //显示毫秒
};

@protocol  TimPickerTextFieldDelegate,TimPickerTextFieldDataSource;

@interface TimPickerTextField : UITextField
//通过设置mode来使用不同的输入源，默认为键盘输入
@property (nonatomic,readwrite) TextFieldInputMode mode;
//设置日期选择器的时间格式
@property (nonatomic,readwrite) TextFieldDateMode dateMode;

@property (nonatomic, assign)BOOL isBirthDay; //是否是选择生日

#pragma mark - Picker
//普通选择器作为输入源，只能用于一列的情况。
//数据源，只能是NSString类型
@property (nonatomic,retain) NSArray *pickerDataSource;

#pragma mark CustomPicker
//自定义选择器作为输入源，遵守datasource 和 delegate两个协议 定制选择器界面和数据。
@property (nonatomic,assign) id <TimPickerTextFieldDataSource> dataSource;
@property (nonatomic,assign) id <TimPickerTextFieldDelegate> actiondelegate;

#pragma mark - DatePicker
//日期选择器作为输入源，专门用于选择日期

#pragma mark - Table
//下拉列表作为输入源，
@end

#pragma mark - Protocol
@protocol TimPickerTextFieldDataSource <NSObject>
@optional
//设置PickerView的rect
- (CGRect)boundsOfPickerView:(UIPickerView *)pickerView;
//设置段数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
//设置每段几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
//设置 段宽 和 行高
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
//设置每行的文字，或者显示特殊文字
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
//设置行视图
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;

@end

@protocol TimPickerTextFieldDelegate <NSObject>
@optional
//按取消按钮的回调
- (void)pickerViewCancel:(UIPickerView *)pickerView;
//按取消按钮的回调
- (void)pickerViewFinish:(UIPickerView *)pickerView;
//按完成按钮的回调
- (void)pickerView:(UIPickerView *)pickerView finishSelectWithRow:(NSInteger)row inComponent:(NSInteger)component;
//选中某行的回调
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end

