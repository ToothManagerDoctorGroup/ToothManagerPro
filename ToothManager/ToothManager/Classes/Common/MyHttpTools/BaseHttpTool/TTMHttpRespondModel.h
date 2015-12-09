//
//  TTMHttpRespondModel.h
//  ToothManager
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 roger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTMHttpRespondModel : NSObject<MJKeyValue>

@property (nonatomic, copy)NSNumber *code;
@property (nonatomic, assign)id result;

@end
