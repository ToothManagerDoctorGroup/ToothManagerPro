//
//  NSString+THCAddtion.m
//  THCFramework
//

#import "NSString+TTMAddtion.h"
#import "CommonCrypto/CommonDigest.h"
#import "sys/utsname.h"
#import "GTMBase64.h"
#import "PinYinForObjc.h"

// 前端与后台商量KEY
#define gkey @"ihaveadream&!haveadream@"
#define gIv  @""
#define kSecrectKeyLength 24

@implementation NSString (TTMAddtion)

- (BOOL)isContainsString:(NSString *)string {
    NSRange range = [self rangeOfString:string];
    return range.location != NSNotFound ? YES : NO;
}

- (unichar)charAt:(NSUInteger)index {
    return [self characterAtIndex:index];
}

- (NSUInteger)indexOfString:(NSString*)str {
    NSRange range = [self rangeOfString:str];
    if (range.location == NSNotFound) {
        return NSNotFound;
    }
    return range.location;
}

- (NSUInteger)indexOfString:(NSString*)str fromIndex:(int)index {
    NSRange fromRange = NSMakeRange(index, self.length - index);
    NSRange range = [self rangeOfString:str options:NSLiteralSearch range:fromRange];
    if (range.location == NSNotFound) {
        return NSNotFound;
    }
    return range.location;
}

- (NSUInteger)firstIndexOfString:(NSString *)str {
    NSRange range = [self rangeOfString:str options:NSCaseInsensitiveSearch];
    if (range.location == NSNotFound) {
        return NSNotFound;
    }
    return range.location;
}

- (NSUInteger)firstIndexOfString:(NSString*)str fromIndex:(int)index {
    NSRange fromRange = NSMakeRange(index, str.length - index);
    NSRange range = [self rangeOfString:str options:NSCaseInsensitiveSearch range:fromRange];
    if (range.location == NSNotFound) {
        return NSNotFound;
    }
    return range.location;
}

- (NSUInteger)lastIndexOfString:(NSString*)str {
    NSRange range = [self rangeOfString:str options:NSBackwardsSearch];
    if (range.location == NSNotFound) {
        return NSNotFound;
    }
    return range.location;
}

- (NSUInteger)lastIndexOfString:(NSString*)str fromIndex:(int)index {
    NSRange fromRange = NSMakeRange(0, index);
    NSRange range = [self rangeOfString:str options:NSBackwardsSearch range:fromRange];
    if (range.location == NSNotFound) {
        return NSNotFound;
    }
    return range.location;
}

- (NSString *)substringFromIndex:(NSUInteger)beginIndex toIndex:(NSUInteger)endIndex {
    if (endIndex <= beginIndex) {
        return @"";
    }
    NSRange range = NSMakeRange(beginIndex, endIndex - beginIndex);
    return [self substringWithRange:range];
}

- (NSString *)removeJsonStringQuotes {
    return self.length ? [self substringFromIndex:1 toIndex:(self.length - 1)] : @"";
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSArray *)indexOfTargetStr:(NSString *)targetStr{
    NSString *temp = nil;
    NSMutableArray *arrayM = [NSMutableArray array];
    for(int i =0; i < [self length]; i++)
    {
        temp = [self substringWithRange:NSMakeRange(i, 1)];
        if ([temp isEqualToString:targetStr]) {
            [arrayM addObject:@(i)];
        }
    }
    return arrayM;
}

- (NSMutableAttributedString *)changeStrColorWithRange:(NSRange)range color:(UIColor *)color{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self];
    //设置：在0-3个单位长度内的内容显示成红色
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    return str;
}

- (NSString *)urlEncode {
    CFStringRef encoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  (__bridge CFStringRef)self,
                                                                  NULL,
                                                                  CFSTR(":/?#[]@!$&'()*+,;="),
                                                                  kCFStringEncodingUTF8);
    return [NSString stringWithString:(__bridge_transfer NSString *)encoded];
}

- (NSString *)urlDecode {
    CFStringRef decoded = CFURLCreateStringByReplacingPercentEscapes( kCFAllocatorDefault,
                                                                     (__bridge CFStringRef)self,
                                                                     CFSTR(":/?#[]@!$&'()*+,;=") );
    return [NSString stringWithString:(__bridge_transfer NSString *)decoded];
}

- (CGRect)measureFrameWithFont:(UIFont *)font size:(CGSize)size {
    NSDictionary *attriDic = @{NSFontAttributeName : font};
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        CGRect strRect = [self boundingRectWithSize:size
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attriDic
                                            context:nil];
        return strRect;
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
        CGSize fontSize = [self sizeWithFont:font];
        CGRect strRect = CGRectMake(0.0f, 0.0f, fontSize.width, fontSize.height);
        return strRect;
#endif
    }
    return CGRectZero;
}

- (NSString *)md5Encrypt {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

#pragma mark - ThreeDES加密方法一
+ (NSString*)encrypt:(NSString *)plainText withKey:(NSString*)key{
    const char *cstr = [key cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [NSData dataWithBytes:cstr length:key.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(keyData.bytes, (CC_LONG)keyData.length, digest);
    
    uint8_t keyByte[kSecrectKeyLength];
    for (int i=0; i<16; i++) {
        keyByte[i] = digest[i];
    }
    for (int i=0; i<8; i++) {
        keyByte[16+i] = digest[i];
    }
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) keyByte;
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [GTMBase64 stringByEncodingData:myData];
    free(bufferPtr);
    
    return result;
}

+ (NSString*)decrypt:(NSString*)encryptText withKey:(NSString*)key{
    const char *cstr = [key cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:key.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    uint8_t keyByte[kSecrectKeyLength];
    for (int i=0; i<16; i++) {
        keyByte[i] = digest[i];
    }
    for (int i=0; i<8; i++) {
        keyByte[16+i] = digest[i];
    }
    
    NSData *encryptData = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) keyByte;
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                      length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    return result;
}
- (NSString*) sha1{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

#pragma mark - ThreeDES加密方法二
+ (NSString *)TripleDES:(NSString *)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt encryptOrDecryptKey:(NSString *)encryptOrDecryptKey
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)//解密
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else //加密
    {
        NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    const void *vkey = (const void *)[gkey UTF8String];
    // NSString *initVec = @"init Vec";
    //const void *vinitVec = (const void *) [initVec UTF8String];
    //  Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    else if (ccStatus == kCCParamError) return @"PARAM ERROR";
     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED";
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                length:(NSUInteger)movedBytes]
                                        encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    free(bufferPtr);
    
    return result;
}

- (NSString *)TripleDESIsEncrypt:(BOOL)isEncrypt{
    if ([EncryptionOpen isEqualToString:Auto_Action_Open]) {
        if (isEncrypt) {
            return [NSString TripleDES:self encryptOrDecrypt:kCCEncrypt encryptOrDecryptKey:NULL];
        }else{
            return [NSString TripleDES:self encryptOrDecrypt:kCCDecrypt encryptOrDecryptKey:NULL];
        }
    }else{
        return self;
    }
}


- (id)JSONObject {
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                           options:kNilOptions error:nil];
}

+ (NSDictionary *)dicFromJsonStr:(NSString *)jsonStr{
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    return dic;
}

- (NSString *)removeUnit {
    NSString *result = [self trim];
    NSError *error;
    NSRegularExpression *regex;
    if ([result containsString:@"."]) { // 小数
        regex = [NSRegularExpression regularExpressionWithPattern:@"(\\d+\\.\\d{1,2})"
                                                          options:0
                                                            error:&error];
    } else { // 整数
        regex = [NSRegularExpression regularExpressionWithPattern:@"(\\d+)"
                                                          options:0
                                                            error:&error];
    }
    if (regex) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:result
                                                             options:0
                                                               range:NSMakeRange(0, [result length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            result = [result substringWithRange:resultRange];
        }
    }
    return result;
}

+ (BOOL)isEmpty:(NSString *)string {
    return !string || string.length == 0;
}

+ (NSString *)deviceString {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSArray *modelArray = @[
                            
                            @"i386", @"x86_64",
                            
                            @"iPhone1,1",
                            @"iPhone1,2",
                            @"iPhone2,1",
                            @"iPhone3,1",
                            @"iPhone3,2",
                            @"iPhone3,3",
                            @"iPhone4,1",
                            @"iPhone5,1",
                            @"iPhone5,2",
                            @"iPhone5,3",
                            @"iPhone5,4",
                            @"iPhone6,1",
                            @"iPhone6,2",
                            @"iPhone7,1",
                            @"iPhone7,2",
                            @"iPhone8,1",
                            @"iPhone8,2",
                            
                            @"iPod1,1",
                            @"iPod2,1",
                            @"iPod3,1",
                            @"iPod4,1",
                            @"iPod5,1",
                            
                            @"iPad1,1",
                            @"iPad2,1",
                            @"iPad2,2",
                            @"iPad2,3",
                            @"iPad2,4",
                            @"iPad3,1",
                            @"iPad3,2",
                            @"iPad3,3",
                            @"iPad3,4",
                            @"iPad3,5",
                            @"iPad3,6",
                            
                            @"iPad2,5",
                            @"iPad2,6",
                            @"iPad2,7",
                            ];
    NSArray *modelNameArray = @[
                                
                                @"iPhone Simulator", @"iPhone Simulator",
                                
                                @"iPhone 2G",
                                @"iPhone 3G",
                                @"iPhone 3GS",
                                @"iPhone 4(GSM)",
                                @"iPhone 4(GSM Rev A)",
                                @"iPhone 4(CDMA)",
                                @"iPhone 4S",
                                @"iPhone 5(GSM)",
                                @"iPhone 5(GSM+CDMA)",
                                @"iPhone 5c(GSM)",
                                @"iPhone 5c(Global)",
                                @"iphone 5s(GSM)",
                                @"iphone 5s(Global)",
                                @"iphone 6Plus",
                                @"iphone 6",
                                @"iphone 6S",
                                @"iphone 6SPlus",
                                
                                @"iPod Touch 1G",
                                @"iPod Touch 2G",
                                @"iPod Touch 3G",
                                @"iPod Touch 4G",
                                @"iPod Touch 5G",
                                
                                @"iPad",
                                @"iPad 2(WiFi)",
                                @"iPad 2(GSM)",
                                @"iPad 2(CDMA)",
                                @"iPad 2(WiFi + New Chip)",
                                @"iPad 3(WiFi)",
                                @"iPad 3(GSM+CDMA)",
                                @"iPad 3(GSM)",
                                @"iPad 4(WiFi)",
                                @"iPad 4(GSM)",
                                @"iPad 4(GSM+CDMA)",
                                
                                @"iPad mini (WiFi)",
                                @"iPad mini (GSM)",
                                @"ipad mini (GSM+CDMA)"
                                ];
    NSInteger modelIndex = - 1;
    NSString *modelNameString = nil;
    modelIndex = [modelArray indexOfObject:deviceString];
    if (modelIndex >= 0 && modelIndex < [modelNameArray count]) {
        modelNameString = [modelNameArray objectAtIndex:modelIndex];
    }
    return modelNameString;
}

+(BOOL)isContainsEmoji:(NSString *)string {
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange,
                                         NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                // surrogate pair
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            isEomji = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        isEomji = YES;
                                    }
                                } else {
                                    // non surrogate
                                    if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                                        isEomji = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        isEomji = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        isEomji = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        isEomji = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 ||
                                               hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                                        isEomji = YES;
                                    }
                                }
    }];
    return isEomji;
}

- (NSDate *)dateValue {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:[self copy]];
    return date;
}

- (BOOL)hasValue {
    if (![self isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)hourMinutesTimeFormat {
    NSUInteger minutes = [self integerValue];
    
    NSUInteger hours = minutes / 60;
    NSUInteger minute = minutes % 60;
    
    NSString *result = nil;
    if (minute == 0) {
        result = [NSString stringWithFormat:@"%@小时", @(hours)];
    } else {
        result = [NSString stringWithFormat:@"%@小时%@分", @(hours), @(minute)];
    }
    return result;
}

- (NSString *)hourMinutesSecondTimeFormat {
    NSUInteger seconds = [self integerValue];
    NSUInteger minutes = seconds / 60;
    
    NSUInteger hours = minutes / 60;
    NSUInteger minute = minutes % 60;
    NSUInteger second = seconds % 60;
    
    NSString *result = [NSString stringWithFormat:@"%@小时%@分%@秒", @(hours), @(minute), @(second)];
    return result;
}

+ (NSString *)stringwithNumber:(NSNumber *)number {
    return [NSString stringWithFormat:@"%@", number];
}


#pragma mark - 判断是否是数字
- (BOOL)isPureNumandCharacters
{
    NSString *string = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

/** 汉字转拼音 */
- (NSString *)chineseToPinyin
{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)transformToPinyin{
    
    return [PinYinForObjc chineseConvertToPinYin:self];
}

- (NSString *)convertIfNill{
    if (self == nil) {
        return @"";
    }else{
        return self;
    }
}
@end
