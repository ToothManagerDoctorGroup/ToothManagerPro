//
//  TTMDoctorTool.h
//  ToothManager
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 roger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTMDoctorModel.h"

@interface TTMDoctorTool : NSObject

/*获取医生的详细信息*/
+ (void)requestDoctorInfoWithDoctorId:(NSString *)doctorId success:(void(^)(TTMDoctorModel *dcotorInfo))success failure:(void(^)(NSError *error))failure;

@end
