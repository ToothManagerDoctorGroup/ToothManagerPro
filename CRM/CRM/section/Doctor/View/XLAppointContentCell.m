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

@property (nonatomic, strong)UIView *bottomLineView;
@property (nonatomic, strong)UIView *rightLineView;

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
//    [self.contentView addSubview:self.rightLineView];
//    [self.contentView addSubview:self.bottomLineView];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 1, 1, 1));
    }];
    
//    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(@1);
//        make.top.right.and.bottom.equalTo(self.contentView);
//    }];
//    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(@1);
//        make.left.right.and.bottom.equalTo(self.contentView);
//    }];
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

- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor colorWithHex:0xcccccc];
    }
    return _bottomLineView;
}

- (UIView *)rightLineView{
    if (!_rightLineView) {
        _rightLineView = [[UIView alloc] init];
        _rightLineView.backgroundColor = [UIColor colorWithHex:0xcccccc];
    }
    return _rightLineView;
}

@end
