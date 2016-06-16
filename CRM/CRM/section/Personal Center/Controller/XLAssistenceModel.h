//
//  XLAssistenceModel.h
//  CRM
//
//  Created by Argo Zhang on 16/3/17.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLAssistenceModel : NSObject

@property (nonatomic, strong)NSNumber *keyId;
@property (nonatomic, copy)NSString *help_name;
@property (nonatomic, copy)NSString *help_url;
@property (nonatomic, copy)NSString *help_des;
@property (nonatomic, copy)NSString *create_time;
@property (nonatomic, strong)NSNumber *sort_num;

@end
