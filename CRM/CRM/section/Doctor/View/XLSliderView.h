//
//  XLSliderView.h
//  CRM
//
//  Created by Argo Zhang on 16/1/26.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLSliderView;
@protocol XLSliderViewDelegate <NSObject>

@optional
- (void)sliderView:(XLSliderView *)sliderView didClickBtnFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface XLSliderView : UIView

@property (nonatomic, strong)NSArray *sourceList;
@property (nonatomic, assign)NSInteger selectIndex;

@property (nonatomic, weak)id<XLSliderViewDelegate> delegate;

@end
