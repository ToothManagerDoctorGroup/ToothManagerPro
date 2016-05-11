//
//  XLSingleContentWriteViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/1/8.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimViewController.h"

@class XLSingleContentWriteViewController;
@protocol XLSingleContentWriteViewControllerDelegate <NSObject>

@optional
- (void)singleContentViewController:(XLSingleContentWriteViewController *)singleVC didChangeSyncTime:(NSString *)syncTime;

@end
@interface XLSingleContentWriteViewController : TimViewController

@property (nonatomic, copy)NSString *currentTime;

@property (nonatomic, weak)id<XLSingleContentWriteViewControllerDelegate> delegate;

+ (void)resetSyncTime;

@end


