//
//  NVMContact.h
//  contacts
//
//  Created by PhilCai on 15/7/29.
//  Copyright (c) 2015年 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const NVMContactAccessAllowedNotification;//only received when asked for the first time and chose YES
extern NSString *const NVMContactAccessDeniedNotification;//only received when asked for the first time and chose NO
extern NSString *const NVMContactAccessFailedNotification;//only received when denied or restricted (not for the first time)

@interface NVMContact : NSObject
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *middleName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy)NSString *fullName;
@property (nonatomic, copy) NSArray *phoneNumbers;//NSString Collection

@property (nonatomic, assign)BOOL hasAdd;//是否已经插入
@end

@interface NVMContactManager : NSObject
+ (instancetype) manager;
@property (nonatomic, strong, readonly) NSArray *allPeople;

@property (nonatomic,strong) NSMutableArray *sequencePeoples;//排序后的数组
@property (nonatomic, strong) NSMutableArray *sequencePeopleTitles;//排序后分组的标题
@end
