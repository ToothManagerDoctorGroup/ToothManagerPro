//
//  XLFilterDismissButton.h
//  CRM
//
//  Created by Argo Zhang on 16/4/7.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

@class XLFilterDismissButton;
@protocol XLFilterDismissButtonDelegate <NSObject>

@optional
- (void)filterDismissButton:(XLFilterDismissButton *)dismissButton animalViewTouchesMoved:(CGFloat)distance;
- (void)filterDismissButton:(XLFilterDismissButton *)dismissButton animalViewTouchesEnded:(CGFloat)distance;

@end

@interface XLFilterDismissButton : UIControl

@property (nonatomic, weak)id<XLFilterDismissButtonDelegate> delegate;

- (CGFloat)fixHeight;

@end
