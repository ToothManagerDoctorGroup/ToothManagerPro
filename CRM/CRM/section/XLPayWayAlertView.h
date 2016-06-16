//
//  XLPayWayAlertView.h
//  CRM
//
//  Created by Argo Zhang on 16/5/20.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

@class XLPayWayAlertView;

typedef NS_ENUM(NSInteger,XLPaymentMethod){
    XLPaymentMethodWeixin,//微信
    XLPaymentMethodAlipay   //支付宝
};

typedef void(^CertainButtonBlock)(XLPayWayAlertView *payAlertView,XLPaymentMethod paymentMethod);


@protocol XLPayWayAlertViewDelegate <NSObject>
@optional
- (void)payWayAlertView:(XLPayWayAlertView *)payAlertView paymentMethod:(XLPaymentMethod)paymentMethod;

@end

@interface XLPayWayAlertView : UIView

- (instancetype)initWithPrice:(NSString *)price delegate:(id<XLPayWayAlertViewDelegate>)delegate;

- (instancetype)initWithPrice:(NSString *)price certainButtonBlock:(CertainButtonBlock)certainButtonBlock;

- (void)show;

@end



@interface XLPayWayAlertViewModel : NSObject

@property (nonatomic, assign)XLPaymentMethod paymentMethod;//付款方式
@property (nonatomic, copy)NSString *payMethodTitle;//名称
@property (nonatomic, assign, getter=isSelect)BOOL select;//是否被选中

- (instancetype)initWithPaymentMethod:(XLPaymentMethod)method
                       payMethodTitle:(NSString *)methodTitle
                             select:(BOOL)select;

@end
