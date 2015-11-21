//
//  THCTimeButton.h
//  THCFramework
//

#import <UIKit/UIKit.h>

@protocol TTMTimeButtonDelegate;

/*!
 @class
 @abstract 计时的Button，用于有倒计时的事件处理，比如说获取验证码
 */
@interface TTMTimeButton : UIButton

/*!
 @property
 @abstract 倒计时的总时间，默认是30秒
 */
@property (nonatomic, assign) NSInteger startTime;

/*!
 @property
 @abstract 重新获取提示的title，默认是“请重新获取验证码”
 */
@property (nonatomic, copy) NSString *againTitle;

/*!
 @property
 @abstract THCTimeButtonDelegate代理
 */
@property (nonatomic, weak) id<TTMTimeButtonDelegate> delegate;

/*!
 @method
 @abstract 开启定时器
 @discussion 暴露该接口的目的在于NSTimer可能会导致内容的泄露，所以要在使用了该类的ViewController的viewWillAppear方法中调用该方法
 */
- (void)openTimer;

/*!
 @method
 @abstract 关闭定时器
 @discussion 暴露该接口的目的在于NSTimer可能会导致内容的泄露，所以要在使用了该类的ViewController的viewDidDisappear方法中调用该方法
 */
- (void)closeTimer;

/*!
 @method
 @abstract 重置按钮状态
 @discussion 重置按钮状态
 */
- (void)resetButtonWithTitle:(NSString *)title;

@end

/*!
 @protocol
 @abstract 计时的Button的代理，用来监听Button点击的事件，代理的方法必须实现
 */
@protocol TTMTimeButtonDelegate <NSObject>
@required
- (void)timeButtonDidClick:(TTMTimeButton *)timeButton;
@end
