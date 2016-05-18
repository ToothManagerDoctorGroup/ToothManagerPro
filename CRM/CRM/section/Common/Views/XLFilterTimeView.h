//
//  XLFilterTimeView.h
//  CRM
//
//  Created by Argo Zhang on 16/4/6.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,FilterTimeState){
    FilterTimeStateDay,
    FilterTimeStateWeek,
    FilterTimeStateMonth,
    FilterTimeStateCustom,
    FilterTimeStateUnSelect
};

@class XLFilterTimeView,TimPickerTextField;
@protocol XLFilterTimeViewDelegate <NSObject>

@optional
- (void)filterTimeView:(XLFilterTimeView *)timeVc startTime:(NSString *)startTime endTime:(NSString *)endTime;
- (void)filterTimeView:(XLFilterTimeView *)timeVc timeState:(FilterTimeState)timeState;

@end

@interface XLFilterTimeView : UIView

@property (nonatomic, strong)TimPickerTextField *startTimeField;
@property (nonatomic, strong)TimPickerTextField *endTimeField;

@property (nonatomic, weak)id<XLFilterTimeViewDelegate> delegate;

@property (nonatomic, assign)BOOL isCustomTime;//是否选择自定义时间

- (instancetype)initWithSourceArray:(NSArray *)sourceArray;

- (CGFloat)fixHeight;

- (void)reset;
@end
