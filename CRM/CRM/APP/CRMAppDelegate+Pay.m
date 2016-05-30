//
//  CRMAppDelegate+Pay.m
//  CRM
//
//  Created by Argo Zhang on 16/5/30.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "CRMAppDelegate+Pay.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation CRMAppDelegate (Pay)

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [WXApi handleOpenURL:url delegate:self];
    WS(weakSelf);
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [weakSelf alipayWithResutl:resultDic];
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            [weakSelf alipayWithResutl:resultDic];
        }];
    }
    
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    [WXApi handleOpenURL:url delegate:self];
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        WS(weakSelf);
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [weakSelf alipayWithResutl:resultDic];
        }];
    }
    return YES;
}
#pragma mark - 支付宝支付回调
-(void)alipayWithResutl:(NSDictionary *)resultDic{
    NSString  *str = [resultDic objectForKey:@"resultStatus"];
    NSString *payResult;
    switch (str.intValue) {
        case 9000:{
            //支付成功
            payResult = @"支付成功";
            TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"支付提示" message:payResult cancel:@"知道了" certain:nil cancelHandler:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:AlipayPayedNotification object:PayedResultSuccess];
            } comfirmButtonHandlder:^{}];
            [alertView show];
            return;
        }
            break;
        case 6001:
            //用户取消支付
            payResult = @"取消支付";
            break;
        default:
            //订单支付失败
            payResult = @"支付失败";
            [[NSNotificationCenter defaultCenter] postNotificationName:AlipayPayedNotification object:PayedResultFailed];
            
            break;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"支付提示" message:payResult delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alertView show];
}

#pragma mark - WXApi delegate
-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma mark 微信返回
-(void)onResp:(BaseResp*)resp
{
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        switch (resp.errCode) {
            case WXSuccess:
            {
                payResoult = @"支付成功";
                TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"支付提示" message:payResoult cancel:@"知道了" certain:nil cancelHandler:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:WeixinPayedNotification object:PayedResultSuccess];
                } comfirmButtonHandlder:^{}];
                [alertView show];
                return;
            }
                break;
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                payResoult = @"支付失败";
                [[NSNotificationCenter defaultCenter] postNotificationName:WeixinPayedNotification object:PayedResultFailed];
                
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                payResoult = @"取消支付";
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                NSLog(@"发送失败");
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                payResoult = @"当前设备未安装微信";
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                payResoult = @"授权失败";
            }
                break;
            default:
                break;
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"支付提示" message:payResoult delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alertView show];
    }
    
}

@end
