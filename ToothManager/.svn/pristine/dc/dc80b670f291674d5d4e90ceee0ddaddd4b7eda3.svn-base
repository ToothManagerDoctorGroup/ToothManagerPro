//
//  TTMChairNoScrollView.h
//  ToothManager
//

#import <UIKit/UIKit.h>
@class TTMChairItemButton;
@protocol TTMChairNoScrollViewDelegate;

/**
 *  椅号滚动视图
 */
@interface TTMChairNoScrollView : UIView
/**
 *  椅号数组
 */
@property (nonatomic, strong) NSArray *chairNoArray;
/**
 *  代理
 */
@property (nonatomic, assign) id<TTMChairNoScrollViewDelegate> delegate;

@end

@protocol TTMChairNoScrollViewDelegate <NSObject>
/**
 *  点击的椅号按钮
 *
 *  @param scrollView self
 *  @param item       按钮
 */
- (void)chairNoScrollView:(TTMChairNoScrollView *)scrollView clickedItem:(TTMChairItemButton *)item;

@end
