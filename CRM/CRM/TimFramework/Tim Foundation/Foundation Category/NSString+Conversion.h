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

//format YYYY:MM:DD HH:MM:SS
+ (NSString *)currentDateFiveMinuteString;

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
/**
 *  计算字符串中的字符总数
 *
 *  @param str 原始字符串
 *
 *  @return 字符总数
 */
- (int)charaterCount;
/**
 *  验证所有的手机号码
 *
 *  @param telNumber 手机号
 *
 *  @return 是否符合
 */
+ (BOOL)checkTelNumber:(NSString *) telNumber;

/**
 *  验证所有的电话号码，包括手机号和座机号
 *
 *  @param phoneNumber 号码
 *
 *  @return 是否符合
 */
+ (BOOL)checkAllPhoneNumber:(NSString *) phoneNumber;
/**
 *  验证身份证号码
 *
 *  @param idCard 身份证号
 *
 *  @return 验证结果
 */
+ (ValidationResult)checkIDCard:(NSString *)idCard;
/**
 *  验证字符串是否符合长度
 *
 *  @param string 原始字符串
 *  @param length 固定长度
 *
 *  @return 验证结果
 */
- (ValidationResult)isValidLength:(int)length;
+ (ValidationResult)isValidLength:(NSString *)string length:(int)length;

@end