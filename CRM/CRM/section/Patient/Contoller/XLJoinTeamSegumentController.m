//
//  XLJoinTeamSegumentController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/8.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLJoinTeamSegumentController.h"
#import "NYSegmentedControl.h"
#import "WMPageController.h"
#import "XLJoinConsultationController.h"
#import "UIColor+Extension.h"
#import "XLWaitHandleViewController.h"
#import "XLWaitPayViewController.h"
#import "XLPayedViewController.h"

@interface XLJoinTeamSegumentController ()

@property NYSegmentedControl *segmentedControl;
@property (nonatomic, weak)UIViewController *currentViewController;

@property (nonatomic, assign)BOOL transiting;

@end

@implementation XLJoinTeamSegumentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    //创建视图
    [self initSegumentController];
    
    //加载子控制器
    [self initSubControllers];
}

//加载子控制器
- (void)initSubControllers{
    //合作治疗视图
    WMPageController *pageController = [self p_defaultController];
    pageController.title = @"合作治疗";
    pageController.menuViewStyle = WMMenuViewStyleLine;
    pageController.titleSizeSelected = 15;
    pageController.titleColorNormal = [UIColor colorWithHex:0x888888];
    pageController.titleColorSelected = [UIColor colorWithHex:0x00a0ea];
    pageController.menuHeight = 44;
    pageController.menuItemWidth = kScreenWidth / 3;
    pageController.bounces = NO;
    [self addChildViewController:pageController];
    self.currentViewController = pageController;
    
    //参与会诊视图
    XLJoinConsultationController *consultationVc = [[XLJoinConsultationController alloc] initWithStyle:UITableViewStylePlain];
    [self addChildViewController:consultationVc];
    
    //设置首先显示的视图
    [self.view addSubview:pageController.view];
    
    
}
//创建选项卡视图
- (void)initSegumentController{
    self.segmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"合作治疗", @"参与会诊"]];
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
    
    WMPageController *pageController = self.childViewControllers[0];
    XLJoinConsultationController *consultationVc = self.childViewControllers[1];
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        
        [self transitionFromViewController:self.currentViewController toViewController:pageController duration:.35 options:UIViewAnimationOptionTransitionNone animations:^{
            
        } completion:^(BOOL finished) {
            if (finished) {
                self.currentViewController = pageController;
            }else{
                self.currentViewController = consultationVc;
            }
        }];
    }else{
        [self transitionFromViewController:self.currentViewController toViewController:consultationVc duration:.35 options:UIViewAnimationOptionTransitionNone animations:^{
        } completion:^(BOOL finished) {
            if (finished) {
                self.currentViewController = consultationVc;
            }else{
                self.currentViewController = pageController;
            }
        }];
    }
}

#pragma mark - 创建控制器
- (WMPageController *)p_defaultController {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    Class class;
    for (int i = 0; i < 3; i++) {
        NSString *title;
        if (i == 0) {
            title = @"待处理";
            class = [XLWaitHandleViewController class];
        }else if(i == 1){
            title = @"已完成待收款";
            class = [XLWaitPayViewController class];
        }else{
            title = @"已收款";
            class = [XLPayedViewController class];
        }
        [viewControllers addObject:class];
        [titles addObject:title];
    }
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageVC.pageAnimatable = YES;
    pageVC.menuItemWidth = kScreenWidth * 0.5;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    return pageVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
