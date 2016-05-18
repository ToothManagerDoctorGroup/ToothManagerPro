//
//  XLAdviceTypeSelectViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/4/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"
/**
 *  选择医嘱类型
 */

@class XLAdviceTypeSelectViewController,XLAdviceTypeModel;
@protocol XLAdviceTypeSelectViewControllerDelegate <NSObject>

@optional
- (void)adviceTypeSelectViewController:(XLAdviceTypeSelectViewController *)selectVC didSelectTypeModel:(XLAdviceTypeModel *)model;
@end

@interface XLAdviceTypeSelectViewController : TimTableViewController

@property (nonatomic, strong)XLAdviceTypeModel *currentModel;

@property (nonatomic, weak)id<XLAdviceTypeSelectViewControllerDelegate> delegate;

@end
