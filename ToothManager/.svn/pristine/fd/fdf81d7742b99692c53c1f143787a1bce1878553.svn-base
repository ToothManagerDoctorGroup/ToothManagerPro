
#import <UIKit/UIKit.h>
#import "TTMApointmentModel.h"
@protocol TTMAppointmentingLineViewDelegate;

/**
 *  进行中cell行视图
 */
@interface TTMAppointmentingLineView : UIView

@property (nonatomic, strong) TTMApointmentModel *model;
@property (nonatomic, weak)   id<TTMAppointmentingLineViewDelegate> delegate;

@end

@protocol TTMAppointmentingLineViewDelegate <NSObject>

/**
 *  点击按钮回调
 *
 *  @param appointmentingLineView      行视图
 *  @param model                       model
 */
- (void)appointmentingLineView:(TTMAppointmentingLineView *)appointmentingLineView
                         model:(TTMApointmentModel *)model;

/**
 *  点击行，进入预约详情页
 *
 *  @param appointmentingLineView appointmentingLineView description
 *  @param model                  model description
 */
- (void)appointmentingLineView:(TTMAppointmentingLineView *)appointmentingLineView
          clickedLineWithModel:(TTMApointmentModel *)model;

@end