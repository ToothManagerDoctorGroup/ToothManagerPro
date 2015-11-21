
#import <Foundation/Foundation.h>
#import "TTMApointmentModel.h"

/**
 *  已完成的我的预约的cellModel
 */
@interface TTMCompleteApointmentCellModel : NSObject

/**
 *  年份
 */
@property (nonatomic, copy)   NSString *year;
/**
 *  月份
 */
@property (nonatomic, copy)   NSString *month;
/**
 *  这月的列表(TTMApointmentModel.h)
 */
@property (nonatomic, strong) NSMutableArray *infoList;
/**
 *  cell高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
