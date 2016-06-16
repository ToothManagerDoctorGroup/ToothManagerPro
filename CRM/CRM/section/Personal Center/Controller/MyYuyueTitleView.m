//
//  MyYuyueTitleView.m
//  CRM
//
//  Created by Argo Zhang on 15/11/26.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "MyYuyueTitleView.h"

#define ContentColor MyColor(179, 181, 183)
#define ContentFont [UIFont systemFontOfSize:14]
@interface MyYuyueTitleView ()

@property (nonatomic, weak)UILabel *content;
@property (nonatomic, weak)UIImageView *imageView;

@end

@implementation MyYuyueTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //初始化
        [self setUp];
    }
    return self;
}
//初始化方法
- (void)setUp{
    UILabel *content = [[UILabel alloc] init];
    content.textColor = ContentColor;
    content.font = ContentFont;
    self.content = content;
    [self addSubview:content];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_crm"]];
    self.imageView = imageView;
    [self addSubview:imageView];
}

- (void)setTitle:(NSString *)title{
    _title = title;

    CGSize titleSize = [title sizeWithFont:ContentFont constrainedToSize:CGSizeMake(self.width - 10, self.height)];
    self.content.frame = CGRectMake(10, (self.height - titleSize.height) * 0.5, titleSize.width, titleSize.height);
    self.content.text = title;
    
    self.imageView.frame = CGRectMake(self.content.right + 5, (self.height - 10) / 2, 10, 10);
}

- (NSString *)currentTitle{
    return self.content.text;
}

@end
