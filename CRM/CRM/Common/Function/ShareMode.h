//
//  ShareMode.h
//  CRM
//
//  Created by mac on 14-6-20.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBTableMode.h"

@interface ShareMode : NSObject

@property (nonatomic,copy) NSString * title;   //主标题
@property (nonatomic,copy) NSString * subTitle;  //子标题
@property (nonatomic,copy) NSString * message;   //主要文字内容
@property (nonatomic,copy) NSString * url;      //分享的链接
@property (nonatomic,copy) UIImage * image;    //图片
@property (nonatomic,retain) MedicalCase * medCase;  //用来拿本地图片的路径

@end