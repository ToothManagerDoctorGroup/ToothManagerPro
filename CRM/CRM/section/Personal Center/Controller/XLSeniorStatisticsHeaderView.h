//
//  XLSeniorStatisticsHeaderView.h
//  CRM
//
//  Created by Argo Zhang on 16/1/22.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  高级统计头视图
 */
@class XLSeniorStatisticsHeaderView,Doctor;
@protocol XLSeniorStatisticsHeaderViewDelegate <NSObject>

@optional
- (void)seniorStatisticsHeaderView:(XLSeniorStatisticsHeaderView *)headerView didSearchWithStartTime:(NSString *)startTime endTime:(NSString *)endTime repairDoctor:(Doctor *)repairDoctor;

@end

@interface XLSeniorStatisticsHeaderView : UIView
//@property (weak, nonatomic) IBOutlet UITextField *startTimeField;
//@property (weak, nonatomic) IBOutlet UITextField *endTimeField;
//@property (weak, nonatomic) IBOutlet UILabel *repairDoctorLabel;
//@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (nonatomic, copy)NSString *type;

@property (nonatomic, weak)id<XLSeniorStatisticsHeaderViewDelegate> delegate;

@end
