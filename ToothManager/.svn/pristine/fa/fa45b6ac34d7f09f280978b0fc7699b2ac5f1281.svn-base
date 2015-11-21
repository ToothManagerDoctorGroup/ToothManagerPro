

#import <UIKit/UIKit.h>
#import "TTMCompleteApointmentCellModel.h"
#import "TTMApointmentModel.h"
@protocol TTMCompleteAppointmentCellDelegate;

/**
 *  已完成的预约cell
 */
@interface TTMCompleteAppointmentCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) TTMCompleteApointmentCellModel *model;

@property (nonatomic, weak)   id<TTMCompleteAppointmentCellDelegate> delegate;

@end

@protocol TTMCompleteAppointmentCellDelegate <NSObject>

/**
 *  点击按钮返回的对象
 *
 *  @param completeAppointmentCell cell
 *  @param model                   model
 */
- (void)completeAppointmentCell:(TTMCompleteAppointmentCell *)completeAppointmentCell
                          model:(TTMApointmentModel *)model;

/**
 *  点击行
 *
 *  @param completeAppointmentCell completeAppointmentCell description
 *  @param model                   model description
 */
- (void)completeAppointmentCell:(TTMCompleteAppointmentCell *)completeAppointmentCell
           clickedLineWithModel:(TTMApointmentModel *)model;
@end
