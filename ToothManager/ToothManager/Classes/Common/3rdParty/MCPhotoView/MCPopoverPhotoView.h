//
//  MCPopoverPhotoView.h
//  MerchantClient
//
//  Created by thc on 15/4/27.
//  Copyright (c) 2015年 Chongqing Huizhan Networking Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  相册的弹出视图
 */
@interface MCPopoverPhotoView : UIView

/**
 *  初始化
 *
 *  @param point  坐标
 *  @param titles 标题数组
 *  @param images 图片数组
 *
 *  @return 返回值
 */
- (instancetype)initWithPoint:(CGPoint)point titles:(NSArray *)titles;
- (void)show;

@property (nonatomic, copy) void (^selectRowAtIndex)(NSInteger index);

@end
