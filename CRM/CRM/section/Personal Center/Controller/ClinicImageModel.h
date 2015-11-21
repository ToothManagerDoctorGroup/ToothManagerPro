//
//  ClinicImageModel.h
//  CRM
//
//  Created by Argo Zhang on 15/11/13.
//  Copyright © 2015年 TimTiger. All rights reserved.
//  诊所实景图的Model

#import <Foundation/Foundation.h>

@interface ClinicImageModel : NSObject

@property (nonatomic, copy)NSString *KeyId;
@property (nonatomic, copy)NSString *clinic_id;
@property (nonatomic, copy)NSString *img_info; //图片路径
@property (nonatomic, copy)NSString *remark;

@end
