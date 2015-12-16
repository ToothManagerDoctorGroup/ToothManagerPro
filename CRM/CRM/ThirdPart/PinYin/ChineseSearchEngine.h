//
//  ChineseSearchEngine.h
//  CRM
//
//  Created by TimTiger on 5/14/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChineseSearchEngine : NSObject

+ (NSArray *)resultArraySearchIntroducerOnArray:(NSArray *)dataArray withSearchText:(NSString *)searchText;
+ (NSArray *)resultArraySearchPatientsOnArray:(NSArray *)dataArray withSearchText:(NSString *)searchText;
+ (NSArray *)resultArraySearchGroupPatientsOnArray:(NSArray *)dataArray withSearchText:(NSString *)searchText;

+ (NSArray *)resultArraySearchMaterialOnArray:(NSArray *)dataArray withSearchText:(NSString *)searchText;
+ (NSArray *)resultArraySearchAddressBookOnArray:(NSArray *)dataArray withSearchText:(NSString *)searchText;
+ (NSArray *)resultArraySearchDoctorOnArray:(NSArray *)dataArray withSearchText:(NSString *)searchText;
+ (NSArray *)resultArraySearchRepairDoctorOnArray:(NSArray *)dataArray withSearchText:(NSString *)searchText;
@end
