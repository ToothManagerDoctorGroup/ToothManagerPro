//
//  NSUserDefaults+THCAddtion.m
//  THCFramework
//

#import "NSUserDefaults+TTMAddtion.h"

@implementation NSUserDefaults (TTMAddtion)

+ (NSString *)obtainAppVersion {
    return [self obtainObjectForKey:@"kVersion"];
}

+ (void)saveAppVersion {
    [self saveObject:[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"] forKey:@"kVersion"];
}

+ (NSString *)obtainAppBuildVersion {
    return [self obtainObjectForKey:@"kBuildVersion"];
}

+ (void)saveAppBuildVersion {
    [self saveObject:[NSBundle mainBundle].infoDictionary[@"CFBundleVersion"] forKey:@"kBuildVersion"];
}

+ (void)launchControllerWithMainControllerBlock:(void (^)())mainControllerBlock
                          launchControllerBlock:(void (^)())launchControllerBlock
                              isShowNewFeatures:(BOOL)isShow {
    
    NSString *newVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString *oldVersion = [self obtainAppVersion];
    // 如果版本相同，就加载主控制器的代码
    if ([oldVersion isEqualToString:newVersion]) {
        mainControllerBlock();
    } else {
        // 如果需要展示，就加载launchController的代码
        if (isShow) {
            launchControllerBlock();
        } else {
            mainControllerBlock();
        }
        [self saveAppVersion];
    }
}

+ (void)saveObject:(id)object forKey:(NSString *)key {
    NSUserDefaults *defaults = [self standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}

+ (id)obtainObjectForKey:(NSString *)key {
    return [[self standardUserDefaults] objectForKey:key];
}

+ (void)deleteObjectForKey:(NSString *)key {
    NSUserDefaults *defaults = [self standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

@end
