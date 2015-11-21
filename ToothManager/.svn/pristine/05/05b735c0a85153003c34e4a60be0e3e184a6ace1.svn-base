//
//  MCPopoverView.h
//  MerchantClient
//
//  Created by thc on 15/5/27.
//  Copyright (c) 2015年 Chongqing Huizhan Networking Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 弹出视图
 */
@interface MCPopoverView : UIView

/**
 *  初始化
 *
 *  @param point  坐标
 *  @param titles 标题数组
 *  @param images 图片数组
 *
 *  @return 返回值
 */
-(instancetype)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray *)images;
-(void)show;
-(void)dismiss;
-(void)dismiss:(BOOL)animated;

@property (nonatomic, copy) UIColor *borderColor;
@property (nonatomic, copy) void (^selectRowAtIndex)(NSInteger index);

@end
