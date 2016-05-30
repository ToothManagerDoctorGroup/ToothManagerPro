//
//  XLClinicCTImageCell.m
//  CRM
//
//  Created by Argo Zhang on 16/5/23.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLClinicCTImageCell.h"
#import "UIImageView+WebCache.h"
#import <Masonry.h>

@interface XLClinicCTImageCell ()

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIButton *chooseButton;

@end

@implementation XLClinicCTImageCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark 初始化
- (void)setUp{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.chooseButton];
    
    [self setUpConstrains];
    
}

#pragma mark 设置约束
- (void)setUpConstrains{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)setModel:(XLClinicCTImageCellModel *)model{
    _model = model;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.urlStr] placeholderImage:[UIImage imageNamed:@"ct_holderImage"] options:SDWebImageRefreshCached | SDWebImageRetryFailed];
    if (model.isSelect) {
        [self.chooseButton setImage:[UIImage imageNamed:@"clinic_ctimage_choose"] forState:UIControlStateNormal];
    }else{
        [self.chooseButton setImage:[UIImage imageNamed:@"clinic_ctimage_no_choose"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - ********************* Lazy Method ***********************
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 5;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}
- (UIButton *)chooseButton{
    if (!_chooseButton) {
        _chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseButton setImage:[UIImage imageNamed:@"clinic_ctimage_no_choose"] forState:UIControlStateNormal];
    }
    return _chooseButton;
}


@end

@implementation XLClinicCTImageCellModel



@end
