//
//  XLLongImageView.h
//  CRM
//
//  Created by Argo Zhang on 16/1/28.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  可缩放的imageView
 */
@interface XLLongImageView : UIImageView{
    UIScrollView *_scrollView; //图片滑动视图
    UIImageView *_originImageView; //放大后的图片视图
}

@end
