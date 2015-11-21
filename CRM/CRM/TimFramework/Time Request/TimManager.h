//
//  TimManager.h
//  CRM
//
//  Created by TimTiger on 9/7/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RequestSuccessBlock)();
typedef void(^RequestFailedBlock)(NSError *error);

@interface TimManager : NSObject

@end
