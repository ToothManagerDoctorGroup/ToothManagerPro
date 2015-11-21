
#import <UIKit/UIKit.h>

@protocol TTMStepViewDelegate;

/*!
 @class
 @abstract 记步控件
 */
@interface TTMStepView : UIView

/*!
 @property
 @abstract 最小数值，默认是0
 */
@property (nonatomic, assign) NSInteger min;

/*!
 @property
 @abstract 最大数值，默认是100
 */
@property (nonatomic, assign) NSInteger max;

/*!
 @property
 @abstract 数值的颜色，默认是黑色
 */
@property (nonatomic, strong) UIColor *numberLabelColor;

/*!
 @property
 @abstract 数值为0的颜色，默认是黑色
 */
@property (nonatomic, strong) UIColor *zeroNumberLabelColor;

/*!
 @property
 @abstract 负数数值的颜色，默认是绿色
 */
@property (nonatomic, strong) UIColor *negativeNumberLabelColor;

/*!
 @property
 @abstract 当前的数字
 */
@property (nonatomic, assign) NSInteger currentNumber;

/*!
 @property
 @abstract 步长，默认是1
 */
@property (nonatomic, assign) NSInteger step;

/*!
 @property
 @abstract 加价是否可用，默认是不可用
 */
@property (nonatomic, assign) BOOL addEnable;

/*!
 @property
 @abstract 减价是否可用，默认是不可用
 */
@property (nonatomic, assign) BOOL minusEnable;

/*!
 @property
 @abstract 从零开始加的时候，第一次是否加step的一半
 */
@property (nonatomic, assign) BOOL isAddHalfStepFromZero;

@property (nonatomic, weak) id<TTMStepViewDelegate> delegate;

@end

@protocol TTMStepViewDelegate <NSObject>

@required
- (void)stepView:(TTMStepView *)stepView currentNumber:(NSInteger)currentNumber;

@end
