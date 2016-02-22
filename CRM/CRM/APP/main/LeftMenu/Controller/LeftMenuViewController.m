//
//  LeftMenuViewController.m
//  CRM
//
//  Created by doctor on 14-6-26.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "CommonMacro.h"
#import "LeftMenuTableViewCell.h"
#import "UIViewController+MMDrawerController.h"
#import "MaterialsViewController.h"
#import "AboutProductViewController.h"
#import "ServerPrivacyViewController.h"
#import "UMFeedback.h"
#import "CRMMacro.h"
#import "VersionViewController.h"
#import "ConfigurationViewController.h"
#import "SysMsgViewController.h"
#import "NewMainViewController.h"

#import "RepairDoctorViewController.h"

#define MaterialsViewControllerIndex 0
#define repairDoctorIndex 1
#define myMessageIndex 2
#define feedbackIndex 3
#define aboutUsIndex 4
#define serverAndSecrityIndex 5
#define settingIndex 6

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController
@synthesize personalCenterNav;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"种牙管家";
        //        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        //        NSString *mainvcIdentifier = nil;
        //        if (SCREEN_HEIGHT > 480) {
        //            mainvcIdentifier = @"MainViewController_iPhone5";
        //        } else {
        //            mainvcIdentifier = @"MainViewController_iPhone4";
        //        }
        //        MainViewController *mainVC = [storyBoard instantiateViewControllerWithIdentifier:mainvcIdentifier];
        //        personalCenterNav = [[TimNavigationViewController alloc]initWithRootViewController:mainVC];
        
        NSString *mainvcIdentifier = nil;
        if (SCREEN_HEIGHT > 480) {
            mainvcIdentifier = @"NewMainViewController_iphone6";
        } else {
            mainvcIdentifier = @"NewMainViewController_iphone5";
        }
        NewMainViewController *mainVC = [[NewMainViewController alloc] initWithNibName:mainvcIdentifier bundle:nil];
        personalCenterNav = [[TimNavigationViewController alloc]initWithRootViewController:mainVC];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    menuArray = [[NSArray alloc]initWithObjects:@"种植体",@"修复医生",@"我的消息",@"意见反馈",@"关于我们",@"服务协议",@"设置", nil];
    //[NSString stringWithFormat:@"版本号 v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]]
    menuImageArray = [[NSArray alloc]initWithObjects:@"zhongzhiti.png",@"repair doctor.png",@"feedBack.png",
                      @"userGuide.png",@"aboutUs.png",@"privacy.png", @"setting.png", nil];
    
    m_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    [m_tableView setSeparatorColor:[UIColor colorWithHex:0x1aaaee]];
    m_tableView.backgroundColor = [UIColor colorWithHex:NAVIGATIONBAR_BACKGROUNDCOLOR];
    m_tableView.backgroundView = nil;
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    [self.view addSubview:m_tableView];
    [self setExtraCellLineHidden:m_tableView];
    
    [self.mm_drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        if (percentVisible == 1) {
//            TimNavigationViewController *tmpnav = drawerController.centerViewController;
//            if (![tmpnav.viewControllers.firstObject isKindOfClass:[NewMainViewController class]]) {
//                NSString *mainvcIdentifier = nil;
//                if (SCREEN_HEIGHT > 480) {
//                    mainvcIdentifier = @"NewMainViewController_iphone6";
//                } else {
//                    mainvcIdentifier = @"NewMainViewController_iphone5";
//                }
//                NewMainViewController *mainVC = [[NewMainViewController alloc] initWithNibName:mainvcIdentifier bundle:nil];
//                TimNavigationViewController *timnav = [[TimNavigationViewController alloc]initWithRootViewController:mainVC];
//                [drawerController setCenterViewController:timnav];
//            }
        }
    }];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma tableView delegate&dataSource mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        cell = [[LeftMenuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        bgView.backgroundColor = [UIColor colorWithHex:0x1aaaee];
        [cell setSelectedBackgroundView:bgView];
    }
    cell.leftImageView.image = [UIImage imageNamed:[menuImageArray objectAtIndex:indexPath.row]];
    cell.rightLabel.text = [menuArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    switch (indexPath.row) {
        case MaterialsViewControllerIndex:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            MaterialsViewController *materialsVC = [storyboard instantiateViewControllerWithIdentifier:@"MaterialsViewController"];
            if (!self.personalCenterNav) {
                personalCenterNav = [[TimNavigationViewController alloc]initWithRootViewController:materialsVC];
            }
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.personalCenterNav.viewControllers];
            [array addObject:materialsVC];
            self.personalCenterNav.viewControllers = array;
            [self.mm_drawerController setCenterViewController:self.personalCenterNav withCloseAnimation:YES completion:^(BOOL finished) {
            }];
        }
            break;
        case repairDoctorIndex: {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            RepairDoctorViewController *repairDoctorVC = [storyboard instantiateViewControllerWithIdentifier:@"RepairDoctorViewController"];
            if (!self.personalCenterNav) {
                personalCenterNav = [[TimNavigationViewController alloc]initWithRootViewController:repairDoctorVC];
            }
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.personalCenterNav.viewControllers];
            [array addObject:repairDoctorVC];
            self.personalCenterNav.viewControllers = array;
            [self.mm_drawerController setCenterViewController:self.personalCenterNav withCloseAnimation:YES completion:^(BOOL finished) {
            }];

        }
            break;
        case myMessageIndex:
        {
            UIStoryboard *storypcboard = [UIStoryboard storyboardWithName:@"PersonalCenterStoryboard" bundle:nil];
            SysMsgViewController *sysmsgVC = [storypcboard instantiateViewControllerWithIdentifier:@"SysMsgViewController"];
            if (!self.personalCenterNav) {
                personalCenterNav = [[TimNavigationViewController alloc]initWithRootViewController:sysmsgVC];
            }
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.personalCenterNav.viewControllers];
            [array addObject:sysmsgVC];
            self.personalCenterNav.viewControllers = array;
            [self.mm_drawerController setCenterViewController:self.personalCenterNav withCloseAnimation:YES completion:^(BOOL finished) {
            }];
//            VersionViewController *versionVC = [[VersionViewController alloc]initWithNibName:@"VersionViewController" bundle:nil];
//            if (!self.personalCenterNav) {
//                personalCenterNav = [[TimNavigationViewController alloc]initWithRootViewController:versionVC];
//            }
//            NSMutableArray *array = [NSMutableArray arrayWithArray:self.personalCenterNav.viewControllers];
//            [array addObject:versionVC];
//            self.personalCenterNav.viewControllers = array;
//            [self.mm_drawerController setCenterViewController:self.personalCenterNav withCloseAnimation:YES completion:^(BOOL finished) {
//            }];
        }
            break;
        case feedbackIndex:
        {
            UIViewController *feedbackVC = [UMFeedback feedbackViewController];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 45, 44);
            [button setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
            [[UMFeedback sharedInstance] setBackButton:button];
            if (!self.personalCenterNav) {
                personalCenterNav = [[TimNavigationViewController alloc]initWithRootViewController:feedbackVC];
            }
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.personalCenterNav.viewControllers];
            [array addObject:feedbackVC];
            self.personalCenterNav.viewControllers = array;
            [self.mm_drawerController setCenterViewController:self.personalCenterNav withCloseAnimation:YES completion:^(BOOL finished) {
            }];
        }
            break;
        case aboutUsIndex:
        {
            AboutProductViewController *aboutVC = [storyBoard instantiateViewControllerWithIdentifier:@"AboutProductViewController"];
            if (!self.personalCenterNav) {
                personalCenterNav = [[TimNavigationViewController alloc]initWithRootViewController:aboutVC];
            }
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.personalCenterNav.viewControllers];
            [array addObject:aboutVC];
            self.personalCenterNav.viewControllers = array;
            [self.mm_drawerController setCenterViewController:self.personalCenterNav withCloseAnimation:YES completion:^(BOOL finished) {
            }];

        }
            break;
        case serverAndSecrityIndex:
        {
            ServerPrivacyViewController *serverVC = [storyBoard instantiateViewControllerWithIdentifier:@"ServerPrivacyViewController"];
            if (!self.personalCenterNav) {
                personalCenterNav = [[TimNavigationViewController alloc]initWithRootViewController:serverVC];
            }
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.personalCenterNav.viewControllers];
            [array addObject:serverVC];
            self.personalCenterNav.viewControllers = array;
            [self.mm_drawerController setCenterViewController:self.personalCenterNav withCloseAnimation:YES completion:^(BOOL finished) {
            }];
        }
            break;
        case settingIndex:
        {
            ConfigurationViewController *serverVC = [storyBoard instantiateViewControllerWithIdentifier:@"ConfigurationViewController"];
            if (!self.personalCenterNav) {
                personalCenterNav = [[TimNavigationViewController alloc]initWithRootViewController:serverVC];
            }
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.personalCenterNav.viewControllers];
            [array addObject:serverVC];
            self.personalCenterNav.viewControllers = array;
            [self.mm_drawerController setCenterViewController:self.personalCenterNav withCloseAnimation:YES completion:^(BOOL finished) {
            }];
        }
            break;
            
        default:
            break;
    }
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
