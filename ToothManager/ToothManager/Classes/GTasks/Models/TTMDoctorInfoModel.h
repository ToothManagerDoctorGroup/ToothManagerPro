//
//  TTMDoctorInfoModel.h
//  ToothManager
//

#import <Foundation/Foundation.h>
/**
 *  医生资料model
 */
@interface TTMDoctorInfoModel : NSObject

/**
 *  性别
 */
@property (nonatomic, copy)   NSString *sex;
/**
 *  特长
 */
@property (nonatomic, copy)   NSString *special;
/**
 *  个人简介
 */
@property (nonatomic, copy)   NSString *introduce;
@end
