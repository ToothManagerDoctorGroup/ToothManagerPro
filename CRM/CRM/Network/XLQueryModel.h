//
//  XLQueryModel.h
//  CRM
//
//  Created by Argo Zhang on 16/1/15.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  用于分页的模型
 */
@interface XLQueryModel : NSObject

//KeyWord//关键字
//SortField//排序字段【注：分组中排序字段直接传：姓名，状态，介绍人等】
//IsAsc//是否正序
//PageIndex//页码
//PageSize//每页大小

@property (nonatomic, copy)NSString *KeyWord;//关键字
@property (nonatomic, copy)NSString *SortField;//排序字段【注：分组中排序字段直接传：姓名，状态，介绍人等】
@property (nonatomic, strong)NSNumber *IsAsc;//是否正序
@property (nonatomic, strong)NSNumber *PageIndex;//页码
@property (nonatomic, strong)NSNumber *PageSize;//每页大小

- (instancetype)initWithKeyWord:(NSString *)keyWord sortField:(NSString *)sortField isAsc:(NSNumber *)isAsc pageIndex:(NSNumber *)pageIndex pageSize:(NSNumber *)pageSize;
@end
