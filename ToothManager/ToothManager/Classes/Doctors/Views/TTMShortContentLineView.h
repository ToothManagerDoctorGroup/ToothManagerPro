//
//  TTMShortContentLineView.h
//  ToothManager
//

#import <UIKit/UIKit.h>

/**
 * 短内容行
 */
@interface TTMShortContentLineView : UIView

/**
 *  实例方法
 *
 *  @param title   标题
 *  @param content 内容
 *
 *  @return 实例
 */
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content;

@end
