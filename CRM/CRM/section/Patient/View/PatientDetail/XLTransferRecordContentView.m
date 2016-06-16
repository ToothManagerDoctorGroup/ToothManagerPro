//
//  XLTransferRecordContentView.m
//  CRM
//
//  Created by Argo Zhang on 16/6/14.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLTransferRecordContentView.h"
#import "UIColor+Extension.h"
#import <Masonry.h>

#define TextColor [UIColor colorWithHex:0x333333]
#define TextFont [UIFont systemFontOfSize:15]
#define TransferTextColor [UIColor colorWithHex:0x888888]
#define HeaderImageWidth 30
#define HeaderImageHeight HeaderImageWidth
#define HeaderBorderColor [UIColor colorWithHex:0xeeeeee]
#define TextLabelHeight 50

@interface XLTransferRecordContentView ()

@property (nonatomic, strong)UILabel *transferLabel;//转诊到

@end

@implementation XLTransferRecordContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - ********************* Private Method ***********************
#pragma mark 初始化
- (void)setUp{
    [self addSubview:self.timeLabel];
    [self addSubview:self.transferLabel];
    [self addSubview:self.headerImageView];
    [self addSubview:self.doctorName];
    
    //设置约束
    [self setUpContrains];
}

#pragma mark 设置约束
- (void)setUpContrains{
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(130, TextLabelHeight));
    }];
    
    [self.transferLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).with.offset(5);
        make.right.equalTo(self.headerImageView.mas_left).with.offset(-5);
        make.top.equalTo(self);
        make.height.mas_equalTo(TextLabelHeight);
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.doctorName.mas_left);
        make.size.mas_equalTo(CGSizeMake(HeaderImageWidth, HeaderImageHeight));
    }];
    
    [self.doctorName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-5);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, TextLabelHeight));
    }];
}

#pragma mark - ********************* Lazy Method ***********************
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = TextColor;
        _timeLabel.font = TextFont;
        [_timeLabel sizeToFit];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (UILabel *)transferLabel{
    if (!_transferLabel) {
        _transferLabel = [[UILabel alloc] init];
        _transferLabel.textColor = TransferTextColor;
        _transferLabel.font = TextFont;
        [_transferLabel sizeToFit];
        _transferLabel.textAlignment = NSTextAlignmentCenter;
        _transferLabel.text = @"转诊到";
    }
    return _transferLabel;
}

- (UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.layer.cornerRadius = HeaderImageHeight / 2;
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.layer.borderWidth = 1;
        _headerImageView.layer.borderColor = HeaderBorderColor.CGColor;
    }
    return _headerImageView;
}

- (UILabel *)doctorName{
    if (!_doctorName) {
        _doctorName = [[UILabel alloc] init];
        _doctorName.textColor = TextColor;
        _doctorName.font = TextFont;
        [_doctorName sizeToFit];
    }
    return _doctorName;
}

@end
