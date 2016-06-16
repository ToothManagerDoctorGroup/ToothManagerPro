//
//  XLTransferRecordCell.m
//  CRM
//
//  Created by Argo Zhang on 16/6/14.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLTransferRecordCell.h"
#import "XLTransferRecordContentView.h"
#import "UIImage+LBImage.h"
#import "UIColor+Extension.h"
#import "XLTransferRecordModel.h"
#import "UIImageView+WebCache.h"
#import <Masonry.h>

#define RowHeight 60

@interface XLTransferRecordCell ()

@property (nonatomic, strong)UIButton *sortButton;
@property (nonatomic, strong)XLTransferRecordContentView *detailView;

@end

@implementation XLTransferRecordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"transfer_record_cell";
    XLTransferRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化
        [self setUp];
    }
    return self;
}

#pragma mark - ********************* Private Method ***********************
#pragma mark 初始化
- (void)setUp{
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.sortButton];
    [self.contentView addSubview:self.detailView];
    
    [self setUpContrains];
}

#pragma mark 设置约束
- (void)setUpContrains{
    [self.sortButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(5);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sortButton.mas_right);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.top.equalTo(self.contentView).with.offset(10);
        make.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - ********************* Public Method ***********************
+ (CGFloat)cellHeight{
    return RowHeight;
}

- (void)setModel:(XLTransferRecordModel *)model{
    _model = model;
    
    [self.sortButton setTitle:[NSString stringWithFormat:@"%ld",(long)model.number] forState:UIControlStateNormal];
    self.detailView.timeLabel.text = [model.intr_time substringToIndex:model.intr_time.length - 3];
    [self.detailView.headerImageView sd_setImageLoadingWithURL:[NSURL URLWithString:model.doctor_image] placeholderImage:[UIImage imageNamed:@"user_icon"]];
    self.detailView.doctorName.text = model.doctor_name;
}

#pragma mark - ********************* Lazy Method ***********************
- (UIButton *)sortButton{
    if (!_sortButton) {
        _sortButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sortButton setBackgroundImage:[UIImage imageNamed:@"transfer_circle"] forState:UIControlStateNormal];
        [_sortButton setTitleColor:[UIColor colorWithHex:0x5ec1f0] forState:UIControlStateNormal];
        _sortButton.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return _sortButton;
}

- (XLTransferRecordContentView *)detailView{
    if (!_detailView) {
        _detailView = [[XLTransferRecordContentView alloc] init];
        _detailView.image = [UIImage imageWithStretchableName:@"transfer_bg"];
        _detailView.userInteractionEnabled = YES;
    }
    return _detailView;
}

@end
