//
//  DBManager+AutoSync.m
//  CRM
//
//  Created by Argo Zhang on 15/12/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "DBManager+AutoSync.h"
#import "NSString+TTMAddtion.h"
#import "MJExtension.h"
#import "JSONKit.h"

#define MAX_SYNC_COUNT 50

@implementation DBManager (AutoSync)



- (BOOL)insertInfoWithInfoAutoSync:(InfoAutoSync *)info{
    if (info == nil || [info.dataEntity isEmpty]) {
        return NO;
    }
    
    __block BOOL ret;
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"data_type"];
        [columeArray addObject:@"post_type"];
        [columeArray addObject:@"dataEntity"];
        [columeArray addObject:@"sync_status"];
        [columeArray addObject:@"autoSync_CreateDate"];
        [columeArray addObject:@"syncCount"];
        
        [valueArray addObject:info.data_type];
        [valueArray addObject:info.post_type];
        [valueArray addObject:info.dataEntity];
        [valueArray addObject:info.sync_status];
        [valueArray addObject:info.autoSync_CreateDate];
        [valueArray addObject:@(info.syncCount)];
        
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@)", InfoAutoSyncTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
    }];
    return ret;
}

- (BOOL)updateInfoWithInfoAutoSync:(InfoAutoSync *)info{
    if (info == nil || [info.dataEntity isEmpty]) {
        return NO;
    }
    
    __block BOOL ret;
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"data_type"];
        [columeArray addObject:@"post_type"];
        [columeArray addObject:@"dataEntity"];
        [columeArray addObject:@"sync_status"];
        [columeArray addObject:@"autoSync_CreateDate"];
        [columeArray addObject:@"syncCount"];
        
        [valueArray addObject:info.data_type];
        [valueArray addObject:info.post_type];
        [valueArray addObject:info.dataEntity];
        [valueArray addObject:info.sync_status];
        [valueArray addObject:info.autoSync_CreateDate];
        [valueArray addObject:@(info.syncCount)];
        
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where id = %ld", InfoAutoSyncTableName, [columeArray componentsJoinedByString:@"=?,"],(long)info.info_id];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
    }];
    return ret;
}

- (BOOL)updateInfoWithSyncStatus:(NSString *)syncStatus byInfoId:(NSInteger)infoId{
    __block BOOL ret;
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set sync_status=\"%@\" where id=%ld",InfoAutoSyncTableName,syncStatus,(long)infoId];
        ret = [db executeUpdate:sqlQuery];
    }];
    return ret;
}

- (BOOL)updateInfoWithSyncStatus:(NSString *)syncStatus byInfo:(InfoAutoSync *)info{
    __block BOOL ret;
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set sync_status=\"%@\",syncCount = %d where id=%ld",InfoAutoSyncTableName,syncStatus,info.syncCount,(long)info.info_id];
        ret = [db executeUpdate:sqlQuery];
    }];
    return ret;
}

- (BOOL)deleteInfoWithInfoAutoSync:(InfoAutoSync *)info{
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where id = %ld",InfoAutoSyncTableName,(long)info.info_id];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    return ret;
}

- (BOOL)deleteInfoWithSyncStatus:(NSString *)status{
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where sync_status = \"%@\"",InfoAutoSyncTableName,status];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    return ret;
}


- (NSArray *)getInfoListWithSyncStatus:(NSString *)status{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sqlString = [NSString stringWithFormat:@"select * from %@ where sync_status=\"%@\"",InfoAutoSyncTableName,status];
         
         result = [db executeQuery:sqlString];
         
         while ([result next])
         {
             InfoAutoSync * info = [InfoAutoSync InfoAutoSyncWithResult:result];
             [resultArray addObject:info];
         }
         [result close];
     }];
    return resultArray;
}

- (NSArray *)getInfoListWithPostType:(NSString *)postType syncStatus:(NSString *)status{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sqlString;
         if ([status isContainsString:@","]) {
             NSArray *statusArr = [status componentsSeparatedByString:@","];
             NSMutableString *sqlStringM = [NSMutableString stringWithFormat:@"select * from %@ where post_type=\"%@\" and syncCount <= %d and (",InfoAutoSyncTableName,postType,MAX_SYNC_COUNT];
             for (int i = 0; i < statusArr.count; i++) {
                 if (i != statusArr.count - 1) {
                     [sqlStringM appendFormat:@"sync_status=\"%@\" or ",statusArr[i]];
                 }else{
                     [sqlStringM appendFormat:@"sync_status=\"%@\")",statusArr[i]];
                 }
             }
             sqlString = [NSString stringWithString:sqlStringM];
         }else{
             sqlString = [NSString stringWithFormat:@"select * from %@ where post_type=\"%@\" and sync_status=\"%@\" and syncCount <= %d",InfoAutoSyncTableName,postType,status,MAX_SYNC_COUNT];
         }
         
         result = [db executeQuery:sqlString];
         
         while ([result next])
         {
             InfoAutoSync * info = [InfoAutoSync InfoAutoSyncWithResult:result];
             [resultArray addObject:info];
         }
         [result close];
     }];
    return resultArray;
}

- (NSArray *)getInfoListBySyncCountWithStatus:(NSString *)status{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
        
         NSString *sqlString = [NSString stringWithFormat:@"select * from %@ where sync_status=\"%@\" and syncCount > %d",InfoAutoSyncTableName,status,MAX_SYNC_COUNT];
         
         result = [db executeQuery:sqlString];
         
         while ([result next])
         {
             InfoAutoSync * info = [InfoAutoSync InfoAutoSyncWithResult:result];
             [resultArray addObject:info];
         }
         [result close];
     }];
    return resultArray;
}


- (NSArray *)getAllInfo{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         
         NSString *sqlString = [NSString stringWithFormat:@"select * from %@",InfoAutoSyncTableName];
         
         result = [db executeQuery:sqlString];
         
         while ([result next])
         {
             InfoAutoSync * info = [InfoAutoSync InfoAutoSyncWithResult:result];
             [resultArray addObject:info];
         }
         [result close];
     }];
    return resultArray;
}

/**
 *  数据是否正在上传或者上传成功
 */
- (BOOL)isExistWithPostType:(NSString *)postType dataType:(NSString *)dataType ckeyId:(NSString *)ckeyId{
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db){
         NSString *sqlString = [NSString stringWithFormat:@"select * from %@ where post_type='%@' and data_type = '%@' and sync_status in (0,1,2)",InfoAutoSyncTableName,postType,dataType];
         
         result = [db executeQuery:sqlString];
         while ([result next])
         {
             InfoAutoSync * info = [InfoAutoSync InfoAutoSyncWithResult:result];
             [resultArray addObject:info];
         }
         [result close];
     }];
    BOOL exist;
    if ([postType isEqualToString:AutoSync_CtLib]) {
        for (InfoAutoSync *info in resultArray) {
            CTLib *ct = [CTLib objectWithKeyValues:[info.dataEntity objectFromJSONString]];
            if ([ct.ckeyid isEqualToString:ckeyId]) {
                exist = YES;
                break;
            }
        }
    }
    return exist;
}
@end
