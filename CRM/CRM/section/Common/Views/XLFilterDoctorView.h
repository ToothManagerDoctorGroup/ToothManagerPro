//
//  XLFilterDoctorView.h
//  CRM
//
//  Created by Argo Zhang on 16/4/6.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLFilterDoctorView;
@protocol XLFilterDoctorViewDelegate <NSObject>

@optional
- (void)filterDoctorView:(XLFilterDoctorView *)doctorView didSelectDoctors:(NSArray *)doctors;

@end

@interface XLFilterDoctorView : UIView

@property (nonatomic, weak)id<XLFilterDoctorViewDelegate> delegate;

- (CGFloat)fixHeight;

//重置
- (void)reset;
@end
