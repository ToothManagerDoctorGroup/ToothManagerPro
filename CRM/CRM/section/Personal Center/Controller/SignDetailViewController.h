//
//  SignDetailViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/11/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimViewController.h"

@class ClinicModel,XLClinicModel,SignDetailViewController;
@protocol SignDetailViewControllerDelegate <NSObject>

@optional
- (void)didClickApplyButtonWithResult:(NSString *)result;

@end
@interface SignDetailViewController : TimViewController

@property (nonatomic, strong)ClinicModel *signModel;

@property (nonatomic, strong)XLClinicModel *unSignModel;

@property (nonatomic, weak)id<SignDetailViewControllerDelegate> delegate;

@end
