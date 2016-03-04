//
//  XLMedicalButtonScrollView.h
//  CRM
//
//  Created by Argo Zhang on 16/3/1.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  病历切换按钮
 */
@class XLMedicalButtonScrollView;
@protocol XLMedicalButtonScrollViewDelegate <NSObject>

@optional
- (void)medicalButtonScrollView:(XLMedicalButtonScrollView *)scrollView didSelectButtonWithIndex:(NSUInteger)index;

@end

@interface XLMedicalButtonScrollView : UIScrollView

@property (nonatomic, strong)NSArray *medicalCases;

@property (nonatomic, weak)id<XLMedicalButtonScrollViewDelegate> medicalDelegate;

@end
