//
//  THCTabBar.h
//  THCFramework
//

#import <UIKit/UIKit.h>
@protocol TTMTabBarDelegate;

@interface TTMTabBar : UIView

@property (nonatomic, weak) id<TTMTabBarDelegate> delegate;

- (void)addButtonWithTabBarItem:(UITabBarItem *)tabBarItem;

@end

@protocol TTMTabBarDelegate <NSObject>

@required
- (void)tabBar:(TTMTabBar *)tabBar fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

@end
