//
//  XLChatRecordQueryModel.m
//  CRM
//
//  Created by Argo Zhang on 16/5/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLChatRecordQueryModel.h"
#import "AccountManager.h"

@implementation XLChatRecordQueryModel
/**
 *  根据开始或结束时间或关键字查询聊天记录
 */
- (instancetype)initWithSenderId:(NSString *)senderId
                      receiverId:(NSString *)receiverId
                       beginTime:(NSString *)beginTime
                         endTime:(NSString *)endTime
                         keyWord:(NSString *)keyWord
                       sortField:(NSString *)sortField
                           isAsc:(BOOL)isAsc{
    if (self = [super init]) {
        self.SenderId = senderId;
        self.ReceiverId = receiverId;
        self.ContentType = @"";
        self.BeginTime = beginTime;
        self.EndTime = endTime;
        self.KeyWord = keyWord;
        self.SortField = sortField;
        self.PageIndex = @(1);
        self.PageSize = @(20);
        self.IsAsc = isAsc;
    }
    return self;
}

@end
