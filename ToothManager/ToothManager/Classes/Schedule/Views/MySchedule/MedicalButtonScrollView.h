//
//  MedicalButtonScrollView.h
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  病历详情页面病历按钮滚动视图
 */
@class MedicalButtonScrollView;
@protocol MedicalButtonScrollViewDelegate <NSObject>

@optional
- (void)medicalButtonScrollView:(MedicalButtonScrollView *)scrollView didSelectButtonWithIndex:(NSUInteger)index;

@end

@interface MedicalButtonScrollView : UIScrollView

@property (nonatomic, strong)NSArray *medicalCases;

@property (nonatomic, weak)id<MedicalButtonScrollViewDelegate> medicalDelegate;

@end
