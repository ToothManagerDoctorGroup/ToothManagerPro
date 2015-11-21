//
//  TTMBaseColorController.h
//  ToothManager
//

#import <UIKit/UIKit.h>

/**
 *  背景是颜色值的Controller，基类
 */
@interface TTMBaseColorController : UIViewController


/**
 *  设置右边按钮
 */
- (void)setupRightItem;

/**
 *  按钮事件
 *
 *  @param button button description
 */
- (void)buttonAction:(UIButton *)button;

@end

