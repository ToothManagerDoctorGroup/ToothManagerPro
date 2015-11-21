//
//  TTMClinicModel.h
//  ToothManager
//

#import <Foundation/Foundation.h>

/**
 *  诊所model
 */
@interface TTMClinicModel : NSObject

@property (nonatomic, assign) NSInteger keyId;

// 基础信息
/**
 *  营业时间
 */
@property (nonatomic, copy)   NSString *business_hours;
/**
 *  诊所id
 */
@property (nonatomic, assign) NSInteger clinic_id;
/**
 *  诊所图片
 */
@property (nonatomic, copy)   NSString *clinic_img;
/**
 *  诊所地址
 */
@property (nonatomic, copy)   NSString *clinic_location;
/**
 *  诊所简介
 */
@property (nonatomic, copy)   NSString *clinic_summary;
/**
 *  区域
 */
@property (nonatomic, copy)   NSString *clinic_area;
/**
 *  诊所名
 */
@property (nonatomic, copy)   NSString *clinic_name;
/**
 *  诊所电话
 */
@property (nonatomic, copy)   NSString *clinic_phone;
/**
 *  二维码图片地址
 */
@property (nonatomic, copy)   NSString *qrcodeImage;

// 汇总信息
/**
 *  收入
 */
@property (nonatomic, assign) NSInteger revenue;
/**
 *  医生数
 */
@property (nonatomic, assign) NSInteger doctor_count;
/**
 *  预约数
 */
@property (nonatomic, assign) NSInteger appoint_count;

// 银行卡信息
@property (nonatomic, copy)   NSString *bank_card;
@property (nonatomic, copy)   NSString *bank_name;
@property (nonatomic, copy)   NSString *cardholder;
@property (nonatomic, copy)   NSString *subbranch_name;
@property (nonatomic, assign) BOOL is_main; // 是否主卡

// 账户信息
/**
 *  已支付
 */
@property (nonatomic, assign) NSInteger paid;
/**
 *  未支付
 */
@property (nonatomic, assign) NSInteger unpaid;

/**
 *  缓存
 */
- (void)archive;

/**
 *  取出本地缓存
 *
 */
+ (instancetype)unArchive;

/**
 *  查询诊所详情
 */
+ (void)queryClinicDetailWithComplete:(CompleteBlock)complete;

/**
 *  查询诊所二维码
 */
+ (void)queryClinicQRCodeWithComplete:(CompleteBlock)complete;

/**
 *  查询诊所数据汇总信息
 */
+ (void)queryClinicSummaryWithComplete:(CompleteBlock)complete;

/**
 *  查询诊所银行卡信息
 */
+ (void)queryClinicBankWithComplete:(CompleteBlock)complete;

/**
 *  查询诊所账户信息
 */
+ (void)queryClinicAccountWithComplete:(CompleteBlock)complete;


/**
 *  余额提现
 */
+ (void)getCashWithMoney:(NSString *)money payPassword:(NSString *)payPassword complete:(CompleteBlock)complete;

/**
 *  修改诊所信息
 *
 *  @param clinic   诊所信息
 *  @param complete 回调
 */
+ (void)updateWithClinic:(TTMClinicModel *)clinic complete:(CompleteBlock)complete;

/**
 *  修改诊所地址
 *
 *  @param address  地址
 *  @param complete 回调
 */
+ (void)updateWithAddress:(NSString *)address complete:(CompleteBlock)complete;

/**
 *  编辑头像
 *
 *  @param headImage 头像文件
 *  @param complete  回调
 */
+ (void)editHeadImage:(UIImage *)headImage complete:(CompleteBlock)complete;

@end
