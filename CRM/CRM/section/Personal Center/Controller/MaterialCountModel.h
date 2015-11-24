//
//  MaterialCountModel.h
//  CRM
//
//  Created by Argo Zhang on 15/11/24.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface MaterialCountModel : NSObject<MJKeyValue>
/**
 *  "KeyId": 2,
 "mat_name": "登腾",
 "mat_price": 1000,
 "mat_type": "1",
 "creation_time": "0001-01-01 00:00:00",
 "data_flag": 0
 num
 */
@property (nonatomic, copy)NSString *keyId;
@property (nonatomic, copy)NSString *mat_name;
@property (nonatomic, copy)NSString *mat_type;
@property (nonatomic, copy)NSString *mat_price;
@property (nonatomic, copy)NSString *creation_time;
@property (nonatomic, copy)NSString *data_flag;

@property (nonatomic, assign)NSInteger num;


@end
