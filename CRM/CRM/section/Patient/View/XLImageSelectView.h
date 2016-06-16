//
//  XLImageSelectView.h
//  CRM
//
//  Created by Argo Zhang on 16/3/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLImageSelectView;
@protocol XLImageSelectViewDelegate <NSObject>

@optional
- (void)imageSelectView:(XLImageSelectView *)selectView didChooseImages:(NSArray *)images;

@end
@interface XLImageSelectView : UIView

@property (nonatomic, weak)id<XLImageSelectViewDelegate> delegate;

@property (nonatomic, strong)NSArray *images;//已经选择的image数组


- (CGFloat)getTotalHeigth;
@end
