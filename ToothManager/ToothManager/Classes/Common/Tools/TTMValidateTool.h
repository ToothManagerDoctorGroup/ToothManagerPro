//
//  THCValidateTool.h
//  THCFramework
//

#import <Foundation/Foundation.h>

/**
 *  电话号码类型
 */
typedef NS_ENUM(NSUInteger, MobileNubmerType){
    /**
     *  不是电话号码
     */
    MobileNubmerTypeNone = 0,
    /**
     *  中国移动
     */
    MobileNubmerTypeChinaMobile,
    /**
     *  中国联通
     */
    MobileNubmerTypeChinaUnicom,
    /**
     *  中国电信
     */
    MobileNubmerTypeChinaTelecom,
    /**
     *  其它(座机)
     */
    MobileNubmerTypeOther
};

@interface TTMValidateTool : NSObject

/*!
 @method
 @abstract 判断电话号码
 @discussion 判断电话号码
 
 @param mobileNumber 需要判断的电话号码字符串
 
 @result 返回电话号码的类型
 */
+ (MobileNubmerType)isMobileNumber:(NSString *)mobileNumber;

/*!
 @method
 @abstract 判断是否是邮箱
 @discussion 判断是否是邮箱
 
 @param emailAddress 需要判断的邮箱地址
 
 @result 如果是邮箱地址返回YES，反之返回NO
 */
+ (BOOL)isEmailAddress:(NSString *)emailAddress;

/*!
 @method
 @abstract 判断是否是数字
 @discussion 判断是否是数字
 
 @param number 需要判断的数字
 
 @result 如果是数字返回YES，反之返回NO
 */
+ (BOOL)isNumber:(NSString *)number;

@end
