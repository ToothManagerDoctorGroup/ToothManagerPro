//
//  XLImageScrollViewCell.m
//  CRM
//
//  Created by Argo Zhang on 16/5/24.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLImageScrollViewCell.h"
#import <Masonry.h>

@implementation XLImageScrollViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [self.contentView addSubview:self.imageView];
    
    [self setUpContrains];
}

- (void)setUpContrains{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 5;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}
@end
