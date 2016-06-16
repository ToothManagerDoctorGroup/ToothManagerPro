//
//  CRMNavigationViewController.m
//  CRM
//
//  Created by TimTiger on 5/11/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimNavigationViewController.h"
#import "TimFramework.h"
#import "AccountViewController.h"
#import "PatientSegumentController.h"
#import "MenuView.h"
#import "MenuButtonPushManager.h"

@interface TimNavigationViewController ()

@end



@implementation TimNavigationViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // Custom initialization
        TimNavigationBar *timNavBar = [[TimNavigationBar alloc]init];
        [self setValue:timNavBar forKey:@"navigationBar"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
