//
//  DBManager+AutoSync.h
//  CRM
//
//  Created by Argo Zhang on 15/12/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "DBManager.h"

@interface DBManager (AutoSync)
/**
 *  添加一条同步信息
 *
 *  @param info 同步信息模型
 *
 *  @return 返回参数
 */
- (BOOL)insertInfoWithInfoAutoSync:(InfoAutoSync *)info;

/**
 *  更新一条同步信息
 *
 *  @param info 同步信息模型
 *
 *  @return 返回参数
 */
- (BOOL)updateInfoWithInfoAutoSync:(InfoAutoSync *)info;
/**
 *  更新同步状态
 *
 *  @param syncStatus 同步状态
 *  @param infoId     同步信息id
 *
 *  @return 返回参数
 */
- (BOOL)updateInfoWithSyncStatus:(NSString *)syncStatus byInfoId:(NSInteger)infoId;
/**
 *  更新同步状态
 *
 *  @param syncStatus 同步状态
 *  @param info       info模型
 *
 *  @return 返回参数
 */
- (BOOL)updateInfoWithSyncStatus:(NSString *)syncStatus byInfo:(InfoAutoSync *)info;
/**
 *  删除一条同步信息
 *
 *  @param info 同步模型
 *
 *  @return 返回参数
 */
- (BOOL)deleteInfoWithInfoAutoSync:(InfoAutoSync *)info;

/**
 *  删除一条同步信息
 *
 *  @param status 同步状态
 *
 *  @return 返回参数
 */
- (BOOL)deleteInfoWithSyncStatus:(NSString *)status;

/**
 *  根据上传状态查询查询数据
 *
 *  @param status 上传状态（0：未上传 1：上传中 2：上传成功 3：上传失败）
 *
 *  @return 返回参数
 */
- (NSArray *)getInfoListWithSyncStatus:(NSString *)status;
/**
 *  根据上传类型和上传状态查询数据
 *
 *  @param postType 上传类型(insert,update,delete)
 *  @param status   上传状态（0：未上传 1：上传中 2：上传成功 3：上传失败）
 *
 *  @return 返回参数
 */
- (NSArray *)getInfoListWithPostType:(NSString *)postType syncStatus:(NSString *)status;
/**
 *  根据同步状态获取所有异常数据
 *
 *  @return 返回参数
 */
- (NSArray *)getInfoListBySyncCountWithStatus:(NSString *)status;

/**
 *  获取所有数据
 *
 *  @return 返回参数
 */
- (NSArray *)getAllInfo;

/**
 *  数据是否正在上传或者上传成功
 */
- (BOOL)isExistWithPostType:(NSString *)postType dataType:(NSString *)dataType ckeyId:(NSString *)ckeyId;

@end
