//
//  XLAppointmentBaseViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/5/16.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAppointmentBaseViewController.h"
#import "NYSegmentedControl.h"
#import "XLSelectYuyueViewController.h"
#import "UIColor+Extension.h"
#import "XLClinicsDisplayViewController.h"

@interface XLAppointmentBaseViewController ()

@property NYSegmentedControl *segmentedControl;
@property (nonatomic, weak)UIViewController *currentViewController;

@property (nonatomic, assign)BOOL transiting;

@end

@implementation XLAppointmentBaseViewController
#pragma mark - ********************* Life Method ***********************
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建视图
    [self initSegumentController];
    
    //加载子控制器
    [self initSubControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ********************* Private Method ***********************
//加载子控制器
- (void)initSubControllers{

    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    //本地预约视图
    XLSelectYuyueViewController *selectYuyeVc = [[XLSelectYuyueViewController alloc] init];
    selectYuyeVc.hidesBottomBarWhenPushed = YES;
    if (self.patient == nil) {
        selectYuyeVc.isHome = YES;
    }else{
        selectYuyeVc.isAddLocationToPatient = YES;
        selectYuyeVc.patient = self.patient;
    }
    [self addChildViewController:selectYuyeVc];
    self.currentViewController = selectYuyeVc;
    
    //诊所预约视图
    XLClinicsDisplayViewController *clinicVc = [[XLClinicsDisplayViewController alloc] initWithStyle:UITableViewStylePlain];
    clinicVc.hidesBottomBarWhenPushed = YES;
    if (self.patient) {
        clinicVc.patient = self.patient;
    }
    [self addChildViewController:clinicVc];
    [self.view addSubview:selectYuyeVc.view];
}

//创建选项卡视图
- (void)initSegumentController{
    self.segmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"执业医院", @"合作诊所"]];
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
    self.navigationItem.titleView = self.segmentedControl;
}
//点击切换选项卡
- (void)segmentSelected {
    XLSelectYuyueViewController *selectYuyeVc = self.childViewControllers[0];
    XLClinicsDisplayViewController *clinicVc = self.childViewControllers[1];
    
    if (self.transiting) {
        return;
    }
    self.transiting = YES;
    WS(weakSelf);
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self transitionFromViewController:self.currentViewController toViewController:selectYuyeVc duration:.35 options:UIViewAnimationOptionTransitionNone animations:^{
            
        } completion:^(BOOL finished) {
            weakSelf.transiting = NO;
            weakSelf.currentViewController = selectYuyeVc;
        }];
    }else{
        [self transitionFromViewController:self.currentViewController toViewController:clinicVc duration:.35 options:UIViewAnimationOptionTransitionNone animations:^{
        } completion:^(BOOL finished) {
            weakSelf.transiting = NO;
            weakSelf.currentViewController = clinicVc;
        }];
    }
}

@end
