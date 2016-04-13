//
//  DBManager+Transaction.m
//  CRM
//
//  Created by Argo Zhang on 16/4/12.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "DBManager+Transaction.h"
#import "DBManager+Doctor.h"

@implementation DBManager (Transaction)

- (void)insertDoctorUseTransactionWithDoctor:(Doctor *)doctor
{
    __block BOOL ret = NO;
    __block FMResultSet *set = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        BOOL isRollBack = NO;
        @try {
            NSString *sqlStr = [NSString stringWithFormat:@"select count(*) as 'count' from %@ where doctor_name = \"%@\" and user_id = \"%@\"",DoctorTableName,doctor.doctor_name,[AccountManager currentUserid]];
            set = [db executeQuery:sqlStr];
            if (set && [set next]) {
                ret = YES;
            }
            [set close];
            if (ret) {
                
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [db rollback];
        }
        @finally {
            if (!isRollBack) {
                [db commit];
            }
        }
    }];
}

@end
