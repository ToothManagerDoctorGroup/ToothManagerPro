//
//  NSString+Conversion.m
//  PhotoSharer
//
//  Created by TimTiger on 3/18/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "NSString+Conversion.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSDate+Conversion.h"

@implementation NSString (Conversion)

- (NSDate *)stringToNSDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateFormatter dateFromString:self];
    return date;
}

+ (NSString *)defaultDateString {
    NSDate* defData = [NSDate dateWithTimeIntervalSince1970:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:defData];
}

+ (NSString *)currentDateString {
    NSDate* curDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:curDate];
}

+ (NSString *)defaultDateTenMinuteString{
    NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* date1 = [[NSDate alloc] init];
    date1 = [def dateByAddingTimeInterval:-600];
    NSString *string1 =  [dateFormatter stringFromDate:date1];
    
    return  string1;
}

+ (NSString *)currentDateTenMinuteString{
    NSDate* curDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* date1 = [[NSDate alloc] init];
    date1 = [curDate dateByAddingTimeInterval:-600];
    NSString *string1 =  [dateFormatter stringFromDate:date1];
    
    return  string1;
}

//format YYYY:MM:DD HH:MM:SS
+ (NSString *)currentDateFiveMinuteString{
    NSDate* curDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* date1 = [[NSDate alloc] init];
    date1 = [curDate dateByAddingTimeInterval:-300];
    NSString *string1 =  [dateFormatter stringFromDate:date1];
    
    return  string1;
}

- (NSString*)MD5
{
	// Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
 	// Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
	// Create 16 bytes MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
	// Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

- (NSString *)stringIsEqualTo:(NSString *)str replaceByString:(NSString *)replace {
    if ([self isEqualToString:str]) {
        return replace;
    }
    return self;
}

@end


@implementation NSString (Empty)

- (BOOL)isEmpty {
    
    if (self == nil || self.length < 1 || [self isEqual:[NSNull null]]) {
        return YES;
    }
    
    if(![[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        //string is all whitespace
        return YES;
    }

    return NO;
}

- (BOOL)isNotEmpty {
    if ([self isEmpty]) {
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)isEmptyString:(NSString *)str {
    
    if (str == nil || str.length < 1 || [str isEqual:[NSNull null]]) {
        return YES;
    }
    
    if (![[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        return  YES;
    }
    
    return NO;
}

+ (BOOL)isNotEmptyString:(NSString *)str {
    return ![NSString isEmptyString:str];
}

@end

@implementation NSString (date)

- (BOOL)isSameDay:(NSString *)string {
    NSDate *selfdate = [self stringToNSDate];
    NSDate *otherdate = [string stringToNSDate];
    return [selfdate isSameDay:otherdate];
}

- (NSString *)stringYearMonthDay:(NSString *)string {
    NSDate *date = [string stringToNSDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

@end

@implementation NSString (Regular)

/**
 *  检查是否是正确的邮箱地址
 *
 *  @param emailString 邮箱字符串
 *
 *  @return YES，有效，NO ,无效。
 */
- (ValidationResult)isValidEmail {
    return [NSString isValidString:self withFormat:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

+ (ValidationResult)isValidEmail:(NSString *)emailString {
    return [NSString isValidString:emailString withFormat:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

/**
 *  检查字符串是否符合指定格式
 *
 *  @param format 格式
 *
 *  @return YES,有效。 NO, 无效。
 */
- (ValidationResult)isValidWithFormat:(NSString *)format {
    return [NSString isValidString:self withFormat:format];
}

+ (ValidationResult)isValidString:(NSString *)string withFormat:(NSString *)format {
    if ([string isEmpty]) {
        return ValidationResultValidateStringIsEmpty;
    }
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", format];
    BOOL ret = [emailTest evaluateWithObject:string];
    if (ret) {
        return ValidationResultValid;
    }
    return ValidationResultInValid;
}


- (int)charaterCount{
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;

}

+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    
    
//    NSString *pattern = @"^((13[0-9])|(147)|(15[^4,\\D])|(17[0-9])|(18[0,5-9]))\\d{8}$";
    NSString *pattern = @"^[1][34578]\\d{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

+ (BOOL)checkAllPhoneNumber:(NSString *)phoneNumber{
//    NSString *pattern = @"^(0[0-9]{2,3}/-)?([2-9][0-9]{6,7})+(/-[0-9]{1,4})?$";
    NSString *pattern = @"^([1][34578]\\d{9})$|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    
    if (isMatch) {
        return YES;
    }
    
    return NO;
}

+ (ValidationResult)checkIDCard:(NSString *)idCard{
    return [self isValidString:idCard withFormat:@"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$"];
}
/**
 *  验证字符串是否符合长度
 *
 *  @param string 原始字符串
 *  @param length 固定长度
 *
 *  @return 验证结果
 */
- (ValidationResult)isValidLength:(int)length{
    return [NSString isValidLength:self length:length];
}
+ (ValidationResult)isValidLength:(NSString *)string length:(int)length{
    if ([string isEmpty]) {
        return ValidationResultValidateStringIsEmpty;
    }
    //获取字符串的长度
    int len = [string charaterCount];
    if (len > length) {
        return ValidationResultInValid;
    }
    
    return ValidationResultValid;
}

@end