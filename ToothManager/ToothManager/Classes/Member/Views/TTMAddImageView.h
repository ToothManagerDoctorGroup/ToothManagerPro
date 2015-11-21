

#import <UIKit/UIKit.h>
#import "TTMRealisticModel.h"
@protocol TTMAddImageViewDelegate;

/**
 *  实景图片，椅位配置图片添加视图
 */
@interface TTMAddImageView : UIView

/**
 *  图片数组,类型为(TTMRealisticModel.h)
 */
@property (nonatomic, strong) NSMutableArray *photoArray;

@property (nonatomic, weak)   id<TTMAddImageViewDelegate> delegate;

/**
 *  刷新视图
 */
- (void)reloadView;

@end

@protocol TTMAddImageViewDelegate <NSObject>

/**
 *  点击图片返回的model
 *
 *  @param addImageView addImageView description
 *  @param model        model description
 */
- (void)addImageView:(TTMAddImageView *)addImageView clickedWithModel:(TTMRealisticModel *)model button:(UIButton *)button;

/**
 *  点击删除按钮
 *
 *  @param addImageView addImageView description
 *  @param model        model description
 */
- (void)addImageView:(TTMAddImageView *)addImageView deleteWithModel:(TTMRealisticModel *)model;


@end
