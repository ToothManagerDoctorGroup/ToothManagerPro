//
//  ContactDataHelper.m
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

// 格式化联系人列表
#import "ContactDataHelper.h"
#import "NSString+TTMAddtion.h"

@implementation ContactDataHelper

/** 获取所有联系人 */
+ (NSMutableArray *)getFriendListDataBy:(NSMutableArray *)array
{
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    //排序
    NSArray *serializeArray = [(NSArray *)array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int i;
        NSString *strA = ((EMBuddy *)obj1).username.chineseToPinyin;
        NSString *strB = ((EMBuddy *)obj2).username.chineseToPinyin;
        for (i = 0; i < strA.length && i < strB.length; i ++) {
            char a = [strA characterAtIndex:i];
            char b = [strB characterAtIndex:i];
            if (a > b) {
                return (NSComparisonResult)NSOrderedDescending;//上升
            } else if (a < b) {
                return (NSComparisonResult)NSOrderedAscending;//下降
            }
        }
        
        if (strA.length > strB.length) {
            return (NSComparisonResult)NSOrderedDescending;
        } else if (strA.length < strB.length) {
            return (NSComparisonResult)NSOrderedAscending;
        } else {
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    char lastC = '1';
    NSMutableArray *data;
    NSMutableArray *oth = [[NSMutableArray alloc] init];
    for (EMBuddy *user in serializeArray) {
        char c = [user.username.chineseToPinyin characterAtIndex:0];
        if (!isalpha(c)) {
            [oth addObject:user];
        }
        else if (c != lastC){
            lastC = c;
            if (data && data.count > 0) {
                [ans addObject:data];
            }
            
            data = [[NSMutableArray alloc] init];
            [data addObject:user];
        }
        else {
            [data addObject:user];
        }
    }
    
    if (data && data.count > 0) {
        [ans addObject:data];
    }
    if (oth.count > 0) {
        [ans addObject:oth];
    }
    return ans;
}

/** 获取联系人的分组 */
+ (NSMutableArray *)getFriendListSectionBy:(NSMutableArray *)array
{
    NSMutableArray *section = [[NSMutableArray alloc] init];
    // 如果搜索框加在tableview上,可以加上下面一句使索引位置显示"放大镜"图标
     [section addObject:UITableViewIndexSearch];
    // 添加其他内容
    for (NSArray *item in array) {
        EMBuddy *buddy = [item objectAtIndex:0];
        char c = [[buddy.username chineseToPinyin] characterAtIndex:0];
        if (!isalpha(c)) c = '#';
        [section addObject:[NSString stringWithFormat:@"%c", toupper(c)]];
    }
    return section;
}

@end
