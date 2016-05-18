//
//  AddressBoolTool.h
//  CRM
//
//  Created by Argo Zhang on 16/2/26.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonMacro.h"

@class Patient;
@interface AddressBoolTool : NSObject
Declare_ShareInstance(AddressBoolTool);

- (UIImage *)drawImageWithSourceImage:(UIImage *)sourceImage plantTime:(NSString *)plantTime intrName:(NSString *)intrName;

- (void)saveWithImage:(UIImage *)image person:(NSString *)personName phone:(NSString *)personPhone;
/**
 *  判断联系人是否存在
 *
 *  @param contactName  联系人姓名
 *  @param contactPhone 联系人电话
 *
 *  @return 返回值
 */
- (BOOL)getContactsWithName:(NSString *)contactName phone:(NSString *)contactPhone;
/**
 *  将患者插入通讯录
 *
 *  @param patient 患者信息
 */
- (BOOL)addContactToAddressBook:(Patient *)patient;
/**
 *  用户是否开启通讯录权限
 *
 *  @return 是否开钱
 */
- (BOOL)userAllowToAddress;
@end
