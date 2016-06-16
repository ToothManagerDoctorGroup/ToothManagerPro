//
//  ComonMacro.h
//  PhotoSharer
//
//  Created by TimTiger on 3/14/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#ifndef PhotoSharer_ComonMacro_h
#define PhotoSharer_ComonMacro_h


#pragma mark - ----------------UIScreen------------------------------------------------------
#define SCREEN_WIDTH     ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT    ([UIScreen mainScreen].bounds.size.height)

#define APP_FRAME        [[UIScreen mainScreen] applicationFrame]
#define APP_SIZE         [[UIScreen mainScreen] applicationFrame].size

#pragma mark - -----------------Singleton-----------------------------------------------------
#undef Declare_ShareInstance
#define Declare_ShareInstance(__class) +(__class *)shareInstance

#undef Realize_ShareInstance
#define Realize_ShareInstance(__class) \
+(__class *)shareInstance { \
static dispatch_once_t onceToken; \
static __class *_instance_; \
dispatch_once(&onceToken, ^{ \
    _instance_ = [[__class alloc]init]; \
});   \
return _instance_;\
}

#pragma mark ------------------ignoreLeakWarning-----------------------------------------------------
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#pragma mark - -----------------System--------------------------------------------------------
#define SYSTEMVERSION [[UIDevice currentDevice].systemVersion floatValue]

#define IOS_9_OR_LATER (((SYSTEMVERSION) >= 9.0) ? YES:NO)
#define IOS_8_OR_LATER (((SYSTEMVERSION) >= 8.0) ? YES:NO)
#define IOS_7_OR_LATER (((SYSTEMVERSION) >= 7.0) ? YES:NO)
#define IOS_6_OR_LATER (((SYSTEMVERSION) >= 6.0) ? YES:NO)
#define IOS_5_OR_LATER (((SYSTEMVERSION) >= 5.0) ? YES:NO)
#define IOS_4_OR_LATER (((SYSTEMVERSION) >= 4.0) ? YES:NO)
#define IOS_3_OR_LATER (((SYSTEMVERSION) >= 3.0) ? YES:NO)

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)

#endif

#pragma mark - -------------------Func ---------------------------------------------------------

#define DEF_STATIC_CONST_STRING(name,string) \
static NSString * const name = @""#string;

#define DEF_URL static NSString * const


#pragma mark -------------------- Color -------------------------------------------------------

#define VIEWCONTROLLER_BACKGROUNDCOLOR (0xF8F8F8)

#pragma mark ---------------------- frame ,bounds ---------------------------------------------
#define SELF_VIEW_BOUNDS_WIDTH   self.view.bounds.size.width
#define SELF_VIEW_BOUNDS_HEIGHT self.view.bounds.size.height

#pragma mark -----------------------  EXTERN --------------------------------------------------
#ifdef __cplusplus
#define TIM_EXTERN		extern "C"
#else
#define TIM_EXTERN	    extern
#endif

