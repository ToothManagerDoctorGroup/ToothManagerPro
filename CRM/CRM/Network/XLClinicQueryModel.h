//
//  XLClinicQueryModel.h
//  CRM
//
//  Created by Argo Zhang on 16/5/26.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  诊所查询模型
 */
@interface XLClinicQueryModel : NSObject
/**
 *  {"KeyWord":null,"IsAsc":true,"SortField":null,"PageIndex":2,"PageSize":5,"DoctorId":1865,"ClinicId":null,"ClinicName":null,"ClinicArea":"武汉市","BusinessHours":null,"BusinessWeek":null}
 */

@property (nonatomic, copy)NSString *KeyWord;//关键字查询
@property (nonatomic, assign)BOOL IsAsc;  //是否升序
@property (nonatomic, copy)NSString *SortField;//
@property (nonatomic, strong)NSNumber *PageIndex;//页码
@property (nonatomic, strong)NSNumber *PageSize;//每页显示个数
@property (nonatomic, copy)NSString *DoctorId;//医生id
@property (nonatomic, copy)NSString *ClinicId;//诊所id
@property (nonatomic, copy)NSString *ClinicName;//诊所名称
@property (nonatomic, copy)NSString *ClinicArea;//诊所地址
@property (nonatomic, copy)NSString *BusinessHours;//营业时间
@property (nonatomic, copy)NSString *BusinessWeek;//营业周

- (instancetype)initWithKeyWord:(NSString *)keyWord
                          isAsc:(BOOL)isAsc
                       doctorId:(NSString *)doctorId;

@end
