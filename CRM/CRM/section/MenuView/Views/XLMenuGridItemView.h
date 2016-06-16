//
//  XLMenuGridItemView.h
//  CRM
//
//  Created by Argo Zhang on 16/5/31.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLGridItemModel,XLMenuGridItemView;

typedef void(^ItemLongPressOperationBlock)(UILongPressGestureRecognizer *longPressed);
typedef void(^ButtonClickOperationBlock)(XLMenuGridItemView *itemView);
typedef void(^IconViewClickOperationBlock)(XLMenuGridItemView *iconView);

@interface XLMenuGridItemView : UIView

@property (nonatomic, strong)XLGridItemModel *itemModel;
@property (nonatomic, strong)UIImage *iconImage;
@property (nonatomic, assign)BOOL hidenIcon;

//长按事件
@property (nonatomic, copy)ItemLongPressOperationBlock longPressOperationBlock;
//按钮点击事件
@property (nonatomic, copy)ButtonClickOperationBlock buttonClickOperationBlock;
//iconView点击事件
@property (nonatomic, copy)IconViewClickOperationBlock iconViewClickOperationBlock;
@end
