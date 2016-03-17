//
//  Share.m
//  CRM
//
//  Created by mac on 14-6-20.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "Share.h"

@implementation Share

+ (void)shareToPlatform:(PlatformType)platform WithMode:(ShareMode *)mode
{
    
    switch (platform) {
        case weixin:{
            Share * share = [[Share alloc]init];
            [share shareToWeiXinWithMode:mode];
        }break;
            
        case QZong:
            break;
        case weixinFriend:{
            Share * share = [[Share alloc]init];
            [share shareToWeiXinFriendsWithMode:mode];
        }
            break;
        default:
            break;
    }

}

/**
 *  分享到微信呢朋友圈
 *
 *  @param mode 分享的内容
 */
- (void)shareToWeiXinWithMode:(ShareMode *)mode
{
    CGRect bounds = CGRectMake(0, 0, 100, 100);
    UIGraphicsBeginImageContext(bounds.size);
    [mode.image drawInRect:bounds];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //设置分享的内容<标题，描述，图片>
    WXMediaMessage * message = [WXMediaMessage message];
    [message setTitle:mode.title];
    [message setDescription:mode.message];
    [message setThumbImage:resizedImage];
    //构造WeiXin  WebPage对象
    WXWebpageObject * wxwbo = [WXWebpageObject object];
    [wxwbo setWebpageUrl:mode.url];
    [message setMediaObject:wxwbo];
    
    SendMessageToWXReq * req = [[SendMessageToWXReq alloc]init];
    [req setBText:NO]; //发送消息类型:此处选择了多媒体消息
    [req setMessage:message];
    [req setScene:WXSceneTimeline]; //分享至朋友圈
    
    [WXApi sendReq:req];
}

/**
 *  分享到微信好友
 *
 *  @param mode 分享的内容
 */
- (void)shareToWeiXinFriendsWithMode:(ShareMode *)mode
{
    CGRect bounds = CGRectMake(0, 0, 100, 100);
    UIGraphicsBeginImageContext(bounds.size);
    [mode.image drawInRect:bounds];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //设置分享的内容<标题，描述，图片>
    WXMediaMessage * message = [WXMediaMessage message];
    [message setTitle:mode.title];
    [message setDescription:mode.message];
    [message setThumbImage:resizedImage];
    //构造WeiXin  WebPage对象
    WXWebpageObject * wxwbo = [WXWebpageObject object];
    [wxwbo setWebpageUrl:mode.url];
    [message setMediaObject:wxwbo];
    
    SendMessageToWXReq * req = [[SendMessageToWXReq alloc]init];
    [req setBText:NO]; //发送消息类型:此处选择了多媒体消息
    [req setMessage:message];
    [req setScene:WXSceneSession]; //分享至微信好友
    
    BOOL ret = [WXApi sendReq:req];
    NSLog(@"ret = %d",ret);
}

/**
 *  sharedUtility使用单例模式(可以通过sharedUtility来调用Share的减方法，当加方法不能直接用的时候)
 *
 *  @return self
 */
+ (Share *)sharedUtility
{
    static Share * share;
    @synchronized(self) {
        if (!share){
            share = [[Share alloc]init];
        }
    }
    return share;
}

/**
 *  当用户没有安装微信的时候，下载微信
 *
 *  @param _appId     微信的app_id（可在ituns微信下载页面里找到）
 *  @param controller 当前下载视图
 */
- (void)showAppInApp:(NSString *)_appId AndWithController:(UIViewController *)controller
{
    Class isAllow = NSClassFromString(@"SKStoreProductViewController");
    if (isAllow != nil) {
        SKStoreProductViewController *sKStoreProductViewController = [[SKStoreProductViewController alloc] init];
        sKStoreProductViewController.delegate = self;
        [sKStoreProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: _appId}
                                                completionBlock:^(BOOL result, NSError *error) {
                                                    if (result) {
                                                        [controller presentViewController:sKStoreProductViewController
                                                                           animated:YES
                                                                         completion:nil];
                                                    }
                                                    else{
                                                        NSLog(@"%@",error);
                                                    }
                                                }];
    }
    else{
        //低于iOS6没有这个类
        NSString *string = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8",_appId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    }
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
