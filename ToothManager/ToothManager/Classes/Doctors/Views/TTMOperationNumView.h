//
//  TTMOperationNumView.h
//  ToothManager
//

#import <UIKit/UIKit.h>
@class TTMGTaskCellModel;

/**
 *  手术量view
 */
@interface TTMOperationNumView : UIView
/**
 *  实例化
 *
 *  @param model model description
 *
 *  @return return value description
 */
- (instancetype)initWithModel:(TTMGTaskCellModel *)model;

@end
