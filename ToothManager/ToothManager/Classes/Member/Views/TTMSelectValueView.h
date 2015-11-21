
#import <UIKit/UIKit.h>
#import "TTMMaterialModel.h"
@protocol TTMSelectValueViewDelegate;

/**
 *  选值视图
 */
@interface TTMSelectValueView : UIView

/**
 *  数据
 */
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) id<TTMSelectValueViewDelegate> delegate;

@property (nonatomic, weak) UIButton *clickedButton;

- (void)showInView:(UIView *)view;

- (void)dismiss;

@end

@protocol TTMSelectValueViewDelegate <NSObject>

- (void)selectValueView:(TTMSelectValueView *)selectValueView selectedModel:(TTMMaterialModel *)selectedModel;

@end
