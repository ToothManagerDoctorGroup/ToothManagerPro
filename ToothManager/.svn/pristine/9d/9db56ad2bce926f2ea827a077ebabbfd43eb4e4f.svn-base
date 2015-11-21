

#import <Foundation/Foundation.h>

/**
 *  实景图model
 */
@interface TTMRealisticModel : NSObject

/**
 *  唯一标志
 */
@property (nonatomic, assign) NSInteger KeyId;
/**
 *  备注
 */
@property (nonatomic, copy) NSString *remark;
/**
 *  诊所id
 */
@property (nonatomic, assign) NSInteger clinic_id;
/**
 *  图片信息
 */
@property (nonatomic, copy) NSString *img_info;

/**
 *  上传的图片
 */
@property (nonatomic, strong) UIImage *uploadImage;

/**
 *  椅位id
 */
@property (nonatomic, copy)   NSString *seat_id;


/**
 *  查询实景图信息
 *
 *  @param complete 回调
 */
+ (void)queryImagesWithComplete:(CompleteBlock)complete;

/**
 *  删除实景图
 *
 *  @param model    model
 *  @param complete 回调
 */
+ (void)deleteImageWithModel:(TTMRealisticModel *)model complete:(CompleteBlock)complete;

/**
 *  添加实景图
 *
 *  @param model    model
 *  @param complete 回调
 */
+ (void)addImageWithModel:(TTMRealisticModel *)model complete:(CompleteBlock)complete;

/////////////////////////////////////////////////
////                                         ////
////                 椅位图                  ////
////                                        ////
////////////////////////////////////////////////

/**
 *  查询椅位图信息
 *
 *  @param seatId   椅位id
 *  @param complete 回调
 */
+ (void)queryImagesWithSeatId:(NSString *)seatId complete:(CompleteBlock)complete;

/**
 *  添加椅位图
 *
 *  @param model    model
 *  @param complete 回调
 */
+ (void)addChairImageWithModel:(TTMRealisticModel *)model complete:(CompleteBlock)complete;

/**
 *  删除椅位图
 *
 *  @param model    model
 *  @param complete 回调
 */
+ (void)deleteChairImageWithModel:(TTMRealisticModel *)model complete:(CompleteBlock)complete;

@end
