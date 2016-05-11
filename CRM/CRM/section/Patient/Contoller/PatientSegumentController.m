//
//  PatientSegumentController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/7.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "PatientSegumentController.h"
#import "NYSegmentedControl.h"
#import "TwoViewController.h"

#import "CRMMacro.h"
#import "PatientsCellMode.h"
#import "DBManager+Materials.h"
#import "PatientsTableViewCell.h"
#import "DBManager+Patients.h"
#import "SDImageCache.h"
#import "LocalNotificationCenter.h"
#import "SVProgressHUD.h"
#import "SyncManager.h"
#import "PatientDetailViewController.h"
#import "SuccessViewController.h"
#import "XLPatientDisplayViewController.h"
#import "UIColor+Extension.h"
#import "XLFilterAlertView.h"
#import "XLFilterView.h"

@interface PatientSegumentController ()<XLFilterViewDelegate>

@property NYSegmentedControl *segmentedControl;
@property (nonatomic, weak)UIViewController *currentViewController;
@property (nonatomic, weak)UIView *tipView;
@property (nonatomic, assign)BOOL filterShow;
@property (nonatomic, strong)XLFilterView *filterView;

@end

@implementation PatientSegumentController

- (void)dealloc{
    NSLog(@"患者列表被销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建视图
    [self initSegumentController];
    
    //加载子控制器
    [self initSubControllers];
}
//加载子控制器
- (void)initSubControllers{
    //患者视图
    XLPatientDisplayViewController *patientVc = [[XLPatientDisplayViewController alloc] initWithStyle:UITableViewStylePlain];
    patientVc.patientStatus = PatientStatuspeAll;
    [self addChildViewController:patientVc];
    self.currentViewController = patientVc;
    [self setRightBarButtonWithTitle:@"筛选"];
    
    //消息视图
    SuccessViewController *successVc = [[SuccessViewController alloc] init];
    [successVc networkChanged:_connectionState];
    [self addChildViewController:successVc];

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
    [self.segmentedControl addSubview:tipView];
    if (self.showTipView) {
        tipView.hidden = NO;
    }else{
        tipView.hidden = YES;
    }
    self.tipView = tipView;
    
    self.navigationItem.titleView = self.segmentedControl;
}
//点击切换选项卡
- (void)segmentSelected {
    XLPatientDisplayViewController *patientVC = self.childViewControllers[0];
    SuccessViewController *successVc = self.childViewControllers[1];
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self setRightBarButtonWithTitle:@"筛选"];
          [self transitionFromViewController:self.currentViewController toViewController:patientVC duration:.35 options:UIViewAnimationOptionTransitionNone animations:^{
              
          } completion:^(BOOL finished) {
              if (finished) {
                  self.currentViewController = patientVC;
              }else{
                  self.currentViewController = successVc;
              }
          }];
    }else{
        [self setRightBarButtonWithTitle:nil];
        [self transitionFromViewController:self.currentViewController toViewController:successVc duration:.35 options:UIViewAnimationOptionTransitionNone animations:^{
        } completion:^(BOOL finished) {
            if (finished) {
                self.currentViewController = successVc;
            }else{
                self.currentViewController = patientVC;
            }
        }];
    }
}

#pragma mark - Right View
- (void)onRightButtonAction:(id)sender {
    [self.view endEditing:YES];
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        XLPatientDisplayViewController *patientVC = self.childViewControllers[0];
        //判断当前选择的查询条件
        [patientVC showFilterView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
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


- (void)setShowTipView:(BOOL)showTipView{
    _showTipView = showTipView;
    
    self.tipView.hidden = !showTipView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
