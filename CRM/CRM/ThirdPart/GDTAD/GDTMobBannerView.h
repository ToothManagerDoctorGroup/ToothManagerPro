//
//  GDTMobBannerView.h
//  GDTMobSDK
//
//  Created by chaogao on 13-11-5.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  广点通推荐尺寸,开发者在嵌入Banner条时，可以手动设置Banner条的宽度用来满足场景需求，
 *  而高度的话广点通侧不建议更改，否则显示效果会有影响
 */
#define GDTMOB_AD_SUGGEST_SIZE_320x50    CGSizeMake(320, 50) //For iPhone
#define GDTMOB_AD_SUGGEST_SIZE_468x60    CGSizeMake(468, 60) //For iPad
#define GDTMOB_AD_SUGGEST_SIZE_728x90    CGSizeMake(728, 90) //For iPad

typedef enum GDTErrorCode_Banner {
    GDTB_Network_Request_Failure = -2, // Banner广告请求网络无法连接
    GDTB_Server_Request_Failure = -1,  // Banner广告请求服务器失败
}GDTErrorCode_Banner;

@protocol GDTMobBannerViewDelegate <NSObject>

@optional

- (void)bannerViewMemoryWarning;

/**
 *  请求广告条数据成功后调用
 *  详解:当接收服务器返回的广告数据成功后调用该函数
 */
- (void)bannerViewDidReceived;

/**
 *  请求广告条数据失败后调用
 *  详解:当接收服务器返回的广告数据失败后调用该函数
 */
- (void)bannerViewFailToReceived:(int)errCode;

/**
 *  应用进入后台时调用
 *  详解:当点击应用下载或者广告调用系统程序打开，应用将被自动切换到后台
 */
- (void)bannerViewWillLeaveApplication;

/**
 *  banner条被用户关闭时调用
 *  详解:当打开showCloseBtn开关时，用户有可能点击关闭按钮从而把广告条关闭
 */
- (void)bannerViewWillClose;
/**
 *  banner条曝光回调
 */
- (void)bannerViewWillExposure;
/**
 *  banner条点击回调
 */
- (void)bannerViewClicked;

@end

@interface GDTMobBannerView : UIView

/**
 *  父视图
 *  详解：[必选]需设置为显示广告的UIViewController
 */
@property (nonatomic, assign) UIViewController *currentViewController;

/**
 *  委托 [可选]
 */
@property(nonatomic, assign) id<GDTMobBannerViewDelegate> delegate;

/**
 *  广告刷新间隔 [可选]
 */
@property(nonatomic, assign) int interval;

/**
 *  GPS精准广告定位模式开关,默认Gps关闭
 *  详解：[可选]GPS精准定位模式开关，YES为开启GPS，NO为关闭GPS，建议设为开启，可以获取地理位置信息，提高广告的填充率，增加收益。
 */
@property(nonatomic, assign) BOOL isGpsOn;

/**
 *  Banner展现和轮播时的动画效果开关，默认打开
 */
@property(nonatomic, assign) BOOL isAnimationOn;

/**
 *  Banner条展示关闭按钮，默认打开
 */
@property(nonatomic, assign) BOOL showCloseBtn;

/**
 *  构造方法
 *  详解：frame是广告banner展示的位置和大小，包含四个参数(x, y, width, height)
 *       appkey是应用id
 *       placementId是广告位id
 */
- (id)initWithFrame:(CGRect)frame appkey:(NSString *)appkey placementId:(NSString *)placementId;

/**
 *  拉取并展示广告
 */
- (void) loadAdAndShow;
@end