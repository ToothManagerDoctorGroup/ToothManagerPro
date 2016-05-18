//
//  XLFilterDoctorListView.h
//  CRM
//
//  Created by Argo Zhang on 16/4/6.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLFilterDoctorListView;
@protocol XLFilterDoctorListViewDelegate <NSObject>

@optional
- (void)filterDoctorListView:(XLFilterDoctorListView *)listView didChooseDoctors:(NSArray *)doctors;

@end

@interface XLFilterDoctorListView : UIView

@property (nonatomic, strong)NSMutableArray *sourceArray;

- (CGFloat)fixHeigthWithWidth:(CGFloat)width;

@property (nonatomic, weak)id<XLFilterDoctorListViewDelegate> delegate;

@end
