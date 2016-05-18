//
//  XLThreaterSelectViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/4/7.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimViewController.h"

/**
 *  治疗医生选择
 */
@class XLThreaterSelectViewController;
@protocol XLThreaterSelectViewControllerDelegate <NSObject>

@optional
- (void)threaterSelectViewController:(XLThreaterSelectViewController *)selectVc didSelectDoctors:(NSArray *)selectDocs;

@end

@interface XLThreaterSelectViewController : TimViewController

@property (nonatomic, weak)id<XLThreaterSelectViewControllerDelegate> delegate;

@property (nonatomic, strong)NSArray *existMembers;//当前存在的成员

@end
