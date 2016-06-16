//
//  XLMenuButtonView.m
//  CRM
//
//  Created by Argo Zhang on 16/4/7.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLMenuButtonView.h"
#import "MenuView.h"
#import "XLSelectYuyueViewController.h"
#import "XLQrcodePatientViewController.h"
#import "XLAppointmentBaseViewController.h"

@interface XLMenuButtonView ()<MenuViewDelegate>{
    UIView *_clearView;
    MenuView *_menuView;
}

@end

@implementation XLMenuButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - 初始化
- (void)setUp{
    _clearView = [[UIView alloc] init];
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView:)];
    tapges.numberOfTapsRequired = 1;
    [_clearView addGestureRecognizer:tapges];
    [self addSubview:_clearView];
    
    _menuView = [[MenuView alloc] init];
    [_menuView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"menuView"]]];
    _menuView.delegate = self;
    [self addSubview:_menuView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _clearView.frame = self.bounds;
    _menuView.frame = CGRectMake(kScreenWidth / 2 - 104 / 2, kScreenHeight-self.viewController.tabBarController.tabBar.height - 88, 104, 88);
}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}


#pragma mark - MenuViewDelegate
-(void)yuyueButtonDidSelected{
    [self removeFromSuperview];
    
//    XLSelectYuyueViewController *selectYuyeVc = [[XLSelectYuyueViewController alloc] init];
//    selectYuyeVc.hidesBottomBarWhenPushed = YES;
//    selectYuyeVc.isHome = YES;
//    [self.viewController pushViewController:selectYuyeVc animated:YES];
    
    XLAppointmentBaseViewController *baseVC = [[XLAppointmentBaseViewController alloc] init];
    baseVC.hidesBottomBarWhenPushed = YES;
    [self.viewController pushViewController:baseVC animated:YES];
}

-(void)huanzheButtonDidSeleted{
    [self removeFromSuperview];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    XLQrcodePatientViewController *qrVC = [storyBoard instantiateViewControllerWithIdentifier:@"XLQrcodePatientViewController"];
    qrVC.hidesBottomBarWhenPushed = YES;
    [self.viewController pushViewController:qrVC animated:YES];
}

- (void)dismissView:(UITapGestureRecognizer *)tap{
    [self dismiss];
}

- (void)dismiss{
    [self removeFromSuperview];
}

@end
