//
//  ClinicCover.h
//  CRM
//
//  Created by Argo Zhang on 15/11/14.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClinicCover;
@protocol ClinicCoverDelegate <NSObject>

@optional
- (void)coverDidClickCover:(ClinicCover *)cover;

@end

@interface ClinicCover : UIView

//显示蒙板
+ (instancetype)show;

- (void)dismiss;

//设置是否显示透明蒙板或者是浅灰色蒙板
@property (nonatomic, assign)BOOL dimBackground;

//代理属性
@property (nonatomic, weak)id<ClinicCoverDelegate> delegate;

@end
