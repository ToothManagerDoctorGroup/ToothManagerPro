//
//  XLQueryModel.m
//  CRM
//
//  Created by Argo Zhang on 16/1/15.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLQueryModel.h"

@implementation XLQueryModel

- (instancetype)initWithKeyWord:(NSString *)keyWord sortField:(NSString *)sortField isAsc:(NSNumber *)isAsc pageIndex:(NSNumber *)pageIndex pageSize:(NSNumber *)pageSize{
    if (self = [super init]) {
        self.KeyWord = keyWord;
        self.SortField = sortField;
        self.IsAsc = isAsc;
        self.PageIndex = pageIndex;
        self.PageSize = pageSize;
    }
    return self;
}

@end


