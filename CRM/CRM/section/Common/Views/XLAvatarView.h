//
//  XLAvatarView.h
//  CRM
//
//  Created by Argo Zhang on 16/3/7.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLAvatarView;
@protocol XLAvatarViewDelegate <NSObject>

@optional
- (void)didClickAvatarView:(XLAvatarView *)avatarView;

@end

@interface XLAvatarView : UIView

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *urlStr;
@property (nonatomic, strong)UIImage *targetImage;//标签图片
@property (nonatomic, strong)UIImage *image;

@property (nonatomic, weak)id<XLAvatarViewDelegate> delegate;

- (id)initWithURLString:(NSString *)string;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
