//
//  THCMacro.h
//  THCFramework
//

#ifndef THCFramework_THCMacro_h
#define THCFramework_THCMacro_h

#ifdef DEBUG
#define TTMLog(...) NSLog(__VA_ARGS__)
#else
#define TTMLog(...)
#endif

// 1.判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// 2.获得RGB颜色
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 3.获得ARGB颜色
#define ARGBColor(a, r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

// 4.Document的路径
#define DocumentPath ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject])

// 5.弧度转角度
#define RADIANS_TO_DEGREES(x) ((x) / M_PI * 180.0)

// 6.角度转弧度
#define DEGREES_TO_RADIANS(x) ((x) / 180.0 * M_PI)

// 7.屏幕宽度高度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

// 8.导航栏高度
#define NavigationHeight 64

// 9.Tabbar高度
#define TabbarHeight 49

// 10.TableViewCell分割线的高度
#define TableViewCellSeparatorHeight 0.4f
// 11.TableViewCell分割线的透明度
#define TableViewCellSeparatorAlpha 0.4f
// 12.TableViewCell分割线的颜色
#define TableViewCellSeparatorColor [UIColor grayColor]

// 13.网络请求返回结果(现在的逻辑，result是空表示成功，result是NSString类型表示错误信息)
typedef void (^CompleteBlock)(id result);

// 14.主色调
#define MainColor RGBColor(42.0, 189.0, 199.0)


#define NormalLineH 44.f

#define NormalMargin 10.f
#endif
