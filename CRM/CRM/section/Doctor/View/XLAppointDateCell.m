//
//  XLDateCell.m
//  CRM
//
//  Created by Argo Zhang on 16/5/14.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAppointDateCell.h"
#import <Masonry.h>
#import "UIColor+Extension.h"


@interface XLAppointDateCell ()

@property (nonatomic, strong)UIView *bottomLineView;
@property (nonatomic, strong)UIView *rightLineView;

@end
@implementation XLAppointDateCell

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
    [self.contentView addSubview:self.dateLabel];
//    [self.contentView addSubview:self.rightLineView];
//    [self.contentView addSubview:self.bottomLineView];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:15];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    return _dateLabel;
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
