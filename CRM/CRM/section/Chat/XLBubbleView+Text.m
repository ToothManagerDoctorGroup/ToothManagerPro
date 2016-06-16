//
//  XLBubbleView+Text.m
//  CRM
//
//  Created by Argo Zhang on 16/4/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLBubbleView+Text.h"
#import <Masonry.h>

@implementation XLBubbleView (Text)
- (void)setupTextBubbleView
{
    self.textLabel = [UILabel new];
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.numberOfLines = 0;
//    self.textLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.textLabel.delegate = self;
    [self.backgroundImageView addSubview:self.textLabel];
    
    //设置约束
    WS(weakSelf);
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.backgroundImageView).with.insets(self.margin);
    }];
}

@end
