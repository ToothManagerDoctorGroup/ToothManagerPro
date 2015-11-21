//
//  CommentModelFrame.h
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommentModel;
@interface CommentModelFrame : NSObject
/**
 *  数据模型
 */
@property (nonatomic, strong)CommentModel *model;
/**
 *  头像Frame
 */
@property (nonatomic, assign)CGRect headImgFrame;
/**
 *  姓名Frame
 */
@property (nonatomic, assign)CGRect nameFrame;
/**
 *  时间Frame
 */
@property (nonatomic, assign)CGRect timeFrame;
/**
 *  内容Frame
 */
@property (nonatomic, assign)CGRect contentFrame;

/**
 *  cell的高度
 */
@property (nonatomic, assign)CGFloat cellHeight;


@end
