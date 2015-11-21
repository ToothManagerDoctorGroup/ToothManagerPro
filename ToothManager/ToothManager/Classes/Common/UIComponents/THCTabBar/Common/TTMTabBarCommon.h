//
//  TTMTabBarCommon.h
//  TTMFramework
//

// TTMTabBarController的配置文件
#ifndef TTMFramework_TTMTabBarCommon_h
#define TTMFramework_TTMTabBarCommon_h

#pragma mark - THCTabBarButtonItem的配置信息
// THCTabBar的背景颜色
#define kTabBarBackgroundColor RGBColor(245.0f, 245.0f, 245.0f);
// THCTabBarButtonItem中titleLable和imageView的所占比例
#define kTabBarButtonItemRadio 0.7
// THCTabBarButtonItem中titleLabel的字体大小
#define kTabBarButtonItemFontSize 11.0
// THCTabBarButtonItem默认文字颜色
#define kTabBarButtonItemTitleColor RGBColor(169.0f, 178.0f, 183.0f)
// THCTabBarButtonItem选中文字颜色
#define kTabBarButtonItemTitleSelectedColor MainColor
// THCTabBarButtonItem右上角消息数View的背景颜色
#define kTabBarBadgeViewColor RGBColor(252.0f, 62.0f, 51.0f)
// THCTabBarButtonItem右上角消息数View的字体大小
#define kTabBarBadgeViewFont 12.0f
// THCTabBarButtonItem右上角消息数View的宽高
#define kTabBarBadgeViewWH 20.0f
// THCTabBarButtonItem右上角消息数View的Y
#define kTabBarBadgeViewY 2.0f
// THCTabBarButtonItem右上角消息数的最大值
#define kTabBarBadgeViewMaxNumber 99
// THCTabBarButtonItem右上角消息数超过最大值显示的字符串
#define kTabBarBadgeViewMaxNumberShow @"N+"

#endif
