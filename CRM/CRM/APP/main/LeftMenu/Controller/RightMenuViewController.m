//
//  RightMenuViewController.m
//  CRM
//
//  Created by TimTiger on 9/9/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "RightMenuViewController.h"
#import "TimNavigationViewController.h"
#import "CommonMacro.h"
#import "LeftMenuTableViewCell.h"
#import "UIViewController+MMDrawerController.h"
#import "MaterialsViewController.h"
#import "AboutProductViewController.h"
#import "ServerPrivacyViewController.h"
#import "CRMMacro.h"
#import "VersionViewController.h"
#import "ConfigurationViewController.h"
#import "AccountManager.h"
#import "SigninViewController.h"
#import "UserInfoViewController.h"
#import "NewMainViewController.h"
#import "AvatarView.h"
#import "CRMUserDefalut.h"
#import "ChangePasswdViewController.h"
#import "SysMsgViewController.h"
#import "SyncManager.h"
#import "SVProgressHUD.h"
#import "QrCodeViewController.h"

@interface RightMenuViewController ()

@property (nonatomic,retain) AvatarView *avatar;

@end

@implementation RightMenuViewController
@synthesize personalCenterNav;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    self.view.backgroundColor = [UIColor colorWithHex:VIEWCONTROLLER_BACKGROUNDCOLOR];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    menuArray = [[NSArray alloc]initWithObjects:@"同步",@"我的二维码",@"修改密码",@"注销",nil];
    menuImageArray = [[NSArray alloc]initWithObjects:@"sys.png",@"code.png",@"changePassword.png",@"sign_out.png",nil];
    
    m_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    [m_tableView setSeparatorColor:[UIColor colorWithHex:0x1aaaee]];
    m_tableView.backgroundColor = [UIColor colorWithHex:VIEWCONTROLLER_BACKGROUNDCOLOR];
    m_tableView.backgroundView = nil;
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    [self.view addSubview:m_tableView];
    UIView *view =[ [UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = [UIColor colorWithHex:VIEWCONTROLLER_BACKGROUNDCOLOR];
    [m_tableView setTableFooterView:view];
    
    _avatar = [[AvatarView alloc]initWithURLString:@""];
    _avatar.frame = CGRectMake(0, 0, 120, 30);
    if ([[AccountManager shareInstance] isLogin]) {
        _avatar.title = [AccountManager shareInstance].currentUser.name;
    } else {
        _avatar.title = @"未登录";
    }
    [_avatar addTarget:self action:@selector(onAvatarAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:_avatar];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    [self addNotificationObserver];
}

- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)dealloc {
    [self removeNotificationObserver];
}

#pragma mark - Notification
- (void)addNotificationObserver {
    [self addObserveNotificationWithName:SignInSuccessNotification];
    [self addObserveNotificationWithName:SignOutSuccessNotification];
//    [self addObserveNotificationWithName:SignUpSuccessNotification];
}

- (void)removeNotificationObserver {
    [self removeObserverNotificationWithName:SignInSuccessNotification];
    [self removeObserverNotificationWithName:SignOutSuccessNotification];
//    [self removeObserverNotificationWithName:SignUpSuccessNotification];
}

- (void)handNotification:(NSNotification *)notifacation {
    if ([notifacation.name isEqualToString:SignInSuccessNotification]) {
        NSLog(@"%@",[AccountManager shareInstance].currentUser.name);
        self.avatar.title = [AccountManager shareInstance].currentUser.name;
    } else if ([notifacation.name isEqualToString:SignOutSuccessNotification]) {
        self.avatar.title = @"未登录";
    }
}

#pragma mark - 
- (void)onAvatarAction:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    if ([[AccountManager shareInstance] isLogin]) {
        UserInfoViewController *userInfoVC = [storyBoard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
        TimNavigationViewController *timNav = [[TimNavigationViewController alloc]initWithRootViewController:userInfoVC];
        [self presentViewController:timNav animated:YES completion:^{
        }];
    } else {
        SigninViewController *signinVC = [storyBoard instantiateViewControllerWithIdentifier:@"SigninViewController"];
        TimNavigationViewController *timNav = [[TimNavigationViewController alloc]initWithRootViewController:signinVC];
            [self presentViewController:timNav animated:YES completion:^{
        }];
    }
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

- (void)callSync {
    [[SyncManager shareInstance] startSync];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    switch (indexPath.row) {
        case 0:
        {
            NSLog(@"This is the sync module");
           
            [SVProgressHUD showWithStatus:@"同步中..."];
            
             if ([[AccountManager shareInstance] isLogin]) {
                 
                 [NSTimer scheduledTimerWithTimeInterval:0.2
                                                  target:self
                                                selector:@selector(callSync)
                                                userInfo:nil
                                                 repeats:NO];
            
                             } else {
                 NSLog(@"User did not login");
                 
                 [SVProgressHUD showWithStatus:@"同步失败，请先登录..."];
                 [SVProgressHUD dismiss];
                                 
                 [NSThread sleepForTimeInterval: 1];
                 
                 
             }
            
          
//            if ([[AccountManager shareInstance] isLogin]) {
//                UserInfoViewController *userInfoVC = [storyBoard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
//                if (!self.personalCenterNav) {
//                    personalCenterNav = [[TimNavigationViewController alloc]init];
//                }
//                personalCenterNav.viewControllers = [NSArray arrayWithObject:userInfoVC];
//                [self.mm_drawerController setCenterViewController:self.personalCenterNav
//                                               withCloseAnimation:YES completion:nil];
//            } else {
//                SigninViewController *signinVC = [storyBoard instantiateViewControllerWithIdentifier:@"SigninViewController"];
//                if (!self.personalCenterNav) {
//                    personalCenterNav = [[TimNavigationViewController alloc]init];
//                }
//                personalCenterNav.viewControllers = [NSArray arrayWithObject:signinVC];
//                [self.mm_drawerController setCenterViewController:self.personalCenterNav
//                                               withCloseAnimation:YES completion:nil];
//            }
            
            
        }
            break;
            
        case 1:
        {
            QrCodeViewController *qrVC = [storyBoard instantiateViewControllerWithIdentifier:@"QrCodeViewController"];
            if (!self.personalCenterNav) {
                personalCenterNav = [[TimNavigationViewController alloc]initWithRootViewController:qrVC];
            }
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.personalCenterNav.viewControllers];
            [array addObject:qrVC];
            self.personalCenterNav.viewControllers = array;
            [self.mm_drawerController setCenterViewController:self.personalCenterNav withCloseAnimation:YES completion:^(BOOL finished) {
            }];
        }
            break;
            
        case 2:
        {
            ChangePasswdViewController *changepasswdVC = [storyBoard instantiateViewControllerWithIdentifier:@"ChangePasswdViewController"];
            if (!self.personalCenterNav) {
                personalCenterNav = [[TimNavigationViewController alloc]initWithRootViewController:changepasswdVC];
            }
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.personalCenterNav.viewControllers];
            [array addObject:changepasswdVC];
            self.personalCenterNav.viewControllers = array;
            [self.mm_drawerController setCenterViewController:self.personalCenterNav withCloseAnimation:YES completion:^(BOOL finished) {
            }];
        }
            break;
        case 3:
        {
            [[AccountManager shareInstance] logout];
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


@end
