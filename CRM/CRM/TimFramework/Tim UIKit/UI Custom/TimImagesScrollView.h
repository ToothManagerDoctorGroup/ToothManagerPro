//
//  TimImagesScrollView.h
//  CRM
//
//  Created by TimTiger on 1/25/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimImage : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *url;   //可以是本地路径，也可以是网络地址
@end


@protocol TimImagesScrollViewDelegate;
@interface TimImagesScrollView : UIScrollView

@property (nonatomic) CGFloat imageViewWidth;      //先设置每张图片的显示宽度
@property (nonatomic) BOOL showTitle;
@property (nonatomic,retain) NSArray *imageArray;  //然后设置图片数据源 、TimImage的数组
@property (nonatomic,weak) id <TimImagesScrollViewDelegate> sdelegate;
@end

@protocol TimImagesScrollViewDelegate <NSObject>

- (void)imagesScrollView:(TimImagesScrollView *)scrollView didTouchImage:(NSInteger)index;

@end
