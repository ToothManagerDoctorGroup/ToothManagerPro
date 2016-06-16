//
//  ContactDataHelper.h
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

// 格式化联系人列表
#import <Foundation/Foundation.h>

@interface ContactDataHelper : NSObject

/** 获取所有联系人 */
+ (NSMutableArray *)getFriendListDataBy:(NSMutableArray *)array;
/** 获取联系人的分组 */
+ (NSMutableArray *)getFriendListSectionBy:(NSMutableArray *)array;

@end