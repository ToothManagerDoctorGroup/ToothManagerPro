
#import <Foundation/Foundation.h>

/**
 *  银行卡
 */
@interface TTMBankModel : NSObject

/**
 *  唯一id
 */
@property (nonatomic, assign) NSInteger keyId;
/**
 *  卡号
 */
@property (nonatomic, copy)   NSString *bank_card;
/**
 *  持卡人
 */
@property (nonatomic, copy)   NSString *cardholder;
/**
 *  银行卡名称
 */
@property (nonatomic, copy)   NSString *bank_name;
/**
 *  分行
 */
@property (nonatomic, copy)   NSString *subbranch_name;
/**
 *  是否主卡
 */
@property (nonatomic, copy)   NSString *is_main;

/**
 *  添加银行卡
 *
 *  @param model    银行卡信息
 *  @param complete 回调
 */
+ (void)addBankWithModel:(TTMBankModel *)model complete:(CompleteBlock)complete;

/**
 *  修改银行卡
 *
 *  @param model    银行卡信息
 *  @param complete 回调
 */
+ (void)updateBankWithModel:(TTMBankModel *)model complete:(CompleteBlock)complete;

@end
