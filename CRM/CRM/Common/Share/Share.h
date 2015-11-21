//
//  Share.h
//  CRM
//
//  Created by mac on 14-6-20.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "ShareMode.h"
#import <StoreKit/StoreKit.h>

typedef NS_ENUM(NSInteger, PlatformType){
    weixin = 1,    //微信朋友圈
    QZong,         //qq空间
    weixinFriend,        //微信好友
};

@interface Share : NSObject <SKStoreProductViewControllerDelegate>

/**
 *  分享到各大平台
 *
 *  @param platform 平台代码（是个枚举）
 *  @param mode     分享的数据模型
 */
+ (void)shareToPlatform:(PlatformType)platform WithMode:(ShareMode *)mode;

/**
 *  当用户没有安装微信的时候，下载微信
 */
+ (Share *)sharedUtility;

- (void)showAppInApp:(NSString *)_appId AndWithController:(UIViewController *)controller;


+ (void)shareToPlatform:(PlatformType)platform WithMode:(ShareMode *)mode;

@end