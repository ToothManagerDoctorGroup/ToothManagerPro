

#import <UIKit/UIKit.h>
#import "TTMApointmentModel.h"
@protocol TTMCompleteAppointmentLineViewDelegate;

/**
 *  已完成的预约cell的行视图
 */
@interface TTMCompleteAppointmentLineView : UIView

/**
 *  行model
 */
@property (nonatomic, strong) TTMApointmentModel *model;

@property (nonatomic, weak)   id<TTMCompleteAppointmentLineViewDelegate> delegate;

@end

@protocol TTMCompleteAppointmentLineViewDelegate <NSObject>

/**
 *  点击按钮回调
 *
 *  @param completeAppointmentLineView 行视图
 *  @param model                       model
 */
- (void)completeAppointmentLineView:(TTMCompleteAppointmentLineView *)completeAppointmentLineView
                              model:(TTMApointmentModel *)model;

/**
 *  点击行视图
 *
 *  @param completeAppointmentLineView completeAppointmentLineView description
 *  @param model                       model description
 */
- (void)completeAppointmentLineView:(TTMCompleteAppointmentLineView *)completeAppointmentLineView
               clickedLineWithModel:(TTMApointmentModel *)model;

@end
