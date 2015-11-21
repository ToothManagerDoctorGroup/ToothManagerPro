//
//  TTMLoseNumView.h
//  ToothManager
//

#import <UIKit/UIKit.h>
@class TTMGTaskCellModel;

/**
 *  失败率view
 */
@interface TTMLoseNumView : UIView
/**
 *  实例化
 *
 *  @param model model description
 *
 *  @return return value description
 */
- (instancetype)initWithModel:(TTMGTaskCellModel *)model;

@end
