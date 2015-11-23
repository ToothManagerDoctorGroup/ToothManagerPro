//
//  AddReminderViewController.h
//  CRM
//
//  Created by doctor on 15/3/4.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"
#import "TimPickerTextField.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AddReminderViewController : TimTableViewController<TimPickerTextFieldDataSource,TimPickerTextFieldDelegate,MFMessageComposeViewControllerDelegate>
{
    NSArray *selectMatterArray;
    NSArray *selectRepeatArray;
}

@property (strong, nonatomic) IBOutlet TimPickerTextField *selectMatterTextField;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet TimPickerTextField *huanzheTextField;

@property (strong, nonatomic) IBOutlet TimPickerTextField *yaWeiTextField;

@property (weak, nonatomic) IBOutlet TimPickerTextField *medicalPlaceTextField;
@property (weak, nonatomic) IBOutlet TimPickerTextField *timeTextField;

@property (weak, nonatomic) IBOutlet TimPickerTextField *medicalChairTextField;
@property (weak, nonatomic) IBOutlet UILabel *timeDurationLabel;

@property (nonatomic) BOOL ifNextReserve;

@property (strong, nonatomic) NSString *selectDateString;

@property (nonatomic,strong) NSString *reservedPatiendId;

@end
