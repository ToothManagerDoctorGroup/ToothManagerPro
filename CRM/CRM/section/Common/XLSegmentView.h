//
//  XLSegmentView.h
//  CRM
//
//  Created by Argo Zhang on 16/5/25.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnClickBlock)(NSInteger index);
/**
 *  按钮滑动视图
 */
@interface XLSegmentView : UIView
//设置未选中的字体颜色(默认黑色)
@property (nonatomic, strong)UIColor *titleNormalColor;
//设置选中的字体颜色(默认红色)
@property (nonatomic, strong)UIColor *titleSelectColor;
//设置普通的字体的大小(默认15)
@property (nonatomic, strong)UIFont *titleNormalFont;
//设置选中的字体大小(默认15)
@property (nonatomic, strong)UIFont *titleSelectFont;
//设置默认选中index
@property (nonatomic, assign)NSInteger defaultIndex;
//点击事件
@property (nonatomic, copy)BtnClickBlock block;
//数据源
@property (nonatomic, strong)NSArray *titleArray;

/**
 *  初始化方法
 *
 *  @param frame      frame
 *  @param titleArray 标题名称
 *  @param block      点击block
 *
 *  @return 当前对象
 */
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray clickBlick:(BtnClickBlock)block;

@end
