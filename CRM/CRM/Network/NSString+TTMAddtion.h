//
//  NSString+THCAddtion.h
//  THCFramework
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSString (TTMAddtion)

#pragma mark - 计算字符串截取等功能
/**
 *  判断是否存在字符串
 *
 *  @param string 需要判断的字符串
 *
 *  @return 如果存在返回YES，反之返回NO
 */
- (BOOL)isContainsString:(NSString *)string;

/**
 *  返回字符串中指定位置的字符
 *
 *  @param index 指定的位置
 *
 *  @return 返回的字符
 */
- (unichar)charAt:(NSUInteger)index;

/**
 *  检索某个字符串的位置
 *
 *  @param str 需要检索的字符串
 *
 *  @return 返回检索后的位置
 */
- (NSUInteger)indexOfString:(NSString*)str;

/**
 *  检索某个字符串的位置
 *
 *  @param str   需要检索的字符串
 *  @param index 起始位置(闭区间)
 *
 *  @return 返回检索后的位置
 */
- (NSUInteger)indexOfString:(NSString*)str fromIndex:(int)index;

/**
 *  检索第一个字符串出现的位置
 *
 *  @param str 需要检索的字符串
 *
 *  @return 返回检索后的位置
 */
- (NSUInteger)firstIndexOfString:(NSString *)str;

/**
 *  检索第一个字符串出现的位置
 *
 *  @param str   需要检索的字符串
 *  @param index 从什么位置开始检索
 *
 *  @return 返回检索后的位置
 */
- (NSUInteger)firstIndexOfString:(NSString*)str fromIndex:(int)index;

/**
 *  检索最后一个字符串出现的位置
 *
 *  @param str 需要检索的字符串
 *
 *  @return 返回检索后的位置
 */
- (NSUInteger)lastIndexOfString:(NSString*)str;

/**
 *  检索最后一个字符串出现的位置
 *
 *  @param str   需要检索的字符串
 *  @param index 从什么位置开始检索
 *
 *  @return 返回检索后的位置
 */
- (NSUInteger)lastIndexOfString:(NSString*)str fromIndex:(int)index;

/**
 *  截子串
 *
 *  @param beginIndex 开始的位置(闭区间)
 *  @param endIndex   结束的位子(开区间)
 *
 *  @return 返回截完后的字符串
 */
- (NSString *)substringFromIndex:(NSUInteger)beginIndex toIndex:(NSUInteger)endIndex;

/**
 *  去掉json字符串中的一头一尾的双引号
 *
 *  @return 返回截完后的JSON字符串
 */
- (NSString *)removeJsonStringQuotes;

/**
 *  去掉头尾空格
 *
 *  @return 返回去掉了头尾空格的字符串
 */
- (NSString *)trim;
/**
 *  获取某个字符串在当前字符串中的位置
 *
 *  @param targetStr 目标字符串
 *
 *  @return 位置数组
 */
- (NSArray *)indexOfTargetStr:(NSString *)targetStr;

/**
 *  改变指定字符串的颜色
 *
 *  @param range 字符串的位置
 *  @param color 颜色
 *
 *  @return 带有属性的字符串
 */
- (NSMutableAttributedString *)changeStrColorWithRange:(NSRange)range color:(UIColor *)color;

#pragma mark - 字符串的网络编码
/**
 *  返回encode编码后的url字符串
 *
 *  @return 返回encode编码后的url字符串
 */
- (NSString *)urlEncode;

/**
 *  返回decode编码后的url字符串
 *
 *  @return 返回decode编码后的url字符串
 */
- (NSString *)urlDecode;

#pragma mark - 计算字符串的frame
/**
 *  通过字体和size计算出字符串的CGRect
 *
 *  @param font 字体
 *  @param size size
 *
 *  @return 返回计算好的CGRect
 */
- (CGRect)measureFrameWithFont:(UIFont *)font size:(CGSize)size;

#pragma mark - MD5加密
- (NSString *)md5Encrypt;

#pragma mark - ThreeDES加密
+ (NSString*)encrypt:(NSString*)plainText withKey:(NSString*)key;
+ (NSString*)decrypt:(NSString*)encryptText withKey:(NSString*)key;
- (NSString*) sha1;
#pragma mark - ThreeDES加密方法二
+ (NSString *)TripleDES:(NSString *)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt encryptOrDecryptKey:(NSString *)encryptOrDecryptKey;
- (NSString *)TripleDESIsEncrypt:(BOOL)isEncrypt;
#pragma mark - 返回json对象
- (id)JSONObject;

#pragma mark - 将json字符串转换为字典
+ (NSDictionary *)dicFromJsonStr:(NSString *)jsonStr;

/**
 *  去掉字符串的单位
 *
 *  @return 没有单位的字符串
 */
- (NSString *)removeUnit;
/**
 *  判断字符串是否为空
 *
 *  @param string 需要判断的string
 *
 *  @return BOOL
 */
+ (BOOL)isEmpty:(NSString *)string;

/*!
 @method
 @abstract 获取设备
 @discussion 获取设备
 
 @result 返回对应的设备
 */
+ (NSString *)deviceString;

/**
 *  是否包含emoj表情
 *
 *  @param string 文本
 *
 *  @return BOOL
 */
+(BOOL)isContainsEmoji:(NSString *)string;

/**
 *  根据string返回date
 *
 *  @return date
 */
- (NSDate *)dateValue;

/**
 *  判断是否有值
 *
 *  @return bool
 */
- (BOOL)hasValue;

/**
 *  时分格式的日期
 *
 *  @return string
 */
- (NSString *)hourMinutesTimeFormat;

/**
 *  时分秒格式的日期
 *
 *  @return string
 */

- (NSString *)hourMinutesSecondTimeFormat;

/**
 *  从数字转换为字符串
 *
 *  @param number 数字
 *
 *  @return 字符串
 */
+ (NSString *)stringwithNumber:(NSNumber *)number;


/**
 *  判断是否是纯数字
 *
 *  @return 是否为数字
 */
- (BOOL)isPureNumandCharacters;
/**
 *  汉字转拼音
 *
 *  @return 转换后的拼音
 */
- (NSString *)chineseToPinyin;

- (NSString *)transformToPinyin;

/**
 *  判断是否为nil
 *
 *  @return 如果为nil，则返回@""
 */
- (NSString *)convertIfNill;

@end
