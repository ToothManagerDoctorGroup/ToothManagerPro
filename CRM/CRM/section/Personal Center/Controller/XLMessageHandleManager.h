//
//  XLMessageHandleManager.h
//  CRM
//
//  Created by Argo Zhang on 16/5/11.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  消息处理机制
 */
@interface XLMessageHandleManager : NSObject

+ (void)beginHandle;
/**
 *  处理未读消息
 *
 *  @param message 未读消息数组
 */
+ (void)handleUnReadMessages:(NSArray *)messages;

@end
