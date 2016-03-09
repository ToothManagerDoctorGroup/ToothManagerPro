//
//  XLTreatPlanViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/3/2.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"
/**
 *  治疗方案
 */
@class MedicalCase;
@interface XLTreatPlanViewController : TimTableViewController

@property (nonatomic, strong)MedicalCase *mCase;

@end
