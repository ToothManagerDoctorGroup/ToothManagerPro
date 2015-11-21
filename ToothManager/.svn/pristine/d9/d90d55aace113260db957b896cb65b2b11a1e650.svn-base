//
//  THCNavigationController.m
//  THCFramework
//

#import "TTMNavigationController.h"
#import "TTMNavigationControllerCommon.h"
#import "UIImage+TTMAddtion.h"

@interface TTMNavigationController ()

@end

@implementation TTMNavigationController

+ (void)initialize {
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    // 设置NavigationBar的背景颜色
    [navigationBar setBackgroundImage:[UIImage resizedImageWithName:kNavigationBarBackgroundImageName]
                        forBarMetrics:UIBarMetricsDefault];
    
    navigationBar.tintColor = [UIColor whiteColor];
    // 设置NavigationBar的底线为透明
    [navigationBar setShadowImage:[UIImage new]];
    
    // 设置NavigationBar的title字体的大小
    NSMutableDictionary *titleTextDic = [NSMutableDictionary dictionary];
    titleTextDic[NSFontAttributeName] =  [UIFont systemFontOfSize:kNavigationBarTitleFontSize];
    // 设置NavigationBar的title字体颜色
    titleTextDic[NSForegroundColorAttributeName] = kNavigationBarTitleColor;
    // 设置NavigationBar的title阴影
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = kNavigationBarTitleShadowColor;
    shadow.shadowOffset = kNavigationBarTitleShadowOffset;
    shadow.shadowBlurRadius = kNavigationBarTitleShadowBlurRadius;
    titleTextDic[NSShadowAttributeName] = shadow;
    [navigationBar setTitleTextAttributes:titleTextDic];
    
    // 设置BarButtonItem的样式
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    NSMutableDictionary *barButtonItemTitleTextDic = [NSMutableDictionary dictionary];
    // 设置BarButtonItem的title字体的大小
    barButtonItemTitleTextDic[NSFontAttributeName] = [UIFont systemFontOfSize:kBarButtonItemTitleFontSize];
    // 设置BarButtonItem的title字体颜色
    barButtonItemTitleTextDic[NSForegroundColorAttributeName] = kBarButtonItemTitleColor;
    // 设置BarButtonItem的title阴影
    NSShadow *barButtonItemShadow = [[NSShadow alloc] init];
    barButtonItemShadow.shadowColor = kBarButtonItemTitleShadowColor;
    barButtonItemShadow.shadowOffset = kBarButtonItemTitleShadowOffset;
    barButtonItemShadow.shadowBlurRadius = kBarButtonItemTitleShadowBlurRadius;
    barButtonItemTitleTextDic[NSShadowAttributeName] = barButtonItemShadow;
    [barButtonItem setTitleTextAttributes:barButtonItemTitleTextDic forState:UIControlStateNormal];
    [barButtonItem setTitleTextAttributes:barButtonItemTitleTextDic forState:UIControlStateHighlighted];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 重写push方法，去掉返回按钮中的文字
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    viewController.navigationItem.backBarButtonItem = backItem;
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }

    [super pushViewController:viewController animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
