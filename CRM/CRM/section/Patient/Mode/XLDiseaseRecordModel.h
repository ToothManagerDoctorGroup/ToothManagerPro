//
//  XLDiseaseRecordModel.h
//  CRM
//
//  Created by Argo Zhang on 16/3/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  病程记录模型
 */
@interface XLDiseaseRecordModel : NSObject

@property (nonatomic, copy)NSString *time;

@property (nonatomic, copy)NSString *type;

@property (nonatomic, strong)NSArray *images;//缩略图

@end
