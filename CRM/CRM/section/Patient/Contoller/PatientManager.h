//
//  PatientManager.h
//  CRM
//
//  Created by TimTiger on 5/31/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientManager : NSObject

#pragma mark - NewCaseViewController 
+ (NSString *)pathImageSaveToCache:(UIImage *)image withKey:(NSString *)key;

+ (NSString *)pathImageSaveToDisk:(UIImage *)image withKey:(NSString *)key;

+ (CGSize)getSizeWithString:(NSString *)string;

+ (UIImage *)pathImageGetFromDisk:(NSString *)key;

+ (BOOL)IsImageExisting:(NSString *)key;

@end
