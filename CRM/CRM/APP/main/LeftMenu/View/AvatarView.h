//
//  AvatarView.h
//  RuiliVideo
//
//  Created by TimTiger on 14-7-27.
//  Copyright (c) 2014年 Mudmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvatarView : UIView

@property (nonatomic,copy) NSString *urlStr;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;

- (id)initWithURLString:(NSString *)string;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
