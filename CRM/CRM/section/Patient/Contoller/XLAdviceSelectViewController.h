//
//  XLAdviceSelectViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/4/26.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimViewController.h"

@class XLAdviceSelectViewController;
@protocol XLAdviceSelectViewControllerDelegate <NSObject>

@optional
- (void)adviceSelectViewController:(XLAdviceSelectViewController *)adviceSelectVc didSelectAdviceContent:(NSString *)adviceContent;

@end

@interface XLAdviceSelectViewController : TimViewController

@property (nonatomic, weak)id<XLAdviceSelectViewControllerDelegate> delegate;

@end
