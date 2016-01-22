//
//  PatientSegumentController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/7.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "PatientSegumentController.h"
#import "NYSegmentedControl.h"
#import "PatientsDisplayViewController.h"
#import "TwoViewController.h"

#import "CRMMacro.h"
#import "PatientsCellMode.h"
#import "DBManager+Materials.h"
#import "PatientsTableViewCell.h"
#import "PatientInfoViewController.h"
#import "CreatePatientViewController.h"
#import "AddressBookViewController.h"
#import "SelectDateViewController.h"
#import "DBManager+Patients.h"
#import "MudItemBarItem.h"
#import "MudItemsBar.h"
#import "SDImageCache.h"
#import "LocalNotificationCenter.h"
#import "SVProgressHUD.h"
#import "SyncManager.h"
#import "PatientDetailViewController.h"
#import "SuccessViewController.h"
#import "XLPatientDisplayViewController.h"
#import "UIColor+Extension.h"

@interface PatientSegumentController ()<MudItemsBarDelegate>

@property NYSegmentedControl *segmentedControl;
@property (nonatomic, weak)UIViewController *currentViewController;

@property (nonatomic,retain) MudItemsBar *menubar;
@property (nonatomic) BOOL isBarHidden;

@property (nonatomic, weak)UIView *tipView;
@end

@implementation PatientSegumentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setLeftBarButtonWithImage:[UIImage imageNamed:@"ic_nav_tongbu"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_new"]];
    self.view.backgroundColor = [UIColor whiteColor];
    //创建视图
    [self initSegumentController];
    
    //加载子控制器
    [self initSubControllers];
}
//加载子控制器
- (void)initSubControllers{
    //患者视图
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
//    PatientsDisplayViewController *patientVC = [storyboard instantiateViewControllerWithIdentifier:@"PatientsDisplayViewController"];
//    patientVC.patientStatus = PatientStatuspeAll;
//    patientVC.isTabbarVc = YES;
//    [self addChildViewController:patientVC];
//    self.currentViewController = patientVC;
    XLPatientDisplayViewController *patientVc = [[XLPatientDisplayViewController alloc] initWithStyle:UITableViewStylePlain];
    patientVc.patientStatus = PatientStatuspeAll;
    [self addChildViewController:patientVc];
    self.currentViewController = patientVc;
    
    
    //消息视图
//    SuccessViewController *successVc = [[SuccessViewController alloc] init];
//    [successVc networkChanged:_connectionState];
//    [self addChildViewController:successVc];
    
    TwoViewController *twoVc = [[TwoViewController alloc] init];
    [self addChildViewController:twoVc];
    
    [self.view addSubview:patientVc.view];
    
    
}
//创建选项卡视图
- (void)initSegumentController{
    self.segmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"患者", @"消息"]];
    [self.segmentedControl addTarget:self action:@selector(segmentSelected) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:14.0f];
    self.segmentedControl.titleTextColor = [UIColor whiteColor];
    self.segmentedControl.selectedTitleFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f];
    self.segmentedControl.selectedTitleTextColor = [UIColor colorWithHex:0x00a0ea];
    self.segmentedControl.borderWidth = 1.0f;
    self.segmentedControl.borderColor = [UIColor whiteColor];
    self.segmentedControl.segmentIndicatorInset = 0;
    self.segmentedControl.segmentIndicatorGradientTopColor = [UIColor whiteColor];
    self.segmentedControl.segmentIndicatorGradientBottomColor = [UIColor whiteColor];
    self.segmentedControl.drawsSegmentIndicatorGradientBackground = YES;
    self.segmentedControl.segmentIndicatorBorderWidth = 0.0f;
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl sizeToFit];
    
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.segmentedControl.frame) - 20, 2, 8, 8)];
    tipView.backgroundColor = [UIColor redColor];
    tipView.layer.cornerRadius = 4;
    tipView.layer.masksToBounds = YES;
    tipView.hidden = YES;
    [self.segmentedControl addSubview:tipView];
    self.tipView = tipView;
    
    self.navigationItem.titleView = self.segmentedControl;
}
//点击切换选项卡
- (void)segmentSelected {
    XLPatientDisplayViewController *patientVC = self.childViewControllers[0];
//    SuccessViewController *successVc = self.childViewControllers[1];
    TwoViewController *twoVc = self.childViewControllers[1];
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_new"]];
        self.navigationItem.rightBarButtonItem.enabled = YES;
          [self transitionFromViewController:self.currentViewController toViewController:patientVC duration:.35 options:UIViewAnimationOptionTransitionNone animations:^{
              
          } completion:^(BOOL finished) {
              if (finished) {
                  self.currentViewController = patientVC;
              }else{
                  self.currentViewController = twoVc;
              }
          }];
    }else{
        [self setRightBarButtonWithImage:nil];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self transitionFromViewController:self.currentViewController toViewController:twoVc duration:.35 options:UIViewAnimationOptionTransitionNone animations:^{
        } completion:^(BOOL finished) {
            if (finished) {
                self.currentViewController = twoVc;
            }else{
                self.currentViewController = patientVC;
            }
        }];
    }
}
#pragma mark - 左侧按钮点击事件
-(void)onLeftButtonAction:(id)sender{
    
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

}
- (void)callSync {
    [[SyncManager shareInstance] startSync];
}

#pragma mark - Right View
- (void)onRightButtonAction:(id)sender {
    if (self.isBarHidden == YES) { //如果是消失状态
        [self setupMenuBar];
        [self.menubar showBar:self.navigationController.view WithBarAnimation:MudItemsBarAnimationTop];
    } else {                      //如果是显示状态
        [self.menubar hiddenBar:self.navigationController.view WithBarAnimation:MudItemsBarAnimationTop];
    }
    self.isBarHidden = !self.isBarHidden;
}

- (void)setupMenuBar {
    if (self.menubar == nil) {
        _menubar = [[MudItemsBar alloc]init];
        self.menubar.delegate = self;
        self.menubar.duration = 0.15;
        self.menubar.barOrigin = CGPointMake(0, 64.5);
        self.menubar.backgroundColor = [UIColor colorWithHex:MENU_BAR_BACKGROUND_COLOR];
        UIImage *normalImage = [[UIImage imageNamed:@"baritem_normal_bg"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5];
        UIImage *selectImage = [[UIImage imageNamed:@"baritem_select_bg"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5];
        MudItemBarItem *itemAddressBook = [[MudItemBarItem alloc]init];
        itemAddressBook.text = @"新建患者";
        itemAddressBook.iteImage = [UIImage imageNamed:@"file"];
        [itemAddressBook setBackgroundImage:normalImage forState:UIControlStateNormal];
        [itemAddressBook setBackgroundImage:selectImage forState:UIControlStateHighlighted];
        MudItemBarItem *itemAdd = [[MudItemBarItem alloc]init];
        itemAdd.text = @"通讯录导入";
        itemAdd.iteImage = [UIImage imageNamed:@"copyfile"];
        [itemAdd setBackgroundImage:normalImage forState:UIControlStateNormal];
        [itemAdd setBackgroundImage:selectImage forState:UIControlStateHighlighted];
        self.menubar.items = [NSArray arrayWithObjects:itemAdd,itemAddressBook,nil];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    if (self.isBarHidden == NO){                      //如果是显示状态
        [self.menubar hiddenBar:self.navigationController.view WithBarAnimation:MudItemsBarAnimationTop];
    }

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //判断当前是否有显示
    NSInteger bageNum = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (bageNum > 0) {
        self.tipView.hidden = NO;
    }else{
        self.tipView.hidden = YES;
    }
}

#pragma mark - MudItemsBarDelegate
- (void)itemsBar:(MudItemsBar *)itemsBar clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    switch (buttonIndex) {
        case 0:
        {
            AddressBookViewController *addressBook =[storyBoard instantiateViewControllerWithIdentifier:@"AddressBookViewController"];
            addressBook.type = ImportTypePatients;
            addressBook.hidesBottomBarWhenPushed = YES;
            [self pushViewController:addressBook animated:YES];
        }
            break;
        case 1:
        {
            CreatePatientViewController *newPatientVC = [storyBoard instantiateViewControllerWithIdentifier:@"CreatePatientViewController"];
            newPatientVC.hidesBottomBarWhenPushed = YES;
            [self pushViewController:newPatientVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)itemsBarWillDisAppear {
    self.isBarHidden = YES;
}

-(void)refreshDataSource
{
    if ([self.currentViewController isKindOfClass:[SuccessViewController class]]) {
        SuccessViewController *successVc = (SuccessViewController *)self.currentViewController;
        [successVc refreshDataSource];
    }
    
}

- (void)isConnect:(BOOL)isConnect{
    if ([self.currentViewController isKindOfClass:[SuccessViewController class]]) {
        SuccessViewController *successVc = (SuccessViewController *)self.currentViewController;
        [successVc isConnect:isConnect];
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    if ([self.currentViewController isKindOfClass:[SuccessViewController class]]) {
        SuccessViewController *successVc = (SuccessViewController *)self.currentViewController;
        [successVc networkChanged:connectionState];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
