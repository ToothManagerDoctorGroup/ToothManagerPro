//
//  XLFilterView.h
//  CRM
//
//  Created by Argo Zhang on 16/4/6.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBTableMode.h"

@class XLFilterView;
@protocol XLFilterViewDelegate <NSObject>

@optional
- (void)filterView:(XLFilterView *)filterView patientStatus:(PatientStatus)status startTime:(NSString *)startTime endTime:(NSString *)endTime cureDoctors:(NSArray *)cureDoctors;
- (void)dismiss;

@end

@interface XLFilterView : UIView

@property (nonatomic, weak)id<XLFilterViewDelegate> delegate;

- (CGFloat)fixHeight;

- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;

@end
