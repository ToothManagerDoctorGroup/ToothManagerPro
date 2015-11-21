//
//  CommentModel.h
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
/**
 *  头像
 */
@property (nonatomic, copy)NSString *headimg_url;
/**
 *  发送人姓名
 */
@property (nonatomic, copy)NSString *name;

/**
 *  发送时间
 */
@property (nonatomic, copy)NSString *time;
/**
 *  发送内容
 */
@property (nonatomic, copy)NSString *content;

@end
