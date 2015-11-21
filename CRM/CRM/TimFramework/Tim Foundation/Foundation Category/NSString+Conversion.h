//
//  NSString+Conversion.h
//  PhotoSharer
//
//  Created by TimTiger on 3/18/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Conversion)

//format YYYY:MM:DD HH:MM:SS
+ (NSString *)defaultDateString;

//format YYYY:MM:DD HH:MM:SS
+ (NSString *)currentDateString;


//format YYYY:MM:DD HH:MM:SS
+ (NSString *)defaultDateTenMinuteString;

//format YYYY:MM:DD HH:MM:SS
+ (NSString *)currentDateTenMinuteString;

- (NSDate *)stringToNSDate;

- (NSString *)MD5;

- (NSString *)stringIsEqualTo:(NSString *)str replaceByString:(NSString *)replace;

@end

@interface NSString (Empty)

+ (BOOL)isEmptyString:(NSString *)str;
+ (BOOL)isNotEmptyString:(NSString *)str;
- (BOOL)isEmpty;
- (BOOL)isNotEmpty;

@end

@interface NSString (date)

- (BOOL)isSameDay:(NSString *)string;
- (NSString *)stringYearMonthDay:(NSString *)string;

@end

typedef NS_ENUM(NSInteger,ValidationResult) {
    ValidationResultValid,                  //字符串符合格式
    ValidationResultValidateStringIsEmpty,  //验证字符串为空
    ValidationResultInValid,                //字符串不符合格式
};

@interface NSString (Regular)

/**
 *  检查是否是正确的邮箱地址
 *
 *  @param emailString 邮箱字符串
 *
 *  @return YES，有效，NO ,无效。
 */
- (ValidationResult)isValidEmail;
+ (ValidationResult)isValidEmail:(NSString *)emailString;

/**
 *  检查字符串是否符合指定格式
 *
 *  @param format 格式
 *
 *  @return YES,有效。 NO, 无效。
 */
- (ValidationResult)isValidWithFormat:(NSString *)format;
+ (ValidationResult)isValidString:(NSString *)string withFormat:(NSString *)format;

@end