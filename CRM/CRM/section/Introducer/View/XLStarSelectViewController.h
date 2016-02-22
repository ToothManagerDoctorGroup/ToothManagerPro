//
//  XLStarSelectViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/2/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimDisplayViewController.h"
/**
 *  星级选择页面
 */
@class XLStarSelectViewController;
@protocol XLStarSelectViewControllerDelegate <NSObject>

@optional
- (void)starSelectViewController:(XLStarSelectViewController *)starSelectVc didSelectLevel:(NSInteger)level;

@end
@interface XLStarSelectViewController : TimDisplayViewController

@property (nonatomic, weak)id<XLStarSelectViewControllerDelegate> delegate;

@end
