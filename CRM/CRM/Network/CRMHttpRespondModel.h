//
//  CRMHttpRespond.h
//  CRM
//
//  Created by Argo Zhang on 15/11/18.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface CRMHttpRespondModel : NSObject<MJKeyValue>

@property (nonatomic, copy)NSNumber *code;
@property (nonatomic, assign)id result;
@end
