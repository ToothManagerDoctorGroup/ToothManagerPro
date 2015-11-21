//
//  TTMDoctorInfoView.h
//  ToothManager
//

#import <UIKit/UIKit.h>
@class TTMDoctorInfoModel;

/**
 *  医生资料
 */
@interface TTMDoctorInfoView : UIView
/**
 *  实例化
 *
 *  @param model model description
 *
 *  @return return value description
 */
- (instancetype)initWithModel:(TTMDoctorInfoModel *)model;

@end
