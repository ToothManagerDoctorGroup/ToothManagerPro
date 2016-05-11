//
//  DBTableMode.h
//  CRM
//
//  Created by TimTiger on 5/15/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const RepeatIntervalDay;
extern NSString * const RepeatIntervalWeek;
extern NSString * const RepeatIntervalMonth;
extern NSString * const RepeatIntervalNone;

typedef NS_ENUM(NSInteger,ExpenseState){
    ExpenseStateUpdate = 0, //修改
    ExpenseStateAdd = 1,    //新增
    ExpenseStateDelete = 2  //删除
};

typedef NS_ENUM(NSInteger, MaterialType) {
    MaterialTypeOther = 1,
    MaterialTypeMaterial = 2,
// MaterialTypeNuoBeiEr = 2,  //诺贝尔，ITI，奥齿泰，费亚丹 D​E​N​T​I​S
// MaterialTypeITI = 3,
//  MaterialTypeAoChiTai = 4,
//    MaterialTypeFeiYaDan = 5,
//    MaterialTypeDENTIS = 6,
};

typedef NS_ENUM(NSInteger, PatientStatus) {
    PatientStatusUntreatment = 0 ,//未就诊
    PatientStatusUnplanted ,   //未种植
    PatientStatusUnrepaired , //已种植未修复
    PatientStatusRepaired ,   //已修复
    PatientStatuspeAll,    //所有患者
    PatientStatusUntreatUnPlanted, //未就诊 和 未种植的   0是未就诊，1未种植，2已种未修，3已修复。
};

typedef NS_ENUM(NSInteger, AuthStatus) {
    AuthStatusNotApply,        //未申请
    AuthStatusInProgress,      //认证中
    AuthStatusPassed,          //认证通过
    AuthStatusNotPass,         //认证未通过
};

@class FMResultSet;
typedef CGFloat Money;

@interface DBTableMode : NSObject

@property (nonatomic,copy) NSString *ckeyid;     //全局唯一key
@property (nonatomic,copy) NSString *user_id;    //医生id
@property (nonatomic,copy) NSString *doctor_id;    //医生id

@end

@interface Doctor : DBTableMode

@property (nonatomic,copy) NSString *doctor_name;          //医生姓名
@property (nonatomic,copy) NSString *doctor_dept;          //科室
@property (nonatomic,copy) NSString *doctor_phone;         //电话
@property (nonatomic,copy) NSString *doctor_email;         //邮箱
@property (nonatomic,copy) NSString *doctor_hospital;      //医院
@property (nonatomic,copy) NSString *doctor_position;      //职称
@property (nonatomic,copy) NSString *doctor_degree;        //学历
@property (nonatomic,copy) NSString *doctor_image;        //头像
@property (nonatomic)      AuthStatus auth_status;         //认证状态
@property (nonatomic,copy) NSString *auth_text;
@property (nonatomic,copy) NSString *auth_pic;
@property (nonatomic,copy) NSString *creation_date;      //创建时间
@property (nonatomic,copy) NSString *update_date;
@property (nonatomic,copy) NSString *doctor_certificate;  //医生证书
@property (nonatomic) BOOL isopen;
@property (nonatomic,copy) NSString *sync_time;      //同步时间

@property (nonatomic, copy)NSString *doctor_birthday; //医生的生日
@property (nonatomic, copy)NSString *doctor_gender; //医生性别
@property (nonatomic, copy)NSString *doctor_cv; //医生个人简介
@property (nonatomic, copy)NSString *doctor_skill; //医生的职业技能

/**
 *  临时字段，不做数据库的存储操作
 */
@property (nonatomic, assign)BOOL is_exists;
@property (nonatomic, copy)NSString *patient_count;
@property (nonatomic, assign)BOOL isSelect;//是否选中
@property (nonatomic, assign)BOOL isExist;//是否存在

+(Doctor *)doctorlWithResult:(FMResultSet *)result;
+ (Doctor *)DoctorFromDoctorResult:(NSDictionary *)dic;
+ (Doctor *)DoctorWithPatientCountFromDoctorResult:(NSDictionary *)dic;
@end

@interface RepairDoctor : Doctor
@property (nonatomic,copy) NSString *data_flag;
@property (nonatomic,copy) NSString *creation_time;

+ (RepairDoctor *)repairDoctorlWithResult:(FMResultSet *)result;
+ (RepairDoctor *)repairDoctorFromDoctorResult:(NSDictionary *)dic;

@end

@interface Introducer : DBTableMode

@property (nonatomic,copy) NSString *intr_name;      //介绍人姓名
@property (nonatomic,copy) NSString *intr_phone;     //电话
@property (nonatomic,copy) NSString *intr_id;
@property (nonatomic,readwrite) NSInteger intr_level; //等级
@property (nonatomic,copy) NSString *creation_date;  //创建时间
@property (nonatomic,copy) NSString *update_date;
@property (nonatomic,copy) NSString *sync_time;  //同步时间

+(Introducer *)intoducerFromIntro:(Introducer *)intro;
+(Introducer *)introducerlWithResult:(FMResultSet *)result;
+(Introducer *)IntroducerFromIntroducerResult:(NSDictionary *)inte;
@end

@interface Patient : DBTableMode

@property (nonatomic,copy) NSString *patient_name;     //患者姓名
@property (nonatomic,copy) NSString *patient_phone;    //患者电话
@property (nonatomic,copy) NSString *patient_avatar;    //患者照片
@property (nonatomic,copy) NSString *patient_gender;    //患者性别
@property (nonatomic,copy) NSString *patient_age;    //患者年龄
@property (nonatomic,readwrite) PatientStatus patient_status;
@property (nonatomic,copy) NSString *introducer_id; //介绍人id
@property (nonatomic,copy) NSString *ori_user_id;  //转诊医生id
@property (nonatomic,copy) NSString *creation_date; //创建时间
@property (nonatomic,copy) NSString *update_date;  //更新时间
@property (nonatomic,copy) NSString *sync_time;  //同步时间
@property (nonatomic,copy) NSString *case_update_time;
@property (nonatomic,copy) NSString *intr_name;
//新增患者字段
@property (nonatomic, copy)NSString *patient_allergy;//患者过敏史
@property (nonatomic, copy)NSString *patient_remark;//医生给患者的备注信息
@property (nonatomic, copy)NSString *idCardNum;//身份证号（原有字段是IdCardNum）
@property (nonatomic, copy)NSString *patient_address;//患者家庭地址
@property (nonatomic, copy)NSString *anamnesis;//既往病史（原有字段是Anamnesis）
@property (nonatomic, copy)NSString *nickName;//昵称(原有字段NickName)

//本地所用字段，与服务器无关
@property (nonatomic, assign)NSInteger expense_num;//种植体数量

+ (Patient *)patientWithMixResult:(FMResultSet *)result;//只用于患者列表信息
+ (Patient *)patientlWithResult:(FMResultSet *)result;
+ (NSString *)statusStrWithIntegerStatus:(PatientStatus)status;
+ (UIColor *)statusColorWithIntegerStatus:(PatientStatus)status;
+ (Patient *)PatientFromPatientResult:(NSDictionary *)pat;

@end

@interface Material : DBTableMode

@property (nonatomic,copy) NSString *mat_name;          //材料名称
@property (nonatomic,readwrite) CGFloat mat_price;      //材料价格
@property (nonatomic,readwrite) MaterialType mat_type;  //材料类型
@property (nonatomic,copy) NSString *update_date;
@property (nonatomic,copy) NSString *sync_time;      //同步时间

+ (Material *)materialWithResult:(FMResultSet *)result;
+ (NSString *)typeStringWith:(MaterialType)type;
+ (MaterialType)typeIntegerWith:(NSString *)string;
+ (Material *)MaterialFromMaterialResult:(NSDictionary *)mat;

@end

@interface CTLib : DBTableMode

@property (nonatomic,copy) NSString *patient_id;   //患者id
@property (nonatomic,copy) NSString *case_id;      //病例id
@property (nonatomic,copy) NSString *ct_image;             //CT图片地址
@property (nonatomic,copy) NSString *ct_desc;              //CT描述
@property (nonatomic,copy) NSString *creation_date;   //创建时间
@property (nonatomic,copy) NSString *update_date;
@property (nonatomic,copy) NSString *sync_time;      //同步时间
@property (nonatomic,copy) NSString *creation_date_sync;      //创建日期,用于同步
@property (nonatomic, copy)NSString *is_main;//1:主照片  0:不是主照片


+(CTLib *)libWithResult:(FMResultSet *)result;
+(CTLib *)CTLibFromCTLibResult:(NSDictionary *)medCT;

@end


@interface MedicalCase : DBTableMode

@property (nonatomic,copy) NSString *case_name;    //病例名称
@property (nonatomic,copy) NSString *patient_id;   //患者id
@property (nonatomic,copy) NSString *implant_time;         //移植时间
@property (nonatomic,copy) NSString *next_reserve_time;    //下次预约时间
@property (nonatomic,copy) NSString *repair_time;          //修复时间
@property (nonatomic,readwrite) NSInteger case_status;     //病例状态
@property (nonatomic,copy) NSString *repair_doctor;        //修复医生id
@property (nonatomic, copy)NSString *repair_doctor_name;   //修复医生名称
@property (nonatomic,copy)  NSString *creation_date;      //创建日期
@property (nonatomic,copy) NSString *update_date;
@property (nonatomic,copy) NSString *sync_time;  //同步时间
@property (nonatomic,copy)  NSString *creation_date_sync;      //创建日期,用于同步

@property (nonatomic, copy)NSString *tooth_position;//病历对应牙位
@property (nonatomic, copy)NSString *team_notice;//团队注意事项
@property (nonatomic, copy)NSString *hxGroupId;//环信群组的id

+ (MedicalCase *)medicalCaseWithResult:(FMResultSet *)result;
+ (MedicalCase *)MedicalCaseFromPatientMedicalCase:(NSDictionary *)medcas;

@end

@interface MedicalExpense : DBTableMode

@property (nonatomic,readwrite) NSString  *patient_id;  //患者id
@property (nonatomic,readwrite) NSString  *mat_id;     //材料id
@property (nonatomic,readwrite) NSString  *case_id;     //病例id
@property (nonatomic,readwrite) NSInteger expense_num; //消耗数量
@property (nonatomic,readwrite) Money     expense_price;      //价格
@property (nonatomic,readwrite) Money     expense_money;       //实际支付
@property (nonatomic,copy) NSString *update_date;
@property (nonatomic,copy) NSString *sync_time;      //同步时间
@property (nonatomic,copy)  NSString *creation_date;      //创建日期
@property (nonatomic,copy)  NSString *creation_date_sync;      //创建日期,用于同步

/**
 *  材料名称，操作状态，只做显示用，不涉及数据库操作
 */
@property (nonatomic, copy)NSString *mat_name;
@property (nonatomic, assign)ExpenseState state;//操作状态


+ (MedicalExpense *)expenseWithResult:(FMResultSet *)result;
+ (MedicalExpense *)MEFromMEResult:(NSDictionary *)medEx;

@end

@interface MedicalRecord : DBTableMode

@property (nonatomic,copy) NSString *patient_id;   //患者id
@property (nonatomic,copy) NSString  *case_id;      //病例id
@property (nonatomic,copy) NSString *record_content;   //就诊记录
@property (nonatomic,copy) NSString* creation_date;   //创建时间
@property (nonatomic,copy) NSString *update_date;
@property (nonatomic,copy) NSString *sync_time;      //同步时间
@property (nonatomic,copy)  NSString *creation_date_sync;      //创建日期,用于同步

/**
 *  创建人姓名，临时字段
 */
@property (nonatomic, copy)NSString *doctor_name;

+ (MedicalRecord *)medicalRecordWithResult:(FMResultSet *)result;
+ (MedicalRecord *)MRFromMRResult:(NSDictionary *)medRe;

@end

@interface PatientConsultation : DBTableMode

@property (nonatomic,copy) NSString *patient_id;   //患者id
@property (nonatomic,copy) NSString *doctor_id;      //doctor id
@property (nonatomic,copy) NSString *doctor_name;    //医生姓名
@property (nonatomic,copy) NSString *amr_file;       //语音文件
@property (nonatomic,copy) NSString *amr_time;   //语音时长
@property (nonatomic,copy) NSString *cons_type;      //类型
@property (nonatomic,copy) NSString *cons_content;   //会诊信息文字
@property (nonatomic,readwrite) NSInteger data_flag;
@property (nonatomic,copy) NSString *sync_time;      //同步时间
@property (nonatomic,copy) NSString* creation_date;   //创建时间

@property (nonatomic,copy) NSString *update_date;

@property (nonatomic,copy)  NSString *creation_date_sync;      //创建日期,用于同步

+ (PatientConsultation *)patientConsultationWithResult:(FMResultSet *)result;
+ (PatientConsultation *)PCFromPCResult:(NSDictionary *)pat;

@end

@interface MedicalReserve : DBTableMode

@property (nonatomic,copy) NSString *patient_id;        //患者id
@property (nonatomic,copy) NSString *case_id;           //病例id
@property (nonatomic,copy) NSString *reserve_time; //预约时间
@property (nonatomic,copy) NSString *actual_time;   //就诊时间
@property (nonatomic,copy) NSString *repair_time;  //修复时间
@property (nonatomic,copy) NSString *creation_date; //创建时间
@property (nonatomic,copy) NSString *update_date;
@property (nonatomic,copy) NSString *sync_time;      //同步时间
@property (nonatomic,copy)  NSString *creation_date_sync;      //创建日期,用于同步

+(MedicalReserve *)medicalReserveWithResult:(FMResultSet *)result;
- (BOOL)hasActualDate;
- (BOOL)hasRepairDate;
- (BOOL)hasRserveDate;
+(MedicalReserve *)MRSFromMRSResult:(NSDictionary *)medRs;
@end

@interface PatientIntroducerMap : DBTableMode

@property (nonatomic,copy) NSString *patient_id;        //患者id
@property (nonatomic,copy) NSString *intr_id;     //介绍人id
@property (nonatomic,copy) NSString *intr_time;         //介绍时间
@property (nonatomic,copy) NSString *intr_source;       //介绍人来源
@property (nonatomic,copy) NSString *remark;            //备注
@property (nonatomic,copy) NSString *creation_date; //创建时间
@property (nonatomic,copy) NSString *update_date;
@property (nonatomic,copy) NSString *sync_time;      //同步时间

+(PatientIntroducerMap *)PIFromMIResult:(NSDictionary *)mIRs;
+(PatientIntroducerMap *)patientIntroducerWithResult:(FMResultSet *)result;
@end

@interface UserObject : NSObject

@property (nonatomic,copy) NSString *accesstoken;   //token
@property (nonatomic,copy) NSString *userid;        //用户id
@property (nonatomic,copy) NSString *name;          //姓名
@property (nonatomic,copy) NSString *phone;         //电话
@property (nonatomic,copy) NSString *email;         //邮箱
@property (nonatomic,copy) NSString *hospitalName;  //医院
@property (nonatomic,copy) NSString *department;    //科室
@property (nonatomic,copy) NSString *title;         //职称
@property (nonatomic,copy) NSString *degree;        //学历
@property (nonatomic,copy) NSString *img;           //头像
@property (nonatomic,readwrite) AuthStatus authStatus; //认证状态
@property (nonatomic,copy) NSString *authText;
@property (nonatomic,copy) NSString *authPic;

@property (nonatomic, copy)NSString *doctor_birthday; //医生的生日
@property (nonatomic, copy)NSString *doctor_gender; //医生性别
@property (nonatomic, copy)NSString *doctor_cv; //医生个人简介
@property (nonatomic, copy)NSString *doctor_skill; //医生的职业技能

+ (UserObject *)userobjectWithResult:(FMResultSet *)result;
+ (NSString *)authStringWithStatus:(AuthStatus)status;
- (void)setUserObjectWithDic:(NSDictionary *)dic;
+ (UserObject *)userobjectFromDic:(NSDictionary *)dic;

@end

#if 0
//暂时注释掉， 因为在DBManager＋LocalNotification.h 中已经有定义

//"patient_id text, reserve_type text , reserve_time text, reserve_content text, user_id text, creation_date text, update_date text, ckeyid text PRIMARY KEY, sync_time text"

@interface LocalNotification_Sync : DBTableMode

@property (nonatomic,copy) NSString *patient_id;      //患者id
@property (nonatomic) NSString *reserve_type;
@property (nonatomic,copy) NSString *reserve_time;    //预约时间
@property (nonatomic,copy) NSString *reserve_content; //预约内容
@property (nonatomic,copy) NSString *medical_place;   //就诊地点
@property (nonatomic,copy) NSString *medical_chair;   //椅位
@property (nonatomic,copy) NSString *userid;          //用户id
@property (nonatomic,copy) NSString* creation_date;   //创建时间
@property (nonatomic,copy) NSString *update_date;
@property (nonatomic,copy) NSString *sync_time;      //同步时间

+ (LocalNotification_Sync *)LocalNotiWithResult:(FMResultSet *)result;
+ (LocalNotification_Sync *)LNFromLNFResult:(NSDictionary *)lnRe;

@end

#endif

@interface InfoAutoSync : NSObject
/**
 *  主键id
 */
@property (nonatomic, assign)NSInteger info_id;
/**
 *  数据的类型
 */
@property (nonatomic, copy)NSString *data_type;
/**
 *  上传的类型：insert,update,delete
 */
@property (nonatomic, copy)NSString *post_type;
/**
 *  具体的数据
 */
@property (nonatomic, copy)NSString *dataEntity;
/**
 *  同步的状态：0:未上传  1:上传中 2:上传成功 3:上传失败 4:上传失败后传入服务器
 */
@property (nonatomic, copy)NSString *sync_status;
/**
 *  创建时间  yyyyMMddHHmmss
 */
@property (nonatomic, copy)NSString *autoSync_CreateDate;
/**
 *  上传次数，当服务器发生异常时，限制最大上传次数50
 */
@property (nonatomic, assign)int syncCount;//上传次数，最大限制50次

+ (InfoAutoSync *)InfoAutoSyncWithResult:(FMResultSet *)result;
- (instancetype)initWithDataType:(NSString *)dataType postType:(NSString *)postType dataEntity:(NSString *)dataEntity syncStatus:(NSString *)syncStatus;
@end
