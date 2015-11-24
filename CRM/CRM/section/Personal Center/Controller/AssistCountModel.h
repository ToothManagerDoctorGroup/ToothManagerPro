//
//  AssistCountModel.h
//  CRM
//
//  Created by Argo Zhang on 15/11/24.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface AssistCountModel : NSObject<MJKeyValue>

/*"KeyId": 2,
"assist_name": "研究生",
"assist_price": 260,
"assist_type": "研究生",
"creation_time": "0001-01-01 00:00:00",
"data_flag": 0*/

@property (nonatomic, copy)NSString *keyId;
@property (nonatomic, copy)NSString *assist_name;
@property (nonatomic, copy)NSString *assist_price;
@property (nonatomic, copy)NSString *assist_type;
@property (nonatomic, copy)NSString *creation_time;
@property (nonatomic, copy)NSString *data_flag;

@property (nonatomic, assign)NSInteger num;


@end
