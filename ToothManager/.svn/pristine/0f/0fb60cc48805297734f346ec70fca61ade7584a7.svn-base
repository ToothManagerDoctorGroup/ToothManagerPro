//
//  NSUserDefaults+THCAddtion.h
//  THCFramework
//

#import <Foundation/Foundation.h>

/*!
 @class
 @abstract NSUserDefaults的分类
 */
@interface NSUserDefaults (TTMAddtion)

/*!
 @method
 @abstract 获取App的版本号
 @discussion 获取App的版本号
 
 @result 返回App的版本号
 */
+ (NSString *)obtainAppVersion;

/*!
 @method
 @abstract 存储App的版本号
 @discussion 存储App的版本号
 
 @param version App的版本号
 */
+ (void)saveAppVersion;

/*!
 @method
 @abstract 获取App的Build版本号
 @discussion 获取App的Build版本号
 
 @result 返回App的Build版本号
 */
+ (NSString *)obtainAppBuildVersion;

/*!
 @method
 @abstract 存储App的Build版本号
 @discussion 存储App的Build版本号
 
 @param version App的Build版本号
 */
+ (void)saveAppBuildVersion;

/*!
 @method
 @abstract 检测是否有新版本的Launcher
 @discussion 检测是否有新版本的Launcher
 
 @param mainControllerBlock 加载主控制器的代码
 @param launchControllerBlock 加载LaunchController的代码
 @param isShow   如果版本不同，是否还是显示Launch
 */
+ (void)launchControllerWithMainControllerBlock:(void (^)())mainControllerBlock
                          launchControllerBlock:(void (^)())launchControllerBlock
                              isShowNewFeatures:(BOOL)isShow;

/**
 *  保存对象到NSUserDefaulst
 *
 *  @param object 需要保存的对象
 *  @param key    保存的key
 */

/*!
 @method
 @abstract 保存对象到NSUserDefaulst
 @discussion 保存对象到NSUserDefaulst
 
 @param object 需要保存的对象
 @param key    保存的key
 */
+ (void)saveObject:(id)object forKey:(NSString *)key;

/*!
 @method
 @abstract 获取保存的对象
 @discussion 获取保存的对象
 
 @param key 保存对象的key
 
 @result 获取的对象
 */
+ (id)obtainObjectForKey:(NSString *)key;

/**
 *  删除保存的对象
 *
 *  @param key 保存对象的key
 */

/*!
 @method
 @abstract 删除保存的对象
 @discussion 删除保存的对象
 
 @param key 保存对象的key
 */
+ (void)deleteObjectForKey:(NSString *)key;

@end
