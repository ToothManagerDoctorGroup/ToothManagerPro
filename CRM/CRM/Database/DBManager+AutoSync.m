//
//  DBManager+AutoSync.m
//  CRM
//
//  Created by Argo Zhang on 15/12/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "DBManager+AutoSync.h"
#import "NSString+TTMAddtion.h"

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
        
        [valueArray addObject:info.data_type];
        [valueArray addObject:info.post_type];
        [valueArray addObject:info.dataEntity];
        [valueArray addObject:info.sync_status];
        [valueArray addObject:info.autoSync_CreateDate];
        
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
        
        [valueArray addObject:info.data_type];
        [valueArray addObject:info.post_type];
        [valueArray addObject:info.dataEntity];
        [valueArray addObject:info.sync_status];
        [valueArray addObject:info.autoSync_CreateDate];
        
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
             NSMutableString *sqlStringM = [NSMutableString stringWithFormat:@"select * from %@ where post_type=\"%@\" and (",InfoAutoSyncTableName,postType];
             for (int i = 0; i < statusArr.count; i++) {
                 if (i != statusArr.count - 1) {
                     [sqlStringM appendFormat:@"sync_status=\"%@\" or ",statusArr[i]];
                 }else{
                     [sqlStringM appendFormat:@"sync_status=\"%@\")",statusArr[i]];
                 }
             }
             sqlString = [NSString stringWithString:sqlStringM];
         }else{
             sqlString = [NSString stringWithFormat:@"select * from %@ where post_type=\"%@\" sync_status=\"%@\"",InfoAutoSyncTableName,postType,status];
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

@end
