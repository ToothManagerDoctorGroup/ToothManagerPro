//
//  XLContactModel.h
//  CRM
//
//  Created by Argo Zhang on 16/3/15.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  联系人模型
 */
@interface XLContactModel : NSObject

@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy)UIImage *image;
@property (nonatomic, copy)NSString *email;

@property (nonatomic, assign)BOOL hasAdd;//是否已经插入

@end
