//
//  XLPatientSortManager.h
//  CRM
//
//  Created by Argo Zhang on 16/4/22.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  患者排序
 */

typedef NS_ENUM(NSInteger,PatientSortType){
    PatientSortTypeName,
    PatientSortTypeStatus,
    PatientSortTypeIntrName,
    PatientSortTypeMaterialCount
};

@class PatientsCellMode;
@interface XLPatientSortManager : NSObject
/**
 *  排序数组
 *
 *  @param sourceArray 目标数组
 *  @param isAsc       是否是升序
 *  @param sortStr     排序的字段
 *
 *  @return 排序后的数组
 */
+ (NSArray *)sortWithSourceArray:(NSArray *)sourceArray asc:(BOOL)isAsc sortStr:(PatientSortType)sortType;

@end
