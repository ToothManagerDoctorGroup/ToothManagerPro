//
//  XLAdviceTypeModel.h
//  CRM
//
//  Created by Argo Zhang on 16/4/28.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  医嘱类型
 */
@interface XLAdviceTypeModel : NSObject

@property (nonatomic, strong)NSNumber *keyId;
@property (nonatomic, copy)NSString *creation_time;
@property (nonatomic, copy)NSString *type_desc;
@property (nonatomic, copy)NSString *type_name;

@end
