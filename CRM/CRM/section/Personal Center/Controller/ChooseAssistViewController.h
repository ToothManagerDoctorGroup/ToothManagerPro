//
//  ChooseAssistViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/11/24.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimViewController.h"

@class ChooseAssistViewController;
@protocol ChooseAssistViewControllerDelegate <NSObject>

@optional
- (void)chooseAssistViewController:(ChooseAssistViewController *)aController didSelectAssists:(NSArray *)assists;

@end

@interface ChooseAssistViewController : TimViewController

@property (nonatomic, copy)NSString *clinicId;

@property (nonatomic, strong)NSArray *chooseAssists;//选择的助手数

@property (nonatomic, weak)id<ChooseAssistViewControllerDelegate> delegate;

@end
