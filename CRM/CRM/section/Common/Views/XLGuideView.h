//
//  XLGuideView.h
//  CRM
//
//  Created by Argo Zhang on 16/1/18.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XLGuideViewStep)
{
    //引导步骤
    XLGuideViewStepOne = 0,
    XLGuideViewStepTwo = 1,
    XLGuideViewStepThree = 2,
    XLGuideViewStepFour = 3
};

typedef NS_ENUM(NSInteger, XLGuideViewType)
{
    //引导图类型
    XLGuideViewTypePatient = 0,//创建患者的引导图
    
};

@class XLGuideView;
@protocol XLGuideViewDelegate <NSObject>

@optional
- (void)guideView:(XLGuideView *)guideView didClickView:(UIView *)view step:(XLGuideViewStep)step;

@end

@interface XLGuideView : UIView

- (void)showInView:(UIView *)view maskViewFrame:(CGRect)maskViewFrame;
- (void)dismiss;

@property (nonatomic, weak)id<XLGuideViewDelegate> delegate;

@property (nonatomic, assign)XLGuideViewStep step;
@property (nonatomic, assign)XLGuideViewType type;

@end
