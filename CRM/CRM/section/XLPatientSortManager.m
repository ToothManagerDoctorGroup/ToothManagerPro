//
//  XLPatientSortManager.m
//  CRM
//
//  Created by Argo Zhang on 16/4/22.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLPatientSortManager.h"
#import "PatientsCellMode.h"
#import "NSString+TTMAddtion.h"

@implementation XLPatientSortManager

+ (NSArray *)sortWithSourceArray:(NSArray *)sourceArray asc:(BOOL)isAsc sortStr:(PatientSortType)sortType{
    
    NSArray *targetArray = [NSArray array];
    NSString *sortKey;
    
    switch (sortType) {
        case PatientSortTypeMaterialCount:
            sortKey = @"countMaterial";
            targetArray = [self sortNumberWithSortKey:sortKey sourceArray:sourceArray isAsc:isAsc];
            break;
        case PatientSortTypeStatus:
            {
                sortKey = @"status";
                targetArray = [self sortNumberWithSortKey:sortKey sourceArray:sourceArray isAsc:isAsc];
            }
            break;
        default:
            if (sortType == PatientSortTypeName) {
                sortKey = @"name";
            }else if (sortType == PatientSortTypeIntrName){
                sortKey = @"introducerName";
            }
            targetArray = [self sortStringWithSortKey:sortKey sourceArray:sourceArray isAsc:isAsc];
            
            break;
    }
    
    return targetArray;
}
//排序数字
+ (NSArray *)sortNumberWithSortKey:(NSString *)sortKey sourceArray:(NSArray *)sourceArray isAsc:(BOOL)isAsc{
    NSArray *targetArray = [NSArray array];
    if (isAsc) {
        //升序
        targetArray = [sourceArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            PatientsCellMode *object1 = (PatientsCellMode *)obj1;
            PatientsCellMode *object2 = (PatientsCellMode *)obj2;
            if([[object1 valueForKeyPath:sortKey] integerValue] > [[object2 valueForKeyPath:sortKey] integerValue]){
                return  NSOrderedAscending;
            }
            if ([[object1 valueForKeyPath:sortKey] integerValue] < [[object2 valueForKeyPath:sortKey] integerValue]){
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }];
    }else{
        targetArray = [sourceArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            PatientsCellMode *object1 = (PatientsCellMode *)obj1;
            PatientsCellMode *object2 = (PatientsCellMode *)obj2;
            if([[object1 valueForKeyPath:sortKey] integerValue] < [[object2 valueForKeyPath:sortKey] integerValue]){
                return  NSOrderedAscending;
            }
            if ([[object1 valueForKeyPath:sortKey] integerValue] > [[object2 valueForKeyPath:sortKey] integerValue]){
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }];
    }
    return targetArray;
}
//排序字符串
+ (NSArray *)sortStringWithSortKey:(NSString *)sortKey sourceArray:(NSArray *)sourceArray isAsc:(BOOL)isAsc{
    NSArray *targetArray = [NSArray array];
    if (isAsc) {
        //升序
        targetArray = [sourceArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSComparisonResult result;
            PatientsCellMode *object1 = (PatientsCellMode *)obj1;
            PatientsCellMode *object2 = (PatientsCellMode *)obj2;
            result = [((NSString *)[object1 valueForKeyPath:sortKey]).transformToPinyin localizedCompare:((NSString *)[object2 valueForKeyPath:sortKey]).transformToPinyin];
            return result == NSOrderedAscending;
        }];
    }else{
        //降序
        targetArray = [sourceArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSComparisonResult result;
            PatientsCellMode *object1 = (PatientsCellMode *)obj1;
            PatientsCellMode *object2 = (PatientsCellMode *)obj2;
            result = [((NSString *)[object1 valueForKeyPath:sortKey]).transformToPinyin localizedCompare:((NSString *)[object2 valueForKeyPath:sortKey]).transformToPinyin];
            return result == NSOrderedDescending;
        }];
    }
    return targetArray;
}

@end
