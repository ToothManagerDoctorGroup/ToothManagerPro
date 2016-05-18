//
//  XLBubbleView+Image.m
//  CRM
//
//  Created by Argo Zhang on 16/4/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLBubbleView+Image.h"
#import <Masonry.h>

@implementation XLBubbleView (Image)
- (void)setupImageBubbleView
{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.backgroundColor = [UIColor clearColor];
    [self.backgroundImageView addSubview:self.imageView];
    
    WS(weakSelf);
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.edges.equalTo(weakSelf.backgroundImageView).with.insets(weakSelf.margin);
    }];
}
@end
