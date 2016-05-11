//
//  XLChatRecordQueryModel.h
//  CRM
//
//  Created by Argo Zhang on 16/5/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  聊天记录的查询模型
 */
@interface XLChatRecordQueryModel : NSObject
/**医生id*/
@property (nonatomic, copy)NSString *SenderId;
/**接收者的id*/
@property (nonatomic, copy)NSString *ReceiverId;
/**内容的类型*/
@property (nonatomic, copy)NSString *ContentType;
/**开始时间*/
@property (nonatomic, copy)NSString *BeginTime;
/**结束时间*/
@property (nonatomic, copy)NSString *EndTime;
/**检索关键字*/
@property (nonatomic, copy)NSString *KeyWord;
/**检索的字段*/
@property (nonatomic, copy)NSString *SortField;
/**是否升序*/
@property (nonatomic, assign)BOOL IsAsc;
/**页数*/
@property (nonatomic, strong)NSNumber *PageIndex;
/**每页显示多少*/
@property (nonatomic, strong)NSNumber *PageSize;
/**
 *  根据开始或结束时间或关键字查询聊天记录
 */
- (instancetype)initWithSenderId:(NSString *)senderId
                      receiverId:(NSString *)receiverId
                       beginTime:(NSString *)beginTime
                         endTime:(NSString *)endTime
                         keyWord:(NSString *)keyWord
                       sortField:(NSString *)sortField
                           isAsc:(BOOL)isAsc;

@end
