
#import <Foundation/Foundation.h>

/**
 *  cell类型
 */
typedef NS_ENUM(NSUInteger, TTMClinicCellModelType){
    /**
     *  普通
     */
    TTMClinicCellModelTypeNormal,
    /**
     *  头像
     */
    TTMClinicCellModelTypeHead,
    /**
     *  二维码
     */
    TTMClinicCellModelTypeQRCode,
    /**
     *  输入框
     */
    TTMClinicCellModelTypeTextField,
};

/**
 *  诊所信息cellModel
 */
@interface TTMClinicInfoCellModel : NSObject

/**
 *  标题
 */
@property (nonatomic, copy)   NSString *title;
/**
 *  内容
 */
@property (nonatomic, copy)   NSString *content;
/**
 *  图片地址(头像和，二维码)
 */
@property (nonatomic, copy)   NSString *imageURL;
/**
 *  输入框内容
 */
@property (nonatomic, copy)   NSString *textFieldString;
/**
 *  cell类型
 */
@property (nonatomic, assign) TTMClinicCellModelType type;
/**
 *  页面跳转控制器
 */
@property (nonatomic, assign) Class controllerClass;


+ (instancetype)modelWithTitle:(NSString *)title
                       content:(NSString *)content
                      imageURL:(NSString *)imageURL
                          type:(TTMClinicCellModelType)type
               controllerClass:(Class)controllerClass;


@end
