//
//  TimTabBarViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/7.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimTabBarViewController.h"
#import "TimFramework.h"
#import "IntroducerViewController.h"
#import "ScheduleReminderViewController.h"
#import "AccountViewController.h"
#import "PatientSegumentController.h"
#import "MenuView.h"
#import "MenuButtonPushManager.h"
#import "SigninViewController.h"
#import "SignUpViewController.h"

@interface TimTabBarViewController (){
    UIButton *menuButton;
    MenuView *menuView;
    MenuButtonPushManager *manager;
    UIView *clearView;
    
    ScheduleReminderViewController *_scheduleReminderVC;
    IntroducerViewController *_introducerVC;
    PatientSegumentController *_patientVc;
    AccountViewController *_account;
}

@end

@implementation TimTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeMainView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)makeMainView
{
    //日程提醒
    _scheduleReminderVC = [[ScheduleReminderViewController alloc]init];
    TimNavigationViewController *viewController1=[[TimNavigationViewController alloc]initWithRootViewController:_scheduleReminderVC];
    
    //介绍人
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    _introducerVC = [storyboard instantiateViewControllerWithIdentifier:@"IntroducerViewController"];
    [self setTabbarItemState:_introducerVC withTitle:@"介绍人" withImage1:@"ic_tabbar_library" withImage2:@"ic_tabbar_library_active"];
    _introducerVC.isHome = YES;
    TimNavigationViewController* ncViewController2=[[TimNavigationViewController alloc]initWithRootViewController:_introducerVC];
    
    //患者
    _patientVc = [[PatientSegumentController alloc] init];
    [self setTabbarItemState:_patientVc withTitle:@"患者" withImage1:@"ic_tabbar_library" withImage2:@"ic_tabbar_library_active"];
    TimNavigationViewController* ncViewController3=[[TimNavigationViewController alloc]initWithRootViewController:_patientVc];
    
    
    //我的空间
    _account = [storyboard instantiateViewControllerWithIdentifier:@"AccountViewController"];
    TimNavigationViewController* ncViewController4=[[TimNavigationViewController alloc]initWithRootViewController:_account];
    [self setTabbarItemState:_account withTitle:@"我的空间" withImage1:@"ic_tabbar_me" withImage2:@"ic_tabbar_me_active"];
    
    UIViewController *vc3 = [[UIViewController alloc]init];
    TimNavigationViewController* nc3=[[TimNavigationViewController alloc]initWithRootViewController:vc3];
    
    
    self.tabBar.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:viewController1, ncViewController3, nc3,ncViewController2, ncViewController4,nil];
    [self setViewControllers:array];
    
    menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 0, SCREEN_WIDTH/5-15, self.tabBar.frame.size.height);
    [menuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateSelected];
    [menuButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setCenter:CGPointMake(SCREEN_WIDTH/2,(self.tabBar.frame.size.height)/2)];
    [self.tabBar addSubview:menuButton];
    
}

-(void)click:(id)sender{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight)];
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc]init];
    [tapges addTarget:self action:@selector(disMissView)];
    tapges.numberOfTapsRequired = 1;
    [clearView addGestureRecognizer:tapges];
    [window addSubview:clearView];
    
    menuView = [[MenuView alloc]init];
    [menuView setFrame:CGRectMake(SCREEN_WIDTH/2-104/2, SCREEN_HEIGHT-self.tabBar.frame.size.height-88, 104, 88)];
    [menuView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"menuView"]]];
    [window addSubview:menuView];
    
    manager = [[MenuButtonPushManager alloc]init];
    manager.viewController = (UINavigationController *)self.selectedViewController;
    menuView.delegate = manager;
}
-(void)disMissView{
    [clearView removeFromSuperview];
    [menuView removeFromSuperview];
}

-(void)setTabbarItemState:(UIViewController *)viewController withTitle:(NSString *)title withImage1:(NSString*)image1 withImage2:(NSString *)image2{
    UIImage *image11 = [[UIImage imageNamed:image1] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image21 = [[UIImage imageNamed:image2] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image11 selectedImage:image21];
    [viewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithRed:59.0f/255.0f green:161.0f/255.0f blue:233.0f/255.0f alpha:1], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    [viewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor lightGrayColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
}

@end
