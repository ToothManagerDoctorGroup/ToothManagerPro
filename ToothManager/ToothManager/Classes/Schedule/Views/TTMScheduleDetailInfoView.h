//
//  TTMScheduleDetailInfoView.h
//  ToothManager
//

#import <UIKit/UIKit.h>
@class TTMScheduleCellModel;

/**
 *  预约详细信息View
 */
@interface TTMScheduleDetailInfoView : UIView
/**
 *  实例化
 *
 *  @param model 数据model
 *
 *  @return return value description
 */
- (instancetype)initWithModel:(TTMScheduleCellModel *)model;

@end
