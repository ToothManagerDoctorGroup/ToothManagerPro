//
//  XLDateCell.m
//  CRM
//
//  Created by Argo Zhang on 16/5/14.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLDateCell.h"
#import <Masonry.h>

@implementation XLDateCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews{
    [self addSubview:self.dateLabel];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:15];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.textColor = [UIColor blackColor];
    }
    return _dateLabel;
}

@end
