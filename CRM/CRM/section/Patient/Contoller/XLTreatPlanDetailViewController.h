//
//  XLTreatPlanDetailViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/3/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"
/**
 *  治疗方案详情
 */
@class XLCureProjectModel;
@interface XLTreatPlanDetailViewController : TimTableViewController

@property (nonatomic, strong)XLCureProjectModel *model;

@end
