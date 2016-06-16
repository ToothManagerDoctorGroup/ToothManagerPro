//
//  DBManager+Doctor.h
//  CRM
//
//  Created by TimTiger on 5/20/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "DBManager.h"

@interface DBManager (Doctor)

/**
 *  插入一条医生信息1
 *
 *  @param userobj 医生信息
 *
 *  @return 是否成功
 */
-(BOOL)insertDoctorWithDoctor:(Doctor *)doctorobj;

/**
 *  更新一条医生信息
 *
 *  @param userobj 医生信息
 *
 *  @return 是否成功
 */
- (BOOL)updateDoctorWithDoctor:(Doctor *)doctorobj;
/**
 *  更新一条医生信息
 *
 *  @param doctorobj 医生对象
 *  @param db        db
 *
 *  @return 是否成功
 */
- (BOOL)updateDoctorUseTransactionWithDoctor:(Doctor *)doctorobj andDB:(FMDatabase *)db;

/**
 *  删除一条医生信息
 *
 *  @param userobj 医生信息
 *
 *  @return 是否成功
 */
- (BOOL)deleteDoctorWithUserObject:(Doctor *)doctorobj;

/**
 *  获取一条医生信息
 *
 *  @param userobj 医生id
 *
 *  @return 医生信息
 */
- (Doctor *)getDoctorWithCkeyId:(NSString *)user_id;

/**
 *  获取一条医生信息
 *
 *  @param docname 医生姓名
 *
 *  @return 医生信息
 */
- (Doctor *)getDoctorWithName:(NSString *)docname;

/**
 *  获取医生列表
 *  @return 医生列表
 */
- (NSArray *)getAllDoctor;


/**
 *  通过map表获得患者的“转诊到”信息
 */

-(Doctor *)getDoctorNameByPatientIntroducerMapWithPatientId:(NSString *)patientId withIntrId:(NSString *)intrId;
@end
