//
//  XLContentCell.m
//  CRM
//
//  Created by Argo Zhang on 16/5/14.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAppointContentCell.h"
#import "UIColor+Extension.h"
#import <Masonry.h>

@interface XLAppointContentCell ()

@end

@implementation XLAppointContentCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews{
    self.backgroundColor = [UIColor colorWithHex:0xcccccc];
    self.contentView.backgroundColor = [UIColor colorWithHex:0xcccccc];
    [self.contentView addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 1, 1, 1));
    }];
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.adjustsFontSizeToFitWidth = YES;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    return _contentLabel;
}
@end
