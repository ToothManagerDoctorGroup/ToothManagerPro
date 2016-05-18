//
//  XLSeniorStatisticsViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/1/22.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimDisplayViewController.h"
/**
 *  高级统计
 */
typedef NS_ENUM(NSInteger, SeniorStatisticsViewControllerType) {
    SeniorStatisticsViewControllerPlant,// 种植统计
    SeniorStatisticsViewControllerRepair//修复统计
};

@interface XLSeniorStatisticsViewController : TimDisplayViewController

@property (nonatomic, assign)SeniorStatisticsViewControllerType type;

@end
