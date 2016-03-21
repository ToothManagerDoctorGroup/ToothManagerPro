//
//  XLPersonalStepTwoViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/12/22.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimDisplayViewController.h"
/**
 *  个人信息完善步骤2
 */
@class XLPersonalStepTwoViewController;
@protocol XLPersonalStepTwoViewControllerDelegate <NSObject>

@optional
- (void)personalStepTwoVC:(XLPersonalStepTwoViewController *)stepOneVc didWriteAge:(NSString *)age sex:(NSString *)sex degree:(NSString *)degree;

@end
@interface XLPersonalStepTwoViewController : TimDisplayViewController

@property (nonatomic, copy)NSString *userName;//姓名
@property (nonatomic, copy)NSString *hospitalName;//医院
@property (nonatomic, copy)NSString *departMentName;//科室
@property (nonatomic, copy)NSString *professionalName;//职称


@property (nonatomic, copy)NSString *age;//年龄
@property (nonatomic, copy)NSString *sex;//性别
@property (nonatomic, copy)NSString *degree;//学历

@property (nonatomic, assign)id<XLPersonalStepTwoViewControllerDelegate> delegate;

@end
