//
//  TTMDoctorDetailController.h
//  ToothManager
//

#import <UIKit/UIKit.h>
#import "TTMBaseColorController.h"
@class TTMGTaskCellModel;

/**
 *  医生库详情
 */
@interface TTMDoctorDetailController : TTMBaseColorController

/**
 *  cell传递过来的model
 */
@property (nonatomic, strong) TTMGTaskCellModel *model;

@end
