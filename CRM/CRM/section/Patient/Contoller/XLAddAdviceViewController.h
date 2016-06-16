//
//  XLAddAdviceViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/4/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"
/**
 *  自定义医嘱
 */
@class XLAdviceDetailModel;
@interface XLAddAdviceViewController : TimTableViewController

@property (nonatomic, assign)BOOL isEdit;
@property (nonatomic, strong)XLAdviceDetailModel *model;

@end
