//
//  RBCustomDatePickerView.h
//  RBCustomDateTimePicker
//  e-mail:rbyyy924805@163.com
//  Created by renbing on 3/17/14.
//  Copyright (c) 2014 renbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSCycleScrollView.h"

@class RBCustomDatePickerView;
@protocol RBCustomDatePickerViewDelete <NSObject>

@optional
- (void)custonDatePickerView:(RBCustomDatePickerView *)pickerView didSelectDateStr:(NSString *)dateStr;

@end
@interface RBCustomDatePickerView : UIView <MXSCycleScrollViewDatasource,MXSCycleScrollViewDelegate>

@property (nonatomic, weak)id<RBCustomDatePickerViewDelete> delegate;
@property (nonatomic, copy)NSString *currentDateStr;

- (void)show;
- (void)dismiss;
@end
