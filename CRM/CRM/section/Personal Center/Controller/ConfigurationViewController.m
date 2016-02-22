//
//  ConfigurationViewController.m
//  CRM
//
//  Created by du leiming on 8/31/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "CRMUserDefalut.h"


@interface ConfigurationViewController ()

@end

@implementation ConfigurationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.versionLabel.text = [NSString stringWithFormat:@"版本号 v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    [self.wifiSwitch setOn: YES
                      animated: YES];
    [self.wifiSwitch setDidChangeHandler:^(BOOL isOn) {
        // Store the data
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setInteger:isOn forKey:@"WifiIsOn"];
        
        [defaults synchronize];
        
        
        NSLog(@"Smallest switch changed to %d", isOn);
    }];

  //  self.devicetokenTextView.text = [CRMUserDefalut objectForKey:DeviceToken];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
