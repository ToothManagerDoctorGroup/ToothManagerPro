//
//  TimPickerView.h
//  CRM
//
//  Created by TimTiger on 5/17/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TimToolBar;

@protocol TimPickerViewDelegate <NSObject>

@optional
//按取消按钮的回调
- (void)pickerViewCancel:(UIPickerView *)pickerView;
//按完成按钮的回调
- (void)pickerView:(UIPickerView *)pickerView finishSelectWithRow:(NSInteger)row inComponent:(NSInteger)component;

@end

@interface TimPickerView : UIPickerView

@property (nonatomic,assign) id <TimPickerViewDelegate> timdelegate;

@property (nonatomic,retain) TimToolBar *toolBar;
@property (nonatomic,retain) UIColor *barColor;


@end
