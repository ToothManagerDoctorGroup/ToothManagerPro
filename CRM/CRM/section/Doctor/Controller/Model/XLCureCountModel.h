//
//  XLCureCountModel.h
//  CRM
//
//  Created by Argo Zhang on 16/3/11.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  医生详情数据统计模型
 */
@interface XLCureCountModel : NSObject

@property (nonatomic, strong)NSArray *cureByMe;
@property (nonatomic, strong)NSArray *cureByHim;
@property (nonatomic, strong)NSArray *introByHim;
@property (nonatomic, strong)NSArray *introByMe;

@end
