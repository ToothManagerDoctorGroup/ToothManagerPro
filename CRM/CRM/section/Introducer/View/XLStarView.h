//
//  XLStarView.h
//  CRM
//
//  Created by Argo Zhang on 16/2/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XLStarViewAlignment) {
    //以下是枚举成员
    XLStarViewAlignmentCentre = 0,
    XLStarViewAlignmentLeft = 1,
    XLStarViewAlignmentRight = 2,
};
/**
 *  评分视图
 */
@interface XLStarView : UIControl

@property (nonatomic, assign)NSInteger level;//星级
@property (nonatomic, assign)XLStarViewAlignment alignment;//位置

@end
