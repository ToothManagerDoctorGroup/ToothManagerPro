//
//  XLMenuGridItemView.m
//  CRM
//
//  Created by Argo Zhang on 16/5/31.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLMenuGridItemView.h"
#import "UIButton+WebCache.h"
#import "XLMenuGridViewItemButton.h"
#import "XLGridItemModel.h"

#define kMenuGridItemIconButtonWidth 20
#define kMenuGridItemIconButtonHeight kMenuGridItemIconButtonWidth
#define kMargin 10

@interface XLMenuGridItemView (){
    XLMenuGridViewItemButton *_itemButton;
    UIButton *_iconButton;
}

@end

@implementation XLMenuGridItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        [self setUp];
    }
    return self;
}
#pragma mark - 初始化
- (void)setUp{
    self.backgroundColor = [UIColor whiteColor];
    
    _itemButton = [[XLMenuGridViewItemButton alloc] init];
    [_itemButton addTarget:self action:@selector(buttonClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_itemButton];
    
    _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _iconButton.hidden = YES;
    [_iconButton setImage:[UIImage imageNamed:@"addManBtn"] forState:UIControlStateNormal];
    [_iconButton addTarget:self action:@selector(iconViewClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_iconButton];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
}

#pragma mark - LayoutSubViews
- (void)layoutSubviews{
    [super layoutSubviews];
    
    _itemButton.frame = self.bounds;
    
    CGFloat iconX = self.frame.size.width - kMenuGridItemIconButtonWidth - kMargin;
    CGFloat iconY = kMargin;
    _iconButton.frame = CGRectMake(iconX, iconY, kMenuGridItemIconButtonWidth, kMenuGridItemIconButtonHeight);
}

#pragma mark - Setter
- (void)setIconImage:(UIImage *)iconImage{
    _iconImage = iconImage;
    
    [_iconButton setImage:iconImage forState:UIControlStateNormal];
}

- (void)setHidenIcon:(BOOL)hidenIcon{
    _hidenIcon = hidenIcon;
    _iconButton.hidden = hidenIcon;
}

- (void)setItemModel:(XLGridItemModel *)itemModel{
    _itemModel = itemModel;
    
    //设置按钮标题
    if (_itemModel.title) {
        [_itemButton setTitle:itemModel.title forState:UIControlStateNormal];
    }
    //设置按钮图片
    if ([itemModel.imageUrlStr hasPrefix:@"http://"]) {
        [_itemButton sd_setBackgroundImageWithURL:[NSURL URLWithString:itemModel.imageUrlStr] forState:UIControlStateNormal placeholderImage:nil];
    }else{
        [_itemButton setImage:[UIImage imageNamed:itemModel.imageUrlStr] forState:UIControlStateNormal];
    }
}

#pragma mark - 点击事件
- (void)buttonClickAction{
    if (self.buttonClickOperationBlock) {
        self.buttonClickOperationBlock(self);
    }
}
- (void)iconViewClickAction{
    if (self.iconViewClickOperationBlock) {
        self.iconViewClickOperationBlock(self);
    }
}

#pragma mark - 长按事件
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    if (self.longPressOperationBlock) {
        self.longPressOperationBlock(longPress);
    }
}

@end
