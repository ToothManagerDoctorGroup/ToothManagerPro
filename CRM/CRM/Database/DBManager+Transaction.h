//
//  DBManager+Transaction.h
//  CRM
//
//  Created by Argo Zhang on 16/4/12.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "DBManager.h"
/**
 *  通过事务来批量保存数据到数据库
 */
@interface DBManager (Transaction)

- (void)insertObjects:(NSArray *)resources useTransaction:(BOOL)useTransaction;

@end
