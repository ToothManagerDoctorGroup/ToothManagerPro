//
//  PatientDetailHeadInfoView.h
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBTableMode.h"
/**
 *  患者详情页头视图上的详情数据
 */
@protocol  PatientDetailHeadInfoViewDelegate <NSObject>

@optional
- (void)didSelectIntroducer;

@end

@interface PatientDetailHeadInfoView : UIView


@property (nonatomic,retain)Patient *detailPatient;
@property (nonatomic, copy)NSString *introducerName;
@property (nonatomic, assign)BOOL introduceCanEdit;//判断介绍人是否可以进行修改
@property (nonatomic, copy)NSString *transferStr;

@property (nonatomic, weak)id<PatientDetailHeadInfoViewDelegate> delegate;

@property (nonatomic, assign)BOOL isWeixin;

- (CGFloat)getTotalHeight;

@end
