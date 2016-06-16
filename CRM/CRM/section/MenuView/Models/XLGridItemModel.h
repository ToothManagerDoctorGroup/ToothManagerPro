//
//  XLGridItemModel.h
//  CRM
//
//  Created by Argo Zhang on 16/5/31.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLGridItemModel : UIView

@property (nonatomic, copy)NSString *imageUrlStr;//按钮图片的名称
@property (nonatomic, copy)NSString *title;//按钮的标题
@property (nonatomic, copy)Class destinationClass;//目标控制器

@end
