//
//  DBManager+User.h
//  CRM
//
//  Created by TimTiger on 9/6/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "DBManager.h"

@interface DBManager (User)

/**
 *  插入一条用户信息
 *
 *  @param userobj 用户信息
 *
 *  @return 是否成功
 */
-(BOOL)insertUserWithUserObject:(UserObject *)userobj;

/**
 *  更新一条用户信息
 *
 *  @param userobj 用户信息
 *
 *  @return 是否成功
 */
- (BOOL)updateUserWithUserObject:(UserObject *)userobj;

/**
 *  删除一条用户信息
 *
 *  @param userobj 用户信息
 *
 *  @return 是否成功
 */
- (BOOL)deleteUserWithUserObject:(UserObject *)userobj;

/**
 *  获取一条用户信息
 *
 *  @param userobj 用户id
 *
 *  @return 用户信息
 */
- (UserObject *)getUserObjectWithUserId:(NSString *)userid;

/**
 *  更新用户头像
 *
 *  @param userId 用户id
 */
- (BOOL)upDateUserHeaderImageUrlWithUserId:(NSString *)userId imageUrl:(NSString *)imageUrl;

/**
 *  就诊人数
 *
 *  @return 就诊人数
 */
- (NSInteger)countPatient;

/**
 *  种植个数
 *
 *  @return 种植个数
 */
- (NSInteger)countMedicalExpense;

/**
 *  未处理预约数
 *
 *  @return 人数
 */
- (NSInteger)countUnTreatReserve;

@end
