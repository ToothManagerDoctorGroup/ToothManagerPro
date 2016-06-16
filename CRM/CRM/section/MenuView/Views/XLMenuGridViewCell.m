//
//  XLMenuGridViewCell.m
//  CRM
//
//  Created by Argo Zhang on 16/6/1.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLMenuGridViewCell.h"
#import "XLMenuGridViewItemButton.h"
#import "XLGridItemModel.h"
#import "UIButton+WebCache.h"

@interface XLMenuGridViewCell ()

@property (nonatomic, strong)XLMenuGridViewItemButton *itemButton;

@end

@implementation XLMenuGridViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.itemButton];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.itemButton.frame = self.bounds;
}

- (void)setItemModel:(XLGridItemModel *)itemModel{
    _itemModel = itemModel;
    
    //设置按钮标题
    if (_itemModel.title) {
        [_itemButton setTitle:itemModel.title forState:UIControlStateNormal];
    }
    //设置按钮图片
    if ([itemModel.imageUrlStr hasPrefix:@"http://"]) {
        [_itemButton sd_setImageWithURL:[NSURL URLWithString:itemModel.imageUrlStr] forState:UIControlStateNormal placeholderImage:nil];
    }else{
        [_itemButton setImage:[UIImage imageNamed:itemModel.imageUrlStr] forState:UIControlStateNormal];
    }
}

- (XLMenuGridViewItemButton *)itemButton{
    if (!_itemButton) {
        _itemButton = [[XLMenuGridViewItemButton alloc] init];
        _itemButton.userInteractionEnabled = NO;
    }
    return _itemButton;
}
@end
