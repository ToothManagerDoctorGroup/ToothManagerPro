//
//  PatientInfoViewController.h
//  CRM
//
//  Created by TimTiger on 10/23/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimViewController.h"
#import "TSPopoverController.h"

@class PatientsCellMode;
@interface PatientInfoViewController : TimViewController<UITableViewDelegate,UITableViewDataSource,TSPopoverTouchesDelegate,UIGestureRecognizerDelegate>

@property (nonatomic) TSPopoverController *tsPopoverController;

@property (nonatomic,retain) PatientsCellMode *patientsCellMode;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)createCaseAction:(id)sender;
- (IBAction)referralAction:(id)sender;
- (IBAction)createNotificationAction:(id)sender;
@end
