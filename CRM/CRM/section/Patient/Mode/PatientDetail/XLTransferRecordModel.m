//
//  XLTransferRecordModel.m
//  CRM
//
//  Created by Argo Zhang on 16/6/14.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLTransferRecordModel.h"

@implementation XLTransferRecordModel

+ (instancetype)transferRecordModelWithResultSet:(FMResultSet *)resultSet{
    XLTransferRecordModel *model = [[XLTransferRecordModel alloc] init];
    model.doctor_id = [resultSet stringForColumn:@"doctor_id"];
    model.doctor_name = [resultSet stringForColumn:@"doctor_name"];
    model.doctor_image = [resultSet stringForColumn:@"doctor_image"];
    model.intr_time = [resultSet stringForColumn:@"intr_time"];
    return model;
}

@end
