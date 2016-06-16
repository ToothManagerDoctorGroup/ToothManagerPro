//
//  TimViewController.m
//  PhotoSharer
//
//  Created by TimTiger on 3/12/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimViewController.h"
#import "CommonMacro.h"
#import "TimRequest.h"
#import "DBManager.h"
#import "UIBarButtonItem+Extension.h"
#import "UIViewController+MMDrawerController.h"
#import "CRMAppDelegate.h"
#import "UIColor+Extension.h"
#import "UINavigationItem+Margin.h"

@interface TimViewController () <UIAlertViewDelegate>

@end

@implementation TimViewController

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

#ifdef __IPHONE_7_0
    if (IOS_7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif
    if (IOS_7_OR_LATER) {
        if (!self.navigationController || [self.navigationController isNavigationBarHidden]) {
            self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 20);
        } else {
            self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64);
        }
    } else if (IOS_5_OR_LATER) {
        if (!self.navigationController || ![self.navigationController isNavigationBarHidden]) {
            self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44);
        }
    }
    self.view.backgroundColor = [UIColor colorWithHex:VIEWCONTROLLER_BACKGROUNDCOLOR];
    
    [self performSelector:@selector(initData)];
    [self performSelector:@selector(initView)];
    [self becomeRequestResponder]; //成为网络数据响应者
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

- (void)showNoResultViewInView:(UIView *)view top:(CGFloat)top{

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CRMAppDelegate *appDelegate = (CRMAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self addUIkeyboardNotificationObserver];
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
    [self removeUIkeyboardNotificationObserver];
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
    [self.navigationController popViewControllerAnimated:animated];
}

- (void)popToRootViewControllerAnimated:(BOOL)animated {
    [self.navigationController popToRootViewControllerAnimated:animated];
}

- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navigationController popToViewController:viewController animated:animated];
}

- (void)presentToViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    [self presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)dismissModelViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
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

@implementation TimViewController (Notification)

- (void)addNotificationObserver {
    
}

- (void)removeNotificationObserver {
    
}

- (void)addUIkeyboardNotificationObserver {
    [self addObserveNotificationWithName:UIKeyboardWillShowNotification];
    [self addObserveNotificationWithName:UIKeyboardWillHideNotification];
    
    // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
    if(IOS_5_OR_LATER) {
        [self addObserveNotificationWithName:UIKeyboardWillChangeFrameNotification];
    }
#endif
    
//    [self addObserveNotificationWithName:UITextFieldTextDidChangeNotification];
//    [self addObserveNotificationWithName:UITextFieldTextDidEndEditingNotification];
//    [self addObserveNotificationWithName:UITextViewTextDidChangeNotification];
//    [self addObserveNotificationWithName:UITextViewTextDidEndEditingNotification];
//    
}

- (void)removeUIkeyboardNotificationObserver {
    [self removeObserverNotificationWithName:UIKeyboardWillShowNotification];
    [self removeObserverNotificationWithName:UIKeyboardWillHideNotification];
    
    // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
    if(IOS_5_OR_LATER) {
        [self removeObserverNotificationWithName:UIKeyboardWillChangeFrameNotification];
    }
#endif
    
//    [self removeObserverNotificationWithName:UITextFieldTextDidChangeNotification];
//    [self removeObserverNotificationWithName:UITextFieldTextDidEndEditingNotification];
//    [self removeObserverNotificationWithName:UITextViewTextDidChangeNotification];
//    [self removeObserverNotificationWithName:UITextViewTextDidEndEditingNotification];
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
    NSDictionary *info = [notifacation userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    if ([notifacation.name isEqualToString:UIKeyboardWillShowNotification]) {
        [self keyboardWillShow:keyboardSize.height];
    } else if ([notifacation.name isEqualToString:UIKeyboardWillHideNotification]) {
        [self keyboardWillHidden:keyboardSize.height];
    } else if ([notifacation.name isEqualToString:UIKeyboardWillChangeFrameNotification]) {
//        [self keyboardWillShow:keyboardSize.height];
    }
}

- (void)keyboardWillShow:(CGFloat)keyboardHeight {
   
}

- (void)keyboardWillHidden:(CGFloat)keyboardHeight {
    
}

- (void)keyboardFrameChnaged:(CGFloat)changeHeight {
    
}

@end

@implementation TimViewController (UIBarButtonItem)

- (void)setBackBarButtonWithImage:(UIImage *)image {
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithImage:image target:self action:@selector(onBackButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)setLeftBarButtonWithImage:(UIImage *)image {
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithImage:image target:self action:@selector(onLeftButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:backItem];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onRightButtonAction:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

@end
