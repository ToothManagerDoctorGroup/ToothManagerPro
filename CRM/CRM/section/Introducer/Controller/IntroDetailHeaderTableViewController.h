//
//  IntroDetailHeaderTableViewController.h
//  CRM
//
//  Created by TimTiger on 3/7/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "TimViewController.h"

@class TimPickerTextField,TimStarTextField,XLStarView,IntroDetailHeaderTableViewController;
@protocol IntroDetailHeaderTableViewControllerDelegate <NSObject>

@optional
- (void)didClickStarView;

@end


@interface IntroDetailHeaderTableViewController : TimViewController
@property (weak, nonatomic) IBOutlet TimPickerTextField *nameTextField;
@property (weak, nonatomic) IBOutlet XLStarView *levelView;
@property (weak, nonatomic) IBOutlet TimPickerTextField *phoneTextField;

@property (nonatomic, weak)id<IntroDetailHeaderTableViewControllerDelegate> delegate;

@property (nonatomic) NSString *ckeyId;
@end

