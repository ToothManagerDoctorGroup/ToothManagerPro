//
//  XLTeamMemberModel.h
//  CRM
//
//  Created by Argo Zhang on 16/3/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLTeamMemberModel : NSObject
/**
 *  "KeyId": 1,
 "case_id": "612_20151223150148",
 "patient_id": "612_20151123191137",
 "team_nick_name": "",
 "member_id": 1037,
 "nick_name": "",
 "member_name": "李晓鹏",
 "is_consociation": 1,
 "is_intr": 0,
 "create_user": 970,
 "create_time": "2016-03-04 19:20:41"
 */
@property (nonatomic, strong)NSNumber *keyId;
@property (nonatomic, copy)NSString *case_id;
@property (nonatomic, copy)NSString *patient_id;
@property (nonatomic, copy)NSString *team_nick_name;
@property (nonatomic, copy)NSNumber *member_id;
@property (nonatomic, copy)NSString *nick_name;
@property (nonatomic, copy)NSString *member_name;
@property (nonatomic, strong)NSNumber *is_consociation;//是否是合作医生（0:否 1：是）
@property (nonatomic, strong)NSNumber *is_intr;//是否是介绍人
@property (nonatomic, strong)NSNumber *create_user;
@property (nonatomic, copy)NSString *create_time;
@property (nonatomic, copy)NSString *doctor_image;

@end
