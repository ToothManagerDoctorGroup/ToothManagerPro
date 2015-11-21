

#import <UIKit/UIKit.h>
#import "TTMAppointmentingCellModel.h"
@protocol TTMApointmentingCellDelegate;

/**
 *  进行中预约cell
 */
@interface TTMApointmentingCell : UITableViewCell

@property (nonatomic, strong) TTMAppointmentingCellModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak)   id<TTMApointmentingCellDelegate> delegate;

@end

@protocol TTMApointmentingCellDelegate <NSObject>

/**
 *  点击按钮返回事件
 *
 *  @param apointmentingCell cell
 *  @param model             model
 */
- (void)apointmentingCell:(TTMApointmentingCell *)apointmentingCell model:(TTMApointmentModel *)model;

/**
 *  点击行进入详情
 *
 *  @param apointmentingCell apointmentingCell description
 *  @param model             model description
 */
- (void)apointmentingCell:(TTMApointmentingCell *)apointmentingCell clickedLineWithModel:(TTMApointmentModel *)model;

@end
