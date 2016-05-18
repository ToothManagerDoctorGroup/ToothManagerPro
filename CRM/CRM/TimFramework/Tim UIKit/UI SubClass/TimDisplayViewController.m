//
//  TimDisplayViewController.m
//  CRM
//
//  Created by TimTiger on 9/25/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimDisplayViewController.h"
#import "CRMAppDelegate.h"
#import "CommonMacro.h"
#import "TimRequest.h"
#import "DBManager.h"
#import "UIBarButtonItem+Extension.h"
#import "UIViewController+MMDrawerController.h"
#import "CRMAppDelegate.h"
#import "UIColor+Extension.h"
#import "UINavigationItem+Margin.h"

@interface TimDisplayViewController ()

@end

@implementation TimDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:VIEWCONTROLLER_BACKGROUNDCOLOR];
    [self performSelector:@selector(initData)];
    [self performSelector:@selector(initView)];
    [self becomeRequestResponder]; //成为网络数据响应者
    [self addNotificationObserver];
}

- (void)initView {
    // Do any additional setup after did load the view.
}

- (void)refreshView {
    // Do any setup when want to refresh the view.
}

- (void)initData {
    // Do any additional  data setup after did load the view.
}

- (void)refreshData {
    // Do any data setup when want to refresh data.
}

- (BOOL)isSearchResultsTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return YES;
    }
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CRMAppDelegate *appDelegate = (CRMAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;
    CRMAppDelegate *appDelegate = (CRMAppDelegate *)[UIApplication sharedApplication].delegate;
    if (viewControllers.count <= 1) {
        [appDelegate.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        if (IOS_7_OR_LATER) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
    else{
        [appDelegate.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        if (IOS_7_OR_LATER) {
            self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        // View is disappearing because a new view controller was pushed onto the stack
        // NSLog(@"New view controller was pushed");
        if (IOS_7_OR_LATER) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        // View is disappearing because it was popped from the stack
        //  NSLog(@"View controller was popped");
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //    //收到内存警告
    //    static int warning = 1;
    //    //所有网络请求响应体 移除
    //    [[TimRequest deafalutRequest] removeAllResponder];
    //
    //    //页面回滚到最前页 【根据应用的结构不同这里应该自行调整代码
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    //
    //    if (warning%20 == 0) { //每收到20次内存警告 提醒用户关闭一些后台程序！
    //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"内存警告" message:@"内存严重不足，请您关闭一些后台程序！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //        [alertView show];
    //    }
    //    warning++;
}

- (void)dealloc {
    [self removeRequestResponder];
    [self removeNotificationObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Public API
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    [self.navigationController pushViewController:viewController animated:animated];
}

- (void)popViewControllerAnimated:(BOOL)animated {
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    } else {
        [self.navigationController popViewControllerAnimated:animated];
    }
}

- (void)popToRootViewControllerAnimated:(BOOL)animated {
    [self.navigationController popToRootViewControllerAnimated:animated];
}

- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navigationController popToViewController:viewController animated:animated];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [super dismissViewControllerAnimated:flag completion:completion];
}

#pragma mark - Pvivate API
- (void)becomeRequestResponder {
    [[TimRequest deafalutRequest] addResponder:self];
}

- (void)removeRequestResponder {
    [[TimRequest deafalutRequest] removeResponder:self];
}

#pragma mark - Set Data

@end

@implementation TimDisplayViewController (Notification)

- (void)addNotificationObserver {
    
}
- (void)removeNotificationObserver {
    
}

- (void)addObserveNotificationWithName:(NSString *)aName {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handNotification:) name:aName object:nil];
}

- (void)addObserveNotificationWithName:(NSString *)aName object:(id)anObject {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handNotification:) name:aName object:anObject];
}

- (void)removeObserverNotificationWithName:(NSString *)aName {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:aName object:nil];
}

- (void)removeObserverNotificationWithName:(NSString *)aName object:(id)anObject {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:aName object:anObject];
}

- (void)postNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)postNotificationName:(NSString *)aName object:(id)anObject {
    [[NSNotificationCenter defaultCenter] postNotificationName:aName object:anObject];
}

- (void)postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:aName object:anObject userInfo:aUserInfo];
}

- (void)handNotification:(NSNotification *)notifacation {
    
}

@end

@implementation TimDisplayViewController (UIBarButtonItem)

- (void)setBackBarButtonWithImage:(UIImage *)image {
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithImage:image target:self action:@selector(onBackButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)setLeftBarButtonWithImage:(UIImage *)image {
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithImage:image target:self action:@selector(onLeftButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)setLeftBarButtonWithImage:(UIImage *)image searchButton:(UIButton *)searchButton{
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithImage:image target:self action:@selector(onLeftButtonAction:)];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    [self.navigationItem setLeftBarButtonItems:@[backItem,searchItem] animated:NO];
}

- (void)setRightBarButtonWithImage:(UIImage *)image {
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImage:image target:self action:@selector(onRightButtonAction:)];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void)setRightBarButtonWithTitle:(NSString *)title {
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithTitle:title target:self action:@selector(onRightButtonAction:)];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void)onLeftButtonAction:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)onBackButtonAction:(id)sender {
    [self popViewControllerAnimated:YES];
}

- (void)onRightButtonAction:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

@end
