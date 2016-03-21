//
//  XLContentWriteViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/1/7.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimViewController.h"
/**
 *  通用信息填写页面
 */
@class XLContentWriteViewController;
@protocol  XLContentWriteViewControllerDelegate <NSObject>

@optional
- (void)contentWriteViewController:(XLContentWriteViewController *)contentVC didWriteContent:(NSString *)content;

@end
@interface XLContentWriteViewController : TimViewController

@property (nonatomic, copy)NSString *currentContent;

@property (nonatomic, copy)NSString *placeHolder;

@property (nonatomic, assign)int limit;//长度限制

@property (nonatomic, weak)id<XLContentWriteViewControllerDelegate> delegate;

@end
