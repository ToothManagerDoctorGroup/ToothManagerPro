//
//  AvatarView.m
//  RuiliVideo
//
//  Created by TimTiger on 14-7-27.
//  Copyright (c) 2014年 Mudmen. All rights reserved.
//

#import "AvatarView.h"
#import "UIButton+WebCache.h"
#import "CornerButton.h"
#import "NSString+Conversion.h"
#import "UIColor+Extension.h"

@interface AvatarView ()

@property (nonatomic,retain) CornerButton *avatarButton;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *contentLabel;

@end

@implementation AvatarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib {
    if (self) {
        [self setUp];
    }
}
#pragma mark - 初始化
- (void)setUp{
    self.userInteractionEnabled = YES;
    _avatarButton = [CornerButton buttonWithType:UIButtonTypeCustom];
    [_avatarButton setImage:[UIImage imageNamed:@"user_icon"] forState:UIControlStateNormal];
    [self addSubview:_avatarButton];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    _titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:_titleLabel];
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.font = [UIFont systemFontOfSize:14.0f];
    _contentLabel.textColor = [UIColor whiteColor];
    [self addSubview:_contentLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.avatarButton.frame = CGRectMake(1,1,self.bounds.size.height - 2, self.bounds.size.height - 2);
    self.backgroundColor = [UIColor clearColor];
    
    if ([NSString isNotEmptyString:self.title] && [NSString isEmptyString:self.content]) {
        self.titleLabel.frame = CGRectMake(self.bounds.size.height+5, 0, self.bounds.size.width-self.bounds.size.height, self.bounds.size.height);
        self.titleLabel.text = self.title;
        self.contentLabel.hidden = YES;
    } else if ([NSString isEmptyString:self.title] && [NSString isNotEmptyString:self.content]) {
        self.contentLabel.frame = CGRectMake(self.bounds.size.height, 0, self.bounds.size.width-self.bounds.size.height, self.bounds.size.height);
        self.contentLabel.text = self.content;
        self.titleLabel.hidden = YES;
    } else if ([NSString isEmptyString:self.title] && [NSString isEmptyString:self.content]) {
        self.contentLabel.hidden = YES;
        self.titleLabel.hidden = YES;
    } else if ([NSString isNotEmptyString:self.title] && [NSString isNotEmptyString:self.content]) {
        self.titleLabel.frame = CGRectMake(self.bounds.size.height, 0, self.bounds.size.width-self.bounds.size.height, self.bounds.size.height/2);
        self.contentLabel.frame = CGRectMake(self.bounds.size.height, self.bounds.size.height/2, self.bounds.size.width-self.bounds.size.height, self.bounds.size.height/2);
        self.contentLabel.text = self.content;
        self.titleLabel.text = self.title;
    }
}

- (id)initWithURLString:(NSString *)string {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _avatarButton = [CornerButton buttonWithType:UIButtonTypeCustom];
        [_avatarButton setImage:[UIImage imageNamed:@"user_icon"] forState:UIControlStateNormal];
        [self addSubview:_avatarButton];
        self.urlStr = string;
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.textColor = [UIColor whiteColor];
        [self addSubview:_contentLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self setNeedsLayout];
}

- (void)setContent:(NSString *)content {
    _content = content;
    [self setNeedsLayout];
}

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    
    [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_icon"] options:SDWebImageRefreshCached];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [self.avatarButton addTarget:target action:action forControlEvents:controlEvents];
}

@end
