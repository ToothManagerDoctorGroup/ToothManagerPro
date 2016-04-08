//
//  XLFilterDoctorListView.h
//  CRM
//
//  Created by Argo Zhang on 16/4/6.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLFilterDoctorListView : UIView

@property (nonatomic, strong)NSArray *sourceArray;

- (CGFloat)fixHeigthWithWidth:(CGFloat)width;

@end
