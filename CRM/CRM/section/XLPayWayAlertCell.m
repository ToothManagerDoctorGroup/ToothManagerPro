//
//  XLPayWayAlertCell.m
//  CRM
//
//  Created by Argo Zhang on 16/6/23.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLPayWayAlertCell.h"
#import <Masonry.h>

#define logoImageWidth 22
#define logoImageHeight logoImageWidth
#define kMargin 15


@interface XLPayWayAlertCell ()

@end

@implementation XLPayWayAlertCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"pay_cell";
    XLPayWayAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [self.contentView addSubview:self.logoImageView];
    [self.contentView addSubview:self.contentLabel];
    self.accessoryType = UITableViewCellAccessoryCheckmark;
    //设置约束
    [self setUpContraints];
}

#pragma mark - 设置约束
- (void)setUpContraints{
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kMargin);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(logoImageWidth, logoImageHeight));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(kMargin);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(150);
    }];
}


#pragma mark - ********************* Lazy Method ***********************
- (UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
    }
    return _logoImageView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = [UIFont systemFontOfSize:15];
    }
    return _contentLabel;
}

@end
