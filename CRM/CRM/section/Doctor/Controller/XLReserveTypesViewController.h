//
//  XLReserveTypesViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/12/23.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"
/**
 *  预约类型列表
 */
@class XLReserveTypesViewController;
@protocol XLReserveTypesViewControllerDelegate <NSObject>

@optional
- (void)reserveTypesViewController:(XLReserveTypesViewController *)vc didSelectReserveType:(NSString *)type;

@end
@interface XLReserveTypesViewController : TimTableViewController

@property (nonatomic, copy)NSString *reserve_type;//页面传递过来的事项

@property (nonatomic, weak)id<XLReserveTypesViewControllerDelegate> delegate;

@end
