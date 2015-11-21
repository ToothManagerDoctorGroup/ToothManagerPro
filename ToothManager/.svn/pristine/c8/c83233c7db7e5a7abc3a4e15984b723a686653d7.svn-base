//
//  THCTabBarViewController.m
//  THCFramework
//

#import "TTMTabBarController.h"
#import "TTMTabBar.h"
#import "TTMTabBarItemModel.h"
#import "TTMNavigationController.h"

@interface TTMTabBarController () <TTMTabBarDelegate>

@property (nonatomic, weak) TTMTabBar *thcTabBar;
@property (nonatomic, strong) NSArray *tabBarDatas;

@end

@implementation TTMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 先添加TabBar
    [self setupTabBar];

    // 再添加controller
    [self setupChildControllers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (UIView *view in self.tabBar.subviews) {
        if ([view isKindOfClass:[UIControl class]]) {
            [view removeFromSuperview];
        }
    }
}

- (NSArray *)tabBarDatas {
    if (!_tabBarDatas) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TabBarDatas.plist" ofType:nil];
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            TTMTabBarItemModel *tabBarItemModel = [TTMTabBarItemModel tabBarItemModelWithDic:dic];
            [tempArray addObject:tabBarItemModel];
        }
        _tabBarDatas = [tempArray copy];
    }
    return _tabBarDatas;
}

/**
 *  添加TabBar
 */
- (void)setupTabBar {
    TTMTabBar *thcTabBar = [[TTMTabBar alloc] init];
    thcTabBar.frame = self.tabBar.bounds;
    thcTabBar.delegate = self;
    [self.tabBar addSubview:thcTabBar];
    self.thcTabBar = thcTabBar;
}

/**
 *  添加ChildController
 */
- (void)setupChildControllers {
    for (TTMTabBarItemModel *tabBarItemModel in self.tabBarDatas) {
        [self addChildViewControllerWithTabBarItemModel:tabBarItemModel];
    }
}

- (void)addChildViewControllerWithTabBarItemModel:(TTMTabBarItemModel *)tabBarItemModel {
    UIViewController *controller = [[NSClassFromString(tabBarItemModel.tabBarController) alloc] init];
    controller.title = tabBarItemModel.tabBarTitle;
    controller.tabBarItem.image = [UIImage imageNamed:tabBarItemModel.tabBarImageName];
    controller.tabBarItem.selectedImage = [UIImage imageNamed:tabBarItemModel.tabBarSelectedImageName];
    TTMNavigationController *navigationController = [[TTMNavigationController alloc]
                                                     initWithRootViewController:controller];
    [self addChildViewController:navigationController];

    [self.thcTabBar addButtonWithTabBarItem:controller.tabBarItem];
}

#pragma mark - THCTabBarDelegate
- (void)tabBar:(TTMTabBar *)tabBar fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    self.selectedIndex = toIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
