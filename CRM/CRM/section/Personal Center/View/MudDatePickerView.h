//
//  MudDatePickerView.h
//  CRM
//
//  Created by doctor on 15/4/28.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MudDatePickerViewDelegate <NSObject>
@optional

- (void)certainButtonOnClickedWithDateString:(NSString *)dateString;//确定按钮

- (void)cancelButtonOnClicked;//取消按钮

@end

@interface MudDatePickerView : UIView
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (weak, nonatomic) id <MudDatePickerViewDelegate> delegate;
@property (strong, nonatomic) NSDate *date;
@end
