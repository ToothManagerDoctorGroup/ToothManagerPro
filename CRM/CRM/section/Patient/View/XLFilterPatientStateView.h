//
//  XLFilterPatientStateView.h
//  CRM
//
//  Created by Argo Zhang on 16/4/1.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  根据患者状态进行筛选
 */
@class XLFilterPatientStateView;
@protocol XLFilterPatientStateViewDelegate <NSObject>

@optional
- (void)filterPatientStateView:(XLFilterPatientStateView *)stateView didSelectItem:(NSInteger)index;

@end
@interface XLFilterPatientStateView : UIView

@property (nonatomic, weak)id<XLFilterPatientStateViewDelegate> delegate;

@end
