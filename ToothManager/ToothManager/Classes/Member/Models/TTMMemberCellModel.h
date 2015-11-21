//
//  TTMMemberCellModel.h
//  ToothManager
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TTMMemberCellModelAccessType) {
    TTMMemberCellModelAccessTypeArrow,
    TTMMemberCellModelAccessTypeButton,
    TTMMemberCellModelAccessTypeNone,
};

/**
 *  会员中心cellModel
 */
@interface TTMMemberCellModel : NSObject
/**
 *  标题
 */
@property (nonatomic, copy)   NSString *title;
/**
 *  内容
 */
@property (nonatomic, copy)   NSString *content;
/**
 *  按钮名
 */
@property (nonatomic, copy)   NSString *buttonTitle;
/**
 *  access样式
 */
@property (nonatomic, assign) TTMMemberCellModelAccessType accessType;
/**
 *  内容字体颜色
 */
@property (nonatomic, strong) UIColor *contenColor;
/**
 *  消息条数
 */
@property (nonatomic, assign) NSUInteger messageNum;
/**
 *  点击后需要跳转到的Controller
 */
@property (nonatomic, assign) Class controllerClass;

/**
 *  实例化model
 *
 *  @param title       名称
 *  @param content     内容
 *  @param buttonTitle 按钮名称
 *  @param contenColor 内容颜色
 *  @param messageNum  信息数
 *  @param accessType  access类型
 *
 *  @return 实例
 */
- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
                  buttonTitle:(NSString *)buttonTitle
                  contenColor:(UIColor *)contenColor
                   messageNum:(NSUInteger)messageNum
                   accessType:(TTMMemberCellModelAccessType)accessType;
@end
