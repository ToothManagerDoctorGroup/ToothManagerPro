//
//  XLTimeView.h
//  CRM
//
//  Created by Argo Zhang on 16/1/20.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLTimeViewDelegate <NSObject>

@optional
- (void)didClickJumpButton;

@end
/**
 *  倒计时按钮
 */
@interface XLTimeView : UIView

@property (nonatomic, weak)id<XLTimeViewDelegate> delegate;

- (void)start;
@end

