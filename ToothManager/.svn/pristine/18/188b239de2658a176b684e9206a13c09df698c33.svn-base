

#import <UIKit/UIKit.h>
#import "TTMAssistModel.h"
#import "TTMMaterialModel.h"

@protocol TTMUpdateSteperDelegate;

/**
 *  计步行视图
 */
@interface TTMUpdateStepper : UIView

/**
 *  助理模型
 */
@property (nonatomic, strong) TTMAssistModel *assistModel;

/**
 *  材料模型
 */
@property (nonatomic, strong) TTMMaterialModel *materialModel;

/**
 *  代理
 */
@property (nonatomic, weak) id<TTMUpdateSteperDelegate> delegate;

@end

@protocol TTMUpdateSteperDelegate <NSObject>

/**
 *  助手回调
 *
 *  @param updateSteper updateSteper description
 *  @param model        model description
 */
- (void)updateSteper:(TTMUpdateStepper *)updateSteper model:(TTMAssistModel *)model;

/**
 *  种植体回调
 *
 *  @param updateSteper  updateSteper description
 *  @param materialModel materialModel description
 */
- (void)updateSteper:(TTMUpdateStepper *)updateSteper materialModel:(TTMMaterialModel *)materialModel;

@end
