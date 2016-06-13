//
//  DBManager+Materials.m
//  CRM
//
//  Created by TimTiger on 5/14/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "DBManager+Materials.h"
#import "TimFramework.h"
#import "CRMUserDefalut.h"


@implementation DBManager (Materials)

#pragma mark - MaterialTableName
/*
 *@brief 插入一条耗材数据 到耗材表中
 *@param material 数据
 */
- (BOOL)insertMaterial:(Material *)material {
    if (material == nil) {
        return NO;
    }
    
    __block BOOL ret = NO;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\"",MaterialTableName,material.ckeyid];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            ret = YES;
        }
        [set close];
    }];
    if (ret) {
        ret = [self updateMaterial:material];
        return ret;
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        
        //"KeyId INTEGER PRIMARY KEY AUTOINCREMENT,mat_name text, mat_price double, mat_type integer,user_id text, creation_date text, update_date text, ckeyid text, sync_time text"];

        [columeArray addObject:@"ckeyid"]; //ckeyid：由用户id_时间戳组成
        [columeArray addObject:@"mat_name"];
        [columeArray addObject:@"mat_type"];
        [columeArray addObject:@"mat_price"];
        [columeArray addObject:@"update_date"]; //更新时间
        [columeArray addObject:@"creation_date"];
        [columeArray addObject:@"sync_time"]; //同步时间，在创建表项的时候写入default的时间
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"doctor_id"];
        
        [valueArray addObject:material.ckeyid];
        [valueArray addObject:material.mat_name];
        [valueArray addObject:[NSNumber numberWithInt:material.mat_type]];
        [valueArray addObject:[NSNumber numberWithFloat:material.mat_price]];
        [valueArray addObject:[NSString defaultDateString]];
        [valueArray addObject:[NSString currentDateString]];
        if ([NSString isEmptyString:material.sync_time]) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:material.sync_time];
        }
        [valueArray addObject:material.user_id];
        [valueArray addObject:material.doctor_id];
        
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@)", MaterialTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
       ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
        if (ret == NO) {

        }
        
    }];
    return ret;
}

- (BOOL)updateMaterial:(Material *)material {
    if (material == nil) {
        return NO;
    }
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        NSDate* currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* strCurrentDate = [dateFormatter stringFromDate:currentDate];
        
        [columeArray addObject:@"mat_name"];
        [columeArray addObject:@"mat_type"];
        [columeArray addObject:@"mat_price"];
        [columeArray addObject:@"update_date"]; //更新时间
        [columeArray addObject:@"sync_time"]; //同步时间，在创建表项的时候写入default的时间
        [columeArray addObject:@"doctor_id"];
        
        [valueArray addObject:material.mat_name];
        [valueArray addObject:[NSNumber numberWithInt:material.mat_type]];
        [valueArray addObject:[NSNumber numberWithFloat:material.mat_price]];
        if ([NSString isEmptyString:material.update_date]) {
           [valueArray addObject:[NSString stringWithString:strCurrentDate]];
        } else {
            [valueArray addObject:material.update_date];
        }
        [valueArray addObject:material.sync_time];
        [valueArray addObject:material.doctor_id];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where ckeyid = \"%@\"", MaterialTableName, [columeArray componentsJoinedByString:@"=?,"],material.ckeyid];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
    }];
    return ret;
}

/*
 *@brief 获取耗材库中全部耗材
 *@return NSArray 返回耗材数组，没有则为nil
 */
- (NSArray *)getAllMaterials {
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {

         result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where user_id = '%@' and creation_date > datetime('%@')",MaterialTableName,[CRMUserDefalut latestUserId], [NSString defaultDateString]]];
//TODO: Tiger
//         result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where creation_date > datetime('%@')",MaterialTableName, [NSString defaultDateString]]];

         while ([result next])
         {
             Material* material = [Material materialWithResult:result];
             [resultArray addObject:material];
         }
         [result close];
     }];
    
    return resultArray;
}

/*
 *@brief 获取耗材库中的耗材
 *@param type 耗材类型
 *@param min/max 价格区间
 *@return NSArray 返回耗材数组，没有则为nil
 */
- (NSArray *)getMaterialArrayWithType:(MaterialType)type minPrice:(CGFloat)min maxPrice:(CGFloat)max {
    if (type < 0) {
        return nil;
    }
    
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where mat_type = %ld and mat_price <= %f and mat_price >= %f and creation_date > datetime('%@')",MaterialTableName,(long)type,max,min, [NSString defaultDateString]]];
         
         while ([result next])
         {
             Material* material = [Material materialWithResult:result];
             [resultArray addObject:material];
         }
         [result close];
     }];
    
    return resultArray;
}


/**
 *  @brief 根据耗材id获取耗材信息
 *  @param mid 耗材id
 *  @return 耗材类
 */
- (Material *)getMaterialWithId:(NSString *)mid {

    if ([NSString isEmptyString:mid]) {
        return nil;
    }
    
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\" and creation_date > datetime('%@')",MaterialTableName,mid, [NSString defaultDateString]];

    __block Material *material = nil;
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlStr];
        if (result && result.next) {
            material = [Material materialWithResult:result];
        }
        [result close];
    }];
    
    
    return material;
}

#pragma mark -- 通过耗材id找到患者们
- (NSArray *)getPatientByMaterialId:(NSString *)materialId
{
    if ([NSString isEmptyString:materialId]) {
        return nil;
    }
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    NSString *sqlString = [NSString stringWithFormat:@"select * from (select a.doctor_id, a.ckeyid,a.[patient_name],a.[patient_phone],a.[patient_status],a.[update_date],a.[nickName],b.intr_name,sum(ifnull(expense_num,0)) as expense_num from (select * from patient_version2 where creation_date > datetime('%@') and ckeyid in (select patient_id from %@ where mat_id='%@')) a left join (select m.*,i.intr_name as intr_name from introducer_version2 i,patient_introducer_map_version2 m where m.[intr_id]=i.[ckeyid] and m.intr_source like '%%B' and m.doctor_id=\"%@\" union select m.*,i.doctor_name as intr_name from doctor_version2 i,patient_introducer_map_version2 m where m.[intr_id]=i.[doctor_id] and m.intr_source like '%%I' and m.doctor_id=\"%@\") b on a.ckeyid=b.patient_id left join (select * from %@ ee join %@ m on ee.mat_id=m.ckeyid and m.mat_type=2) e on a.[ckeyid]=e.patient_id group by a.ckeyid,a.patient_name,a.patient_status,b.intr_name order by a.update_date desc)",[NSString defaultDateString],MedicalExpenseTableName,materialId,[AccountManager shareInstance].currentUser.userid,[AccountManager shareInstance].currentUser.userid,MedicalExpenseTableName,MaterialTableName];
    
    __block Patient *patient = nil;
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlString];
        while ([result next]) {
            patient = [Patient patientWithMixResult:result];
            [resultArray addObject:patient];
        }
        [result close];
    }];
    return resultArray;
}

/**
 *  @brief 根据耗材id删除一件耗材
 *  @param mid 耗材id
 *  @return 成功返回YES,失败返回NO
 */
- (BOOL)deleteMaterialWithId:(NSString *)mid {
    if ([NSString isEmptyString:mid]) {
        return NO;
    }
    
    
    //在删除的时候把create_date设为初始值，等同步成功后，由同步模块删除
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
      
        [columeArray addObject:@"creation_date"]; //更新时间
       
        [valueArray addObject:[NSString defaultDateString]];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where ckeyid = \"%@\"", MaterialTableName, [columeArray componentsJoinedByString:@"=?,"],mid];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
    }];
    return ret;
}

/**
 *  @brief 根据耗材id删除一件耗材, 新方案中用于同步成功后删除
 *  @param mid 耗材id
 *  @return 成功返回YES,失败返回NO
 */
- (BOOL)deleteMaterialWithId_sync:(NSString *)mid {
    if ([NSString isEmptyString:mid]) {
        return NO;
    }
    
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where ckeyid = \"%@\"",MaterialTableName,mid];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    
    return ret;
}


/**
 *  获取单个患者种植体消耗个数
 *
 *  @param patientId 患者id
 *
 *  @return 个数
 */
- (NSInteger)numberMaterialsExpenseWithPatientId:(NSString *)patientId {
    if ([NSString isEmptyString:patientId]) {
        return 0;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"select expense_num from %@ e join %@ m on m.ckeyid = e.[mat_id] and m.mat_type = 2 and e.patient_id = \"%@\" and e.user_id = \"%@\" and e.creation_date_sync > datetime('%@')",MedicalExpenseTableName,MaterialTableName,patientId,[AccountManager currentUserid],[NSString defaultDateString]];
    __block FMResultSet *result = nil;
    __block NSInteger count = 0;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        NSInteger num = 0;
        result = [db executeQuery:sqlStr];
        while (result && [result next]) {
            num = [result intForColumn:@"expense_num"];
            count += num;
        }
        [result close];
    }];
    
    return count;
}


#pragma mark - Medical_expense

/**
 *  @brief 插入一条消耗记录
 *  @param expense 消耗记录mode
 *  @return 成功返回YES,失败返回NO
 */
- (BOOL)insertMedicalExpenseWith:(MedicalExpense *)expense {
    
    if (!expense) {
        return NO;
    }
    
    __block BOOL ret = NO;
   
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\"",MedicalExpenseTableName,expense.ckeyid];
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = nil;
        set = [db executeQuery:sqlStr];
        if (set && [set next]) {
            ret = YES;
        }
        [set close];
        }];
    if (ret == YES) {
        ret = [self updateMedicalExpenseWith:expense];
        return ret;
    }
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        /*
         @property (nonatomic,readwrite) NSInteger patient_id;  //患者id
         @property (nonatomic,readwrite) NSInteger mat_id;     //材料id
         @property (nonatomic,readwrite) NSInteger case_id;     //病例id
         @property (nonatomic,readwrite) NSInteger expense_num; //消耗数量
         @property (nonatomic,readwrite) Money     expense_price;      //价格
         @property (nonatomic,readwrite) Money     expense_money;       //实际支付
         @property (nonatomic,copy) NSString *user_id;    //医生id
         @property (nonatomic,copy) NSString *update_date;
         @property (nonatomic,copy) NSString *sync_time;      //同步时间
         */
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"ckeyid"];
        [columeArray addObject:@"patient_id"];
        [columeArray addObject:@"mat_id"];
        [columeArray addObject:@"case_id"];
        [columeArray addObject:@"expense_num"];
        [columeArray addObject:@"expense_price"];
        [columeArray addObject:@"expense_money"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"creation_date_sync"]; //创建时间,仅用于同步
        [columeArray addObject:@"update_date"];
        [columeArray addObject:@"sync_time"];
        [columeArray addObject:@"doctor_id"];
        [columeArray addObject:@"creation_date"]; //创建时间
        
        [valueArray addObject:expense.ckeyid];
        [valueArray addObject:expense.patient_id];
        [valueArray addObject:expense.mat_id];
        [valueArray addObject:expense.case_id];
        [valueArray addObject:[NSNumber numberWithFloat:expense.expense_num]];
        [valueArray addObject:[NSNumber numberWithFloat:expense.expense_price]];
        [valueArray addObject:[NSNumber numberWithFloat:expense.expense_money]];
        [valueArray addObject:expense.user_id];
        [valueArray addObject:[NSString currentDateString]];
        [valueArray addObject:[NSString defaultDateString]];
        if ([NSString isEmptyString:expense.sync_time]) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:expense.sync_time];
        }
        [valueArray addObject:expense.doctor_id];
        [valueArray addObject:expense.creation_date];
        
        
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        [titleArray addObject:@"?"];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@)", MedicalExpenseTableName, [columeArray componentsJoinedByString:@","], [titleArray componentsJoinedByString:@","]];
         NSLog(@"insert Expense :%@",sqlQuery);
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
    }];
    
    return ret;
}

/**
 *  更新一条消耗记录
 *
 *  @param expense 消耗记录
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)updateMedicalExpenseWith:(MedicalExpense *)expense {
    if (!expense || [NSString isEmptyString:expense.ckeyid]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        NSDate* currentDate = [NSDate date];
        
        [columeArray addObject:@"patient_id"];
        [columeArray addObject:@"mat_id"];
        [columeArray addObject:@"case_id"];
        [columeArray addObject:@"expense_num"];
        [columeArray addObject:@"expense_price"];
        [columeArray addObject:@"expense_money"];
        [columeArray addObject:@"user_id"];
        [columeArray addObject:@"creation_date_sync"]; //创建时间,仅用于同步
        [columeArray addObject:@"update_date"];
        [columeArray addObject:@"sync_time"];
        [columeArray addObject:@"doctor_id"];
        [columeArray addObject:@"creation_date"];
        
        [valueArray addObject:expense.patient_id];
        [valueArray addObject:expense.mat_id];
        [valueArray addObject:expense.case_id];
        [valueArray addObject:[NSNumber numberWithFloat:expense.expense_num]];
        [valueArray addObject:[NSNumber numberWithFloat:expense.expense_price]];
        [valueArray addObject:[NSNumber numberWithFloat:expense.expense_money]];
        [valueArray addObject:expense.user_id];
        [valueArray addObject:[NSString currentDateString]];
        if ([NSString isEmptyString:expense.update_date]) {
            [valueArray addObject:[NSString stringWithString:[currentDate description]]];
        } else {
            [valueArray addObject:[NSString stringWithString:expense.update_date]];
        }
        
        if ([NSString isEmptyString:expense.sync_time]) {
            [valueArray addObject:[NSString defaultDateString]];
        } else {
            [valueArray addObject:expense.sync_time];
        }
        [valueArray addObject:expense.doctor_id];
        [valueArray addObject:expense.creation_date];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@ =? where ckeyid = '%@'", MedicalExpenseTableName, [columeArray componentsJoinedByString:@"=?,"], expense.ckeyid];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
    }];
    
    return ret;

}

/**
 *  删除一条消耗记录
 *
 *  @param expenseId 消耗记录id
 *
 *  @return 成功YES,失败NO
 */
- (BOOL)deleteMedicalExpenseWithId:(NSString *)expenseId {
    if ([NSString isEmptyString:expenseId]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"creation_date_sync"];
        
        [valueArray addObject:[NSString defaultDateString]];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where ckeyid = \"%@\"", MedicalExpenseTableName, [columeArray componentsJoinedByString:@"=?,"], expenseId];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
    }];

    return ret;
}



- (BOOL)deleteMedicalExpenseWithId_sync:(NSString *)expenseId {
    if ([NSString isEmptyString:expenseId]) {
        return NO;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where ckeyid = \"%@\"",MedicalExpenseTableName,expenseId];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    return ret;
}

- (BOOL)deleteMedicalExpenseWithCaseId:(NSString *)caseid {
    if (caseid <= 0) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
        [columeArray addObject:@"creation_date_sync"];
        
        [valueArray addObject:[NSString defaultDateString]];
        
        // 3. 写入数据库
        NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where case_id = \"%@\"", MedicalExpenseTableName, [columeArray componentsJoinedByString:@"=?,"], caseid];
        ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
    }];

    return ret;
}

- (BOOL)deleteMedicalExpenseWithPatientId:(NSString *)patientId {
    if ([NSString isEmptyString:patientId]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
    NSMutableArray *columeArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
        
    [columeArray addObject:@"creation_date_sync"];
        
    [valueArray addObject:[NSString defaultDateString]];
        
    // 3. 写入数据库
    NSString *sqlQuery = [NSString stringWithFormat:@"update %@ set %@=? where patient_id = \"%@\" and user_id = \"%@\"", MedicalExpenseTableName, [columeArray componentsJoinedByString:@"=?,"], patientId,[AccountManager currentUserid]];
    ret = [db executeUpdate:sqlQuery withArgumentsInArray:valueArray];
        
    }];

    
    return ret;
}

- (BOOL)deleteMedicalExpenseWithPatientId_sync:(NSString *)patientId{
    if ([NSString isEmptyString:patientId]) {
        return NO;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where patient_id = \"%@\" and doctor_id = \"%@\"",MedicalExpenseTableName,patientId,[AccountManager currentUserid]];
    __block BOOL ret = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlStr];
    }];
    return ret;
}

/**
 *  @brief 根据患者id 查询消耗（MedicalExpense）
 *  @param patientId 患者id
 *  @return 消耗数组(MedicalExpense组成的数组)
 */
- (NSArray *)getMedicalExpenseArrayWithPatientId:(NSString *)patientId {

    if ([NSString isEmptyString:patientId]) {
        return nil;
    }
    
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where patient_id = \"%@\" and creation_date_sync > datetime('%@')",MedicalExpenseTableName,patientId,[NSString defaultDateString]]];
         
         while ([result next])
         {
             MedicalExpense* expense = [MedicalExpense expenseWithResult:result];
             [resultArray addObject:expense];
         }
         [result close];
     }];
    
    return resultArray;
}



/**
 *  @brief 根据病例id 查询消耗（MedicalExpense）
 *  @param patientId 患者id
 *  @return 消耗数组(MedicalExpense组成的数组)
 */
- (NSArray *)getMedicalExpenseArrayWithMedicalCaseId:(NSString *)caseId {
    
    if ([NSString isEmptyString:caseId]) {
        return nil;
    }
    
    __block FMResultSet* result = nil;
    NSMutableArray* resultArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where case_id = \"%@\" and creation_date_sync > datetime('%@')",MedicalExpenseTableName,caseId, [NSString defaultDateString]]];
         
         while ([result next])
         {
             MedicalExpense* expense = [MedicalExpense expenseWithResult:result];
             [resultArray addObject:expense];
         }
         [result close];
     }];
    
    return resultArray;
}


- (MedicalExpense *)getMedicalExpenseWithCkeyId:(NSString *)ckeyId{
    if ([NSString isEmptyString:ckeyId]) {
        return nil;
    }
    
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where ckeyid = \"%@\" and creation_date_sync > datetime('%@')",MedicalExpenseTableName,ckeyId,[NSString defaultDateString]];
    __block MedicalExpense *expense = nil;
    __block FMResultSet *result = nil;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlStr];
        if (result && [result next]) {
            expense = [MedicalExpense expenseWithResult:result];
        }
        [result close];
    }];
    return expense;
}

/**
 *  判断耗材信息是否存在
 *
 *  @param materialName 材料的名称
 *
 *  @return 存在（yes） 不存在（no）
 */
- (BOOL)materialIsExistWithMaterialName:(NSString *)materialName{
    if ([NSString isEmptyString:materialName]) {
        return NO;
    }
    
    NSString *sqlStr = [NSString stringWithFormat:@"select count(ckeyid) as 'count' from %@ where mat_name = '%@' and doctor_id = '%@' and creation_date > datetime('%@')",MaterialTableName,materialName,[AccountManager currentUserid],[NSString defaultDateString]];
    __block FMResultSet *result = nil;
    __block BOOL exists = NO;
    [self.fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeQuery:sqlStr];
        
        int count = 0;
        while ([result next]) {
           count  = [result intForColumn:@"count"];
        }
        if (count > 0) {
            exists = YES;
        }
        
        [result close];
    }];
    return exists;
}

@end
