//
//  XLContactsManager.h
//  CRM
//
//  Created by Argo Zhang on 16/3/24.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const XLContactAccessAllowedNotification;//同意访问
extern NSString *const XLContactAccessDeniedNotification;//拒绝访问
extern NSString *const XLContactAccessFailedNotification;//访问失败

@interface XLContactsManager : NSObject

- (NSArray *)loadAllPeople;

@end

@interface XLContact : NSObject
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *middleName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy)NSString *fullName;
@property (nonatomic, copy) NSArray *phoneNumbers;//NSString Collection

@property (nonatomic, assign)BOOL hasAdd;//是否已经插入
@end
