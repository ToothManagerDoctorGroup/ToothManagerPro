//
//  TTMGTaskCellModel.h
//  ToothManager
//

#import <Foundation/Foundation.h>

/**
 *  cell类型
 */
typedef NS_ENUM(NSUInteger, TTMGTaskCellModelType){
    /**
     *  待办事项cell
     */
    TTMGTaskCellModelTypeGTask,
    /**
     *  医生库cell
     */
    TTMGTaskCellModelTypeDoctors,
};

/**
 *  待办项，医生库cellModel
 */
@interface TTMGTaskCellModel : NSObject

/**
 *  cell类型
 */
@property (nonatomic, assign) TTMGTaskCellModelType type;
/**
 *  关键字
 */
@property (nonatomic, assign) NSInteger keyId;
/**
 *  星级
 */
@property (nonatomic, assign) NSInteger star_level;
/**
 *  头像
 */
@property (nonatomic, copy)   NSString *doctor_image;
/**
 *  医生名
 */
@property (nonatomic, copy)   NSString *doctor_name;
/**
 *  职位
 */
@property (nonatomic, copy)   NSString *doctor_position;
/**
 *  医院,(或者电话)
 */
@property (nonatomic, copy)   NSString *doctor_hospital;
/**
 *  科室
 */
@property (nonatomic, copy)   NSString *doctor_dept;
/**
 *  个人简历
 */
@property (nonatomic, copy)   NSString *individual_resume;
/**
 *  协议
 */
@property (nonatomic, copy)   NSString *protocol;
/**
 *  性别（1为男，0为女）
 */
@property (nonatomic, assign) NSUInteger doctor_gender;
/**
 *  种植数量
 */
@property (nonatomic, assign) NSInteger planting_quantity;


/**
 *  医生的字段
 */
/**
 *  医生电话
 */
@property (nonatomic, copy)   NSString *doctor_phone;
/**
 *  医生id
 */
@property (nonatomic, assign) NSUInteger doctor_id;
/**
 *  诊所id
 */
@property (nonatomic, assign) NSInteger clinic_id;
/**
 *  年龄
 */
@property (nonatomic, assign) NSInteger age;
/**
 *  擅长项目
 */
@property (nonatomic, copy)   NSString *main_project;
/**
 *  创建时间
 */
@property (nonatomic, copy)   NSString *creation_time;
/**
 *  前牙
 */
@property (nonatomic, assign) NSInteger anterior_teeth;
/**
 *  后牙
 */
@property (nonatomic, assign) NSInteger posterior_teeth;
/**
 *  单颗种植
 */
@property (nonatomic, assign) NSInteger signle_teeth;
/**
 *  全口种植
 */
@property (nonatomic, assign) NSInteger whole_teeth;
/**
 *  移植手术量
 */
@property (nonatomic, assign) NSInteger transplant_operation;
/**
 *  失败率
 */
@property (nonatomic, assign) NSInteger failure_rate;
/**
 *  当前segment状态，待处理0/已处理1
 */
@property (nonatomic, assign) NSInteger currentStatus;
/**
 *  状态，0待处理，1已签约，2已拒绝
 */
@property (nonatomic, assign) NSInteger is_sign;


/**
 *  查询待办事项列表
 */
+ (void)queryListWithStatus:(NSInteger)status complete:(CompleteBlock)complete;
/**
 *  查询待办事项详情
 */
+ (void)queryDetailWithId:(NSInteger)ID complete:(CompleteBlock)complete;
/**
 *  接受
 */
+ (void)agreeWithId:(NSInteger)ID complete:(CompleteBlock)complete;
/**
 *  拒绝
 */
+ (void)disagreeWithId:(NSInteger)ID complete:(CompleteBlock)complete;


/**
 *  查询医生列表
 */
+ (void)queryDoctorListWithComplete:(CompleteBlock)complete;

/**
 *  查询医生详情
 */
+ (void)queryDoctorDetailWithId:(NSInteger)ID complete:(CompleteBlock)complete;

@end
