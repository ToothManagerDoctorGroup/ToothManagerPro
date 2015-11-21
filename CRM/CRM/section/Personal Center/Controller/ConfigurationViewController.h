//
//  ConfigurationViewController.h
//  CRM
//
//  Created by du leiming on 8/31/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"
#import <UIKit/UIKit.h>
#import "KLSwitch.h"

@interface ConfigurationViewController : TimTableViewController
@property (weak, nonatomic) IBOutlet KLSwitch *wifiSwitch;
@property (weak, nonatomic) IBOutlet UITextView *devicetokenTextView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;


@end
