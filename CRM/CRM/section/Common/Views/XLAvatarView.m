//
//  XLAvatarView.m
//  CRM
//
//  Created by Argo Zhang on 16/3/7.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAvatarView.h"
#import "CornerButton.h"
#import "UIColor+Extension.h"
#import "UIButton+WebCache.h"

@interface XLAvatarView ()

@property (nonatomic,strong) CornerButton *avatarButton;
@property (nonatomic, strong)UIImageView *targetImageView;//标签视图
@property (nonatomic,strong) UILabel *titleLabel;

@end
@implementation XLAvatarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithURLString:(NSString *)string {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setUp];
        self.urlStr = string;
    }
    return self;
}

#pragma mark - 初始化
- (void)setUp{
    
    self.userInteractionEnabled = YES;
    
    _avatarButton = [CornerButton buttonWithType:UIButtonTypeCustom];
    [_avatarButton setImage:[UIImage imageNamed:@"user_icon"] forState:UIControlStateNormal];
    [self addSubview:_avatarButton];
    
    _targetImageView = [[UIImageView alloc] init];
    [self addSubview:_targetImageView];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor colorWithHex:0x333333];
    [self addSubview:_titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat avatarX = 0;
    CGFloat avatarY = avatarX;
    CGFloat avatarW = self.bounds.size.width;
    CGFloat avatarH = avatarW;
    CGFloat margin = 5;
    self.avatarButton.frame = CGRectMake(avatarX,avatarY,avatarW, avatarH);
    
    if ([NSString isNotEmptyString:_title]) {
        CGFloat titleX = 0;
        CGFloat titleY = CGRectGetMaxY(self.avatarButton.frame) + margin;
        CGFloat titleW = self.bounds.size.width;
        CGFloat titleH = 20;
        
        self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
        self.titleLabel.text = _title;
    }
    
    if (self.targetImage != nil) {
        CGFloat targetW = 15;
        CGFloat targetH = targetW;
        CGFloat targetX = self.bounds.size.width - targetW;
        CGFloat targetY = 0;
        self.targetImageView.frame = CGRectMake(targetX, targetY, targetW, targetH);
        self.targetImageView.image = _targetImage;
    }
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self setNeedsLayout];
}

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    
    [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_icon"] options:SDWebImageRefreshCached];
}

- (void)setTargetImage:(UIImage *)targetImage{
    _targetImage = targetImage;
    [self setNeedsLayout];
}

- (void)setImage:(UIImage *)image{
    _image = image;
    
    [_avatarButton setImage:image forState:UIControlStateNormal];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [self.avatarButton addTarget:target action:action forControlEvents:controlEvents];
}

@end
