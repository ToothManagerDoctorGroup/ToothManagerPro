//
//  THCValidateTool.m
//  THCFramework
//

#import "TTMValidateTool.h"

@implementation TTMValidateTool

+ (MobileNubmerType)isMobileNumber:(NSString *)mobileNumber {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,147,150,151,152,157,158,159,178,182,183,184,187,188
     * 联通：130,131,132,145,152,155,156,176,185,186
     * 电信：133,1349,153,177,180,181,189
     */
    NSString * MOBILE = @"^1(3[0-9]|4[57]|5[0-235-9]|7[06-8]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|47|5[0-27-9]|78|8[2-478])\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    NSString * CU = @"^1(3[0-2]|45|5[256]|176|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,181,189
     */
    NSString * CT = @"^1((33|53|77|8[019])[0-9]|349)\\d{7}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
     NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *chinaMobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *chinaUnicomTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *chinaTelecomTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *phsTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    if ([mobileTest evaluateWithObject:mobileNumber] == YES) {
        if ([chinaMobileTest evaluateWithObject:mobileNumber] == YES) {
            return MobileNubmerTypeChinaMobile;

        } else if ([chinaUnicomTest evaluateWithObject:mobileNumber] == YES) {
            return MobileNubmerTypeChinaUnicom;

        } else if([chinaTelecomTest evaluateWithObject:mobileNumber] == YES) {
            return MobileNubmerTypeChinaTelecom;

        } else{
            return MobileNubmerTypeOther;
        }
    } else {
        if ([phsTest evaluateWithObject:mobileNumber] == YES) {
            return MobileNubmerTypeOther;
            
        } else {
            return MobileNubmerTypeNone;
        }
    }
}

+ (BOOL)isEmailAddress:(NSString *)emailAddress {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailAddress];
}

+ (BOOL)isNumber:(NSString *)number{
    NSString *reg = @"^[0-9]*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [numberTest evaluateWithObject:number];
}

@end
