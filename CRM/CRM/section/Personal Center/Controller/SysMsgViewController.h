//
//  SysMsgViewController.h
//  CRM
//
//  Created by TimTiger on 11/3/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"

@interface SysMsgViewController : TimTableViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentView;
- (IBAction)segmentValueChanged:(id)sender;

@end
