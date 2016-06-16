//
//  XLTeamMemberParam.h
//  CRM
//
//  Created by Argo Zhang on 16/3/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLTeamMemberParam : NSObject

//{"case_id":"1","patient_id":"1013_1451553870041","team_nick_name":"小团队","member_id":971,"nick_name":"小神童","member_name":"张大发","is_consociation":1,"create_user":1013,"create_time":"2016-03-01 11:10:24"}
@property (nonatomic, copy)NSString *case_id;
@property (nonatomic, copy)NSString *patient_id;
@property (nonatomic, copy)NSString *team_nick_name;
@property (nonatomic, copy)NSNumber *member_id;
@property (nonatomic, copy)NSString *nick_name;
@property (nonatomic, copy)NSString *member_name;
@property (nonatomic, copy)NSNumber *is_consociation;//是否是合作医生（0:否 1：是）
@property (nonatomic, copy)NSNumber *create_user;
@property (nonatomic, copy)NSString *create_time;

- (instancetype)initWithCaseId:(NSString *)case_id patientId:(NSString *)patient_id teamNickName:(NSString *)team_nick_name memberId:(NSNumber *)member_id nickName:(NSString *)nick_name memberName:(NSString *)member_name isConsociation:(BOOL)isConsociation createUserId:(NSNumber *)create_user;

@end
