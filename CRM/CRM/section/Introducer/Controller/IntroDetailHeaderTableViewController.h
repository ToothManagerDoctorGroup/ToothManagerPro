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

@class TimPickerTextField,TimStarTextField;
@interface IntroDetailHeaderTableViewController : UITableViewController<MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet TimPickerTextField *nameTextField;
@property (weak, nonatomic) IBOutlet TimStarTextField *levelTextField;
@property (weak, nonatomic) IBOutlet TimPickerTextField *phoneTextField;

@property (nonatomic) NSString *ckeyId;
@end

