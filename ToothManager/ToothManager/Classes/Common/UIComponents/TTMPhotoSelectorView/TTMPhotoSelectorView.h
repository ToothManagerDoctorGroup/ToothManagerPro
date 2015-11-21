

#import <UIKit/UIKit.h>

#define kPhotoSelectorButtonW 80.0f

@protocol TTMPhotoSelectorViewDelegate;

@interface TTMPhotoSelectorView : UIView

/*!
 @property
 @abstract 能添加图片的最大个数，默认是列数
 */
@property (nonatomic, assign) NSUInteger maxImageNumber;

/*!
 @property
 @abstract 加号按钮的背景
 */
@property (nonatomic, copy) NSString *backgroundImage;

/*!
 @property
 @abstract 加号按钮的高亮背景
 */
@property (nonatomic, copy) NSString *hightlightBackgroundImage;

/*!
 @property
 @abstract 加号按钮的不可用背景
 */
@property (nonatomic, copy) NSString *disableBackgroundImage;

/*!
 @property
 @abstract 删除按钮的背景
 */
@property (nonatomic, copy) NSString *deleteButtonImage;

/*!
 @property
 @abstract 删除按钮的高亮背景
 */
@property (nonatomic, copy) NSString *deleteButtonHightlightImage;

/*!
 @property
 @abstract 加号是否要消失，YES为消失，NO为不消失，默认为不消失，如果不消失，达到最大值时，加号按钮不可用
 */
@property (nonatomic, assign) BOOL isAddButtonDisappear;

@property (nonatomic, weak) id<TTMPhotoSelectorViewDelegate> delegate;

- (void)addImage:(UIImage *)image;

- (NSArray *)photos;

@end

@protocol TTMPhotoSelectorViewDelegate <NSObject>

@required
- (void)photoSelectorView:(TTMPhotoSelectorView *)photoSelectorView didSelected:(UIButton *)button;

@end
